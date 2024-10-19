import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DataPoint {
  final List<double> curData;
  final List<double> pastData;
  final List<String> time;

  DataPoint({
    required this.curData,
    required this.pastData,
    required this.time,
  });
}

class LineChartSample2 extends StatefulWidget {
  final DataPoint dataPoint;

  const LineChartSample2({super.key, required this.dataPoint});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    const Color.fromARGB(255, 255, 255, 255),
    const Color(0xffffffff),
  ];

  List<Color> monthCurrentColors = [
    const Color.fromARGB(255, 255, 255, 255),
    const Color(0xFF0D2434),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              showAvg ? avgData() : mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );

    // Verifica se o valor está dentro do índice da lista 'time'
    if (value.toInt() >= 0 && value.toInt() < widget.dataPoint.time.length) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(widget.dataPoint.time[value.toInt()], style: style),
      );
    } else {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: const Text(''), // Retorna um widget vazio se o índice for inválido
      );
    }
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    // Calcula o valor máximo dinamicamente a partir dos dados passados e atuais
    double maxY = widget.dataPoint.pastData.isNotEmpty ||
            widget.dataPoint.curData.isNotEmpty
        ? [
            if (widget.dataPoint.pastData.isNotEmpty)
              widget.dataPoint.pastData
                  .reduce((a, b) => a > b ? a : b)
                  .toDouble(),
            if (widget.dataPoint.curData.isNotEmpty)
              widget.dataPoint.curData
                  .reduce((a, b) => a > b ? a : b)
                  .toDouble(),
          ].reduce((a, b) =>
            a > b ? a : b) // Calcula o maior valor entre todos os dados
        : 6; // Fallback para 6 caso os dados estejam vazios

    return LineChartData(
      gridData: const FlGridData(
        show: false,
        drawVerticalLine: false,
        horizontalInterval: 1,
        verticalInterval: 1,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: widget.dataPoint.time.length - 1,
      minY: 0,
      maxY: maxY, // Ajusta o eixo Y máximo dinamicamente
      lineBarsData: [
        // Dados do passado
        LineChartBarData(
          spots: List.generate(
            widget.dataPoint.pastData.length,
            (index) => FlSpot(
                index.toDouble(), widget.dataPoint.pastData[index].toDouble()),
          ),
          isCurved: true,
          color: const Color(0xff728682),
          barWidth: 1,
          isStrokeCapRound: false,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
        // Dados atuais
        LineChartBarData(
          spots: List.generate(
            widget.dataPoint.curData.length,
            (index) => FlSpot(
                index.toDouble(), widget.dataPoint.curData[index].toDouble()),
          ),
          isCurved: true,
          color: const Color.fromARGB(255, 255, 255, 255),
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: monthCurrentColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    // Calcula a média dos dados atuais
    double average = widget.dataPoint.curData.isNotEmpty
        ? widget.dataPoint.curData.reduce((a, b) => a + b) /
            widget.dataPoint.curData.length
        : 0;

    // Calcula o valor mínimo e máximo dinamicamente
    double minY = widget.dataPoint.curData.isNotEmpty
        ? widget.dataPoint.curData.reduce((a, b) => a < b ? a : b).toDouble()
        : 0;
    double maxY = widget.dataPoint.curData.isNotEmpty
        ? widget.dataPoint.curData.reduce((a, b) => a > b ? a : b).toDouble()
        : 0;

    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: false,
        drawHorizontalLine: false,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: widget.dataPoint.time.length - 1,
      minY: minY, // Ajusta o eixo Y mínimo dinamicamente
      maxY: maxY, // Ajusta o eixo Y máximo dinamicamente
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(widget.dataPoint.time.length,
              (index) => FlSpot(index.toDouble(), average)),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }
}
