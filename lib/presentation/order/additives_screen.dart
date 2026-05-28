import 'package:CoffeeBreak/core/constant/app_colors.dart';
import 'package:CoffeeBreak/core/constant/text_styles.dart';
import 'package:CoffeeBreak/core/widgets/app_bar.dart';
import 'package:CoffeeBreak/core/widgets/product_card.dart';
import 'package:CoffeeBreak/data/additives_service.dart';
import 'package:CoffeeBreak/domain/models/additive.dart';
import 'package:flutter/material.dart';
import 'package:vize/vize.dart';

class AdditivesScreen extends StatefulWidget {
  final List<Additive> initialSelected;

  const AdditivesScreen({super.key, required this.initialSelected});

  @override
  State<AdditivesScreen> createState() => _AdditivesScreenState();
}

class _AdditivesScreenState extends State<AdditivesScreen> {
  final _additivesService = AdditivesService();
  late List<Additive> _selected;
  late Future<List<Additive>> _additivesFuture;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.initialSelected);
    _additivesFuture = _additivesService.getAdditives();
  }

  void _toggle(Additive additive) {
    setState(() {
      final exists = _selected.any((e) => e.id == additive.id);

      if (exists) {
        _selected.removeWhere((e) => e.id == additive.id);
      } else if (_selected.length < 3) {
        _selected.add(additive);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
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
          shape: CircleBorder(),
          onPressed: () => Navigator.pop(context, _selected),
          child: Icon(Icons.check, color: AppColor.white, size: 40),
        ),
      ),
      body: Padding(
        padding: pa(20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text('Выберите добавку', style: TxtStyle.m14()),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Additive>>(
                future: _additivesFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final items = snapshot.data!;
                  if (items.isEmpty) {
                    return Center(child: Text('Нет доступных добавок'));
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                        isSelected: _selected.any((e) => e.id == item.id),
                        onTap: () => _toggle(item),
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