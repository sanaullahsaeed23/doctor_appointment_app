import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';

InputDecoration getInputDecoration({String? hintText}) {
  return InputDecoration(
    filled: true,
    fillColor:formFillColor,
    hintText: hintText,
    hintStyle: const TextStyle(
      color: Colors.black26,
      fontWeight: FontWeight.bold,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color:Colors.red),
      borderRadius: BorderRadius.circular(15.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: formErrorcolor),
      borderRadius: BorderRadius.circular(15.0),
    ),
  );
}

showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
}

