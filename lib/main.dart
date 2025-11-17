import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/service_locator.dart';
import 'features/dollar_quote/presentation/pages/dollar_home_page.dart';
import 'features/dollar_quote/presentation/providers/dollar_quote_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const DollarNowApp());
}

class DollarNowApp extends StatelessWidget {
  const DollarNowApp({
    super.key,
    this.providerBuilder,
    this.bootstrapData = true,
  });

  final DollarQuoteProvider Function()? providerBuilder;
  final bool bootstrapData;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider =
                (providerBuilder ?? () => sl<DollarQuoteProvider>())();
            if (bootstrapData) {
              provider.loadDashboard();
            }
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Dollar Now',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const DollarHomePage(),
      ),
    );
  }
}
