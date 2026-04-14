import 'package:flutter/material.dart';
import 'package:CoffeeBreak/core/constant/app_colors.dart';

class QuantitySelector extends StatelessWidget {
  final int count;
  final Function(int) onChanged;
  final int min;
  final int max;

  const QuantitySelector({
    super.key,
    required this.count,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      children: [
        _QtyButton(
          icon: Icons.remove,
          onTap: count > min ? () => onChanged(count - 1) : null,
        ),
        SizedBox(
          width: 36,
          child: Center(
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.text,
              ),
            ),
          ),
        ),
        _QtyButton(
          icon: Icons.add,
          onTap: count < max ? () => onChanged(count + 1) : null,
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool enabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: enabled
              ? AppColor.main.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: .circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? AppColor.main : Colors.grey,
        ),
      ),
    );
  }
}