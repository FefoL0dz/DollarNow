import 'package:flutter/material.dart';

import 'package:dollar_now/features/alerts/presentation/pages/alert_planner_page.dart';
import '../widgets/dollar_quote_body.dart';

class DollarHomePage extends StatelessWidget {
  const DollarHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _DollarAppBar(),
      body: const DollarQuoteBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AlertPlannerPage())),
        icon: const Icon(Icons.add_alert),
        label: const Text('Alerta'),
      ),
    );
  }
}

class _DollarAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DollarAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(title: const Text('Dollar Now'), centerTitle: true);
  }
}
