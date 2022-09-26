import 'package:dollar_now/coins_delegate.dart';
import 'package:dollar_now/date_time_utils.dart';
import 'package:dollar_now/model/cotacao_dolar.dart';
import 'package:flutter/material.dart';
import 'package:dollar_now/extensions/extension_num.dart';

class DollarMonitorCard extends StatelessWidget {
  final CotacaoDolar? cotacaoDolar;
  final IDollarDelegate? delegate;

  DollarMonitorCard({
    this.cotacaoDolar,
    this.delegate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Stack(children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Stack(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              _moneyIcon(),
                              SizedBox(
                                height: 10,
                              ),
                              _dollarNameSymbol(),
                              Spacer(),
                              _requestDate(context),
                              SizedBox(
                                width: 10,
                              ),
                              _calendarIcon(context),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              cotacaoDolar != null
                                  ? _dollarAmountValue()
                                  : _resultNotObtained(),
                            ],
                          ),
                        ],
                      ),
                  ),
                ],
              ),
            ),
            _hoursAndMinutes(),
          ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  Widget _hoursAndMinutes() {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0, bottom: 6.0),
      child: Align(
          alignment: Alignment.bottomRight,
          child: Text(cotacaoDolar == null
              ? '' :
              'última atualização: ${DateTimeUtils
                  .hourFormat(cotacaoDolar!.dataHoraCotacao!)}',
              style: TextStyle(
                  //decoration: TextDecoration.underline,
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                  fontSize: 16)
          ),
      ),
    );
  }

  Widget _moneyIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.monetization_on,
            color: Colors.lightGreen,
            size: 40,
          )
      ),
    );
  }

  Widget _dollarNameSymbol() {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: 'Dolar',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: '\nUSD',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _dateTimeTextInCalendar() {
    return RichText(
      text: TextSpan(
        text: '${DateTimeUtils
            .ptBrFormat(cotacaoDolar!.dataHoraCotacao!)}',
        style: TextStyle(
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
            fontSize: 20),
        children: <TextSpan>[
          TextSpan(
              text: '\n${DateTimeUtils
                  .hourFormat(cotacaoDolar!.dataHoraCotacao!)}',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _textInCalendar() {
    return Text(cotacaoDolar != null
        ? '${DateTimeUtils.ptBrFormat(cotacaoDolar!.dataHoraCotacao!)}'
        : 'Selecione outra data!',
        style: TextStyle(
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
        fontSize: 20)
    );
  }

  Widget _requestDate(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onCalendarTap(context);
      },
      child: Align(
        alignment: Alignment.topRight,
        child: cotacaoDolar != null
            ? _textInCalendar()
            : Text('Selecionar data',
            style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
            fontSize: 18)),
      ),
    );
  }

  void _onCalendarTap(BuildContext context) async {
    this.delegate?.pickDate(context);
  }

  Widget _calendarIcon(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
        child: IconButton(
          icon: Icon(
            Icons.calendar_today,
            color: Colors.blueGrey,
            size: 30,
          ),
          onPressed: () {
            _onCalendarTap(context);
          },
        )
    );
  }

  Decoration _boxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.yellow[200] ?? Colors.yellow,
            Colors.red[800] ?? Colors.red,
          ]
      ),
      boxShadow: [
        BoxShadow(
          offset: Offset(5, 10),
          blurRadius: 5,
          color: Colors.grey.withOpacity(0.5),
        ),
      ],
      borderRadius: BorderRadius.all(Radius.circular(20.0))
    );
  }

  Widget _dollarAmountValue() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: _getBRLValue(cotacaoDolar!.cotacaoCompra!),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 30,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: '\nCotação Compra',
                      style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(width: 40,),
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: _getBRLValue(cotacaoDolar!.cotacaoVenda!),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 30,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: '\nCotação Venda',
                      style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
  
  String _getBRLValue(double number) {
    return '\nR\$${number.notationPtBr('br', 4, '')}';
  }

  Widget _resultNotObtained() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, top: 18.0),
        child: Text('A data selecionada não obteve um retorno.',
          style: TextStyle(
          color: Colors.red,
          fontSize: 16,),
        ),
      ),
    );
  }
}