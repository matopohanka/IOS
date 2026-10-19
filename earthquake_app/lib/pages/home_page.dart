
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/earthquake_model.dart';
import '../providers/app_data_provider.dart';
import '../settings_page.dart';
import '../utils/helper_functions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌍 Earthquake App'),
        actions: [
          IconButton(
            tooltip: 'Nastavenia',
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Obnoviť údaje',
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final provider = context.read<AppDataProvider>();

              await provider.fetchEarthquakes();

              if (!context.mounted) return;

              showMessage(
                context,
                provider.errorMessage ??
                    'Údaje boli aktualizované.',
                isError: provider.errorMessage != null,
              );
            },
          ),
        ],
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading &&
              provider.earthquakes.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.errorMessage != null &&
              provider.earthquakes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: provider.fetchEarthquakes,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Skúsiť znova'),
                    ),
                  ],
                ),
              ),
            );
          }

          final earthquakes = provider.filteredEarthquakes;

          return Column(
            children: [
              if (provider.isLoading)
                const LinearProgressIndicator(),

              _buildFilters(provider),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Počet záznamov: ${earthquakes.length}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Obdobie: '
                      '${DateFormat('dd.MM.yyyy').format(provider.startDate)}'
                      ' – '
                      '${DateFormat('dd.MM.yyyy').format(provider.endDate)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: earthquakes.isEmpty
                    ? const Center(
                        child: Text(
                          'Pre zvolené obdobie a filter '
                          'sa nenašli žiadne zemetrasenia.',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: provider.fetchEarthquakes,
                        child: ListView.builder(
                          physics:
                              const AlwaysScrollableScrollPhysics(),
                          itemCount: earthquakes.length,
                          itemBuilder: (context, index) {
                            return _buildEarthquakeCard(
                              context,
                              earthquakes[index],
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilters(AppDataProvider provider) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Minimálna magnitúda: '
              '${provider.minMagnitude.toStringAsFixed(1)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              value: provider.minMagnitude,
              min: 0,
              max: 8,
              divisions: 16,
              label: provider.minMagnitude.toStringAsFixed(1),
              onChanged: provider.setMinMagnitude,
            ),
            Row(
              children: [
                const Text('Triediť podľa:'),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    value: provider.sortBy,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'time',
                        child: Text('Času'),
                      ),
                      DropdownMenuItem(
                        value: 'magnitude',
                        child: Text('Magnitúdy'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        provider.setSortBy(value);
                      }
                    },
                  ),
                ),
                IconButton(
                  tooltip: provider.descending
                      ? 'Zostupne'
                      : 'Vzostupne',
                  icon: Icon(
                    provider.descending
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                  ),
                  onPressed: () {
                    provider.setDescending(!provider.descending);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarthquakeCard(
    BuildContext context,
    Earthquake earthquake,
  ) {
    final date = DateFormat('dd.MM.yyyy HH:mm')
        .format(earthquake.time.toLocal());

    final magnitudeColor = earthquake.magnitude >= 5
        ? Colors.red
        : earthquake.magnitude >= 3
            ? Colors.orange
            : Colors.green;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: magnitudeColor,
          child: Text(
            earthquake.magnitude.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          earthquake.place,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '$date\nHĺbka: ${earthquake.depth.toStringAsFixed(1)} km',
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.open_in_new),
        onTap: () async {
          final url = earthquake.url;

          if (url == null || url.isEmpty) {
            showMessage(
              context,
              'Odkaz na detail nie je dostupný.',
              isError: true,
            );
            return;
          }

          final uri = Uri.tryParse(url);
          if (uri == null) return;

          try {
            final opened = await launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );

            if (!opened && context.mounted) {
              showMessage(
                context,
                'Odkaz sa nepodarilo otvoriť.',
                isError: true,
              );
            }
          } catch (_) {
            if (context.mounted) {
              showMessage(
                context,
                'Odkaz sa nepodarilo otvoriť.',
                isError: true,
              );
            }
          }
        },
      ),
    );
  }
}
