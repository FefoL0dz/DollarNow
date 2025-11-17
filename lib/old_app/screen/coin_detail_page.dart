import 'package:dollar_now/coins_delegate.dart';
import 'package:dollar_now/model/cotacao_moeda.dart';
import 'package:dollar_now/model/moeda.dart';
import 'package:dollar_now/service/olinda_service.dart';
import 'package:dollar_now/theme/palette.dart';
import 'package:dollar_now/widgets/coin_monitor_card.dart';
import 'package:flutter/material.dart';

import '../date_time_utils.dart';

class CoinDetailPage extends StatefulWidget {
  static const routeName = '/MoedaDetailPage';
  final Moeda moeda;
  final MaterialColor backgroundColor;

//TODO: transform in modal
  const CoinDetailPage({
    required this.moeda,
    required this.backgroundColor,
  });

  @override
  _CoinDetailPageState createState() => _CoinDetailPageState(moeda, backgroundColor);
}

class _CoinDetailPageState extends State<CoinDetailPage> implements ICoinsDelegate {

  final Moeda moeda;
  final MaterialColor backgroundColor;
  late OlindaService _service;
  late CotacaoMoeda? _cotacaoMoeda;
  bool _isLoading = false;

  _CoinDetailPageState(this.moeda, this.backgroundColor);

  _instantiateService() {
    if(_service == null)
      _service = OlindaService();
  }

  void _fetchCoins(DateTime dateTime) async {
    _isLoading = true;
    _instantiateService();
    List<CotacaoMoeda> cotacoesMoeda = await _service.fetchCotacaoMoeda(moeda: moeda, date: DateTimeUtils.usFormat(dateTime));
    CotacaoMoeda? cotacaoMoeda = (cotacoesMoeda == null || cotacoesMoeda.isEmpty) ? null : cotacoesMoeda[0];
    setState(() {
      this._cotacaoMoeda = cotacaoMoeda;
      this._isLoading = false;
    });
  }

  @override
  void pickDate(BuildContext context) async {
    DateTime selectedDate = _cotacaoMoeda?.dataHoraCotacao ?? DateTimeUtils.yesterday();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 1),
      helpText: 'Escolha a data da cotação',
      cancelText: 'Cancelar',
      confirmText: 'Ok',
      locale: Locale("pt"),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: backgroundColor,
            ),
          ),
          child: child ?? const Center(),
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      _fetchCoins(picked);
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    _fetchCoins(now.hour > 10
        ? now
        : DateTimeUtils.yesterday());
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, right: 20.0),
                      child: Text(
                        "${moeda.nomeFormatado}",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(width: 20, height: 20,),
              Container(
                padding: EdgeInsets.fromLTRB(10,10,10,0),
                height: 220,
                width: double.maxFinite,
                child: _isLoading ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blueGrey,
                    )
                ) : CoinMonitorCard(
                  cotacaoMoeda: _cotacaoMoeda,
                  color: backgroundColor,
                  title: moeda.simbolo ?? '\$',
                  delegate: this,
                ),
              ),
              // Column(
              //   children: [
              //     Text('${_cotacaoMoeda.paridadeCompra}'),
              //     Text('${_cotacaoMoeda.paridadeVenda}'),
              //     Text('${_cotacaoMoeda.tipoBoletim}'),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

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
        backgroundColor[300] ?? Palette.white,
        backgroundColor[700] ?? Palette.white,
      ],
    );
  }

  LinearGradient _linearGradient4() {
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        backgroundColor[300] ?? Palette.white,
        backgroundColor[500] ?? Palette.white,
      ],
    );
  }

  LinearGradient _linearGradient2() {
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        backgroundColor[800] ?? Palette.white,
        backgroundColor[700] ?? Palette.white,
        backgroundColor[600] ?? Palette.white,
        backgroundColor[400] ?? Palette.white,
      ],
    );
  }

  LinearGradient _linearGradient1() {
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        backgroundColor[700] ?? Palette.white,
        backgroundColor[600] ?? Palette.white,
        backgroundColor[300] ?? Palette.white,
        backgroundColor[200] ?? Palette.white,
      ],
    );
  }
}
