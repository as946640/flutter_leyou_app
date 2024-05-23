import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.text = '',
    required this.onPressed,
    this.radius = 0,
    this.color,
    this.icon,
    this.fontSize = 14,
    this.textColor,
    this.enable = false,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    this.circle = false,
    this.size = const Size(60, 44),
  });

  final String text;

  final Function onPressed;

  final double radius;

  final Color? color;

  final Color? textColor;

  final Icon? icon;

  final double fontSize;

  final Color? borderColor;

  final EdgeInsets padding;

  final bool enable;

  final bool circle;

  final Size size;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enable
          ? null
          : () {
              onPressed();
            },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circle ? size.height : radius),
          side: borderColor == null
              ? BorderSide.none
              : BorderSide(width: 1, color: borderColor!),
        ),
        backgroundColor: color,
        padding: circle ? const EdgeInsets.all(0) : padding,
        minimumSize: size,
        shadowColor: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: EdgeInsets.only(right: circle ? 0 : 4),
              child: icon,
            ),
          if (text.isNotEmpty)
            Text(
              text,
              style: TextStyle(fontSize: fontSize.sp, color: textColor),
            ),
        ],
      ),
    );
  }
}
