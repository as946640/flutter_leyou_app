import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final int maxLines;
  final double width;
  final double minHeight;
  final String hintText;
  final BoxBorder? border;
  final EdgeInsets contentPadding;
  final Color backgroundColor;
  final double radius;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final Widget? suffix;
  final TextEditingController? controller;
  final Function? onSubmit;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    this.maxLines = 1,
    this.width = 0,
    this.minHeight = 40,
    this.hintText = "请输入",
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 20.0),
    this.backgroundColor = Colors.transparent,
    this.radius = 0.0,
    this.hintStyle,
    this.border,
    this.suffix,
    this.prefix,
    this.controller,
    this.onChanged,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      constraints: BoxConstraints(
        maxWidth: width == 0 ? MediaQuery.of(context).size.width : width,
        minHeight: minHeight,
      ),
      decoration: BoxDecoration(
        border: border,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: TextField(
        maxLines: maxLines,
        controller: controller,
        textInputAction: TextInputAction.send,
        decoration: InputDecoration(
          filled: true,
          counterText: '',
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: hintStyle,
          fillColor: backgroundColor,
          contentPadding: contentPadding,
          prefix: prefix,
          suffix: suffix,
        ),
        onSubmitted: (value) {
          onSubmit?.call(value);
        },
        onEditingComplete: () {
          onSubmit?.call();
        },
        onChanged: (value) {
          onChanged?.call(value);
        },
      ),
    );
  }
}
