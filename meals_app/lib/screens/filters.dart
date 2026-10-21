import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({
    super.key,
    required this.currentFilters,
  });

  final Map<String, bool> currentFilters;

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  late Map<String, bool> _filters;

  @override
  void initState() {
    super.initState();
    _filters = Map<String, bool>.from(widget.currentFilters);
  }

  Widget _buildSwitch(
    String key,
    String title,
    String subtitle,
  ) {
    return SwitchListTile(
      value: _filters[key] ?? false,
      title: Text(title),
      subtitle: Text(subtitle),
      onChanged: (value) {
        setState(() => _filters[key] = value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Map<String, bool>>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) Navigator.of(context).pop(_filters);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Filtre jedál'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(_filters),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(_filters),
              child: const Text('Hotovo'),
            ),
          ],
        ),
        body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                'Vyber si vlastnosti jedál, ktoré chceš zobrazovať.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            _buildSwitch('gluten', 'Bez lepku', 'Zobrazovať iba bezlepkové jedlá.'),
            _buildSwitch('lactose', 'Bez laktózy', 'Zobrazovať iba jedlá bez laktózy.'),
            _buildSwitch('vegan', 'Vegánske', 'Bez surovín živočíšneho pôvodu.'),
            _buildSwitch('vegetarian', 'Vegetariánske', 'Bez mäsa a rýb.'),
          ],
        ),
      ),
    );
  }
}
