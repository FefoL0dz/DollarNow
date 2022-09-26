import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoriesCards extends StatelessWidget {
  final String title;
  final String description;
  final MaterialColor color;
  final double categoryHeight;
  Function? func;

  CategoriesCards({
    required this.title,
    required this.description,
    required this.color,
    required this.categoryHeight,
    this.func,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func?.call(),
      child: Container(
        width: 150,
        margin: EdgeInsets.only(right: 20),
        height: this.categoryHeight,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [color[200] ?? Colors.white, color[800] ?? Colors.white]
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(5, 10),
                blurRadius: 5,
                color: Colors.grey.withOpacity(0.5),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(20.0)
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  this.title,
                  style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  this.description,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
             // _dollarIcon()
            ],
          ),
        ),
      ),
    );
  }

  Widget _dollarIcon() {
   return Container(
     child: Column(
       children: <Widget> [
         // SizedBox(
         //   height: 32,
         // ),
         Padding(
             padding: const EdgeInsets.only(bottom: 0.0),
             child: Icon(CupertinoIcons.money_dollar_circle, color: Colors.white,)
         )
       ],
     ),
   );
  }
}
