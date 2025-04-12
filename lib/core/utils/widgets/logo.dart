import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/logo_milestory3.png',
          height: 54,
        ),
        const SizedBox(width: 10),
        const Text(
          " MileStory",
          style: TextStyle(
            fontFamily: "Tajawal",
            fontSize: 30,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const Text(
          "  CRM Admin",
          style: TextStyle(
            fontFamily: "Tajawal",
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
