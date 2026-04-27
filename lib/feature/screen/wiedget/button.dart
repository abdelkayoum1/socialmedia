import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String? text;
  final VoidCallback? ontab;
  final Widget? child;
  const Button({super.key, this.text, this.ontab, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: ontab,

        style: TextButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        child: child,

        // Text(text, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
