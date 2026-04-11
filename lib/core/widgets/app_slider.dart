import 'package:flutter/material.dart';
import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/constant/text_styles.dart';

// слайдер для выбора размера стаканчика кофе.
class AppSlider extends StatefulWidget {
  final List<String> size;
  final Function(int) onTap;

  const AppSlider({
    super.key,
    required this.size,
    required this.onTap,
  });

  @override
  State<AppSlider> createState() => _AppSliderState();
}

class _AppSliderState extends State<AppSlider> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: AppColor.gray.withOpacity(0.3),
        borderRadius: .circular(15),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemW = constraints.maxWidth / widget.size.length;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                bottom: 0,
                left: _selected * itemW + (itemW - itemW * 0.4) / 5,
                child: Container(
                  width: itemW * 0.75,
                  height: 2,
                  color: AppColor.main,
                ),
              ),
              Row(
                children: List.generate(widget.size.length, (index) {
                  final isActive = _selected == index;
                  return Expanded(
                    child: GestureDetector(
                      behavior: .opaque,
                      onTap: () {
                        setState(() => _selected = index);
                        widget.onTap(index);
                      },
                      child: Container(
                        alignment: .center,
                        height: double.infinity,
                        child: Text(
                          widget.size[index],
                          style: TxtStyle.m14(
                            color: isActive ? AppColor.main : AppColor.text,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}