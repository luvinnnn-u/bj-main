// import 'package:bluejobs/styles/textstyle.dart';
// import 'package:flutter/material.dart';
// //import 'package:bluejobs_user/styles/custom_button.dart';

// class CustomButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   final String buttonText;
//   final Color buttonColor;
//   final Color textColor;
//   final double width;
//   final double height;
//   final double borderRadius;
//   final double borderWidth;
//   final Color borderColor;

//    const CustomButton({
//     Key? key,
//     required this.onPressed,
//     required this.buttonText,
//     this.buttonColor = const Color.fromARGB(255, 243, 107, 4),
//     this.textColor = Colors.white,
//     this.width = double.infinity,
//     this.height = 50,
//     this.borderRadius = 15,//frp, 5
//     this.borderWidth = 2,
//     this.borderColor = const Color.fromARGB(255, 243, 107, 4),
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           color: buttonColor,
//           borderRadius: BorderRadius.circular(borderRadius),
//           border: Border.all(
//             color: borderColor,
//             width: borderWidth,
//           ),
//         ),
//         child: Center(
//           child: Text(
//             buttonText,
//             style: CustomTextStyle.semiBoldText.copyWith(
//               color: textColor,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:bluejobs/styles/textstyle.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double width;
  final double height;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final bool isLoading; // Add this property

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.buttonColor = const Color.fromARGB(255, 243, 107, 4),
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 50,
    this.borderRadius = 15,
    this.borderWidth = 2,
    this.borderColor = const Color.fromARGB(255, 243, 107, 4),
    this.isLoading = false, // Default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPressed, // Disable when loading
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ) // Show loading indicator
              : Text(
                  buttonText,
                  style: CustomTextStyle.semiBoldText.copyWith(
                    color: textColor,
                  ),
                ),
        ),
      ),
    );
  }
}
