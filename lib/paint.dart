import 'package:flutter/material.dart';

class PaintPage extends StatefulWidget {
  PaintPage({Key key}) : super(key: key);

  @override
  _PaintPageState createState() => _PaintPageState();
}

class PaintPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _PaintPageState extends State<PaintPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Touchpaint'),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.black,
        child: Listener(
          child: CustomPaint(
            painter: PaintPainter()
          ),
        ),
      ),
    );
  }
}
