import 'package:flutter/material.dart';

class CustomButtonWidget extends StatefulWidget {
  final Icon icon;
  final Color color;
  final VoidCallback onPressed;
  const CustomButtonWidget({
    Key? key,
    required this.icon,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<CustomButtonWidget> createState() => _CustomButtonWidgetState();
}

class _CustomButtonWidgetState extends State<CustomButtonWidget> {
  @override
  Widget build(BuildContext context) {
    debugPrint('CustomButtonWidget build');
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.2,
      width: MediaQuery.of(context).size.width * 0.2,
      child: GestureDetector(
        onTap: () {
          widget.onPressed();
        },
        child: Card(
          color: widget.color,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          elevation: 20,
          child: widget.icon,
        ),
      ),
    );
  }
}
