import 'package:flutter/material.dart';

enum ButtonType { STATIC, MATERIAL }

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {Key? key,
      this.width,
      this.height = 45,
      this.onClickListener,
      this.color,
      this.colorSelected,
      this.borderRadius,
      this.borderWidth,
      this.borderColor,
      this.text,
      this.textStyle,
      this.type})
      : super(key: key);

  final double? width;

  final double? height;

  final Function? onClickListener;

  final Color? color;

  final Color? colorSelected;

  final BorderRadius? borderRadius;

  final double? borderWidth;

  final Color? borderColor;

  final String? text;

  final TextStyle? textStyle;

  final ButtonType? type;

  @override
  Widget build(BuildContext context) {
    switch (this.type) {
      case ButtonType.MATERIAL:
        return ConstrainedBox(
            constraints:
                BoxConstraints.tightFor(width: this.width, height: this.height),
            child: ElevatedButton(
              onPressed: () {
                if (onClickListener != null) {
                  onClickListener!();
                }
              },
              child: Text(text ?? '', style: textStyle ?? null),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.pressed))
                      return this.colorSelected ?? Colors.red;
                    else
                      return this.color ?? Colors.blue;
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: borderRadius ?? BorderRadius.zero,
                          side: BorderSide(
                              color: this.borderColor ?? Colors.black,
                              width: this.borderWidth ?? 0)))),
            ));
      case ButtonType.STATIC:
      default:
        return GestureDetector(
          onTap: () {
            if (onClickListener != null) {
              onClickListener!();
            }
          },
          child: Container(
            width: this.width,
            height: this.height,
            decoration: BoxDecoration(
                color: this.color ?? Colors.blue,
                borderRadius: borderRadius ?? BorderRadius.zero,
                border: Border.all(
                    width: this.borderWidth ?? 0,
                    color: this.borderColor ?? Colors.black)),
            child: Center(
              child: Text(
                text ?? '',
                style: textStyle ?? null,
              ),
            ),
          ),
        );
    }
  }
}
