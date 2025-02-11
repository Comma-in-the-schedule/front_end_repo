import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        // icon: Padding(
        //   padding: const EdgeInsets.only(left: 10),
        //   child: Image.asset(
        //     iconPath,
        //     width: 20,
        //     height: 20,
        //   ),
        // ),
        icon: Image.asset(
          iconPath,
          width: 20,
          height: 20,
        ),
        label: Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF262627),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
