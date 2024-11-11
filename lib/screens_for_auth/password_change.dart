// // //original code
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';

// // class PasswordChange extends StatefulWidget {
// //   const PasswordChange({super.key});

// //   @override
// //   State<PasswordChange> createState() => _PasswordChangeState();
// // }

// // class _PasswordChangeState extends State<PasswordChange> {
// //   final _formKey = GlobalKey<FormState>();
// //   String _email = '';
// //   bool _loading = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Forgot Password'),
// //       ),
// //       body: SafeArea(
// //         child: Padding(
// //           padding: const EdgeInsets.all(20.0),
// //           child: Form(
// //             key: _formKey,
// //             child: Column(
// //               children: [
// //                 TextFormField(
// //                   decoration: InputDecoration(labelText: 'Email'),
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter your email';
// //                     }
// //                     if (!validateEmail(value)) {
// //                       return 'Invalid email address';
// //                     }
// //                     return null;
// //                   },
// //                   onSaved: (value) => _email = value ?? '',
// //                 ),
// //                 SizedBox(height: 20),
// //                 _loading
// //                     ? CircularProgressIndicator()
// //                     : ElevatedButton(
// //                         child: Text('Send password reset email'),
// //                         onPressed: () async {
// //                           if (_formKey.currentState!.validate()) {
// //                             _formKey.currentState!.save();
// //                             setState(() {
// //                               _loading = true;
// //                             });
// //                             await sendPasswordResetEmail(_email);
// //                             setState(() {
// //                               _loading = false;
// //                             });
// //                           }
// //                         },
// //                       ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   bool validateEmail(String email) {
// //     // Add your email validation logic here
// //     return email.contains('@') && email.contains('.');
// //   }

// //   Future<void> sendPasswordResetEmail(String email) async {
// //     try {
// //       await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
// //       showSnackBar(context, 'Password reset email sent');
// //       // Redirect to login screen or show a success message
// //       Navigator.pushReplacementNamed(context, '/sign_in');
// //     } catch (e) {
// //       showSnackBar(context, 'Error sending password reset email: $e');
// //     }
// //   }

// //   void showSnackBar(BuildContext context, String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text(message)),
// //     );
// //   }
// // }
// // //original code

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:bluejobs/styles/textstyle.dart';
// import 'package:bluejobs/styles/custom_button.dart'; // Use CustomButton from your file
// import 'package:bluejobs/styles/custom_theme.dart';
// import 'package:bluejobs/styles/responsive_utils.dart';
// import 'package:bluejobs/styles/textstyle.dart';

// class PasswordChange extends StatefulWidget {
//   const PasswordChange({super.key});

//   @override
//   State<PasswordChange> createState() => _PasswordChangeState();
// }

// class _PasswordChangeState extends State<PasswordChange> {
//   final _formKey = GlobalKey<FormState>();
//   String _email = '';
//   bool _loading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//   leading: BackButton(
//     color: Colors.white,
//   ),
//   title: Text(
//     'Forgot Password',
//     style: CustomTextStyle.semiBoldText.copyWith(color: Colors.white, fontSize: responsiveSize(context, 0.04)),
//   ),
//   backgroundColor: const Color.fromARGB(255, 7, 30, 47),
// ),
//       backgroundColor: const Color.fromARGB(255, 7, 30, 47),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // text: 'Please enter your email',
//                 // const SizedBox( heighrt: 20),
//            TextFormField(
//   decoration: customInputDecoration('Email').copyWith(
//     errorStyle: CustomTextStyle.regularText.copyWith(color: Colors.white),
//   ),
//   style: CustomTextStyle.regularText,
//   validator: (value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your email';
//     }
//     if (!validateEmail(value)) {
//       return 'Invalid email address';
//     }
//     return null;
//   },
//                   onSaved: (value) => _email = value ?? '',
//                 ),
//                 const SizedBox(height: 20),

//                 // If loading is true, show CircularProgressIndicator
//                 _loading
//                     ? const CircularProgressIndicator()
//                     : CustomButton(
//                         onPressed: () async {
//                           if (_formKey.currentState!.validate()) {
//                             _formKey.currentState!.save();
//                             setState(() {
//                               _loading = true;
//                             });
//                             await sendPasswordResetEmail(_email);
//                             setState(() {
//                               _loading = false;
//                             });
//                           }
//                         },
//                         buttonText: 'Send Password Reset Email',
//                         buttonColor: const Color.fromARGB(255, 243, 107, 4),
//                       ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   bool validateEmail(String email) {
//     // Add your email validation logic here
//     return email.contains('@') && email.contains('.');
//   }

//   Future<void> sendPasswordResetEmail(String email) async {
//     try {
//       await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
//       showSnackBar(context, 'Password reset email sent');
//       // Redirect to login screen or show a success message
//       Navigator.pushReplacementNamed(context, '/sign_in');
//     } catch (e) {
//       showSnackBar(context, 'Error sending password reset email: $e');
//     }
//   }

//   void showSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:bluejobs/styles/custom_button.dart'; // Use CustomButton from your file
import 'package:bluejobs/styles/custom_theme.dart';
import 'package:bluejobs/styles/responsive_utils.dart';

class PasswordChange extends StatefulWidget {
  const PasswordChange({super.key});

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Color.fromARGB(255, 7, 30, 47),
        ),
        title: Text(
          'Forgot Password',
          style: CustomTextStyle.semiBoldText.copyWith(
             // color: Colors.white,
               fontSize: responsiveSize(context, 0.04)),
        ),
       // backgroundColor: const Color.fromARGB(255, 7, 30, 47),
      ),
     // backgroundColor: const Color.fromARGB(255, 7, 30, 47),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align left
              children: [
                // Add space below the AppBar
                const SizedBox(height: 50),

                // Added text
                Text(
                  'Oh no! You forgot your password?',
                  style: CustomTextStyle.semiBoldText.copyWith(
                  //  color: Colors.white,
                    fontSize: responsiveSize(context, 0.05),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'No worries! Enter the email address associated to your account and we BlueJobs team will send you a link for it ',
                  style: CustomTextStyle.regularText.copyWith(
                  //  color: Colors.white,
                    fontSize: responsiveSize(context, 0.04),
                  ),
                ),
                const SizedBox(height: 20),

                // Email Input Field
                TextFormField(
                  decoration: customInputDecoration('Email').copyWith(
                    errorStyle: CustomTextStyle.regularText
                        .copyWith(color: Color.fromARGB(255, 7, 30, 47)),
                  ),
                  style: CustomTextStyle.regularText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!validateEmail(value)) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value ?? '',
                ),
                const SizedBox(height: 20),

                // If loading is true, show CircularProgressIndicator
                _loading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              _loading = true;
                            });
                            await sendPasswordResetEmail(_email);
                            setState(() {
                              _loading = false;
                            });
                          }
                        },
                        buttonText: 'Send Password Reset Email',
                        buttonColor: const Color.fromARGB(255, 243, 107, 4),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showSnackBar(context, 'Password reset email sent');
      Navigator.pushReplacementNamed(context, '/sign_in');
    } catch (e) {
      showSnackBar(context, 'Error sending password reset email: $e');
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
