import 'dart:async';
import 'package:flutter/material.dart';
import '../core/services/finnhub_service.dart';
import '../core/services/ws_service.dart';
import '../data/repositories/forex_repository.dart';
import 'forex_list/forex_pairs_screen.dart';

class MainPage extends StatefulWidget {
  final ForexRepository forexRepository;
  final WsService wsService;
  final FinnhubService finnhubService;

  const MainPage({
    Key? key,
    required this.forexRepository,
    required this.wsService,
    required this.finnhubService,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This menu item is disabled')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FXTM Forex Tracker'),
      ),
      body: ForexPairsScreen(
        forexRepository: widget.forexRepository,
        wsService: widget.wsService,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Markets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
