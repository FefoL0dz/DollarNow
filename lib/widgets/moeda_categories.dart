import 'package:dollar_now/model/moeda.dart';
import 'package:dollar_now/widgets/categories_cards.dart';
import 'package:flutter/material.dart';

class MoedaCategories extends StatelessWidget {
  final Moeda moeda;
  final double categoryHeight;
  final MaterialColor color;
  Function? func;

  MoedaCategories({
    required this.moeda,
    required this.categoryHeight,
    required this.color,
    required this.func,
  });

  @override
  Widget build(BuildContext context) {
    return CategoriesCards(
    func: func,
    title: moeda.simbolo ?? '\$',
    description: moeda.nomeFormatado ?? '',
    color: color,
    categoryHeight: categoryHeight,
    );
  }
}
