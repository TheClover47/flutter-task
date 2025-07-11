import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../cubit/inspection_cubit.dart';
import '../cubit/swing_cubit.dart';

class InspectionScreen extends StatelessWidget {
  const InspectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final swingCubit = context.watch<SwingCubit>();
    final currentSwing = swingCubit.current;

    return Scaffold(
      appBar: AppBar(title: Text("Inspection"), centerTitle: true),
      body: BlocBuilder<InspectionCubit, InspectionState>(
        builder: (context, state) {
          if (state is InspectionLoading) {
            // loader while loading data
            return Center(child: CircularProgressIndicator());
          } else if (state is InspectionLoaded) {
            // after data has been loaded
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Swing ${currentSwing?.id}',
                        style: TextStyle(fontSize: 24),
                      ),
                      IconButton(
                        onPressed: () {
                          swingCubit.deleteCurrent();
                          final newCurrent = swingCubit
                              .current; // set next available swing as active

                          if (newCurrent == null) {
                            Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            );
                          } else {
                            context.read<InspectionCubit>().loadSwing(
                              newCurrent.id,
                            );
                          }
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 300,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: LineChart(
                      LineChartData(
                        extraLinesData: ExtraLinesData(
                          horizontalLines: List.generate(5 * 2 + 1, (i) {
                            final y = (i - 5) * 20.0;
                            return HorizontalLine(
                              y: y,
                              color: Colors.grey,
                              strokeWidth: 1,
                              dashArray: [5, 5],
                            );
                          }),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 10,
                              getTitlesWidget: (value, meta) {
                                if (value % 10 == 0) {
                                  return Text(value.toStringAsFixed(0));
                                }
                                return SizedBox.shrink();
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: state.data.flexEx
                                .asMap()
                                .entries
                                .map((e) => FlSpot(e.key.toDouble(), e.value))
                                .toList(),
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 2,
                          ),
                          LineChartBarData(
                            spots: state.data.radUln
                                .asMap()
                                .entries
                                .map((e) => FlSpot(e.key.toDouble(), e.value))
                                .toList(),
                            isCurved: true,
                            color: Colors.orange,
                            barWidth: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(width: 12, height: 12, color: Colors.blue),
                          SizedBox(width: 6),
                          Text(
                            "Flex/Extension",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 6),
                          Text("Radial/Ulnar", style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (state is InspectionError) {
            return Center(child: Text(state.message));
          }
          return SizedBox();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (swingCubit.hasPrevious)
                TextButton.icon(
                  onPressed: () {
                    swingCubit.previous();
                    context.read<InspectionCubit>().loadSwing(
                      swingCubit.state!,
                    );
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text("Previous"),
                )
              else
                SizedBox(width: 100),
              if (swingCubit.hasNext)
                TextButton.icon(
                  onPressed: () {
                    swingCubit.next();
                    context.read<InspectionCubit>().loadSwing(
                      swingCubit.state!,
                    );
                  },
                  icon: Text("Next"),
                  label: Icon(Icons.arrow_forward),
                )
              else
                SizedBox(width: 100),
            ],
          ),
        ),
      ),
    );
  }
}
