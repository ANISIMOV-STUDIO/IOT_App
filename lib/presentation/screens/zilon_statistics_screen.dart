import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart';

class ZilonStatisticsScreen extends StatefulWidget {
  const ZilonStatisticsScreen({super.key});

  @override
  State<ZilonStatisticsScreen> createState() => _ZilonStatisticsScreenState();
}

class _ZilonStatisticsScreenState extends State<ZilonStatisticsScreen> {
  String _selectedPeriod = 'Week';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.v24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildMainChartCard(context),
                        const SizedBox(height: 24),
                        _buildComparisonChart(context),
                      ],
                    ),
                  ),
                  if (MediaQuery.of(context).size.width > 900) ...[
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildStatCard(context, 'Avg Temp', '22.5°C', Icons.thermostat, Colors.orange),
                          const SizedBox(height: 16),
                          _buildStatCard(context, 'Avg Humidity', '45%', Icons.water_drop, Colors.blue),
                          const SizedBox(height: 16),
                          _buildStatCard(context, 'Energy Usage', '12.4 kWh', Icons.flash_on, Colors.yellow[700]!),
                          const SizedBox(height: 16),
                           _buildEfficiencyCard(context),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Statistics',
          style: AppTypography.displayMedium.copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
          ),
          child: Row(
            children: ['Day', 'Week', 'Month', 'Year'].map((period) {
              final isSelected = _selectedPeriod == period;
              return InkWell(
                onTap: () => setState(() => _selectedPeriod = period),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    period,
                    style: AppTypography.labelSmall.copyWith(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMainChartCard(BuildContext context) {
    final theme = Theme.of(context);
    return SmartCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Temperature & Humidity History', style: AppTypography.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
          const SizedBox(height: 32),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true, 
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][value.toInt() % 7],
                            style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                       FlSpot(0, 20), FlSpot(1, 22), FlSpot(2, 21), FlSpot(3, 24), FlSpot(4, 22), FlSpot(5, 23), FlSpot(6, 21)
                    ],
                    isCurved: true,
                    color: theme.colorScheme.primary,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: theme.colorScheme.primary.withOpacity(0.1),
                    ),
                  ),
                   LineChartBarData(
                    spots: const [
                       FlSpot(0, 40), FlSpot(1, 45), FlSpot(2, 42), FlSpot(3, 48), FlSpot(4, 44), FlSpot(5, 46), FlSpot(6, 42)
                    ],
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    dashArray: [5, 5],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonChart(BuildContext context) {
      final theme = Theme.of(context);
    return SmartCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text('Energy Consumption (kWh)', style: AppTypography.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
             const SizedBox(height: 32),
            SizedBox(
                height: 200,
                child: BarChart(
                    BarChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                             bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                        (value.toInt() + 1).toString(),
                                        style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                        ),
                         borderData: FlBorderData(show: false),
                         barGroups: List.generate(7, (index) => BarChartGroupData(
                             x: index,
                             barRods: [
                                 BarChartRodData(
                                     toY: (index + 2) * 1.5,
                                     color: theme.colorScheme.secondary,
                                     width: 16,
                                     borderRadius: BorderRadius.circular(4),
                                 )
                             ]
                         )),
                    )
                ),
            )
        ],
      )
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    return SmartCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.labelSmall.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
              Text(value, style: AppTypography.headlineMedium.copyWith(color: theme.colorScheme.onSurface)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyCard(BuildContext context) {
       final theme = Theme.of(context);
       return SmartCard(
           padding: const EdgeInsets.all(20),
           backgroundColor: theme.colorScheme.primary,
           child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                   Row(
                       children: [
                           Icon(Icons.eco, color: theme.colorScheme.onPrimary),
                           const SizedBox(width: 8),
                           Text('Efficiency Score', style: AppTypography.titleMedium.copyWith(color: theme.colorScheme.onPrimary)),
                       ],
                   ),
                   const SizedBox(height: 16),
                   Text('94/100', style: AppTypography.displayLarge.copyWith(color: theme.colorScheme.onPrimary, fontSize: 36)),
                   const SizedBox(height: 8),
                   Text('Excellent efficiency! You saved 15% energy this week compared to last month.', style: AppTypography.bodySmall.copyWith(color: theme.colorScheme.onPrimary.withOpacity(0.9))),
               ],
           ),
       );
  }
}
