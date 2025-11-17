
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screen/dollar_home_page.dart';
import 'screen/moeda_detail_page.dart';
import 'theme/color_utils.dart';

class DollarNowApp extends StatelessWidget {
  const DollarNowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      // supportedLocales: const [
      //   Locale('pt'),
      //   Locale('Br')
      // ],
      title: 'Dollar Now Application',
      theme: ThemeData(
        primaryColor: ColorUtils.numUsp93606070(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
        initialRoute: '/',
      home: DollarNowHomePage(),
    );
  }
}