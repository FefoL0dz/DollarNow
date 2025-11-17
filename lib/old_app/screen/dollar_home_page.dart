
import 'package:dollar_now/coins_delegate.dart';
import 'package:dollar_now/const.dart';
import 'package:dollar_now/date_time_utils.dart';
import 'package:dollar_now/model/cotacao_dolar.dart';
import 'package:dollar_now/model/moeda.dart';
import 'package:dollar_now/service/olinda_service.dart';
import 'package:dollar_now/widgets/bordered_text_button.dart';
import 'package:dollar_now/widgets/categories_scroller.dart';
import 'package:dollar_now/widgets/crypto_coin_dashboard.dart';
import 'package:dollar_now/widgets/dollar_monitor_card.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';

class DollarNowHomePage extends StatefulWidget {
  const DollarNowHomePage();

  @override
  _DollarNowHomePageState createState() => _DollarNowHomePageState();
}

class _DollarNowHomePageState extends State<DollarNowHomePage> implements IDollarDelegate {

  List<Moeda>? coins;
  late CotacaoDolar? cotacaoDolar;
  bool _isLoading = true;
  OlindaService _service = OlindaService();
  bool _isFirstPageSelected = true;

  _instantiateService() {
    if(_service == null)
      _service = OlindaService();
  }

  _fetchCoins(DateTime dateTime) async {
    _isLoading = true;
    _instantiateService();
    List<Moeda> coins = await _service.fetchMoedas();
    List<CotacaoDolar> cotacoesDolar = await _service.fetchCotacaoDolar(date: DateTimeUtils.usFormat(dateTime));
    CotacaoDolar? cotacaoDolar = (cotacoesDolar == null || cotacoesDolar.isEmpty) ? null : cotacoesDolar[0];
    setState(() {
      this.coins = coins;
      this.cotacaoDolar = cotacaoDolar;
      this._isLoading = false;
    });
  }

  @override
  void pickDate(BuildContext context) async {
    var selectedDate = cotacaoDolar?.dataHoraCotacao ?? DateTimeUtils.yesterday();
     final DateTime? picked = await showDatePicker(
       context: context,
       initialDate: selectedDate,
       firstDate: DateTime(2000),
       lastDate: DateTime(DateTime.now().year + 1),
       helpText: 'Escolha a data da cotação do dolar',
       cancelText: 'Cancelar',
       confirmText: 'Ok',
       locale: Locale("pt"),
       builder: (context, child) {
         return Theme(
           data: ThemeData.light().copyWith(
             colorScheme: ColorScheme.light(
               primary: kPrimaryColor,
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
    _fetchCoins(now.hour > 13
        ? now
        : DateTimeUtils.yesterday());
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kBackgroundColor,
          leading: IconButton(
            onPressed: () {
              _informativePopUp(context);
            },
            icon: Icon(
              CommunityMaterialIcons.information_outline,
              color: Colors.grey[800],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(CommunityMaterialIcons.bullhorn_outline,
                  color: Colors.grey[800]),
              onPressed: () {},
            )
          ],
        ),
        body: _isFirstPageSelected ? _firstPageBody(size) : _secondPageBody(size),
      ),
    );
  }

  void _informativePopUp(BuildContext context) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.white.withOpacity(0.45),
                  content: Stack(
                    clipBehavior: Clip.none, children: <Widget>[
                      Positioned(
                        right: -40.0,
                        top: -40.0,
                        child: InkResponse(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            child: Icon(Icons.close),
                            backgroundColor: Colors.grey,
                            foregroundColor: kAlertTextColor,
                          ),
                        ),
                      ),
                      Text(kInformativeText, style: TextStyle(fontSize: 20),),
                    ],
                  ),
                );
              });
  }

  Widget _firstPageBody(Size size) {
    return Container(
      height: size.height,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _selectedTextButton(function: () {}, label: 'Moedas'),
              _unselectedTextButton(
                function: () {
                  setState(() {
                    _isFirstPageSelected = false;
                  });
                },
                label: 'Criptomoedas'
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            child: CategoriesScroller(
              moedas: coins,
            ),
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
            ) : DollarMonitorCard(cotacaoDolar: cotacaoDolar, delegate: this,),
          ),
        ],
      ),
    );
  }

  Widget _secondPageBody(Size size) {
    return Container(
      height: size.height,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _unselectedTextButton(
                function: () {
                  setState(() {
                    _isFirstPageSelected = true;
                  });
                },
                label: 'Moedas'),
              _selectedTextButton(
                function: () { },
                label: 'Criptomoedas'),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10,10,10,0),
            height: 220,
            width: double.maxFinite,
            child: _isLoading ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blueGrey,
                )
            ) : CryptoCoinDashboard(
              // cotacaoDolar: cotacaoDolar,
              // delegate: this,
            ),
          ),
        ],
      ),
    );
  }

  BorderedTextButton _selectedTextButton({required String label, required Function function}) {
    return BorderedTextButton(
      function: function,
      text: label,
      textColor: kBackgroundColor,
      fontSize: 22,
      backgroundColor: kSecondaryColor,
      borderWidth: 2,
      borderColor: kSecondaryColor,
      borderRadius: 20,
    );
  }

  BorderedTextButton _unselectedTextButton({required String label, required Function function}) {
    return  BorderedTextButton(
      function: function,
      text: label,
      textColor: kSecondaryColor,
      fontSize: 22,
      backgroundColor: kBackgroundColor,
      borderWidth: 2,
      borderColor: kSecondaryColor,
      borderRadius: 20,
    );
  }
}
