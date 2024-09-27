//original code
// import 'package:flutter/material.dart';
// import 'package:bluejobs/styles/textstyle.dart';

// InputDecoration customInputDecoration(String labelText,
//     {IconButton? suffixIcon}) {
//   return InputDecoration(
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(15),
//       borderSide: const BorderSide(color: Colors.black),
//     ),
//     labelText: labelText, 
//     labelStyle: CustomTextStyle.regularText,
//     suffixIcon: suffixIcon,
//   );
// }
//original code


// import 'package:flutter/material.dart';
// import 'package:bluejobs/styles/textstyle.dart';

// InputDecoration customInputDecoration(String labelText,
//     {IconButton? suffixIcon}) {
//   return InputDecoration(
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(15),
//       borderSide:  BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
//     ),
//     hintText: labelText, 
//     hintStyle: CustomTextStyle.regularText,
//     suffixIcon: suffixIcon,
//   );
// }


import 'package:flutter/material.dart';
import 'package:bluejobs/styles/textstyle.dart';

// InputDecoration customInputDecoration(String labelText, IconButton iconButton, {IconButton? suffixIcon}) {
//   return InputDecoration(
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(15),
//       borderSide: const BorderSide(
//         color: Color.fromARGB(255, 255, 255, 255), // White border when not focused
//       ),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(15),
//       borderSide: const BorderSide(
//         color: Color.fromARGB(255, 255, 255, 255), // White border when focused
//       ),
//     ),
//     hintText: labelText,
//     hintStyle: CustomTextStyle.semiBoldText,
//     suffixIcon: suffixIcon,
//   );
// }



InputDecoration customInputDecoration(String labelText, {IconButton? suffixIcon}) {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 255, 255, 255), // White border when not focused
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 255, 255, 255), // White border when focused
      ),
    ),
    hintText: labelText,
    hintStyle: CustomTextStyle.semiBoldText,
    suffixIcon: suffixIcon,
  );
}