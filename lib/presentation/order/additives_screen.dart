import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/constant/text_styles.dart';
import 'package:CoffeeBreak/core/widgets/app_bar.dart';
import 'package:CoffeeBreak/core/widgets/product_card.dart';
import 'package:CoffeeBreak/data/additives_service.dart';
import 'package:CoffeeBreak/domain/models/additive.dart';
import 'package:flutter/material.dart';

class AdditivesScreen extends StatefulWidget {
  final List<int> initialSelected;

  const AdditivesScreen({super.key, required this.initialSelected});

  @override
  State<AdditivesScreen> createState() => _AdditivesScreenState();
}

class _AdditivesScreenState extends State<AdditivesScreen> {
  final _additivesService = AdditivesService();
  late List<int> _selected;
  late Future<List<Additive>> _additivesFuture;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.initialSelected);
    _additivesFuture = _additivesService.getAdditives();
  }

  void _toggle(int id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else if (_selected.length < 3) {
        _selected.add(id);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Можно выбрать не более 3-х добавок'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppHeader(txt: 'Конструктор заказа', back: true),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          backgroundColor: AppColor.main,
          shape: const CircleBorder(),
          onPressed: () => Navigator.pop(context, _selected),
          child: const Icon(Icons.check, color: AppColor.white, size: 40),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Выберите добавку', style: TxtStyle.m14()),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Additive>>(
                future: _additivesFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final items = snapshot.data!;

                  if (items.isEmpty) {
                    return const Center(child: Text('Нет доступных добавок'));
                  }

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return AdditiveCard(
                        img: item.imagePath,
                        txt: item.name,
                        cost: item.priceLabel,
                        isSelected: _selected.contains(item.id),
                        onTap: () => _toggle(item.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}