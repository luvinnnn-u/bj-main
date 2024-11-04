import 'package:bluejobs/styles/custom_button.dart';
import 'package:bluejobs/styles/custom_theme.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:flutter/material.dart';


class ReferencePage extends StatefulWidget {
  const ReferencePage({super.key});

  @override
  State<ReferencePage> createState() => _ReferencePageState();
}

class _ReferencePageState extends State<ReferencePage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for each TextFormField
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    _nameController.dispose();
    _companyController.dispose();
    _relationshipController.dispose();
    _contactInfoController.dispose();
    super.dispose();
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
          'References',
          style: CustomTextStyle.semiBoldText.copyWith(
            fontSize: responsiveSize(context, 0.04),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Enter Name'),
                TextFormField(
                  controller: _nameController,
                  decoration: customInputDecoration(''),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('Enter Company'),
                TextFormField(
                  controller: _companyController,
                  decoration: customInputDecoration(''),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a company';
                    }
                    return null;
                  },
                  cursorColor: Color.fromARGB(255, 7, 30, 47),
                  style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04)),
                ),
                const SizedBox(height: 16),
                _buildLabel('Enter Relationship'),
                TextFormField(
                  controller: _relationshipController,
                  decoration: customInputDecoration(''),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a relationship';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('Enter Contact Information'),
                TextFormField(
                  controller: _contactInfoController,
                  decoration: customInputDecoration(''),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter contact information';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process the data (e.g., save to a database or send to an API)
                      print('Name: ${_nameController.text}');
                      print('Company: ${_companyController.text}');
                      print('Relationship: ${_relationshipController.text}');
                      print('Contact Information: ${_contactInfoController.text}');
                      // Optionally, show a success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        
                        SnackBar(
                          backgroundColor: Color.fromARGB(255, 243, 107, 4),
                          content: Text(
                            'Reference details submitted!',
                            style: CustomTextStyle.regularText.copyWith(fontSize: responsiveSize(context, 0.04)),
                          ),
                        ),
                      );

                      // Optionally clear the fields after submission
                      _nameController.clear();
                      _companyController.clear();
                      _relationshipController.clear();
                      _contactInfoController.clear();
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
    return Padding(padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        label,
        style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),
      ),
    );
  }
}