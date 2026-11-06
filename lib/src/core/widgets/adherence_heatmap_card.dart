import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class AdherenceHeatmapCard extends StatelessWidget {
  const AdherenceHeatmapCard({
    required this.history,
    this.title = 'Yearly Adherence',
    this.showTitle = true,
    super.key,
  });

  final Map<DateTime, int> history;
  final String title;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (showTitle) ...<Widget>[
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 20),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Static Day Labels on the left
              _buildStaticDayLabels(),
              const SizedBox(width: 8),
              // Scrollable Heatmap
              Expanded(
                child: HeatMap(
                  datasets: history,
                  colorMode: ColorMode.color,
                  defaultColor: Colors.white.withValues(alpha: 0.03),
                  textColor: Colors.white38,
                  showColorTip: false,
                  showText: false,
                  scrollable: true,
                  size: 18,
                  colorsets: <int, Color>{
                    1: primaryColor.withValues(alpha: 0.3),
                    2: primaryColor.withValues(alpha: 0.6),
                    3: primaryColor,
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStaticDayLabels() {
    const double squareSize = 18.0;
    const double spacing = 2.0;
    const TextStyle labelStyle = TextStyle(
      color: Colors.white24,
      fontSize: 10,
      fontWeight: FontWeight.w600,
    );

    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        _label('Sun', labelStyle, squareSize, spacing),
        _label('Mon', labelStyle, squareSize, spacing),
        _label('Tue', labelStyle, squareSize, spacing),
        _label('Wed', labelStyle, squareSize, spacing),
        _label('Thu', labelStyle, squareSize, spacing),
        _label('Fri', labelStyle, squareSize, spacing),
        _label('Sat', labelStyle, squareSize, spacing),
      ],
    );
  }

  Widget _label(String text, TextStyle style, double size, double spacing) {
    return Container(
      height: size,
      margin: EdgeInsets.only(bottom: spacing),
      alignment: Alignment.centerLeft,
      child: Text(text, style: style),
    );
  }
}
