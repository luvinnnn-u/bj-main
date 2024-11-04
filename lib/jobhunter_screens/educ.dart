import 'package:bluejobs/model/education_model.dart';
import 'package:bluejobs/provider/education_provider.dart';
import 'package:bluejobs/styles/custom_button.dart';
import 'package:bluejobs/styles/custom_theme.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:provider/provider.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedEducationLevel;
  String _schoolName = '';
  String? _selectedYearCompleted;

  final List<String> _educationLevels = [
    'Elementary',
    'Junior High School',
    'Senior High School',
    'High School',
    'Alternative Learning System',
    'Undergraduate',
    '2-Year Courses',
    'TESDA',
  ];

  // Generate a list of years from 1950 to the current year
  List<String> _generateYears() {
    int currentYear = DateTime.now().year;
    return List<String>.generate(currentYear - 1949, (index) => (1950 + index).toString());
  }

  // void _submitForm() {
  //   if (_formKey.currentState!.validate()) {
  //     // Process the data (e.g., save to a database or send to an API)
  //     print('Education Level: $_selectedEducationLevel');
  //     print('School Name: $_schoolName');
  //     print('Year Completed: $_selectedYearCompleted');
  //     // Optionally, show a success message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Color.fromARGB(255, 243, 107, 4),
  //         content: Text(
  //           'Education details submitted!',
  //           style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04), color: Colors.white),
  //         ),
  //       ),
  //     );
  //   }
  // }




void _submitForm() {
  if (_formKey.currentState!.validate()) {
    final education = Education(
      level: _selectedEducationLevel!,
      schoolName: _schoolName,
      yearCompleted: _selectedYearCompleted!,
    );

    // Add education to provider
    Provider.of<EducationProvider>(context, listen: false).addEducation(education);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Education details submitted!'),
      ),
    );

    Navigator.of(context).pop();
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Color.fromARGB(255, 7, 30, 47),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Education Form',
          style: CustomTextStyle.semiBoldText.copyWith(
            fontSize: responsiveSize(context, 0.04),
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // Set the body color to white
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildLabel('Select Education Level'),
                DropdownButtonFormField<String>(
                  value: _selectedEducationLevel,
                  decoration: customInputDecoration(''),
                  items: _educationLevels.map((String level) {
                    return DropdownMenuItem<String>(
                      value: level,
                      child: Text(
                        level,
                        style: CustomTextStyle.regularText, // Apply custom text style
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedEducationLevel = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an education level';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('Enter School Name'),
                TextFormField(
                  decoration: customInputDecoration (''),
                  onChanged: (value) {
                    _schoolName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the school name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('Select Year Completed'),
                DropdownButtonFormField<String>(
                  value: _selectedYearCompleted,
                  decoration: customInputDecoration(''),
                  items: _generateYears().map((String year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(
                        year,
                        style: CustomTextStyle.regularText, // Apply custom text style
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedYearCompleted = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a year';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: _submitForm,
                  buttonText: 'Submit',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // For text outside field
  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align to the start
        children: [
          Text(
            label,
            style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),
          ),
        ],
      ),
    );
  }
}