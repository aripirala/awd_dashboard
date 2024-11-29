// lib/farmers_module/widgets/cluster_marker.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/farmer.dart';
import '../utils/phase_colors.dart';

class ClusterMarker extends StatefulWidget {
  final Map<FarmerPhase, int> distribution;
  final int totalCount;

  const ClusterMarker({
    Key? key,
    required this.distribution,
    required this.totalCount,
  }) : super(key: key);

  @override
  State<ClusterMarker> createState() => _ClusterMarkerState();
}

class _ClusterMarkerState extends State<ClusterMarker> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: isHovered ? 8 : 4,
              spreadRadius: isHovered ? 2 : 0,
            ),
          ],
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(2),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(isHovered ? 50 : 40, isHovered ? 50 : 40),
                painter: PieChartPainter(
                  distribution: widget.distribution,
                  total: widget.totalCount,
                ),
              ),
              Container(
                width: isHovered ? 34 : 28,
                height: isHovered ? 34 : 28,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.totalCount.toString(),
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: isHovered ? 14 : 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final Map<FarmerPhase, int> distribution;
  final int total;

  PieChartPainter({
    required this.distribution,
    required this.total,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    double startAngle = -math.pi / 2;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    for (var phase in PhaseColors.phaseOrder) {
      final count = distribution[phase] ?? 0;
      if (count > 0) {
        final sweepAngle = 2 * math.pi * count / total;

        paint.color = PhaseColors.getColor(phase);
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          true,
          paint,
        );

        startAngle += sweepAngle;
      }
    }
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) =>
      oldDelegate.distribution != distribution || oldDelegate.total != total;
}
