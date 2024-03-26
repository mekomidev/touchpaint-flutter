import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:touchpaint/paint.dart';

class FollowPainter extends CustomPainter {
  FollowPainter(
    this.points);

  final Map<int, Offset> points;

  @override
  void paint(Canvas canvas, Size size) {
    final boxPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 115
      ..strokeCap = StrokeCap.square
      ..isAntiAlias = true;

    canvas.drawPoints(PointMode.points, points.values.toList(growable: false), boxPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class FollowWidget extends StatefulWidget {
  FollowWidget({
    super.key,
    this.showSampleRate = false,
  });

  final bool showSampleRate;

  @override
  _FollowWidgetState createState() => _FollowWidgetState();
}

class _FollowWidgetState extends State<FollowWidget> with SampleRateCounterMixin {
  Map<int, Offset> _points = HashMap();

  void _fingerDown(PointerEvent details) {
    setState(() {
      if (widget.showSampleRate) {
        scheduleSampleRate();
      }
    });

    _fingerMove(details);
  }

  void _fingerMove(PointerEvent details) {
    setState(() {
      _points[details.pointer] = details.localPosition;

      eventCount++;
    });
  }

  void _fingerUp(PointerEvent details) {
    setState(() {
      _points.remove(details.pointer);

      sampleRateTimer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _fingerDown,
      onPointerMove: _fingerMove,
      onPointerUp: _fingerUp,
      onPointerCancel: _fingerUp,
      child: CustomPaint(
        painter: FollowPainter(_points)
      ),
    );
  }
}
