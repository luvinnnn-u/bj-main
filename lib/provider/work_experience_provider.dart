import 'package:bluejobs/model/work_experience_model.dart';
import 'package:flutter/material.dart';


class WorkExperienceProvider with ChangeNotifier {
  List<WorkExperience> _workExperiences = [];

  List<WorkExperience> get workExperiences => _workExperiences;

  void addWorkExperience(WorkExperience workExperience) {
    _workExperiences.add(workExperience);
    notifyListeners();
  }

  void clearWorkExperiences() {
    _workExperiences.clear();
    notifyListeners();
  }
}