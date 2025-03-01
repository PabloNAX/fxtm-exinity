// history_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fxtm/features/history/widgets/chart_header.dart';
import 'package:fxtm/features/history/widgets/date_range_selector.dart';
import '../../data/models/forex_pair.dart';
import '../../data/repositories/forex_repository.dart';
import 'cubits/history_cubit.dart';
import 'cubits/history_state.dart';
import '../../data/models/candle_data.dart';
import 'widgets/forex_chart.dart';
import 'widgets/resolution_selector.dart';

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
  String _currentResolution = 'D'; // Default to daily chart
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    // Default date range: last 30 days
    _endDate = DateTime.now();
    _startDate = _endDate.subtract(const Duration(days: 30));
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
          body: BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              if (state is HistoryInitial) {
                context.read<HistoryCubit>().loadHistoricalData(
                      widget.forexPair.symbol,
                      resolution: _currentResolution,
                      from: _startDate.millisecondsSinceEpoch ~/ 1000,
                      to: _endDate.millisecondsSinceEpoch ~/ 1000,
                    );
                return const Center(
                    child: CircularProgressIndicator(color: Colors.green));
              } else if (state is HistoryLoading) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.green));
              } else if (state is HistoryLoaded) {
                // Update date range based on actual data
                if (state.data.isNotEmpty) {
                  _startDate = state.data.first.date;
                  _endDate = state.data.last.date;
                }

                return Column(
                  children: [
                    // Chart header
                    ChartHeader(
                      symbol: widget.forexPair.symbol,
                      dateRange: '',
                    ),
                    // Date Range Selector
                    DateRangeSelector(
                      initialStartDate: _startDate,
                      initialEndDate: _endDate,
                      onDateRangeChanged: (start, end) {
                        setState(() {
                          _startDate = start;
                          _endDate = end;
                        });
                        context.read<HistoryCubit>().loadHistoricalData(
                              widget.forexPair.symbol,
                              resolution: _currentResolution,
                              from: _startDate.millisecondsSinceEpoch ~/ 1000,
                              to: _endDate.millisecondsSinceEpoch ~/ 1000,
                            );
                      },
                    ),

                    // Resolution selector
                    ResolutionSelector(
                      currentResolution: _currentResolution,
                      onResolutionChanged: (resolution) {
                        setState(() {
                          _currentResolution = resolution;
                        });
                        context.read<HistoryCubit>().loadHistoricalData(
                              widget.forexPair.symbol,
                              resolution: resolution,
                              from: _startDate.millisecondsSinceEpoch ~/ 1000,
                              to: _endDate.millisecondsSinceEpoch ~/ 1000,
                            );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Chart
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ForexChart(
                          data: state.data,
                          resolution: _currentResolution,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                );
              } else if (state is HistoryError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.red),
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
                        onPressed: () => context
                            .read<HistoryCubit>()
                            .loadHistoricalData(
                              widget.forexPair.symbol,
                              resolution: _currentResolution,
                              from: _startDate.millisecondsSinceEpoch ~/ 1000,
                              to: _endDate.millisecondsSinceEpoch ~/ 1000,
                            ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        );
      }),
    );
  }
}
