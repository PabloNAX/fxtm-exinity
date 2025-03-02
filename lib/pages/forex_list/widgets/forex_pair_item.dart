// lib/src/forex_pairs/widgets/forex_pair_item.dart

import 'package:flutter/material.dart';
import '../../../data/models/forex_pair.dart';

/// Widget for displaying a single forex pair with its current price, change, and percentage change.
class ForexPairItem extends StatelessWidget {
  final ForexPair pair;
  final VoidCallback onTap;

  const ForexPairItem({
    Key? key,
    required this.pair,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if the price is increasing or decreasing
    final bool isPriceUp = pair.change >= 0;

    // Select the appropriate arrow icon
    final IconData arrowIcon = isPriceUp ? Icons.arrow_upward : Icons.arrow_downward;
    final Color arrowColor = isPriceUp ? Colors.green : Colors.red;

    return ListTile(
      leading: Icon(arrowIcon, color: arrowColor),
      title: Text(
        pair.symbol,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text(
        'Price: ${pair.currentPrice.toStringAsFixed(5)}',
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${pair.change >= 0 ? '+' : ''}${pair.change.toStringAsFixed(5)}',
            style: TextStyle(
              color: arrowColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            '${pair.percentChange >= 0 ? '+' : ''}${pair.percentChange.toStringAsFixed(3)}%',
            style: TextStyle(
              color: arrowColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
