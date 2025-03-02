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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildResolutionButton('15m', '15'),
            _buildResolutionButton('1h', '60'),
            _buildResolutionButton('4h', '240'),
            _buildResolutionButton('1D', 'D'),
            _buildResolutionButton('1W', 'W'),
          ],
        ),
      ),
    );
  }

  Widget _buildResolutionButton(String label, String resolution) {
    final bool isSelected = currentResolution == resolution;
    return Expanded(
      child: GestureDetector(
        onTap: () => onResolutionChanged(resolution),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
