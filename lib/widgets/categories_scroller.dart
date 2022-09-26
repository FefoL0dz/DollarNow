
import 'package:dollar_now/model/moeda.dart';
import 'package:dollar_now/screen/coin_detail_page.dart';
import 'package:dollar_now/theme/color_utils.dart';
import 'package:dollar_now/widgets/moeda_categories.dart';
import 'package:flutter/material.dart';

class CategoriesScroller extends StatelessWidget {

  final List<Moeda>? moedas;

  const CategoriesScroller({
    required this.moedas,
  });

  @override
  Widget build(BuildContext context) {
    final double categoryHeight = MediaQuery.of(context).size.height * 0.30 - 50;
    if (moedas != null && moedas!.isNotEmpty) {
      List<Widget> moedaCategoriesList = [];
      for(int i = 0; i < moedas!.length; i++) {
        var backgroundColor = ColorUtils.materialColors[i];
        moedaCategoriesList.add(
          MoedaCategories(
            func: () {
              // Navigator.push(context, MaterialPageRoute(
              //     builder: (context) => CoinDetailPage(
              //       moeda: moedas![i],
              //       backgroundColor: (backgroundColor as MaterialColor),
              //     )
              // ));
            },
            moeda: moedas![i],
            color: (backgroundColor as MaterialColor),
            categoryHeight: categoryHeight,
          ),
        );
      }
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: FittedBox(
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
            child: moedaCategoriesList != null ?
            Row(
              children: moedaCategoriesList,
            ) : Container(
              child: Text('Ocorreu um erro inesperado'),
            ),
          ),
        ),
      );
    } else {
      return const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.grey,
          )
      );
    }
  }

  Widget _listView(double height) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: moedas?.length,
        itemBuilder: (context, i) {
          return MoedaCategories(
            moeda: moedas![i],
            categoryHeight: height,
            color: ColorUtils.materialColors[i] != null
                ? ColorUtils.materialColors[i] as MaterialColor
                : ColorUtils.randomColor() as MaterialColor, func: null,
          );
        }
    );
  }
}
