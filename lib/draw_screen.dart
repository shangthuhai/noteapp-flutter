import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class DrawingScreen extends StatefulWidget {
  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final GlobalKey _repaintKey = GlobalKey();
  List<List<Offset>> _strokes = [];
  List<Offset> _current = [];

  void _startStroke(Offset pos) {
    _current = [pos];
    _strokes.add(_current);
    setState(() {});
  }

  void _addPoint(Offset pos) {
    _current.add(pos);
    setState(() {});
  }

  Future<void> _saveDrawing() async {
    try {
      RenderRepaintBoundary boundary = _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/drawing_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(pngBytes);

      Navigator.of(context).pop(file.path);
    } catch (e) {
      Navigator.of(context).pop(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vẽ'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveDrawing,
          ),
        ],
      ),
      body: RepaintBoundary(
        key: _repaintKey,
        child: GestureDetector(
          onPanStart: (details) => _startStroke(details.localPosition),
          onPanUpdate: (details) => _addPoint(details.localPosition),
          onPanEnd: (_) => _current = [],
          child: CustomPaint(
            painter: _DrawingPainter(_strokes),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  _DrawingPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // fill background white
    final bg = Paint()..color = Colors.white;
    canvas.drawRect(Offset.zero & size, bg);

    for (final stroke in strokes) {
      if (stroke.length < 2) continue;
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}
