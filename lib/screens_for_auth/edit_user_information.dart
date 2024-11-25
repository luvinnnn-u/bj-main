import 'dart:io';
import 'package:bluejobs/dropdowns/addresses.dart';
import 'package:bluejobs/navigation/employer_navigation.dart';
import 'package:bluejobs/navigation/jobhunter_navigation.dart';
import 'package:bluejobs/provider/auth_provider.dart';
import 'package:bluejobs/styles/custom_button.dart';
import 'package:bluejobs/styles/custom_theme.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:bluejobs/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditUserInformation extends StatefulWidget {
  const EditUserInformation({super.key});

  @override
  State<EditUserInformation> createState() => _EditUserInformationState();
}

class _EditUserInformationState extends State<EditUserInformation> {
  File? image;
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _suffixController = TextEditingController();
  final _birthdayController = TextEditingController();
  String? _address;
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _middleNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _suffixFocusNode = FocusNode();
  final authProvider = AuthProvider();

  bool _isSuffixFocused = false;

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _suffixController.dispose();
    _birthdayController.dispose();
  }

  @override
  void initState() {
    super.initState();
    final ap = Provider.of<AuthProvider>(context, listen: false);
    if (ap.isSignedIn) {
      _firstNameController.text = ap.userModel.firstName;
      _middleNameController.text = ap.userModel.middleName;
      _lastNameController.text = ap.userModel.lastName;
      _suffixController.text = ap.userModel.suffix;
      _address = ap.userModel.address;
      image = File(ap.userModel.profilePic ?? '');
    }
    _firstNameFocusNode.addListener(_onFocusChange);
    _middleNameFocusNode.addListener(_onFocusChange);
    _lastNameFocusNode.addListener(_onFocusChange);
    _suffixFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isSuffixFocused = _suffixFocusNode.hasFocus;
    });
  }

  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userLoggedIn = Provider.of<AuthProvider>(context, listen: false);
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: const Color.fromARGB(255, 7, 30, 47),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: SafeArea(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  height: MediaQuery.of(context).size.height -
                      100, // Adjust the height to fit the content
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Edit your account details.",
                              style: CustomTextStyle.semiBoldText.copyWith(
                                  fontSize: responsiveSize(context, 0.05)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () => selectImage(),
                          child: image == null
                              ? const CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 0, 0, 0),
                                  radius: 50,
                                  child: Icon(
                                    Icons.account_circle,
                                    size: 50,
                                    color: Color.fromARGB(255, 243, 236, 236),
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      userLoggedIn.userModel.profilePic ??
                                          'null'),
                                  radius: 50,
                                ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListBody(
                            children: [
                              _buildLabel('First Name'),
                              TextField(
                                // first name input
                                controller: _firstNameController,
                                focusNode: _firstNameFocusNode,
                                cursorColor: Color.fromARGB(255, 7, 30, 47),
                                style: CustomTextStyle.regularText.copyWith(
                                    fontSize: responsiveSize(context, 0.04)),
                                decoration: customInputDecoration(''),
                              ),
                              const SizedBox(height: 20),
                              _buildLabel('Last Name'),
                              TextField(
                                // last name input
                                controller: _lastNameController,
                                focusNode: _lastNameFocusNode,
                                cursorColor: Color.fromARGB(255, 7, 30, 47),
                                style: CustomTextStyle.regularText.copyWith(
                                    fontSize: responsiveSize(context, 0.04)),
                                decoration: customInputDecoration(''),
                              ),
                              const SizedBox(height: 20),
                              _buildLabel('Middle Name (*Optional)'),
                              TextField(
                                // middle name input
                                controller: _middleNameController,
                                focusNode: _middleNameFocusNode,
                                cursorColor: Color.fromARGB(255, 7, 30, 47),
                                style: CustomTextStyle.regularText.copyWith(
                                    fontSize: responsiveSize(context, 0.04)),
                                decoration: customInputDecoration(''),
                              ),
                              const SizedBox(height: 20),
                              _buildLabel('Suffix(*Optional)'),
                              TextField(
                                // suffix input
                                controller: _suffixController,
                                focusNode: _suffixFocusNode,
                                cursorColor: Color.fromARGB(255, 7, 30, 47),
                                style: CustomTextStyle.regularText.copyWith(
                                    fontSize: responsiveSize(context, 0.04)),
                                decoration: customInputDecoration(''),
                              ),
                              if (_isSuffixFocused)
                                Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Suffixes: Sr., Jr., II, III,  etc.',
                                    style: CustomTextStyle.regularText.copyWith(
                                        fontSize:
                                            responsiveSize(context, 0.03)),
                                  ),
                                ),
                              const SizedBox(height: 15),
//addresss
                              _buildLabel('Find your Address'),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Autocomplete<String>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return const Iterable<String>.empty();
                                    }
                                    // Fix input in address because of other syntaxes like commas
                                    String normalizedInput = textEditingValue
                                        .text
                                        .toLowerCase()
                                        .replaceAll(',', '');
                                    return Addresses.allAddresses
                                        .where((String option) {
                                      String normalizedOption = option
                                          .toLowerCase()
                                          .replaceAll(',', '');
                                      return normalizedOption
                                          .contains(normalizedInput);
                                    }).toList();
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          fieldTextEditingController,
                                      FocusNode fieldFocusNode,
                                      VoidCallback onFieldSubmitted) {
                                    return TextField(
                                      controller: fieldTextEditingController,
                                      focusNode: fieldFocusNode,
                                      cursorColor: Color.fromARGB(255, 7, 30, 47),
                                      style: CustomTextStyle.regularText
                                          .copyWith(
                                              fontSize: responsiveSize(
                                                  context, 0.04)),
                                      decoration: customInputDecoration(
                                        '',
                                        suffixIcon: IconButton(
                                          icon: const Icon(
                                            Icons.search,
                                            color: const Color.fromARGB(
                                                255, 7, 30, 47),
                                          ),
                                          onPressed:
                                              () {}, // Add functionality if needed
                                        ),
                                      ),
                                    );
                                  },
                                  optionsViewBuilder: (BuildContext context,
                                      AutocompleteOnSelected<String> onSelected,
                                      Iterable<String> options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        color: const Color.fromARGB(
                                            255, 7, 30, 47),
                                        // Add this line to change the background color of the options
                                        child: ListView(
                                          padding: EdgeInsets.zero,
                                          children: options
                                              .map<Widget>((String option) {
                                            return InkWell(
                                              onTap: () => onSelected(option),
                                              child: ListTile(
                                                title: Text(
                                                  option,
                                                  style: CustomTextStyle
                                                      .regularText,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                  onSelected: (String selection) {
                                    setState(() {
                                      _address = selection;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 20),

                              SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.90,
                                child: CustomButton(
                                  buttonText: isLoading ? "Saving..." : "Save",
                                  isLoading: isLoading,
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          storeData();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Profile edited successfully',
                                                style:
                                                    CustomTextStyle.regularText,
                                              ),
                                              backgroundColor: Color.fromARGB(
                                                  255, 243, 107, 4),
                                            ),
                                          );
                                        },
                                ),
                              ),
                              const SizedBox(height: 15),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 7, 30, 47),
                                  minimumSize: Size(double.infinity,
                                      50), // Set the height to 50
                                  side: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      width: 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () {
                                  authProvider.initiateUserDeletion(context);
                                },
                                child: Text(
                                  'Delete Account',
                                  style: CustomTextStyle.regularText.copyWith(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: responsiveSize(context, 0.04)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

//text above fields
  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        label,
        style: CustomTextStyle.semiBoldText
            .copyWith(fontSize: responsiveSize(context, 0.04)),
      ),
    );
  }

  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    String? firstName = _firstNameController.text.trim().isEmpty
        ? null
        : _firstNameController.text.trim();
    String? middleName = _middleNameController.text.trim().isEmpty
        ? null
        : _middleNameController.text.trim();
    String? lastName = _lastNameController.text.trim().isEmpty
        ? null
        : _lastNameController.text.trim();
    String? suffix = _suffixController.text.trim().isEmpty
        ? null
        : _suffixController.text.trim();
    String? address =
        _address?.trim().isEmpty ?? true ? null : _address?.trim();
    image = image ?? null;

    await ap.updateUserData(
      context: context,
      uid: ap.uid,
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      suffix: suffix,
      address: address,
      profilePic: image,
      onSuccess: () {
        ap.saveUserDataToSP().then((value) {
          String role = ap.userModel.role;

          // Navigate to the designated page based on the role
          if (role == 'Employer') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const EmployerNavigation(),
              ),
              (route) => false,
            );
          } else if (role == 'Job Hunter') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const JobhunterNavigation(),
              ),
              (route) => false,
            );
          }
        });
      },
    );
  }
}
