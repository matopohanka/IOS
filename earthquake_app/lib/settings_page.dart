
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'providers/app_data_provider.dart';
import 'utils/helper_functions.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nastavenia'),
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Časové obdobie',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vyber obdobie, za ktoré chceš načítať '
                'zemetrasenia z API USGS.',
              ),
              const SizedBox(height: 20),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Dátum od'),
                  subtitle: Text(
                    DateFormat('dd.MM.yyyy')
                        .format(provider.draftStartDate),
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: () async {
                    final selected = await showDatePicker(
                      context: context,
                      initialDate: provider.draftStartDate,
                      firstDate: DateTime(1970),
                      lastDate: DateTime.now(),
                    );

                    if (selected != null) {
                      provider.setDraftStartDate(selected);
                    }
                  },
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text('Dátum do'),
                  subtitle: Text(
                    DateFormat('dd.MM.yyyy')
                        .format(provider.draftEndDate),
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: () async {
                    final selected = await showDatePicker(
                      context: context,
                      initialDate: provider.draftEndDate,
                      firstDate: DateTime(1970),
                      lastDate: DateTime.now(),
                    );

                    if (selected != null) {
                      provider.setDraftEndDate(selected);
                    }
                  },
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton.icon(
                icon: const Icon(Icons.update),
                label: const Text('Update Time Changes'),
                onPressed: provider.isLoading
                    ? null
                    : () async {
                        if (provider.draftStartDate
                            .isAfter(provider.draftEndDate)) {
                          showMessage(
                            context,
                            'Dátum od musí byť pred dátumom do.',
                            isError: true,
                          );
                          return;
                        }

                        final success =
                            await provider.applyDateChanges();

                        if (!context.mounted) return;

                        if (success) {
                          showMessage(
                            context,
                            'Údaje boli načítané podľa nového obdobia.',
                          );
                          Navigator.pop(context);
                        } else {
                          showMessage(
                            context,
                            provider.errorMessage ??
                                'Nepodarilo sa načítať údaje.',
                            isError: true,
                          );
                        }
                      },
              ),

              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: provider.isLoading
                    ? null
                    : provider.resetDraftDates,
                child: const Text('Obnoviť pôvodné dátumy'),
              ),

              if (provider.isLoading) ...[
                const SizedBox(height: 20),
                const Center(
                  child: CircularProgressIndicator(),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text('Načítavam zemetrasenia...'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
