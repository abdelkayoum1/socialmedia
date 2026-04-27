import 'package:flutter/material.dart';

class Textfieledd extends StatelessWidget {
  final String text;
  final Widget? prefixicon;
  final Widget? sufixicon;
  final bool obscureText;
  final String? labelText;
  final TextEditingController? controlle;
  const Textfieledd({
    super.key,
    required this.text,
    this.controlle,
    this.labelText,
    this.prefixicon,
    this.sufixicon,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlle,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$text is required';
        }
        return null;
      },
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 0.3),
        ),
        hint: Text(text),
        labelText: labelText,
        prefixIcon: prefixicon,
        suffixIcon: sufixicon,
        border: OutlineInputBorder(borderSide: BorderSide()),
      ),
    );
  }
}
