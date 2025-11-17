import 'package:flutter/material.dart';

import '../widgets/dollar_quote_body.dart';

class DollarHomePage extends StatelessWidget {
  const DollarHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: _DollarAppBar(), body: DollarQuoteBody());
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
