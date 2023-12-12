import 'package:face_net_authentication/pages/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePainter extends CustomPainter {
  FacePainter({required this.imageSize, required this.face, this.user});

  final Size imageSize;
  double? scaleX, scaleY;
  Face? face;
  User? user;

  @override
  void paint(Canvas canvas, Size size) {
    if (face == null) return;

    Paint paint;

    if (this.face!.headEulerAngleY! > 10 || this.face!.headEulerAngleY! < -10) {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.red;
    } else {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.blue;
    }

    scaleX = size.width / imageSize.width;
    scaleY = size.height / imageSize.height;

    canvas.drawRRect(
        _scaleRect(
            rect: face!.boundingBox,
            imageSize: imageSize,
            widgetSize: size,
            scaleX: scaleX ?? 1,
            scaleY: scaleY ?? 1),
        paint);

    TextSpan span = TextSpan(
        style: TextStyle(color: (user == null) ? Colors.red : Colors.green[300], fontSize: 15),
        text: user?.user ?? 'Unknown');
    TextPainter textPainter = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(size.width - (60 + face!.boundingBox.left.toDouble()) * scaleX!,
            (face!.boundingBox.top.toDouble()-40) * scaleY!));
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.face != face;
  }
}

RRect _scaleRect(
    {required Rect rect,
    required Size imageSize,
    required Size widgetSize,
    double scaleX = 1,
    double scaleY = 1}) {
  return RRect.fromLTRBR(
      (widgetSize.width - rect.left.toDouble() * scaleX),
      rect.top.toDouble() * scaleY,
      widgetSize.width - rect.right.toDouble() * scaleX,
      rect.bottom.toDouble() * scaleY,
      Radius.circular(10));
}
