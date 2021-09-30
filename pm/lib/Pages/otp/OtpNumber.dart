import 'package:flutter/material.dart';
import 'package:pm/UI/ui.dart';

class OtpNumber extends StatelessWidget {
  final otp;
  final numberOfDigits = 6;

  OtpNumber({
    required this.otp,
  });

  getDigitColor(digitIndex) {
    return (digitIndex < otp.length
        ? Palette.primaryDark
        : Palette.secondaryDark);
  }

  replaceDigitWithDotIfEmpty(digitIndex) {
    return (digitIndex < otp.length ? otp[digitIndex] : '•');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(numberOfDigits, (index) {
        final color = getDigitColor(index);
        final digit = replaceDigitWithDotIfEmpty(index);
        return digitWidget(digit, color);
      }),
    );
  }

  digitWidget(digit, color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Text(
            digit,
            style: TextStyle(
              color: color,
              fontSize: Font.h2,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            height: 3.0,
            width: 30.0,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ],
      ),
    );
  }
}
