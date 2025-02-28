// widgets/resolution_selector.dart

import 'package:flutter/material.dart';

class ResolutionSelector extends StatelessWidget {
  final String currentResolution;
  final Function(String) onResolutionChanged;

  const ResolutionSelector({
    Key? key,
    required this.currentResolution,
    required this.onResolutionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildResolutionButton('15 min', '15'),
            _buildResolutionButton('1 hour', '60'),
            _buildResolutionButton('4 hours', '240'),
            _buildResolutionButton('1 day', 'D'),
            _buildResolutionButton('1 week', 'W'),
          ],
        ),
      ),
    );
  }

  Widget _buildResolutionButton(String label, String resolution) {
    bool isSelected = currentResolution == resolution;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.green : Colors.grey.shade200,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        ),
        onPressed: () => onResolutionChanged(resolution),
        child: Text(label),
      ),
    );
  }
}
