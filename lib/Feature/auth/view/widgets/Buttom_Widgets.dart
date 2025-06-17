import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ButtomWidget extends StatelessWidget {
  final void Function()? onTap;
  final double height;
  final double width;
  final double borderRadius;
  final double textSize;
  final String text;
  const ButtomWidget({
    super.key,
    this.height = 60,
    this.width = 200,
    this.borderRadius = 30,
    this.textSize = 16,
    this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } 
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontSize: textSize,
            ),
          ),
        ),
      ),
    );
  }
}
