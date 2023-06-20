import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Function()? onTapChangeButton;
  final Function()? onTapSearchButton;
  final String hintText;
  final String labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  const CustomTextFormField({
    super.key,
    this.onTapChangeButton,
    this.onTapSearchButton,
    required this.hintText,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextFormField(
        onTap: () {},
        keyboardType: keyboardType,
        cursorColor: Colors.black,
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo requerido';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: IconButton(
              onPressed: onTapSearchButton,
              icon: const Icon(Icons.search, size: 30)),
          suffixIcon: IconButton(
            onPressed: onTapChangeButton,
            icon: const Icon(Icons.swap_vertical_circle_outlined, size: 30),
          ),
          labelStyle: const TextStyle(color: Colors.black),
          hintStyle: const TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            //borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            //borderSide: const BorderSide(color: Colors.black),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.red),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            //borderSide: const BorderSide(color: Colors.black),
          ),
          prefixIconColor: Colors.black,
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            //borderSide: const BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
