// import 'dart:io';
// import 'package:bluejobs/dropdowns/addresses.dart';
// import 'package:bluejobs/model/user_model.dart';
// import 'package:bluejobs/provider/auth_provider.dart';
// import 'package:bluejobs/screens_for_auth/confetti.dart';
// import 'package:bluejobs/screens_for_auth/skills.dart';
// import 'package:bluejobs/styles/custom_button.dart';
// import 'package:bluejobs/styles/custom_theme.dart';
// import 'package:bluejobs/styles/responsive_utils.dart';
// import 'package:bluejobs/styles/textstyle.dart';
// import 'package:bluejobs/utils/responsive_utils.dart';
// import 'package:bluejobs/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:provider/provider.dart';

// class UserInformation extends StatefulWidget {
//   final String email;

//   const UserInformation({super.key, required this.email});

//   @override
//   State<UserInformation> createState() => _UserInformationState();
// }

// class _UserInformationState extends State<UserInformation> {
//   File? image;
//   final _firstNameController = TextEditingController();
//   final _middleNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _suffixController = TextEditingController();
//   final _phoneController = TextEditingController();
//   String? _roleSelection;
//   String? _sex;
//   final _birthdayController = TextEditingController();
//   String? _address;
//   // focus node - name and email
//   final FocusNode _firstNameFocusNode = FocusNode();
//   final FocusNode _middleNameFocusNode = FocusNode();
//   final FocusNode _lastNameFocusNode = FocusNode();
//   final FocusNode _suffixFocusNode = FocusNode();
//   final FocusNode _emailFocusNode = FocusNode();
//   // birthdate
//   final FocusNode _birthdayFocusNode = FocusNode();
//   DateTime? _selectedDate;

//   bool _isSuffixFocused = false;

//   @override
//   void dispose() {
//     super.dispose();
//     _firstNameController.dispose();
//     _middleNameController.dispose();
//     _lastNameController.dispose();
//     _suffixController.dispose();
//     _phoneController.dispose();
//     _birthdayController.dispose();
//     _birthdayFocusNode.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Listen for focus changes
//     _firstNameFocusNode.addListener(_onFocusChange);
//     _middleNameFocusNode.addListener(_onFocusChange);
//     _lastNameFocusNode.addListener(_onFocusChange);
//     _suffixFocusNode.addListener(_onFocusChange);
//     _emailFocusNode.addListener(_onFocusChange);
//     _roleSelection = null;
//     _address = null;
//   }

//   void _onFocusChange() {
//     setState(() {
//       _isSuffixFocused = _suffixFocusNode.hasFocus;
//     });
//   }

// // birthdate input
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//     if (pickedDate != null && pickedDate != _selectedDate) {
//       setState(() {
//         _selectedDate = pickedDate;
//         _birthdayController.text =
//             DateFormat('MM-dd-yyyy').format(_selectedDate!);
//       });
//     }
//   }

//   // for selecting image
//   void selectImage() async {
//     image = await pickImage(context);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isLoading =
//         Provider.of<AuthProvider>(context, listen: true).isLoading;
//     final responsive = ResponsiveUtils(context);
//     return Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: const Color.fromARGB(255, 7, 30, 47),
//         ),
//         body: SafeArea(
//           child: isLoading == true
//               ? const Center(
//                   child: CircularProgressIndicator(
//                     color: Colors.grey,
//                   ),
//                 )
//               : SingleChildScrollView(
//                   child: Column(children: [
//                     SizedBox(height: responsive.verticalPadding(0.03)),
//                     Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: responsive.horizontalPadding(0.05)),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text("Let's set up your account.",
//                               style: CustomTextStyle.semiBoldText.copyWith(
//                                   fontSize: responsiveSize(context, 0.05))),
//                         )),

//                     SizedBox(height: responsive.verticalPadding(0.03)),
//                     // circle avatar
//                     InkWell(
//                       onTap: () => selectImage(),
//                       child: image == null
//                           ? const CircleAvatar(
//                               backgroundColor: Colors.grey,
//                               radius: 50,
//                               child: Icon(
//                                 Icons.account_circle,
//                                 size: 50,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : CircleAvatar(
//                               backgroundImage: FileImage(image!),
//                               radius: 50,
//                             ),
//                     ),

//                     const Padding(
//                       padding: EdgeInsets.only(top: 8.0),
//                       child: Text(
//                         'Tap to Select an Image',
//                         style: TextStyle(color: Colors.grey, fontSize: 12),
//                       ),
//                     ),

//                     SizedBox(height: responsive.verticalPadding(0.03)),

//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: responsive.horizontalPadding(0.04)),
//                       child: ListBody(children: [
//                         TextField(
//                           // first name input
//                           controller: _firstNameController,
//                           focusNode: _firstNameFocusNode,
//                           decoration: customInputDecoration('First Name'),
//                         ),

//                         SizedBox(height: responsive.verticalPadding(0.02)),

//                         TextField(
//                           // last name input
//                           controller: _lastNameController,
//                           focusNode: _lastNameFocusNode,
//                           decoration: customInputDecoration('Last Name'),
//                         ),

//                         SizedBox(height: responsive.verticalPadding(0.02)),

//                         TextField(
//                           // middle name input
//                           controller: _middleNameController,
//                           focusNode: _middleNameFocusNode,
//                           decoration:
//                               customInputDecoration('Middle Name (Optional)'),
//                         ),

//                         SizedBox(height: responsive.verticalPadding(0.02)),

//                         TextField(
//                           // suffix input
//                           controller: _suffixController,
//                           focusNode: _suffixFocusNode,
//                           decoration:
//                               customInputDecoration('Suffix (Optional)'),
//                         ),
//                         if (_isSuffixFocused)
//                           const Padding(
//                             padding: EdgeInsets.only(top: 8.0),
//                             child: Text(
//                               'Suffixes: Sr., Jr., II, III,  etc.',
//                               style:
//                                   TextStyle(color: Colors.grey, fontSize: 12),
//                             ),
//                           ),

//                         SizedBox(height: responsive.verticalPadding(0.02)),

//                         IntlPhoneField(
//                           decoration: customInputDecoration('Phone Number'),
//                           controller: _phoneController,
//                           initialCountryCode: 'PH',
//                           onChanged: (phone) {},
//                         ),

//                         // sex input
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: responsive.horizontalPadding(0.04)),
//                           child: Column(
//                             children: [
//                               const Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Sex',
//                                     style: CustomTextStyle.regularText,
//                                   ),
//                                 ],
//                               ),
//                               RadioListTile(
//                                 title: const Text(
//                                   'Male',
//                                   style: CustomTextStyle.regularText,
//                                 ),
//                                 value: 'Male',
//                                 groupValue: _sex,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _sex = value as String?;
//                                   });
//                                 },
//                               ),
//                               RadioListTile(
//                                 title: const Text('Female',
//                                     style: CustomTextStyle.regularText),
//                                 value: 'Female',
//                                 groupValue: _sex,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _sex = value as String?;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),

//                         // birthdate input
//                         Padding(
//                           padding: const EdgeInsets.only(top: 7.0),
//                           child: GestureDetector(
//                             onTap: () => _selectDate(context),
//                             child: AbsorbPointer(
//                               child: TextField(
//                                 controller: _birthdayController,
//                                 focusNode: _birthdayFocusNode,
//                                 decoration: const InputDecoration(
//                                     labelText: 'Birthday',
//                                     labelStyle: CustomTextStyle.regularText,
//                                     suffixIcon: Icon(Icons.calendar_today),
//                                     hintText: 'Select your birthday',
//                                     hintStyle: CustomTextStyle.regularText,
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: Colors.grey,
//                                         width: 1,
//                                       ),
//                                     )),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: responsive.verticalPadding(0.01)),

//                         // address input
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           //auto complete search addresses, but only in albay
//                           child: Autocomplete<String>(
//                             optionsBuilder:
//                                 (TextEditingValue textEditingValue) {
//                               if (textEditingValue.text.isEmpty) {
//                                 return const Iterable<String>.empty();
//                               }
//                               // fix input in adress because of other syntaxes like comma
//                               String normalizedInput = textEditingValue.text
//                                   .toLowerCase()
//                                   .replaceAll(',', '');
//                               return Addresses.allAddresses
//                                   .where((String option) {
//                                 String normalizedOption =
//                                     option.toLowerCase().replaceAll(',', '');
//                                 return normalizedOption
//                                     .contains(normalizedInput);
//                               }).toList();
//                             },
//                             fieldViewBuilder: (BuildContext context,
//                                 TextEditingController
//                                     fieldTextEditingController,
//                                 FocusNode fieldFocusNode,
//                                 VoidCallback onFieldSubmitted) {
//                               return TextField(
//                                 controller: fieldTextEditingController,
//                                 focusNode: fieldFocusNode,
//                                 decoration: const InputDecoration(
//                                   labelText: 'Find your Address',
//                                   labelStyle: CustomTextStyle.regularText,
//                                   suffixIcon: Icon(Icons.search),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                       color: Colors.grey,
//                                       width: 1,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                             optionsViewBuilder: (BuildContext context,
//                                 AutocompleteOnSelected<String> onSelected,
//                                 Iterable<String> options) {
//                               return Align(
//                                 alignment: Alignment.topLeft,
//                                 child: Material(
//                                   child: ListView(
//                                     padding: EdgeInsets.zero,
//                                     children:
//                                         options.map<Widget>((String option) {
//                                       return InkWell(
//                                         onTap: () => onSelected(option),
//                                         child: ListTile(
//                                           title: Text(option),
//                                         ),
//                                       );
//                                     }).toList(),
//                                   ),
//                                 ),
//                               );
//                             },
//                             onSelected: (String selection) {
//                               setState(
//                                 () {
//                                   _address = selection;
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                         SizedBox(height: responsive.verticalPadding(0.01)),
//                         // user type or role input
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Column(
//                             children: [
//                               Container(
//                                 height: 57.0,
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 10),
//                                 decoration: BoxDecoration(
//                                   border:
//                                       Border.all(color: Colors.grey, width: 1),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: DropdownButton<String>(
//                                   value: _roleSelection,
//                                   onChanged: (String? newValue) {
//                                     setState(() {
//                                       _roleSelection = newValue;
//                                     });
//                                   },
//                                   items: <String>['Job Hunter', 'Employer']
//                                       .map<DropdownMenuItem<String>>(
//                                           (String value) {
//                                     return DropdownMenuItem<String>(
//                                       value: value,
//                                       child: Text(value),
//                                     );
//                                   }).toList(),
//                                   hint: const Padding(
//                                     padding: EdgeInsets.only(top: 8.0),
//                                     child: Text(
//                                       'Select your Role: Employer or Job Hunter',
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                   ),
//                                   style: CustomTextStyle.regularText,
//                                   isExpanded: true,
//                                   underline: Container(
//                                     height: 0,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: responsive.verticalPadding(0.09)),
//                         // button for submition
//                         SizedBox(
//                           height: 50,
//                           width: MediaQuery.of(context).size.width * 0.90,
//                           child: CustomButton(
//                             buttonText: "Proceed",
//                             onPressed: () {
//                               storeData();
//                             },
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 400,
//                         ),
//                       ]),
//                     ),
//                   ]),
//                 ),
//         ));
//   }

//   // storing data function
//   void storeData() async {
//     final ap = Provider.of<AuthProvider>(context, listen: false);

//     if (image == null) {
//       showSnackBar(context, "Please upload your profile photo");
//       return;
//     }
//     if (_firstNameController.text.isEmpty) {
//       showSnackBar(context, "Please enter your first name");
//       return;
//     }
//     if (_lastNameController.text.isEmpty) {
//       showSnackBar(context, "Please enter your last name");
//       return;
//     }
//     if (_phoneController.text.isEmpty) {
//       showSnackBar(context, "Please enter your phone number");
//       return;
//     }
//     if (_sex == null) {
//       showSnackBar(context, "Please select your sex");
//       return;
//     }
//     if (_birthdayController.text.isEmpty) {
//       showSnackBar(context, "Please enter your birthday");
//       return;
//     }
//     if (_address == null) {
//       showSnackBar(context, "Please enter your address");
//       return;
//     }
//     if (_roleSelection == null) {
//       showSnackBar(context, "Please select your role, this is Important!");
//       return;
//     }

//     String middleName = _middleNameController.text.trim();
//     String suffix = _suffixController.text.trim();

//     UserModel userModel = UserModel(
//       firstName: _firstNameController.text.trim(),
//       middleName: middleName.isEmpty ? '' : middleName,
//       lastName: _lastNameController.text.trim(),
//       suffix: suffix.isEmpty ? '' : suffix,
//       email: '',
//       role: _roleSelection?.trim() ?? "",
//       sex: _sex ?? "",
//       birthdate: _birthdayController.text.trim(),
//       address: _address?.trim() ?? "",
//       profilePic: "",
//       createdAt: "",
//       phoneNumber: _phoneController.text.trim(),
//       isEnabled: true,
//       uid: ap.uid,
//     );

//     ap.saveUserDataToFirebase(
//       context: context,
//       userModel: userModel,
//       profilePic: image!,
//       onSuccess: () {
//         ap.saveUserDataToSP().then((value) {
//           ap.setSignIn();
//           String role = userModel.role;
//           if (role == 'Employer') {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const DoneCreatePage(),
//               ),
//               (route) => false,
//             );
//           } else if (role == 'Job Hunter') {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const ButtonSpecializationPage(),
//               ),
//               (route) => false,
//             );
//           }
//         });
//       },
//     );
//   }
// }





import 'dart:io';
import 'package:bluejobs/dropdowns/addresses.dart';
import 'package:bluejobs/model/user_model.dart';
import 'package:bluejobs/provider/auth_provider.dart';
import 'package:bluejobs/screens_for_auth/confetti.dart';
import 'package:bluejobs/screens_for_auth/skills.dart';
import 'package:bluejobs/styles/custom_button.dart';
import 'package:bluejobs/styles/custom_theme.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:bluejobs/utils/responsive_utils.dart';
import 'package:bluejobs/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import 'package:intl_phone_field/countries.dart';

class UserInformation extends StatefulWidget {
  final String email;

  const UserInformation({super.key, required this.email});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  File? image;
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _suffixController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _roleSelection;
  String? _sex;
  final _birthdayController = TextEditingController();
  String? _address;
  // focus node - name and email
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _middleNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _suffixFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  // birthdate
  final FocusNode _birthdayFocusNode = FocusNode();
  DateTime? _selectedDate;

  bool _isSuffixFocused = false;

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _suffixController.dispose();
    _phoneController.dispose();
    _birthdayController.dispose();
    _birthdayFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Listen for focus changes
    _firstNameFocusNode.addListener(_onFocusChange);
    _middleNameFocusNode.addListener(_onFocusChange);
    _lastNameFocusNode.addListener(_onFocusChange);
    _suffixFocusNode.addListener(_onFocusChange);
    _emailFocusNode.addListener(_onFocusChange);
    _roleSelection = null;
    _address = null;
  }

  void _onFocusChange() {
    setState(() {
      _isSuffixFocused = _suffixFocusNode.hasFocus;
    });
  }

// birthdate input
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );
  //   if (pickedDate != null && pickedDate != _selectedDate) {
  //     setState(() {
  //       _selectedDate = pickedDate;
  //       _birthdayController.text =
  //           DateFormat('MM-dd-yyyy').format(_selectedDate!);
  //     });
  //   }
  // }


//   Future<void> _selectDate(BuildContext context) async {
//   final DateTime? picked = await showDatePicker(
//     context: context,
//     initialDate: DateTime.now(),
//     firstDate: DateTime(1900),
//     lastDate: DateTime(2100),
//     builder: (BuildContext context, Widget? child) {
//       return Theme(
//         data: ThemeData.light().copyWith(
//           // Background color of the calendar dialog
//           dialogBackgroundColor: const Color.fromARGB(255, 7, 30, 47),
//           primaryColor: Colors.orange, // Color for selected date
//           textTheme: const TextTheme(
//             // Year and date text color
//             bodyMedium: TextStyle(color: Colors.white), // Default text color
//             headlineMedium: TextStyle(color: Colors.white), // Month and year text color
            
//           ),
//           colorScheme: ColorScheme.light(
//             primary: Colors.orange, // Color for selected date
//             onPrimary: Colors.white, // Text color on selected date
//             onSurface: Colors.white, // Default text color for unselected dates
//           ),
//           buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
//         ),
//         child: child ?? const SizedBox.shrink(),
//       );
//     },
//   );

//   // Handle the picked date if necessary
//   if (picked != null && picked != DateTime.now()) {
//     // Perform actions with the picked date
//   }
// }



// Future<void> _selectDate(BuildContext context) async {
//   final DateTime? picked = await showDatePicker(
//     context: context,
//     initialDate: DateTime.now(),
//     firstDate: DateTime(1900),
//     lastDate: DateTime(2100),
//     builder: (BuildContext context, Widget? child) {
//       return Theme(
//         data: ThemeData.light().copyWith(
//           dialogBackgroundColor: const Color.fromARGB(255, 7, 30, 47), // Blue background
//           primaryColor: Colors.orange, // Color for selected date
//           scaffoldBackgroundColor: const Color.fromARGB(255, 7, 30, 47), // Ensures background consistency
//           textTheme: const TextTheme(
//             bodyMedium: TextStyle(color: Colors.white), // Year and date text color
//             headlineMedium: TextStyle(color: Colors.white), // Month and year text color
//           ),
//           colorScheme: ColorScheme.light(
//             primary: Colors.orange, // Color for selected date
//             onPrimary: Colors.white, // Text color on selected date
//             onSurface: Colors.white, // Default text color for unselected dates
//             background: const Color.fromARGB(255, 7, 30, 47), // Blue background for the calendar
//           ),
//           dialogTheme: const DialogTheme(
//             backgroundColor: Color.fromARGB(255, 7, 30, 47), // Blue background for dialog
//           ),
//         ),
//         child: child ?? const SizedBox.shrink(),
//       );
//     },
//   );

//   // Handle the picked date if necessary
//   if (picked != null && picked != DateTime.now()) {
//     // Perform actions with the picked date
//   }
// }


// Future<void> _selectDate(BuildContext context) async {
//   DateTime selectedDate = DateTime.now();

//   await showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Dialog(
//         backgroundColor: const Color.fromARGB(255, 7, 30, 47), // Blue background for the entire dialog
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: CalendarDatePicker(
//           initialDate: selectedDate,
//           firstDate: DateTime(1900),
//           lastDate: DateTime(2100),
//           onDateChanged: (DateTime newDate) {
//             selectedDate = newDate;
//             Navigator.of(context).pop(); // Close the dialog after selecting a date
//           },
//           selectableDayPredicate: (DateTime day) {
//             return true; // All days are selectable
//           },
//         ),
//       );
//     },
//   );
// }


Future<void> _selectDate(BuildContext context) async {
  DateTime selectedDate = DateTime.now();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: const Color.fromARGB(255, 7, 30, 47), // Blue background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Theme(
          data: ThemeData.light().copyWith(
            dialogBackgroundColor: const Color.fromARGB(255, 7, 30, 47), // Blue background for the entire dialog
            primaryColor: Colors.orange, // Color for the selected date
            colorScheme: ColorScheme.light(
              primary: Colors.orange, // Color for the selected date
              onPrimary: Colors.white, // Text color on the selected date
              onSurface: Colors.white, // Default text color for other dates
            ),
            textTheme: TextTheme(
              bodyMedium: CustomTextStyle.regularText, // Applies to the dates
              headlineSmall: CustomTextStyle.semiBoldText, // Applies to months and year
            ),
          ),
          child: CalendarDatePicker(
            initialDate: selectedDate,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            onDateChanged: (DateTime newDate) {
              selectedDate = newDate;
              Navigator.of(context).pop(); // Close the dialog after selecting a date
            },
            selectableDayPredicate: (DateTime day) {
              return true; // All days are selectable
            },
          ),
        ),
      );
    },
  );
}



  // for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    final responsive = ResponsiveUtils(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 7, 30, 47),
        ),
      
        body: Container(
      color: const Color.fromARGB(255, 7, 30, 47),
        child: SafeArea(
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                )
              : SingleChildScrollView(
                
                  child: Column(children: [
                    SizedBox(height: responsive.verticalPadding(0.03)),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: responsive.horizontalPadding(0.05)),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Let's set up your account.",
                              style: CustomTextStyle.semiBoldText.copyWith(
                                  fontSize: responsiveSize(context, 0.05))),
                        )),

                    SizedBox(height: responsive.verticalPadding(0.03)),
                    // circle avatar
                    InkWell(
                      onTap: () => selectImage(),
                      child: image == null
                          ? const CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 255, 255, 255),
                              radius: 50,
                              child: Icon(
                                Icons.account_circle,
                                size: 50,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            )
                          : CircleAvatar(
                              backgroundImage: FileImage(image!),
                              radius: 50,
                            ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Tap to Select an Image',
                        style: CustomTextStyle.regularText
                      ),
                    ),

                    SizedBox(height: responsive.verticalPadding(0.03)),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: responsive.horizontalPadding(0.04)),
                      child: ListBody(children: [
                        TextField(
                          // first name input
                          controller: _firstNameController,
                          focusNode: _firstNameFocusNode,
                          decoration: customInputDecoration('First Name'),
                           style: CustomTextStyle.regularText.copyWith(
                           fontSize: responsiveSize(context, 0.04),)
                        ),

                        SizedBox(height: responsive.verticalPadding(0.02)),

                        TextField(
                          // last name input
                          controller: _lastNameController,
                          focusNode: _lastNameFocusNode,
                          decoration: customInputDecoration('Last Name'),
                           style: CustomTextStyle.regularText.copyWith(
                           fontSize: responsiveSize(context, 0.04),)
                        ),

                        SizedBox(height: responsive.verticalPadding(0.02)),

                        TextField(
                          // middle name input
                          controller: _middleNameController,
                          focusNode: _middleNameFocusNode,
                          decoration:
                              customInputDecoration('Middle Name (Optional)'),
                               style: CustomTextStyle.regularText.copyWith(
                           fontSize: responsiveSize(context, 0.04),)
                        ),

                        SizedBox(height: responsive.verticalPadding(0.02)),

                        TextField(
                          // suffix input
                          controller: _suffixController,
                          focusNode: _suffixFocusNode,
                          decoration:
                              customInputDecoration('Suffix (Optional)'),
                               style: CustomTextStyle.regularText.copyWith(
                           fontSize: responsiveSize(context, 0.04),)
                        ),
                        if (_isSuffixFocused)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Suffixes: Sr., Jr., II, III,  etc.',
                              style:
                                  CustomTextStyle.regularText
                            ),
                          ),

                        SizedBox(height: responsive.verticalPadding(0.02)),

                        IntlPhoneField(
                          decoration: customInputDecoration('Phone Number'),
                          style: CustomTextStyle.regularText.copyWith(
                           fontSize: responsiveSize(context, 0.04),),
                          controller: _phoneController,
                          initialCountryCode: 'PH',
                          onChanged: (phone) {},
                        ),
                        

//sex input
                        Padding(
  padding: EdgeInsets.symmetric(
      horizontal: responsive.horizontalPadding(0.04)),
  child: Column(
    children: [
      const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Sex',
            style: CustomTextStyle.regularText,
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: RadioListTile(
              title: const Text(
                'Male',
                style: CustomTextStyle.regularText,
              ),
              value: 'Male',
              groupValue: _sex,
              onChanged: (value) {
                setState(() {
                  _sex = value as String?;
                });
              },
              activeColor: Colors.white, // Change active color to white
              tileColor: _sex == 'Male' ? Colors.blue : null, // Change background color when selected
            ),
          ),
          Expanded(
            child: RadioListTile(
              title: const Text('Female',
                  style: CustomTextStyle.regularText),
              value: 'Female',
              groupValue: _sex,
              onChanged: (value) {
                setState(() {
                  _sex = value as String?;
                });
              },
              activeColor: Colors.white, // Change active color to white
              tileColor: _sex == 'Female' ? Colors.blue : null, // Change background color when selected
            ),
          ),
        ],
      ),
    ],
  ),
),


//birthday

                        Padding(
  padding: const EdgeInsets.only(top: 7.0),
  child: GestureDetector(
    onTap: () => _selectDate(context),
    child: AbsorbPointer(
      child: TextField(
        controller: _birthdayController,
        focusNode: _birthdayFocusNode,
        decoration: InputDecoration(
          labelText: 'Birthday',
          labelStyle: CustomTextStyle.regularText,
          suffixIcon: Icon(
            Icons.calendar_today,
            color: Colors.white, // Set the icon color to white
          ),
          hintText: 'Select your birthday',
          hintStyle: CustomTextStyle.regularText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 255, 255, 255),
              width: 1,
            ),
          ),
        ),
        style: CustomTextStyle.regularText,
      ),
    ),
  ),
),



                        SizedBox(height: responsive.verticalPadding(0.01)),

                        // address input

Padding(
  padding: const EdgeInsets.only(top: 8.0),
  child: Autocomplete<String>(
    optionsBuilder: (TextEditingValue textEditingValue) {
      if (textEditingValue.text.isEmpty) {
        return const Iterable<String>.empty();
      }
      // Fix input in address because of other syntaxes like commas
      String normalizedInput = textEditingValue.text.toLowerCase().replaceAll(',', '');
      return Addresses.allAddresses.where((String option) {
        String normalizedOption = option.toLowerCase().replaceAll(',', '');
        return normalizedOption.contains(normalizedInput);
      }).toList();
    },
    fieldViewBuilder: (BuildContext context,
        TextEditingController fieldTextEditingController,
        FocusNode fieldFocusNode,
        VoidCallback onFieldSubmitted) {
      return TextField(
        controller: fieldTextEditingController,
        focusNode: fieldFocusNode,
        decoration: customInputDecoration(
          'Find your Address',
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {}, // Add functionality if needed
          ),
        ),
        style: CustomTextStyle.regularText,
      );
    },
    optionsViewBuilder: (BuildContext context,
        AutocompleteOnSelected<String> onSelected,
        Iterable<String> options) {
      return Align(
        alignment: Alignment.topLeft,
        child: Material(
          child: ListView(
            padding: EdgeInsets.zero,
            children: options.map<Widget>((String option) {
              return InkWell(
                onTap: () => onSelected(option),
                child: Container(
                  color: const Color.fromARGB(255, 7, 30, 47), // Blue background
                  child: ListTile(
                    title: Text(
                      option,
                      style: CustomTextStyle.regularText.copyWith(color: Colors.white), // White text
                    ),
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





                        SizedBox(height: responsive.verticalPadding(0.01)),



                        // user type or role input
Padding(
  padding: const EdgeInsets.only(top: 8.0),
  child: Column(
    children: [
      Container(
        height: 57.0,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: DropdownButton<String>(
          value: _roleSelection,
          onChanged: (String? newValue) {
            setState(() {
              _roleSelection = newValue;
            });
          },
          items: <String>['Job Hunter', 'Employer']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                color: const Color.fromARGB(255, 7, 30, 47), // Blue background
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding
                  child: Text(
                    value,
                    style: CustomTextStyle.regularText.copyWith(
                      color: Colors.white, // White text
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          hint: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Select your Role: Employer or Job Hunter',
              style: CustomTextStyle.regularText,
            ),
          ),
          style: CustomTextStyle.regularText.copyWith(color: Colors.white), // Style for the selected value
          dropdownColor: const Color.fromARGB(255, 7, 30, 47), // Dropdown background color
          isExpanded: true,
          underline: Container(
            height: 0,
          ),
        ),
      ),
    ],
  ),
),


                        SizedBox(height: responsive.verticalPadding(0.09)),

                        // button for submition
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.90,
                          child: CustomButton(
                            buttonText: "Proceed",
                            onPressed: () {
                              storeData();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 400,
                        ),
                      ]),
                    ),

                    
                  ]),
                ),
        )
        )
        );
  }

  // storing data function
  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    if (image == null) {
      showSnackBar(context, "Please upload your profile photo");
      return;
    }
    if (_firstNameController.text.isEmpty) {
      showSnackBar(context, "Please enter your first name");
      return;
    }
    if (_lastNameController.text.isEmpty) {
      showSnackBar(context, "Please enter your last name");
      return;
    }
    if (_phoneController.text.isEmpty) {
      showSnackBar(context, "Please enter your phone number");
      return;
    }
    if (_sex == null) {
      showSnackBar(context, "Please select your sex");
      return;
    }
    if (_birthdayController.text.isEmpty) {
      showSnackBar(context, "Please enter your birthday");
      return;
    }
    if (_address == null) {
      showSnackBar(context, "Please enter your address");
      return;
    }
    if (_roleSelection == null) {
      showSnackBar(context, "Please select your role, this is Important!");
      return;
    }

    String middleName = _middleNameController.text.trim();
    String suffix = _suffixController.text.trim();

    UserModel userModel = UserModel(
      firstName: _firstNameController.text.trim(),
      middleName: middleName.isEmpty ? '' : middleName,
      lastName: _lastNameController.text.trim(),
      suffix: suffix.isEmpty ? '' : suffix,
      email: '',
      role: _roleSelection?.trim() ?? "",
      sex: _sex ?? "",
      birthdate: _birthdayController.text.trim(),
      address: _address?.trim() ?? "",
      profilePic: "",
      createdAt: "",
      phoneNumber: _phoneController.text.trim(),
      isEnabled: true,
      uid: ap.uid,
    );

    ap.saveUserDataToFirebase(
      context: context,
      userModel: userModel,
      profilePic: image!,
      onSuccess: () {
        ap.saveUserDataToSP().then((value) {
          ap.setSignIn();
          String role = userModel.role;
          if (role == 'Employer') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const DoneCreatePage(),
              ),
              (route) => false,
            );
          } else if (role == 'Job Hunter') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ButtonSpecializationPage(),
              ),
              (route) => false,
            );
          }
        });
      },
    );
  }
}
