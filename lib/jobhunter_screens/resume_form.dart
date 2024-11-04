import 'dart:io';
import 'package:bluejobs/styles/custom_button.dart';
import 'package:bluejobs/styles/custom_theme.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bluejobs/provider/auth_provider.dart' as auth_provider;

class ResumeForm extends StatefulWidget {
  final Map<String, dynamic>? resumeData;
  final bool isEditMode;

  const ResumeForm({super.key, this.resumeData, this.isEditMode = false});

  @override
  State<ResumeForm> createState() => _ResumeFormState();
}

class _ResumeFormState extends State<ResumeForm> {
  final _formKey = GlobalKey<FormState>();
  final _experienceDescriptionController = TextEditingController();
 // final _workExperienceController = TextEditingController();
  final _skillsController = TextEditingController();
  String? _educationAttainment;
  String? _skillLevel;
  String? _policeClearanceUrl;
  String? _certificateUrl;
  String? _validIdUrl;
  String? _userId;

  final List<String> educationLevels = [
    "Elementary",
    "High School",
    "College",
  ];

  final List<String> skillLevels = [
    "Beginner",
    "Intermediate",
    "Advanced",
    "Expert",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider =
          Provider.of<auth_provider.AuthProvider>(context, listen: false);
      _userId = authProvider.uid;
    });

    if (widget.resumeData != null) {
          _experienceDescriptionController.text =
              widget.resumeData!['experienceDescription'] ?? '';
    //  _workExperienceController.text =
   //       widget.resumeData!['workExperienceDescription'] ?? '';
      _skillsController.text = widget.resumeData!['skills'] ?? '';
      _educationAttainment = widget.resumeData!['educationAttainment'];
      _skillLevel = widget.resumeData!['skillLevel'];
      _policeClearanceUrl = widget.resumeData!['policeClearanceUrl'];
      _certificateUrl = widget.resumeData!['certificateUrl'];
      _validIdUrl = widget.resumeData!['validIdUrl'];
    }
  }

  @override
  void dispose() {
    _experienceDescriptionController.dispose();
//    _workExperienceController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  Future<void> _pickFile({required String type}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      final file = result.files.single;
      await _uploadFile(file: file, type: type);
    }
  }

  Future<void> _uploadFile(
      {required PlatformFile file, required String type}) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('resumes/${_userId!}/${type}_${file.name}');
      final uploadTask = storageRef.putFile(File(file.path!));

      final snapshot = await uploadTask;
      final fileUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        if (type == 'police_clearance') {
          _policeClearanceUrl = fileUrl;
        } else if (type == 'certificate') {
          _certificateUrl = fileUrl;
        } else if (type == 'valid_id') {
          _validIdUrl = fileUrl;
        }
      });
    } catch (e) {
      print(
        'Error uploading file: $e',
      );
    }
  }

  Future<void> _submitResume() async {
    if (_formKey.currentState!.validate()) {
      if (_policeClearanceUrl == null && _validIdUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please upload either Police Clearance or a Valid ID.',
              style: CustomTextStyle.regularText
                  .copyWith(fontSize: responsiveSize(context, 0.04)),
            ),
          ),
        );
        return;
      }

         final experienceDescription = _experienceDescriptionController.text;
    //  final workExperience = _workExperienceController.text;
      final skills = _skillsController.text;

      if (_userId != null) {
        final resumeRef = FirebaseFirestore.instance
            .collection("users")
            .doc(_userId)
            .collection("resume")
            .doc(_userId);

        if (widget.isEditMode) {
          // Update existing resume data
          await resumeRef.update({
                  "experienceDescription": experienceDescription,
          //  "workExperience": workExperience, 
            "educationAttainment": _educationAttainment,
            "skillLevel": _skillLevel,
            "policeClearanceUrl": _policeClearanceUrl,
            "certificateUrl": _certificateUrl,
            "validIdUrl": _validIdUrl,
          });
        } else {
          // Create new resume data
          await resumeRef.set({
                  "experienceDescription": experienceDescription,
           // "workExperience": workExperience, 
            "skills": skills,
            "educationAttainment": _educationAttainment,
            "skillLevel": _skillLevel,
            "policeClearanceUrl": _policeClearanceUrl,
            "certificateUrl": _certificateUrl,
            "validIdUrl": _validIdUrl,
          });
        }

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Resume updated successfully',
                style: CustomTextStyle.regularText
                    .copyWith(fontSize: responsiveSize(context, 0.04))),
          ),
        );

        // Navigate back to the previous screen with a callback to reload
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User ID is empty',
                style: CustomTextStyle.regularText
                    .copyWith(fontSize: responsiveSize(context, 0.04))),
          ),
        );
      }
    }
  }

  Widget _buildFilePreview(String? fileUrl, String type) {
    if (fileUrl == null) {
      return TextButton(
        onPressed: () => _pickFile(type: type),
        child: Text(
          'Upload ${type.replaceAll('_', ' ').toUpperCase()} (PDF, JPG, PNG)',
          style: CustomTextStyle.semiBoldText
              .copyWith(fontSize: responsiveSize(context, 0.04)),
        ),
      );
    }

    bool isImage = fileUrl.endsWith('.jpg') || fileUrl.endsWith('.png');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${type.replaceAll('_', ' ').toUpperCase()} Uploaded:',
          style: CustomTextStyle.regularText
              .copyWith(fontSize: responsiveSize(context, 0.04)),
        ),
        const SizedBox(height: 8),
        isImage
            ? Image.network(fileUrl, height: 100, width: 100, fit: BoxFit.cover)
            : const Icon(Icons.picture_as_pdf,
                size: 100, color: Color.fromARGB(255, 243, 107, 4)),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => _pickFile(type: type),
          child: Text('Change File',
              style: CustomTextStyle.regularText
                  .copyWith(fontSize: responsiveSize(context, 0.04))),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text('Edit Resume Form',
            style: CustomTextStyle.semiBoldText
                .copyWith(fontSize: responsiveSize(context, 0.04))),
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // TextFormField(
                //   controller: _experienceDescriptionController,
                //   decoration: customInputDecoration('Experience Description'),
                //   cursorColor: Colors.white,

                //   maxLines: 4,
                //   style: CustomTextStyle.regularText, // Set text style
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter your experience description';
                //     }
                //     return null;
                //   },
                // ),
                // // _buildLabel('Work Experience'),
                // // TextFormField(
                // //   controller: _workExperienceController,
                // //   decoration: customInputDecoration(''),
                // //    cursorColor: Colors.white,
                // // ),
                // const SizedBox(height: 16.0),
                // DropdownButtonFormField<String>(
                //   value: _educationAttainment,
                //   decoration:
                //       customInputDecoration('Education Attainment').copyWith(
                //     border: OutlineInputBorder(
                //       borderSide: BorderSide(
                //           color: const Color.fromARGB(255, 0, 0,
                //               0)), // Set dropdown button border color to white
                //     ),
                //     filled: true,
                //     fillColor: const Color.fromARGB(255, 255, 255,
                //         255), // Set dropdown button background color to white
                //   ),
                //   style: CustomTextStyle.regularText,
                //   items: educationLevels
                //       .map((level) => DropdownMenuItem(
                //             value: level,
                //             child: Text(level,
                //                 style: CustomTextStyle.regularText.copyWith(
                //                     // Set item text style
                //                     fontSize: responsiveSize(context,
                //                         0.04) // Set item text color to white
                //                     )),
                //           ))
                //       .toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       _educationAttainment = value;
                //     });
                //   },
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please select your education level';
                //     }
                //     return null;
                //   },
                //   //dropdownColor: const Color.fromARGB(255, 7, 30, 47), // Set dropdown menu background color to blue
                // ),
                // const SizedBox(height: 16.0),
                // TextFormField(
                //   controller: _skillsController,
                //   decoration: customInputDecoration('Skills'),
                //   style: CustomTextStyle.regularText, // Set text style
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter your skills';
                //     }
                //     return null;
                //   },
                // ),
                // const SizedBox(height: 16.0),
                // DropdownButtonFormField<String>(
                //   value: _skillLevel,
                //   decoration: customInputDecoration('Skill Level'),
                //   style: CustomTextStyle.regularText, // Set text style
                //   items: skillLevels
                //       .map((level) => DropdownMenuItem(
                //             value: level,
                //             child: Text(level,
                //                 style: CustomTextStyle
                //                     .regularText), // Set item text style
                //           ))
                //       .toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       _skillLevel = value;
                //     });
                //   },
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please select your skill level';
                //     }
                //     return null;
                //   },
                // ),
                const SizedBox(height: 16.0),
                _buildFilePreview(_policeClearanceUrl, 'police_clearance'),
                const SizedBox(height: 16.0),
                _buildFilePreview(_certificateUrl, 'certificate'),
                const SizedBox(height: 16.0),
                _buildFilePreview(_validIdUrl, 'valid_id'),
                const SizedBox(height: 20.0),
               
                CustomButton(
                  onPressed: _submitResume,
                  buttonText: 'Submit Resume',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //for text putside field
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
