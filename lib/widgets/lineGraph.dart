import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:draw_graph/models/feature.dart';

class LineGraphPainter extends CustomPainter {
  final List<String> labelX;
  final List<String> labelY;
  final List<int> list;
  final String fontFamily;
  final Color graphColor;
  final double graphOpacity;
  final int labelYGap;
  bool isShowGraphLine = false;
  LineGraphPainter({
    required this.isShowGraphLine,
    required this.labelX,
    required this.labelY,
    required this.list,
    required this.fontFamily,
    required this.graphColor,
    required this.labelYGap,
    required this.graphOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double _offsetX = 1;
    for (int i = 0; i < labelY.length; i++) {
      if (labelY[i].length > _offsetX) {
        _offsetX = labelY[i].length.toDouble();
      }
    }

    _offsetX *= 7;
    _offsetX += 2 * size.width / 20;
    Size margin = Size(_offsetX, size.height / 20);
    Size graph = Size(
      size.width,
      size.height,
    );
    Size cell = Size(
      (graph.width - margin.width) / (list.length),
      graph.height / labelY.length,
    );
    // drawAxis(canvas, graph, margin);
    if (isShowGraphLine) {
      drawGraph(
        canvas,
        graph,
        cell,
        margin,
      );
    }
    drawLabelsY(canvas, size, margin, graph, cell);

    drawLabelsX(canvas, Size(_offsetX, margin.height / 20), graph, cell);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawAxis(Canvas canvas, Size graph, Size margin) {
    Paint linePaint = Paint()
      ..color = graphColor
      ..strokeWidth = 1;

    Offset xEnd =
        Offset(graph.width + 2 * margin.width, graph.height + margin.height);
    Offset yStart = Offset(margin.width, 0);

    //X-Axis & Y-Axis
    canvas.drawLine(
        Offset(margin.width, graph.height + margin.height), xEnd, linePaint);
    canvas.drawLine(
        yStart, Offset(margin.width, graph.height + margin.height), linePaint);

    //Arrow heads
    canvas.drawLine(xEnd, Offset(xEnd.dx - 5, xEnd.dy - 5), linePaint);
    canvas.drawLine(xEnd, Offset(xEnd.dx - 5, xEnd.dy + 5), linePaint);
    canvas.drawLine(yStart, Offset(yStart.dx - 5, yStart.dy + 5), linePaint);
    canvas.drawLine(yStart, Offset(yStart.dx + 5, yStart.dy + 5), linePaint);
  }

  void drawLabelsY(
      Canvas canvas, Size size, Size margin, Size graph, Size cell) {
    for (int i = 0; i < labelY.length; i++) {
      TextSpan span = TextSpan(
        style: TextStyle(
          color: graphColor,
          fontFamily: fontFamily,
        ),
        text: labelY[i],
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      double textSize = tp.height;
      tp.paint(
        canvas,
        Offset(
          20,
          graph.height - (i) * cell.height - textSize,
        ),
      );
    }
  }

  void drawLabelsX(Canvas canvas, Size margin, Size graph, Size cell) {
    for (int i = 0; i < labelX.length; i++) {
      TextSpan span = TextSpan(
        style: TextStyle(
          color: graphColor,
          fontSize: list.length > 12 ? 7 : 10,
          fontFamily: fontFamily,
        ),
        text: labelX[i],
      );
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(
        canvas,
        Offset(
          margin.width + cell.width * i,
          margin.height + graph.height + 5,
        ),
      );
    }
  }

  void drawGraph(Canvas canvas, Size graph, Size cell, Size margin) {
    Paint fillPaint = Paint()
      ..color = Colors.green.withOpacity(graphOpacity)
      ..style = PaintingStyle.fill;
    Paint strokePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Path path = Path();
    Path linePath = Path();
    int marginBottom = 5;
    path.moveTo(margin.width, graph.height - marginBottom);
    path.lineTo(
      margin.width,
      graph.height - marginBottom,
    );
    double value = cell.height / labelYGap;
    linePath.moveTo(
      margin.width + 0 * cell.width,
      graph.height -
          ((list[0] * value) +
              marginBottom), //here 10 value line start bottom show if add 10 start line point circle start
    );

    const pointMode = PointMode.points;

    for (int i = 0; i < list.length; i++) {
      // this condition for when user draph value  0 that time not draw line and dot shape.
      if (list[i] > 0) {
        final points = [
          Offset(margin.width + i * cell.width,
              graph.height - ((list[i] * value) + marginBottom))
        ];

        final paint = Paint()
          ..color = Colors.green
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round;
        canvas.drawPoints(pointMode, points, paint);
        // if (i != 0) {
        linePath.lineTo(
          margin.width + i * cell.width,
          graph.height - ((list[i] * value) + marginBottom),
        );
        //}
      }
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(linePath, strokePaint);
    }
  }
}
