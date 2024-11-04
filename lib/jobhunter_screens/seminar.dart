// import 'package:bluejobs/styles/custom_theme.dart';
// import 'package:bluejobs/styles/responsive_utils.dart';
// import 'package:bluejobs/styles/textstyle.dart';
// import 'package:flutter/material.dart';

// class SeminarAttendedPage extends StatefulWidget {
//   const SeminarAttendedPage({super.key});

//   @override
//   State<SeminarAttendedPage> createState() => _SeminarAttendedPageState();
// }

// class _SeminarAttendedPageState extends State<SeminarAttendedPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//     appBar: AppBar(
//         leading: BackButton(
//           color: Color.fromARGB(255, 7, 30, 47),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           'Seminars Attended Form',
//           style: CustomTextStyle.semiBoldText.copyWith(
//             fontSize: responsiveSize(context, 0.04),
//           ),
//         ),
//       ),
//       body: Container(
//         color: Colors.white,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildLabel('Enter Seminars Attended'),
// TextFormField(
//   decoration: customInputDecoration(''),
// ),
// const SizedBox(height: 16),
//  _buildLabel('Year Attended'),
 
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   //for text putside field
//   Widget _buildLabel(String label) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 5.0),
//     child: Text(
//       label,
//       style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),
//     ),
//   );
// }

// }


import 'package:bluejobs/styles/custom_button.dart';
import 'package:bluejobs/styles/custom_theme.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:flutter/material.dart';


class SeminarAttendedPage extends StatefulWidget {
  const SeminarAttendedPage({super.key});

  @override
  State<SeminarAttendedPage> createState() => _SeminarAttendedPageState();
}

class _SeminarAttendedPageState extends State<SeminarAttendedPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedYearAttended;
  String _seminarName = '';

  // Generate a list of years from 1950 to the current year
  List<String> _generateYears() {
    int currentYear = DateTime.now().year;
    return List<String>.generate(currentYear - 1949, (index) => (1950 + index).toString());
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
          'Seminars Attended Form',
          style: CustomTextStyle.semiBoldText.copyWith(
            fontSize: responsiveSize(context, 0.04),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Enter Seminars Attended'),
                TextFormField(
                  decoration: customInputDecoration(''),
                  cursorColor: Color.fromARGB(255, 7, 30, 47),
                  onChanged: (value) {
                    _seminarName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the seminar name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('Year Attended'),
                DropdownButtonFormField<String>(
                  value: _selectedYearAttended,
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
                      _selectedYearAttended = newValue;
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process the data (e.g., save to a database or send to an API)
                      print('Seminar Name: $_seminarName');
                      print('Year Attended: $_selectedYearAttended');
                      // Optionally, show a success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Color.fromARGB(255, 243, 107, 4),
                          content: Text(
                            'Seminar details submitted!',
                            style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04,),color: Colors.white),
                          ),
                        ),
                      );
                    }
                  },
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
      child: Text(
        label,
        style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),
      ),
    );
  }
}