import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChartHeader extends StatelessWidget {
  final String symbol;
  final String dateRange;

  const ChartHeader({
    Key? key,
    required this.symbol,
    required this.dateRange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$symbol Price History',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                dateRange,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
