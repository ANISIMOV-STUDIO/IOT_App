// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart';
import '../bloc/statistics/statistics_bloc.dart';
import '../bloc/statistics/statistics_event.dart';
import '../bloc/statistics/statistics_state.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_state.dart';
import '../../../core/di/injection_container.dart';
import '../../domain/entities/temperature_reading.dart'; // Ensure correct import

class ZilonStatisticsScreen extends StatelessWidget {
  const ZilonStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HvacListBloc, HvacListState>(
      builder: (context, hvacState) {
        if (hvacState is HvacListLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (hvacState is HvacListLoaded && hvacState.units.isNotEmpty) {
           final device = hvacState.units.first;
           return BlocProvider(
             create: (context) => sl<StatisticsBloc>()..add(
               LoadStatisticsEvent(deviceId: device.id, period: StatsPeriod.week)
             ),
             child: const _StatisticsContent(),
           );
        }

        return const Center(child: Text('No devices found'));
      },
    );
  }
}

class _StatisticsContent extends StatefulWidget {
  const _StatisticsContent();

  @override
  State<_StatisticsContent> createState() => _StatisticsContentState();
}

class _StatisticsContentState extends State<_StatisticsContent> {
  StatsPeriod _selectedPeriod = StatsPeriod.week;

  void _updatePeriod(BuildContext context, StatsPeriod period) {
     setState(() => _selectedPeriod = period);
     final hvacState = context.read<HvacListBloc>().state;
     if (hvacState is HvacListLoaded && hvacState.units.isNotEmpty) {
        final deviceId = hvacState.units.first.id;
        context.read<StatisticsBloc>().add(LoadStatisticsEvent(deviceId: deviceId, period: period));
     }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsBloc, StatisticsState>(
      builder: (context, state) {
        if (state is StatisticsLoading) {
           return const Center(child: CircularProgressIndicator());
        }
        
        if (state is StatisticsError) {
           return Center(child: Text('Error: ${state.message}'));
        }

        if (state is StatisticsLoaded) {
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
                              _buildMainChartCard(context, state.temperatureHistory),
                              const SizedBox(height: 24),
                              _buildComparisonChart(context, state.energyConsumption),
                            ],
                          ),
                        ),
                        if (MediaQuery.of(context).size.width > 900) ...[
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                _buildStatCard(context, 'Avg Temp', '${_calcAvgTemp(state.temperatureHistory)}°C', Icons.thermostat, Colors.orange),
                                const SizedBox(height: 16),
                                _buildStatCard(context, 'Avg Humidity', '${_calcAvgHumidity(state.temperatureHistory)}%', Icons.water_drop, Colors.blue),
                                const SizedBox(height: 16),
                                _buildStatCard(context, 'Energy Usage', '${_calcTotalEnergy(state.energyConsumption)} kWh', Icons.flash_on, Colors.yellow[700]!),
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

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  String _calcAvgTemp(List<TemperatureReading> data) {
    if (data.isEmpty) return '--';
    final sum = data.fold(0.0, (p, e) => p + e.temperature);
    return (sum / data.length).toStringAsFixed(1);
  }

  String _calcAvgHumidity(List<TemperatureReading> data) {
     if (data.isEmpty) return '--';
    final sum = data.fold(0.0, (p, e) => p + e.humidity);
    return (sum / data.length).toStringAsFixed(0);
  }
  
  String _calcTotalEnergy(List<double> data) {
    final sum = data.fold(0.0, (p, e) => p + e);
    return sum.toStringAsFixed(1);
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
            children: StatsPeriod.values.map((period) {
              final isSelected = _selectedPeriod == period;
              final name = period.toString().split('.').last.toUpperCase();
              return InkWell(
                onTap: () => _updatePeriod(context, period),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    name,
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

  Widget _buildMainChartCard(BuildContext context, List<TemperatureReading> data) {
    final theme = Theme.of(context);
    List<FlSpot> spots = [];
    
    // Sort by timestamp
    final sortedData = List<TemperatureReading>.from(data)..sort((a,b) => a.timestamp.compareTo(b.timestamp));
    
    if (sortedData.isNotEmpty) {
      spots = sortedData.map((e) {
         // X axis: hours/days offset from start
         // For simple visualization, just use index or simple time offset
         // Let's use index for uniform distribution in mock data
         return FlSpot(sortedData.indexOf(e).toDouble(), e.temperature);
      }).toList();
    }
    
    return SmartCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Temperature History', style: AppTypography.titleLarge.copyWith(color: theme.colorScheme.onSurface)),
          const SizedBox(height: 32),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Hide X axis labels for simplicity or implement advanced date formatting
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonChart(BuildContext context, List<double> data) {
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
                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                         borderData: FlBorderData(show: false),
                         barGroups: data.asMap().entries.map((e) => BarChartGroupData(
                             x: e.key,
                             barRods: [
                                 BarChartRodData(
                                     toY: e.value,
                                     color: theme.colorScheme.secondary,
                                     width: 16,
                                     borderRadius: BorderRadius.circular(4),
                                 )
                             ]
                         )).toList(),
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
