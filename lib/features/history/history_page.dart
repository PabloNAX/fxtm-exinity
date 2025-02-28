// history_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fxtm/features/history/widgets/chart_header.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit(widget.forexRepository),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.forexPair.symbol} History'),
          ),
          body: BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              if (state is HistoryInitial) {
                context.read<HistoryCubit>().loadHistoricalData(
                      widget.forexPair.symbol,
                      resolution: _currentResolution,
                    );
                return const Center(child: CircularProgressIndicator());
              } else if (state is HistoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HistoryLoaded) {
                final dateRange = _getDateRange(state.data);
                return Column(
                  children: [
                    // Chart header
                    ChartHeader(
                      symbol: widget.forexPair.symbol,
                      dateRange: dateRange,
                    ),

                    // Resolution selector
                    ResolutionSelector(
                      currentResolution: _currentResolution,
                      onResolutionChanged: (resolution) {
                        _currentResolution = resolution;
                        context.read<HistoryCubit>().loadHistoricalData(
                              widget.forexPair.symbol,
                              resolution: resolution,
                            );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                    SizedBox(
                      height: 20,
                    )
                  ],
                );
              } else if (state is HistoryError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${state.message}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context
                            .read<HistoryCubit>()
                            .loadHistoricalData(widget.forexPair.symbol),
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

  String _getDateRange(List<CandleData> data) {
    if (data.isEmpty) return '';

    final firstDate = data.first.date;
    final lastDate = data.last.date;

    String formatDate(DateTime date) {
      return '${date.day}.${date.month}.${date.year}';
    }

    return '${formatDate(firstDate)} - ${formatDate(lastDate)}';
  }
}
