// import 'package:bluejobs/styles/custom_theme.dart';
// import 'package:bluejobs/styles/responsive_utils.dart';
// import 'package:bluejobs/styles/textstyle.dart';
// import 'package:flutter/material.dart';

// class SkillSetPage extends StatefulWidget {
//   const SkillSetPage({super.key});

//   @override
//   State<SkillSetPage> createState() => _SkillSetPageState();
// }

// class _SkillSetPageState extends State<SkillSetPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: BackButton(
//           color: Color.fromARGB(255, 7, 30, 47),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           'Skills Form',
//           style: CustomTextStyle.semiBoldText.copyWith(
//             fontSize: responsiveSize(context, 0.04),
//           ),
//         ),
//       ),
//       body: Container(
//         color: Colors.white,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//         child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [
//             _buildLabel('Enter Skills'),
//             TextFormField(
//               decoration: customInputDecoration(''),
//             ), 
//              const SizedBox(height: 16),

//            ],
//         ),
//         ),
//       ),
//     );
//   }

//     // For text outside field
//   Widget _buildLabel(String label) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 5.0),
//       child: Text(
//         label,
//         style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),
//       ),
//     );
//   }
// }



import 'package:bluejobs/styles/custom_button.dart';
import 'package:bluejobs/styles/custom_theme.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:flutter/material.dart';


class SkillSetPage extends StatefulWidget {
  const SkillSetPage({super.key});

  @override
  State<SkillSetPage> createState() => _SkillSetPageState();
}

class _SkillSetPageState extends State<SkillSetPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedSkillLevel = 'Beginner'; // Default value
  String _skill = '';

  // List of skill levels
  final List<String> _skillLevels = ['Beginner', 'Intermediate', 'Advanced'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Color.fromARGB(255, 7, 30, 47),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Skills Form',
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
                _buildLabel('Enter Skills'),
                TextFormField(
                  decoration: customInputDecoration(''),
                  onChanged: (value) {
                    _skill = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a skill';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('Select Skill Level'),
                DropdownButtonFormField<String>(
                  value: _selectedSkillLevel,
                  decoration: customInputDecoration('Select Skill Level'),
                  items: _skillLevels.map((String level) {
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
                      _selectedSkillLevel = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a skill level';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process the data (e.g., save to a database or send to an API)
                      print('Skill: $_skill');
                      print('Skill Level: $_selectedSkillLevel');
                      // Optionally, show a success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Color.fromARGB(255, 243, 107, 4),
                          content: Text(
                            'Skill details submitted!',
                            style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04), color: Colors.white),
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