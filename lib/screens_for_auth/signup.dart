// //original code
// // import 'package:bluejobs/provider/auth_provider.dart';
// // import 'package:bluejobs/screens_for_auth/signin.dart';
// // import 'package:bluejobs/screens_for_auth/user_information.dart';
// // import 'package:bluejobs/styles/custom_button.dart';
// // import 'package:bluejobs/styles/responsive_utils.dart';
// // import 'package:bluejobs/styles/textstyle.dart';
// // import 'package:bluejobs/utils/responsive_utils.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';

// // class SignUpPage extends StatefulWidget {
// //   const SignUpPage({super.key});

// //   @override
// //   State<SignUpPage> createState() => _SignUpPageState();
// // }

// // class _SignUpPageState extends State<SignUpPage> {
// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();
// //   final TextEditingController _confirmPasswordController =
// //       TextEditingController();
// //   bool _obscureText = true;

// //   @override
// //   void dispose() {
// //     _emailController.dispose();
// //     _passwordController.dispose();
// //     _confirmPasswordController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final responsive = ResponsiveUtils(context);
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: const Color.fromARGB(255, 7, 30, 47),
// //       ),
// //       backgroundColor: Colors.white,
// //       body: Center(
// //         child: SingleChildScrollView(
// //           child: Padding(
// //             padding: EdgeInsets.symmetric(
// //                 horizontal: responsive.horizontalPadding(0.05)),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Align(
// //                   alignment: Alignment.centerLeft,
// //                   child: Text("Create an Account.",
// //                       style: CustomTextStyle.semiBoldText
// //                           .copyWith(fontSize: responsiveSize(context, 0.05))),
// //                 ),
// //                 SizedBox(height: responsive.verticalPadding(0.04)),
// //                 TextField(
// //                   controller: _emailController,
// //                   decoration: const InputDecoration(
// //                     labelText: 'Email',
// //                     labelStyle: CustomTextStyle.regularText,
// //                     fillColor: Colors.white,
// //                     filled: true,
// //                     border: OutlineInputBorder(),
// //                   ),
// //                 ),
// //                 SizedBox(height: responsive.verticalPadding(0.02)),
// //                 TextField(
// //                   controller: _passwordController,
// //                   obscureText: _obscureText,
// //                   decoration: InputDecoration(
// //                     labelText: 'Password',
// //                     labelStyle: CustomTextStyle.regularText,
// //                     fillColor: Colors.white,
// //                     filled: true,
// //                     border: const OutlineInputBorder(),
// //                     suffixIcon: IconButton(
// //                       icon: Icon(
// //                         _obscureText ? Icons.visibility : Icons.visibility_off,
// //                         color: Theme.of(context).primaryColorDark,
// //                       ),
// //                       onPressed: () {
// //                         setState(() {
// //                           _obscureText = !_obscureText;
// //                         });
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: responsive.verticalPadding(0.02)),
// //                 TextField(
// //                   controller: _confirmPasswordController,
// //                   obscureText: _obscureText,
// //                   decoration: InputDecoration(
// //                     labelText: 'Confirm Password',
// //                     labelStyle: CustomTextStyle.regularText,
// //                     fillColor: Colors.white,
// //                     filled: true,
// //                     border: const OutlineInputBorder(),
// //                     suffixIcon: IconButton(
// //                       icon: Icon(
// //                         _obscureText ? Icons.visibility : Icons.visibility_off,
// //                         color: Theme.of(context).primaryColorDark,
// //                       ),
// //                       onPressed: () {
// //                         setState(() {
// //                           _obscureText = !_obscureText;
// //                         });
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: responsive.verticalPadding(0.05)),
// //                 CustomButton(
// //                   onPressed: () async {
// //                     if (_passwordController.text ==
// //                         _confirmPasswordController.text) {
// //                       if (_emailController.text.isValidEmail) {
// //                         if (_passwordController.text.isValidPassword) {
// //                           try {
// //                             await Provider.of<AuthProvider>(context,
// //                                     listen: false)
// //                                 .signUpWithEmailAndPassword(
// //                               email: _emailController.text,
// //                               password: _passwordController.text,
// //                             );
// //                             Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (context) => UserInformation(
// //                                     email: _emailController.text),
// //                               ),
// //                             );
// //                           } catch (e) {
// //                             print(e);
// //                           }
// //                         } else {
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             const SnackBar(
// //                               content: Text(
// //                                   'Password must be at least 8 characters, contain one uppercase letter, one lowercase letter, and one number'),
// //                             ),
// //                           );
// //                         }
// //                       } else {
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           const SnackBar(
// //                             content: Text('Invalid email address'),
// //                           ),
// //                         );
// //                       }
// //                     } else {
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         const SnackBar(
// //                           content: Text('Passwords do not match'),
// //                         ),
// //                       );
// //                     }
// //                   },
// //                   buttonText: 'Next',
// //                 ),
// //                 const SizedBox(height: 20),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     TextButton(
// //                       onPressed: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => const SignInPage(),
// //                           ),
// //                         );
// //                       },
// //                       child: Text(
// //                         "Already have an account? Sign In",
// //                         style: CustomTextStyle.regularText.copyWith(
// //                           color: Colors.black,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // extension EmailValidator on String {
// //   bool get isValidEmail {
// //     return RegExp(
// //             r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
// //         .hasMatch(this);
// //   }
// // }

// // extension PasswordValidator on String {
// //   bool get isValidPassword {
// //     return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
// //         .hasMatch(this);
// //   }
// // }
// //original code










import 'package:bluejobs/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluejobs/provider/auth_provider.dart';
import 'package:bluejobs/screens_for_auth/signin.dart';
import 'package:bluejobs/screens_for_auth/user_information.dart';
import 'package:bluejobs/styles/custom_button.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:bluejobs/styles/custom_theme.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        title: Text(
          'Register',
          style: CustomTextStyle.semiBoldText.copyWith(
            color: Colors.white,
            fontSize: responsiveSize(context, 0.04),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 7, 30, 47),
      ),
      backgroundColor: const Color.fromARGB(255, 7, 30, 47),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.horizontalPadding(0.05)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align to start
            children: [
              const SizedBox(height: 50), // Add a 50px space below the AppBar

              Text(
                "Create an Account.",
                style: CustomTextStyle.semiBoldText.copyWith(
                  fontSize: responsiveSize(context, 0.05),
                ),
              ),
              SizedBox(height: responsive.verticalPadding(0.02)),

              Text(
                'Creating an account is easy! Follow all of the given fields and you are one step away to connecting with blue collars!',
                style: CustomTextStyle.regularText,
              ),
              SizedBox(height: responsive.verticalPadding(0.02)),

              TextField(
                controller: _emailController,
                decoration: customInputDecoration('Email'),
                style: CustomTextStyle.regularText.copyWith(
                  fontSize: responsiveSize(context, 0.04),
                ),
              ),
              SizedBox(height: responsive.verticalPadding(0.02)),

              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: customInputDecoration(
                  'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                style: CustomTextStyle.regularText.copyWith(
                  fontSize: responsiveSize(context, 0.04),
                ),
              ),
              SizedBox(height: responsive.verticalPadding(0.02)),

              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureText,
                decoration: customInputDecoration(
                  'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                style: CustomTextStyle.regularText.copyWith(
                  fontSize: responsiveSize(context, 0.04),
                ),
              ),
              SizedBox(height: responsive.verticalPadding(0.05)),

              CustomButton(
                onPressed: () async {
                  if (_passwordController.text == _confirmPasswordController.text) {
                    if (_emailController.text.isValidEmail) {
                      if (_passwordController.text.isValidPassword) {
                        try {
                          await Provider.of<AuthProvider>(context, listen: false)
                              .signUpWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserInformation(email: _emailController.text),
                            ),
                          );
                        } catch (e) {
                          print(e);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.orange, // Set SnackBar color to orange
                            content: Text(
                              'Password must be at least 8 characters, contain one uppercase letter, one lowercase letter, and one number',
                              style: CustomTextStyle.regularText, // Use regularText style
                            ),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.orange, // Set SnackBar color to orange
                          content: Text(
                            'Invalid email address',
                            style: CustomTextStyle.regularText, // Use regularText style
                          ),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color.fromARGB(255, 243, 107, 4), // Set SnackBar color to orange
                        content: Text(
                          'Passwords do not match',
                          style: CustomTextStyle.regularText, // Use regularText style
                        ),
                      ),
                    );
                  }
                },
                buttonText: 'Next',
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Already have an account? Sign In",
                      style: CustomTextStyle.regularText.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Validators for email and password
extension EmailValidator on String {
  bool get isValidEmail {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension PasswordValidator on String {
  bool get isValidPassword {
    return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(this);
  }
}



//this one with loading indicator
// import 'package:bluejobs/utils/responsive_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:bluejobs/provider/auth_provider.dart';
// import 'package:bluejobs/screens_for_auth/signin.dart';
// import 'package:bluejobs/screens_for_auth/user_information.dart';
// import 'package:bluejobs/styles/custom_button.dart';
// import 'package:bluejobs/styles/responsive_utils.dart';
// import 'package:bluejobs/styles/textstyle.dart';
// import 'package:bluejobs/styles/custom_theme.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   bool _obscureText = true;
//   bool isLoading = false; // Add this variable

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final responsive = ResponsiveUtils(context);
//     return Scaffold(
//       appBar: AppBar(
//         leading: const BackButton(
//           color: Colors.white,
//         ),
//         title: Text(
//           'Register',
//           style: CustomTextStyle.semiBoldText.copyWith(
//             color: Colors.white,
//             fontSize: responsiveSize(context, 0.04),
//           ),
//         ),
//         backgroundColor: const Color.fromARGB(255, 7, 30, 47),
//       ),
//       backgroundColor: const Color.fromARGB(255, 7, 30, 47),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: responsive.horizontalPadding(0.05)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 50),

//               Text(
//                 "Create an Account.",
//                 style: CustomTextStyle.semiBoldText.copyWith(
//                   fontSize: responsiveSize(context, 0.05),
//                 ),
//               ),
//               SizedBox(height: responsive.verticalPadding(0.02)),

//               Text(
//                 'Creating an account is easy! Follow all of the given fields and you are one step away to connecting with blue collars!',
//                 style: CustomTextStyle.regularText,
//               ),
//               SizedBox(height: responsive.verticalPadding(0.02)),

//               TextField(
//                 controller: _emailController,
//                 decoration: customInputDecoration('Email'),
//                 style: CustomTextStyle.regularText.copyWith(
//                   fontSize: responsiveSize(context, 0.04),
//                 ),
//               ),
//               SizedBox(height: responsive.verticalPadding(0.02)),

//               TextField(
//                 controller: _passwordController,
//                 obscureText: _obscureText,
//                 decoration: customInputDecoration(
//                   'Password',
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscureText ? Icons.visibility : Icons.visibility_off,
//                       color: Colors.white,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscureText = !_obscureText;
//                       });
//                     },
//                   ),
//                 ),
//                 style: CustomTextStyle.regularText.copyWith(
//                   fontSize: responsiveSize(context, 0.04),
//                 ),
//               ),
//               SizedBox(height: responsive.verticalPadding(0.02)),

//               TextField(
//                 controller: _confirmPasswordController,
//                 obscureText: _obscureText,
//                 decoration: customInputDecoration(
//                   'Confirm Password',
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscureText ? Icons.visibility : Icons.visibility_off,
//                       color: Colors.white,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscureText = !_obscureText;
//                       });
//                     },
//                   ),
//                 ),
//                 style: CustomTextStyle.regularText.copyWith(
//                   fontSize: responsiveSize(context, 0.04),
//                 ),
//               ),
//               SizedBox(height: responsive.verticalPadding(0.05)),

//               CustomButton(
//                 onPressed: isLoading ? null : () async {
//                   if (_passwordController.text == _confirmPasswordController.text) {
//                     if (_emailController.text.isValidEmail) {
//                       if (_passwordController.text.isValidPassword) {
//                         setState(() {
//                           isLoading = true; // Set loading to true
//                         });
//                         try {
//                           await Provider.of<AuthProvider>(context, listen: false)
//                               .signUpWithEmailAndPassword(
//                             email: _emailController.text,
//                             password: _passwordController.text,
//                           );
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => UserInformation(email: _emailController.text),
//                             ),
//                           );
//                         } catch (e) {
//                           print(e);
//                         } finally {
//                           setState(() {
//                             isLoading = false; // Reset loading state
//                           });
//                         }
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             backgroundColor: Colors.orange,
//                             content: Text(
//                               'Password must be at least 8 characters, contain one uppercase letter, one lowercase letter, and one number',
//                               style: CustomTextStyle.regularText,
//                             ),
//                           ),
//                         );
//                       }
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           backgroundColor: Colors.orange,
//                           content: Text(
//                             'Invalid email address',
//                             style: CustomTextStyle.regularText,
//                           ),
//                         ),
//                       );
//                     }
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         backgroundColor: const Color.fromARGB(255, 243, 107, 4),
//                         content: Text(
//                           'Passwords do not match',
//                           style: CustomTextStyle.regularText,
//                         ),
//                       ),
//                     );
//                   }
//                 },
//                 buttonText: 'Next',
//                 isLoading: isLoading, // Pass the loading state
//               ),
//               const SizedBox(height: 20),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const SignInPage(),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       "Already have an account? Sign In",
//                       style: CustomTextStyle.regularText.copyWith(
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Validators for email and password
// extension EmailValidator on String {
//   bool get isValidEmail {
//     return RegExp(
//             r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
//         .hasMatch(this);
//   }
// }

// extension PasswordValidator on String {
//   bool get isValidPassword {
//     return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
//         .hasMatch(this);
//   }
// }
