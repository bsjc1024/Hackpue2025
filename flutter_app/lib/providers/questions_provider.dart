// lib/providers/questions_provider.dart
import 'package:flutter/material.dart';

class QuestionsProvider with ChangeNotifier {
  // Form data fields
  String _carrera = '';
  String _universidad = '';
  String _nivelEspanol = '';
  String _nivelBiologia = '';
  int _dias = 0;
  int _horas = 0;
  int _meses = 0;

  // Getters
  String get carrera => _carrera;
  String get universidad => _universidad;
  String get nivelEspanol => _nivelEspanol;
  String get nivelBiologia => _nivelBiologia;
  int get dias => _dias;
  int get horas => _horas;
  int get meses => _meses;

  // Check if basic form is complete (for availability screen)
  bool get isFormComplete {
    return _carrera.isNotEmpty &&
           _universidad.isNotEmpty &&
           _dias > 0 &&
           _horas > 0 &&
           _meses > 0;
  }

  // Check if complete form is ready for Gemini API
  bool get isCompleteForAPI {
    return _carrera.isNotEmpty &&
           _universidad.isNotEmpty &&
           _nivelEspanol.isNotEmpty &&
           _nivelBiologia.isNotEmpty &&
           _dias > 0 &&
           _horas > 0 &&
           _meses > 0;
  }

  // Get all data as Map for API call
  Map<String, dynamic> get formData {
    return {
      'carrera': _carrera,
      'universidad': _universidad,
      'nivel_español': _nivelEspanol,
      'nivel_biologia': _nivelBiologia,
      'dias': _dias,
      'horas': _horas,
      'meses': _meses,
    };
  }

  // Calculate total hours
  int get totalHours {
    return _meses * 4 * _dias * _horas; // meses * semanas * dias * horas
  }

  // Setters
  void setCarrera(String value) {
    _carrera = value;
    notifyListeners();
  }

  void setUniversidad(String value) {
    _universidad = value;
    notifyListeners();
  }

  void setNivelEspanol(String value) {
    _nivelEspanol = value;
    notifyListeners();
  }

  void setNivelBiologia(String value) {
    _nivelBiologia = value;
    notifyListeners();
  }

  void setDias(int value) {
    _dias = value;
    notifyListeners();
  }

  void setHoras(int value) {
    _horas = value;
    notifyListeners();
  }

  void setMeses(int value) {
    _meses = value;
    notifyListeners();
  }

  // Bulk update method
  void updateFormData({
    String? carrera,
    String? universidad,
    String? nivelEspanol,
    String? nivelBiologia,
    int? dias,
    int? horas,
    int? meses,
  }) {
    if (carrera != null) _carrera = carrera;
    if (universidad != null) _universidad = universidad;
    if (nivelEspanol != null) _nivelEspanol = nivelEspanol;
    if (nivelBiologia != null) _nivelBiologia = nivelBiologia;
    if (dias != null) _dias = dias;
    if (horas != null) _horas = horas;
    if (meses != null) _meses = meses;
    notifyListeners();
  }

  // Reset form
  void resetForm() {
    _carrera = '';
    _universidad = '';
    _nivelEspanol = '';
    _nivelBiologia = '';
    _dias = 0;
    _horas = 0;
    _meses = 0;
    notifyListeners();
  }

  // Load from previous data (if you want to edit existing form)
  void loadFromData(Map<String, dynamic> data) {
    _carrera = data['carrera'] ?? '';
    _universidad = data['universidad'] ?? '';
    _nivelEspanol = data['nivel_español'] ?? '';
    _nivelBiologia = data['nivel_biologia'] ?? '';
    _dias = data['dias'] ?? 0;
    _horas = data['horas'] ?? 0;
    _meses = data['meses'] ?? 0;
    notifyListeners();
  }

  // Method to set skill levels based on exam results
  void setSkillLevelsFromExam(double spanishPercentage, double biologyPercentage) {
    // Set Spanish level based on percentage
    if (spanishPercentage >= 80) {
      _nivelEspanol = 'Avanzado';
    } else if (spanishPercentage >= 60) {
      _nivelEspanol = 'Intermedio';
    } else {
      _nivelEspanol = 'Básico';
    }

    // Set Biology level based on percentage
    if (biologyPercentage >= 80) {
      _nivelBiologia = 'Avanzado';
    } else if (biologyPercentage >= 60) {
      _nivelBiologia = 'Intermedio';
    } else {
      _nivelBiologia = 'Básico';
    }

    notifyListeners();
  }
}
