
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/earthquake_model.dart';

class AppDataProvider extends ChangeNotifier {
  List<Earthquake> _earthquakes = [];

  bool _isLoading = false;
  String? _errorMessage;

  double _minMagnitude = 0.0;
  String _sortBy = 'time';
  bool _descending = true;

  DateTime _startDate =
      DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();

  late DateTime _draftStartDate = _startDate;
  late DateTime _draftEndDate = _endDate;

  List<Earthquake> get earthquakes =>
      List.unmodifiable(_earthquakes);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get minMagnitude => _minMagnitude;
  String get sortBy => _sortBy;
  bool get descending => _descending;

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  DateTime get draftStartDate => _draftStartDate;
  DateTime get draftEndDate => _draftEndDate;

  List<Earthquake> get filteredEarthquakes {
    final result = _earthquakes
        .where((earthquake) =>
            earthquake.magnitude >= _minMagnitude)
        .toList();

    result.sort((a, b) {
      final comparison = _sortBy == 'magnitude'
          ? a.magnitude.compareTo(b.magnitude)
          : a.time.compareTo(b.time);

      return _descending ? -comparison : comparison;
    });

    return result;
  }

  Future<void> fetchEarthquakes() async {
    if (_startDate.isAfter(_endDate)) {
      _errorMessage =
          'Začiatočný dátum musí byť pred koncovým dátumom.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Začiatok vybraného dňa v UTC.
      final start = DateTime.utc(
        _startDate.year,
        _startDate.month,
        _startDate.day,
      );

      // Začiatok nasledujúceho dňa.
      // API tak dostane celý koncový deň.
      final endExclusive = DateTime.utc(
        _endDate.year,
        _endDate.month,
        _endDate.day + 1,
      );

      final uri = Uri.https(
        'earthquake.usgs.gov',
        '/fdsnws/event/1/query',
        {
          'format': 'geojson',
          'starttime': start.toIso8601String(),
          'endtime': endExclusive.toIso8601String(),
          'orderby': 'time',
          'limit': '20000',
        },
      );

      debugPrint('USGS URL: $uri');

      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception(
          'USGS API vrátilo HTTP ${response.statusCode}',
        );
      }

      final data =
          jsonDecode(response.body) as Map<String, dynamic>;

      final features = data['features'] as List<dynamic>? ?? [];

      final loaded = features.map((item) {
        return Earthquake.fromJson(
          item as Map<String, dynamic>,
        );
      }).toList();

      // Odstránime udalosti od nasledujúceho dňa,
      // pretože endtime API je vrátane hranice.
      final end = DateTime.utc(
        _endDate.year,
        _endDate.month,
        _endDate.day,
      );

      final nextDay = end.add(const Duration(days: 1));

      final filteredByDate = loaded.where((earthquake) {
        final time = earthquake.time.toUtc();
        return !time.isBefore(start) && time.isBefore(nextDay);
      }).toList();

      _earthquakes = filteredByDate;

      debugPrint(
        'Načítaných zemetrasení: ${_earthquakes.length}',
      );
    } catch (e) {
      _errorMessage =
          'Nepodarilo sa načítať údaje z USGS. '
          'Skontroluj internetové pripojenie a dátumy.';
      debugPrint('Chyba načítania zemetrasení: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setMinMagnitude(double value) {
    _minMagnitude = value;
    notifyListeners();
  }

  void setSortBy(String value) {
    _sortBy = value;
    notifyListeners();
  }

  void setDescending(bool value) {
    _descending = value;
    notifyListeners();
  }

  void setDraftStartDate(DateTime value) {
    _draftStartDate = value;
    notifyListeners();
  }

  void setDraftEndDate(DateTime value) {
    _draftEndDate = value;
    notifyListeners();
  }

  Future<bool> applyDateChanges() async {
    if (_draftStartDate.isAfter(_draftEndDate)) {
      _errorMessage =
          'Začiatočný dátum musí byť pred koncovým dátumom.';
      notifyListeners();
      return false;
    }

    _startDate = _draftStartDate;
    _endDate = _draftEndDate;

    await fetchEarthquakes();

    return _errorMessage == null;
  }

  void resetDraftDates() {
    _draftStartDate = _startDate;
    _draftEndDate = _endDate;
    notifyListeners();
  }
}
