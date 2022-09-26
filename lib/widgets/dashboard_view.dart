import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
              height: 220,
              width: double.maxFinite,
              child: cardWidget(),
            )
        )
    );
  }

  Widget cardWidget() {
    return Card(
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
                            cryptoIcon(),
                            SizedBox(
                              height: 10,
                            ),
                            cryptoNameSymbol(),
                            Spacer(),
                            cryptoChange(),
                            SizedBox(
                              width: 10,
                            ),
                            changeIcon(),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[cryptoAmount()],
                        )
                      ],
                    ))
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget cryptoIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.calendar_today,
            color: Colors.amber,
            size: 40,
          )),
    );
  }
  Widget cryptoNameSymbol() {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: 'Bitcoin',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: '\nBTC',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  Widget cryptoChange() {
    return Align(
      alignment: Alignment.topRight,
      child: RichText(
        text: TextSpan(
          text: '+3.67%',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: '\n+202.835',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  Widget changeIcon() {
    return Align(
        alignment: Alignment.topRight,
        child: Icon(
          Icons.architecture_outlined,
          color: Colors.green,
          size: 30,
        ));
  }
  Widget cryptoAmount() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: '\n\$12.279',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 35,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: '\n0.1349',
                      style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}