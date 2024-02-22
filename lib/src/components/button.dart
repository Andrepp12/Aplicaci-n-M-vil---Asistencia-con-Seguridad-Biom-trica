import 'package:flutter/material.dart';
import 'package:unt_biometric_auth/src/constants/colors.dart';

class Button extends StatefulWidget {
  final String text;
  final Function onPressed;
  // No required
  final bool disabled;


  const Button(
    { 
      Key? key,
      required this.text,
      required this.onPressed,
      this.disabled = false
    }
  ) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsApp.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),

        onPressed: widget.disabled ? null : () => widget.onPressed(),
        child: Text(
          widget.text,
          style: const TextStyle(
            color: ColorsApp.primaryForegroundColor
          ),
        )
      )
    );
  }
}