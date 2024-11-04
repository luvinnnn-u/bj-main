import 'package:bluejobs/model/education_model.dart';
import 'package:flutter/material.dart';

class EducationProvider with ChangeNotifier {
  List<Education> _educations = [];

  List<Education> get educations => _educations;

  void addEducation(Education education) {
    _educations.add(education);
    notifyListeners();
  }

  void clearEducations() {
    _educations.clear();
    notifyListeners();
  }
}