import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LastUpdateChip extends StatelessWidget {
  LastUpdateChip({super.key, required this.dateTime})
    : _formatter = DateFormat('dd/MM/yyyy HH:mm');

  final DateTime dateTime;
  final DateFormat _formatter;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.access_time, size: 18),
      label: Text('Atualizado em ${_formatter.format(dateTime)}'),
    );
  }
}
