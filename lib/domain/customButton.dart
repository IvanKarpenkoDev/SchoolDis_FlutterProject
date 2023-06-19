import 'package:flutter/material.dart';

class ImageBackgroundButton extends StatefulWidget {
  final String imagePath;
  final Function onPressed;

  ImageBackgroundButton({required this.imagePath, required this.onPressed});

  @override
  _ImageBackgroundButtonState createState() => _ImageBackgroundButtonState();
}

class _ImageBackgroundButtonState extends State<ImageBackgroundButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isPressed = !isPressed;
        });
        widget.onPressed();
      },
      child: Container(
        height: 50,
        width: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.imagePath),
            fit: BoxFit.cover,
          ),
          border: Border.all(
            color: isPressed ? Colors.green : Colors.transparent,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
