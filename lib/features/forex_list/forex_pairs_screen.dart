// lib/src/forex_pairs/forex_pairs_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/ws_service.dart';
import '../../data/repositories/forex_repository.dart';
import '../history/history_page.dart';
import 'cubits/forex_pairs_cubit.dart';
import 'cubits/forex_pairs_state.dart';
import 'widgets/forex_pair_item.dart';

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
          return PopScope(
            canPop: true,
            onPopInvokedWithResult: (didPop, result) async {
              await context.read<ForexPairsCubit>().close();
            },
            child: Scaffold(
              body: BlocBuilder<ForexPairsCubit, ForexPairsState>(
                builder: (context, state) {
                  // Проверяем текущее состояние и отображаем соответствующий виджет
                  if (state is ForexPairsInitial) {
                    // Запускаем загрузку при первом отображении экрана
                    context.read<ForexPairsCubit>().loadForexPairs();
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ForexPairsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ForexPairsLoaded) {
                    return _buildPairsList(context, state);
                  } else if (state is ForexPairsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Ошибка: ${state.message}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<ForexPairsCubit>()
                                .loadForexPairs(),
                            child: Text('Повторить'),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // Метод для построения списка валютных пар
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
              context.read<ForexPairsCubit>().pauseWebSocket().then((_) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => HistoryPage(
                      forexPair: pair,
                      forexRepository: forexRepository,
                    ),
                  ),
                ).then(
                    (_) => context.read<ForexPairsCubit>().resumeWebSocket());
              });
            },
          );
        },
      ),
    );
  }
}
