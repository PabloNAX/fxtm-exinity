// lib/src/forex_pairs/forex_pairs_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/ws_service.dart';
import '../../core/ui/error_ui.dart';
import '../../data/repositories/forex_repository.dart';
import '../history/history_page.dart';
import 'cubits/forex_pairs_cubit.dart';
import 'cubits/forex_pairs_state.dart';
import 'widgets/forex_pair_item.dart';

/// Screen that displays a list of forex pairs and handles their loading and error Cubit states.
class ForexPairsScreen extends StatelessWidget {
  final ForexRepository forexRepository;
  final WsService wsService;

  const ForexPairsScreen({
    Key? key,
    required this.forexRepository,
    required this.wsService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForexPairsCubit(wsService, forexRepository),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: BlocConsumer<ForexPairsCubit, ForexPairsState>(
              listener: (context, state) {
                // Show error dialog when error state is emitted
                if (state is ForexPairsError) {
                  ErrorUI.showSnackBar(context, state.error);
                }
              },
              builder: (context, state) {
                if (state is ForexPairsInitial) {
                  context.read<ForexPairsCubit>().loadForexPairs();
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ForexPairsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ForexPairsLoaded) {
                  return _buildPairsList(context, state);
                } else if (state is ForexPairsError) {
                  // Show retry button when in error state
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Failed to load data'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<ForexPairsCubit>().loadForexPairs(),
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
        },
      ),
    );
  }

  Widget _buildPairsList(BuildContext context, ForexPairsLoaded state) {
    return RefreshIndicator(
      onRefresh: () => context.read<ForexPairsCubit>().loadForexPairs(),
      child: ListView.separated(
        itemCount: state.pairs.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final pair = state.pairs[index];
          return ForexPairItem(
            pair: pair,
            onTap: () {
              // Pause WebSocket before navigation
              context.read<ForexPairsCubit>().pauseWebSocket().then((_) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => HistoryPage(
                      forexPair: pair,
                      forexRepository: forexRepository,
                    ),
                  ),
                ).then((_) {
                  // Resume WebSocket after returning
                  context.read<ForexPairsCubit>().resumeWebSocket();
                });
              });
            },
          );
        },
      ),
    );
  }
}
