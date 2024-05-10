import 'package:flutter/material.dart';
import 'dart:math' as math;

class WindSpeedCompass extends StatelessWidget {
  final double windDirectionDegrees;
  final double windSpeed;

  const WindSpeedCompass({
    Key? key,
    required this.windDirectionDegrees,
    required this.windSpeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ignore: sized_box_for_whitespace
          Container(
            width: 150,
            height: 150,
            child: CustomPaint(
              painter: WindCompassPainter(windDirectionDegrees, windSpeed),
            ),
          ),
          Image.network(
            'https://picjj.com/images/2024/05/10/FUbXa.gif',
            fit: BoxFit.contain,
            width: 50.0,
            height: 50.0,
          ),
        ],
      ),
    );
  }
}

class WindCompassPainter extends CustomPainter {
  final double windDirectionDegrees;
  final double windSpeed;

  WindCompassPainter(this.windDirectionDegrees, this.windSpeed);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white;

    // Draw degree lines instead of the compass circle
    drawDegreeLines(canvas, center, radius);

    // Draw the cardinal directions
    drawCardinalPoints(canvas, size, paint);

    // Draw the wind speed needle
    drawWindNeedle(canvas, center, radius, windDirectionDegrees, windSpeed);

  }

  void drawDegreeLines(Canvas canvas, Offset center, double radius) {
  Paint regularPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = Colors.white.withOpacity(0.3); // Regular lines with 50% opacity

  Paint highlightedPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = Colors.white; // Highlighted lines with full opacity

  for (int i = 0; i < 360; i += 3) { // Draw lines every 5 degrees
    final angle = i * math.pi / 180;
    final outerPoint = center + Offset(math.cos(angle), math.sin(angle)) * radius;
    final innerRadius = (i % 30 == 0) ? radius - 12 : radius - 10; // Longer lines every 15 degrees
    final innerPoint = center + Offset(math.cos(angle), math.sin(angle)) * innerRadius;

    canvas.drawLine(innerPoint, outerPoint, (i % 30 == 0) ? highlightedPaint : regularPaint);
  }
}



  void drawCardinalPoints(Canvas canvas, Size size, Paint paint) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
    );

    // List of cardinal points and their respective positions
    final points = ['N', 'E', 'S', 'W'];
    final positions = [
      Offset(size.width / 2, 20),
      Offset(size.width - 20, size.height / 2),
      Offset(size.width / 2, size.height - 20),
      Offset(20, size.height / 2),
    ];

    for (int i = 0; i < points.length; i++) {
      textPainter.text = TextSpan(text: points[i], style: textStyle);
      textPainter.layout();
      textPainter.paint(canvas, positions[i] - Offset(textPainter.width / 2, textPainter.height / 2));
    }
  }

  void drawWindNeedle(Canvas canvas, Offset center, double radius, double directionDegrees, double speed) {
    final paint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.fill;
  final angle = (directionDegrees - 90) * math.pi / 180;
  final needleLength = radius * 0.9;
  final needleStartLength = radius * 0.5; // Inicio de la flecha a la mitad del radio hacia afuera

  // Punto de inicio de la flecha
  final startPoint = center + Offset(needleStartLength * math.cos(angle), needleStartLength * math.sin(angle));
  // Punto final de la flecha (punta)
  final endPoint = center + Offset(needleLength * math.cos(angle), needleLength * math.sin(angle));

  // Construye la flecha
  final needlePath = Path();
  needlePath.moveTo(endPoint.dx, endPoint.dy);
  needlePath.lineTo(startPoint.dx + 10 * math.cos(angle - math.pi / 2), startPoint.dy + 10 * math.sin(angle - math.pi / 2));
  needlePath.lineTo(startPoint.dx + 10 * math.cos(angle + math.pi / 2), startPoint.dy + 10 * math.sin(angle + math.pi / 2));
  needlePath.close();

    canvas.drawPath(needlePath, paint);

    // Wind speed text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${speed.toStringAsFixed(1)} m/s',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height + 20)); // Adjust position as needed
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
