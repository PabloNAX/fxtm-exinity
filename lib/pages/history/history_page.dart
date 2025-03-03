// lib/src/history/history_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/ui/error_ui.dart';
import '../../data/models/forex_pair.dart';
import '../../data/repositories/forex_repository.dart';
import 'cubits/history_cubit.dart';
import 'cubits/history_state.dart';
import 'widgets/chart_header.dart';
import 'widgets/date_range_selector.dart';
import 'widgets/forex_chart.dart';
import 'widgets/resolution_selector.dart';

/// Page for displaying historical data of a specific forex pair, including charts and date range selection.
/// This page manages the loading of historical data, error handling, and user interactions for selecting date ranges and resolutions.
class HistoryPage extends StatefulWidget {
  final ForexPair forexPair;
  final ForexRepository forexRepository;

  const HistoryPage({
    Key? key,
    required this.forexPair,
    required this.forexRepository,
  }) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _currentResolution = 'D';
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _endDate = DateTime.now();
    _startDate = _endDate.subtract(const Duration(days: 30));
  }

  void _loadData(BuildContext context) {
    context.read<HistoryCubit>().loadHistoricalData(
          widget.forexPair.symbol,
          resolution: _currentResolution,
          from: _startDate.millisecondsSinceEpoch ~/ 1000,
          to: _endDate.millisecondsSinceEpoch ~/ 1000,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit(widget.forexRepository),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.forexPair.symbol} History'),
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body: Column(
            children: [
              ChartHeader(
                symbol: widget.forexPair.symbol,
                dateRange: '',
              ),
              DateRangeSelector(
                initialStartDate: _startDate,
                initialEndDate: _endDate,
                onDateRangeChanged: (start, end) {
                  setState(() {
                    _startDate = start;
                    _endDate = end;
                  });
                  _loadData(context);
                },
              ),
              ResolutionSelector(
                currentResolution: _currentResolution,
                onResolutionChanged: (resolution) {
                  setState(() {
                    _currentResolution = resolution;
                  });
                  _loadData(context);
                },
              ),
              const SizedBox(height: 16),
              // Only wrap the chart area with BlocConsumer
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocConsumer<HistoryCubit, HistoryState>(
                    listener: (context, state) {
                      if (state is HistoryError) {
                        ErrorUI.showSnackBar(context, state.error);
                      }
                    },
                    builder: (context, state) {
                      if (state is HistoryInitial) {
                        _loadData(context);
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.green),
                        );
                      } else if (state is HistoryLoading) {
                        return Stack(
                          children: [
                            // Show previous chart data if available
                            if (state.previousData != null &&
                                state.previousData!.isNotEmpty)
                              ForexChart(
                                data: state.previousData!,
                                resolution: _currentResolution,
                              )
                            else
                              Container(color: Colors.grey.shade100),
                            // Show loading indicator on top
                            Container(
                              color: Colors.white.withOpacity(0.5),
                              child: const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.green),
                              ),
                            ),
                          ],
                        );
                      } else if (state is HistoryLoaded) {
                        return ForexChart(
                          data: state.data,
                          resolution: _currentResolution,
                        );
                      } else if (state is HistoryError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Failed to load data',
                                style: TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () => _loadData(context),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }
}
