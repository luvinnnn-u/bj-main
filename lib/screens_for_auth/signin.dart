// // //original code
// // // import 'package:bluejobs/admin/admin_nav.dart';
// // // import 'package:bluejobs/navigation/employer_navigation.dart';
// // // import 'package:bluejobs/navigation/jobhunter_navigation.dart';
// // // import 'package:bluejobs/provider/auth_provider.dart';
// // // import 'package:bluejobs/screens_for_auth/password_change.dart';
// // // import 'package:bluejobs/screens_for_auth/signup.dart';
// // // import 'package:bluejobs/styles/custom_button.dart';
// // // import 'package:bluejobs/styles/responsive_utils.dart';
// // // import 'package:bluejobs/styles/textstyle.dart';
// // // import 'package:bluejobs/utils/responsive_utils.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:provider/provider.dart';

// // // class SignInPage extends StatefulWidget {
// // //   const SignInPage({super.key});

// // //   @override
// // //   State<SignInPage> createState() => _SignInPageState();
// // // }

// // // class _SignInPageState extends State<SignInPage> {
// // //   final TextEditingController _emailController = TextEditingController();
// // //   final TextEditingController _passwordController = TextEditingController();
// // //   bool _obscureText = true;
// // //   bool isLoading = false;

// // //   @override
// // //   void dispose() {
// // //     _emailController.dispose();
// // //     _passwordController.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final responsive = ResponsiveUtils(context);

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         automaticallyImplyLeading: false,
// // //         backgroundColor: const Color.fromARGB(255, 7, 30, 47),
// // //       ),
// // //       backgroundColor: const Color.fromARGB(255, 19, 52, 77),
// // //       body: Center(
// // //         child: Padding(
// // //           padding: EdgeInsets.symmetric(
// // //               horizontal: responsive.horizontalPadding(0.05)),
// // //           child: Column(
// // //             mainAxisAlignment: MainAxisAlignment.center,
// // //             children: [
// // //               Text(
// // //                 'Connecting Blue Collars. One Tap at a time!',
// // //                 style: CustomTextStyle.semiBoldText.copyWith(
// // //                   color: Colors.white,
// // //                   fontSize: responsiveSize(context, 0.03),
// // //                 ),
// // //                 textAlign: TextAlign.center,
// // //               ),
// // //               SizedBox(height: responsive.verticalPadding(0.02)),
// // //               Text(
// // //                 'Log in to Your Account',
// // //                 style: CustomTextStyle.semiBoldText.copyWith(
// // //                   color: Colors.white,
// // //                   fontSize: responsiveSize(context, 0.03),
// // //                 ),
// // //               ),
// // //               SizedBox(height: responsive.verticalPadding(0.02)),
// // //               TextField(
// // //                 controller: _emailController,
// // //                 decoration: const InputDecoration(
// // //                   labelText: 'Email',
// // //                   labelStyle: CustomTextStyle.regularText,
// // //                   fillColor: Colors.white,
// // //                   filled: true,
// // //                   border: OutlineInputBorder(),
// // //                 ),
// // //               ),
// // //               SizedBox(height: responsive.verticalPadding(0.02)),
// // //               TextField(
// // //                 controller: _passwordController,
// // //                 obscureText: _obscureText,
// // //                 decoration: InputDecoration(
// // //                   labelText: 'Password',
// // //                   labelStyle: CustomTextStyle.regularText,
// // //                   fillColor: Colors.white,
// // //                   filled: true,
// // //                   border: const OutlineInputBorder(),
// // //                   suffixIcon: IconButton(
// // //                     icon: Icon(
// // //                       _obscureText ? Icons.visibility : Icons.visibility_off,
// // //                       color: Theme.of(context).primaryColorDark,
// // //                     ),
// // //                     onPressed: () {
// // //                       setState(() {
// // //                         _obscureText = !_obscureText;
// // //                       });
// // //                     },
// // //                   ),
// // //                 ),
// // //               ),
// // //               SizedBox(height: responsive.verticalPadding(0.02)),
// // //               Align(
// // //                 alignment: Alignment.centerRight,
// // //                 child: InkWell(
// // //                   onTap: () {
// // //                     Navigator.push(
// // //                       context,
// // //                       MaterialPageRoute(
// // //                         builder: (context) => const PasswordChange(),
// // //                       ),
// // //                     );
// // //                   },
// // //                   child: Text(
// // //                     "Forgot Password?",
// // //                     style: CustomTextStyle.regularText.copyWith(
// // //                       color: Colors.white,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //               SizedBox(height: responsive.verticalPadding(0.04)),
// // //               CustomButton(
// // //                 onPressed: () async {
// // //                   setState(() {
// // //                     isLoading = true;
// // //                   });
// // //                   try {
// // //                     final ap =
// // //                         Provider.of<AuthProvider>(context, listen: false);
// // //                     await ap.signInWithEmailAndPassword(
// // //                       context: context,
// // //                       email: _emailController.text,
// // //                       password: _passwordController.text,
// // //                     );
// // //                     ap.checkExistingUser().then((value) async {
// // //                       if (value == true) {
// // //                         await ap.getDataFromFirestore();
// // //                         await ap.saveUserDataToSP();
// // //                         await ap.setSignIn();

// // //                         // Fetch the user's role from the fetched data
// // //                         String role = ap.userModel.role;

// // //                         // Navigate to the designated page based on the role
// // //                         if (role == 'Employer') {
// // //                           Navigator.pushAndRemoveUntil(
// // //                             context,
// // //                             MaterialPageRoute(
// // //                               builder: (context) => const EmployerNavigation(),
// // //                             ),
// // //                             (route) => false,
// // //                           );
// // //                         } else if (role == 'Job Hunter') {
// // //                           Navigator.pushAndRemoveUntil(
// // //                             context,
// // //                             MaterialPageRoute(
// // //                               builder: (context) => const JobhunterNavigation(),
// // //                             ),
// // //                             (route) => false,
// // //                           );
// // //                         } else if (role == 'admin') {
// // //                           Navigator.pushAndRemoveUntil(
// // //                             context,
// // //                             MaterialPageRoute(
// // //                               builder: (context) => const AdminNavigation(),
// // //                             ),
// // //                             (route) => false,
// // //                           );
// // //                         }
// // //                       }
// // //                     });
// // //                   } catch (e) {
// // //                     ScaffoldMessenger.of(context).showSnackBar(
// // //                       const SnackBar(
// // //                         content: Text('Invalid email address or password!'),
// // //                         backgroundColor: Colors.red,
// // //                       ),
// // //                     );
// // //                   } finally {
// // //                     setState(() {
// // //                       isLoading = false;
// // //                     });
// // //                   }
// // //                 },
// // //                 buttonText: 'Sign In',
// // //               ),
// // //               if (isLoading) const CircularProgressIndicator(),
// // //               SizedBox(height: responsive.verticalPadding(0.02)),
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: [
// // //                   TextButton(
// // //                     onPressed: () {
// // //                       Navigator.push(
// // //                         context,
// // //                         MaterialPageRoute(
// // //                           builder: (context) => const SignUpPage(),
// // //                         ),
// // //                       );
// // //                     },
// // //                     child: Text(
// // //                       "Don't have an account? Register here",
// // //                       style: CustomTextStyle.regularText.copyWith(
// // //                         color: Colors.white,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   const SizedBox(width: 3),
// // //                 ],
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //original code 





// import 'package:bluejobs/admin/admin_nav.dart';
// import 'package:bluejobs/navigation/employer_navigation.dart';
// import 'package:bluejobs/navigation/jobhunter_navigation.dart';
// import 'package:bluejobs/provider/auth_provider.dart';
// import 'package:bluejobs/screens_for_auth/password_change.dart';
// import 'package:bluejobs/screens_for_auth/signup.dart';
// import 'package:bluejobs/styles/custom_button.dart';
// import 'package:bluejobs/styles/responsive_utils.dart';
// import 'package:bluejobs/styles/textstyle.dart';
// import 'package:bluejobs/utils/responsive_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:bluejobs/styles/custom_theme.dart';

// class SignInPage extends StatefulWidget {
//   const SignInPage({super.key});

//   @override
//   State<SignInPage> createState() => _SignInPageState();
// }

// class _SignInPageState extends State<SignInPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _obscureText = true;
//   bool isLoading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final responsive = ResponsiveUtils(context);

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: const Color.fromARGB(255, 7, 30, 47),
//       ),
//       backgroundColor: const Color.fromARGB(255, 7, 30, 47),
//       body: 
//       Center(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//               horizontal: responsive.horizontalPadding(0.05)),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Logo image placed below the AppBar
//               Image.asset(
//                 'assets/images/bluejobs.png',
//                 height: responsiveSize(context, 0.4), // Adjust height as needed
//                // height: 200,
//                // fit: BoxFit.contain,
//               ),
//               SizedBox(height: responsive.verticalPadding(0.03)),

//               // Existing text and other UI elements
//               Text(
//                 'Connecting Blue Collars. One Tap at a time!',
//                 style: CustomTextStyle.semiBoldText.copyWith(
//                   fontSize: responsiveSize(context, 0.04),
//                 ),
//                 textAlign: TextAlign.start,
//               ),
//               SizedBox(height: responsive.verticalPadding(0.02)),


//               // Email TextField
//               TextField(
//                 controller: _emailController,
//                 decoration: customInputDecoration('Email'),
//                 style: CustomTextStyle.regularText.copyWith(
//                   fontSize: responsiveSize(context, 0.04),
//                 ),
//               ),

//               SizedBox(height: responsive.verticalPadding(0.02)),

//               // Password TextField
//               TextField(
//                 controller: _passwordController,
//                 obscureText: _obscureText,
//                 decoration: customInputDecoration(
//                   'Password...',
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

//               // Sign In Button
//               CustomButton(
//                 onPressed: () async {
//                   setState(() {
//                     isLoading = true;
//                   });
//                   try {
//                     final ap = Provider.of<AuthProvider>(context, listen: false);
//                     await ap.signInWithEmailAndPassword(
//                       context: context,
//                       email: _emailController.text,
//                       password: _passwordController.text,
//                     );
//                     ap.checkExistingUser().then((value) async {
//                       if (value == true) {
//                         await ap.getDataFromFirestore();
//                         await ap.saveUserDataToSP();
//                         await ap.setSignIn();

//                         String role = ap.userModel.role;

//                         if (role == 'Employer') {
//                           Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const EmployerNavigation(),
//                             ),
//                             (route) => false,
//                           );
//                         } else if (role == 'Job Hunter') {
//                           Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const JobhunterNavigation(),
//                             ),
//                             (route) => false,
//                           );
//                         } else if (role == 'admin') {
//                           Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const AdminNavigation(),
//                             ),
//                             (route) => false,
//                           );
//                         }
//                       }
//                     });
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text(
//                           'Invalid email address or password!',
//                           style: CustomTextStyle.regularText,
//                         ),
//                         backgroundColor: Color.fromARGB(255, 226, 141, 4),
//                       ),
//                     );
//                   } finally {
//                     setState(() {
//                       isLoading = false;
//                     });
//                   }
//                 },
//                 buttonText: 'Sign In',
//               ),

//               if (isLoading) const CircularProgressIndicator(),

//               SizedBox(height: responsive.verticalPadding(0.02)),

//               // "Forgot Password?" and "Register here" links
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const PasswordChange(),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       "Forgot Password?",
//                       style: CustomTextStyle.semiBoldText.copyWith(
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const SignUpPage(),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       "Register here",
//                       style: CustomTextStyle.semiBoldText.copyWith(
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




import 'package:bluejobs/admin/admin_nav.dart';
import 'package:bluejobs/navigation/employer_navigation.dart';
import 'package:bluejobs/navigation/jobhunter_navigation.dart';
import 'package:bluejobs/provider/auth_provider.dart';
import 'package:bluejobs/screens_for_auth/password_change.dart';
import 'package:bluejobs/screens_for_auth/signup.dart';
import 'package:bluejobs/styles/custom_button.dart';
import 'package:bluejobs/styles/custom_theme.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:bluejobs/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 7, 30, 47),
      ),
      backgroundColor: const Color.fromARGB(255, 7, 30, 47),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: responsive.horizontalPadding(0.05)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100), // 60px below the AppBar
              
              // Logo image placed 60px below the AppBar
              Image.asset(
                'assets/images/bluejobs.png',
                height: responsiveSize(context, 0.4),
              ),

              SizedBox(height: responsive.verticalPadding(0.03)),

              // Existing text and other UI elements
              Text(
                'Connecting Blue Collars. One Tap at a time!',
                style: CustomTextStyle.semiBoldText.copyWith(
                  fontSize: responsiveSize(context, 0.04),
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: responsive.verticalPadding(0.02)),

              // Email TextField
              TextField(
                controller: _emailController,
                decoration: customInputDecoration('Email'),
                style: CustomTextStyle.regularText.copyWith(
                  fontSize: responsiveSize(context, 0.04),
                ),
              ),

              SizedBox(height: responsive.verticalPadding(0.02)),

              // Password TextField
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: customInputDecoration(
                  'Password...',
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

              // Sign In Button
              // CustomButton(
              //   onPressed: () async {
              //     setState(() {
              //       isLoading = true;
              //     });
              //     try {
              //       final ap = Provider.of<AuthProvider>(context, listen: false);
              //       await ap.signInWithEmailAndPassword(
              //         context: context,
              //         email: _emailController.text,
              //         password: _passwordController.text,
              //       );
              //       ap.checkExistingUser().then((value) async {
              //         if (value == true) {
              //           await ap.getDataFromFirestore();
              //           await ap.saveUserDataToSP();
              //           await ap.setSignIn();

              //           String role = ap.userModel.role;

              //           if (role == 'Employer') {
              //             Navigator.pushAndRemoveUntil(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => const EmployerNavigation(),
              //               ),
              //               (route) => false,
              //             );
              //           } else if (role == 'Job Hunter') {
              //             Navigator.pushAndRemoveUntil(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => const JobhunterNavigation(),
              //               ),
              //               (route) => false,
              //             );
              //           } else if (role == 'admin') {
              //             Navigator.pushAndRemoveUntil(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => const AdminNavigation(),
              //               ),
              //               (route) => false,
              //             );
              //           }
              //         }
              //       });
              //     } catch (e) {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(
              //           content: Text(
              //             'Invalid email address or password!',
              //             style: CustomTextStyle.regularText,
              //           ),
              //           backgroundColor: Color.fromARGB(255, 226, 141, 4),
              //         ),
              //       );
              //     } finally {
              //       setState(() {
              //         isLoading = false;
              //       });
              //     }
              //   },
              //   buttonText: 'Sign In',
              // ),

//              if (isLoading) const CircularProgressIndicator(),


CustomButton(
  onPressed: () async {
    setState(() {
      isLoading = true;
    });
    try {
      final ap = Provider.of<AuthProvider>(context, listen: false);
      await ap.signInWithEmailAndPassword(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
      );
      ap.checkExistingUser().then((value) async {
        if (value == true) {
          await ap.getDataFromFirestore();
          await ap.saveUserDataToSP();
          await ap.setSignIn();

          String role = ap.userModel.role;

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
          } else if (role == 'admin') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminNavigation(),
              ),
              (route) => false,
            );
          }
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid email address or password!',
            style: CustomTextStyle.regularText,
          ),
          backgroundColor: Color.fromARGB(255, 226, 141, 4),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  },
  buttonText: 'Sign In',
  isLoading: isLoading, // Pass the loading state
),


              SizedBox(height: responsive.verticalPadding(0.02)),

              // "Forgot Password?" and "Register here" links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PasswordChange(),
                        ),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: CustomTextStyle.semiBoldText.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Register here",
                      style: CustomTextStyle.semiBoldText.copyWith(
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
