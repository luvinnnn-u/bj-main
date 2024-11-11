import 'package:flutter/material.dart';
import 'package:bluejobs/styles/textstyle.dart';


InputDecoration customInputDecorationn(String labelText, {IconButton? suffixIcon}) {
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
    hintStyle: CustomTextStyle.semiBoldText.copyWith(color: Colors.white),
    suffixIcon: suffixIcon,
    
  );
  
  
}