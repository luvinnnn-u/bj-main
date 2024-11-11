
import 'package:bluejobs/admin/admin_nav.dart';
import 'package:bluejobs/navigation/employer_navigation.dart';
import 'package:bluejobs/navigation/jobhunter_navigation.dart';
import 'package:bluejobs/provider/auth_provider.dart';
import 'package:bluejobs/screens_for_auth/password_change.dart';
import 'package:bluejobs/screens_for_auth/signup.dart';
import 'package:bluejobs/styles/custom_button.dart';
import 'package:bluejobs/styles/custom_theme.dart';
import 'package:bluejobs/styles/customthemesignin.dart';
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
                'assets/images/prev.png',
                height: responsiveSize(context, 0.4),
              ),

              SizedBox(height: responsive.verticalPadding(0.02)),

              // Existing text and other UI elements
              Text(
                'Connecting Blue Collars with BlueJobs.',
                style: CustomTextStyle.semiBoldText.copyWith(color: Colors.white,
                  fontSize: responsiveSize(context, 0.04),
                ),
                textAlign: TextAlign.center,
              ),
             // SizedBox(height: responsive.verticalPadding(0.01)),
               Text(
                'One Tap at a time!',
                style: CustomTextStyle.semiBoldText.copyWith(color: Colors.white,
                  fontSize: responsiveSize(context, 0.04),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: responsive.verticalPadding(0.02)),

              // Email TextField
              TextField(
                controller: _emailController,
                decoration: customInputDecorationn('Email...'),
                cursorColor: Colors.white,
                style: CustomTextStyle.regularText.copyWith(
                  fontSize: responsiveSize(context, 0.04),
                   color: Colors.white
                ),
              ),

              SizedBox(height: responsive.verticalPadding(0.02)),

              // Password TextField
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: customInputDecorationn(
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
                cursorColor: Colors.white,
                style: CustomTextStyle.regularText.copyWith(
                  fontSize: responsiveSize(context, 0.04),
                   color: Colors.white
                ),
              ),

              SizedBox(height: responsive.verticalPadding(0.02)),

              // Sign In Button


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
          backgroundColor: Color.fromARGB(255, 243, 107, 4),
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
