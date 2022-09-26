import 'package:dollar_now/model/cotacao_moeda.dart';
import 'package:dollar_now/model/moeda.dart';
import 'package:dollar_now/service/olinda_service.dart';
import 'package:flutter/material.dart';
class MoedaDetailPage extends StatelessWidget {
  static const routeName = '/MoedaDetailPage';
  final Moeda moeda;
  final MaterialColor backgroundColor;
//TODO: transform in modal
  const MoedaDetailPage({
    required this.moeda,
    required this.backgroundColor
  });

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      gradient: _linearGradient3()
    );
  }

  BoxDecoration _boxDecoration2() {
    return BoxDecoration(
        gradient: _linearGradient4()
    );
  }

  LinearGradient _linearGradient3() {
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        backgroundColor[300] ?? backgroundColor,
        backgroundColor[700] ?? backgroundColor,
      ],
    );
  }

  LinearGradient _linearGradient4() {
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        backgroundColor[300] ?? backgroundColor,
        backgroundColor[500] ?? backgroundColor,
      ],
    );
  }

  LinearGradient _linearGradient2() {
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        backgroundColor[800] ?? backgroundColor,
        backgroundColor[700] ?? backgroundColor,
        backgroundColor[600] ?? backgroundColor,
        backgroundColor[400] ?? backgroundColor,
      ],
    );
  }

  LinearGradient _linearGradient1() {
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        backgroundColor[700] ?? backgroundColor,
        backgroundColor[600] ?? backgroundColor,
        backgroundColor[300] ?? backgroundColor,
        backgroundColor[200] ?? backgroundColor,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      //color: backgroundColor,
      decoration: _boxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: _boxDecoration2(),
          ),
          leading: IconButton(
            iconSize: 26,
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 26.0),
                    child: Text(
                      "${moeda.simbolo}",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                  ),
                  Text(
                    "${moeda.nomeFormatado}",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getCotacaoMoeda() async {
    List<CotacaoMoeda> cotacaoMoeda = await OlindaService().fetchCotacaoMoeda(moeda: moeda, date: DateTime.now().toString());
  }
}