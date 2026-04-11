import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int count;
  final Function(int) onChanged;

  const QuantitySelector({
    super.key,
    required this.count,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
