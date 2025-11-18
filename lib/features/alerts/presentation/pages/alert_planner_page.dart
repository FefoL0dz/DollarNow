import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/di/service_locator.dart';
import '../../../dollar_quote/domain/entities/currency.dart';
import '../../../dollar_quote/presentation/providers/dollar_quote_provider.dart';
import '../providers/alert_planner_provider.dart';

class AlertPlannerPage extends StatelessWidget {
  const AlertPlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AlertPlannerProvider>(
      create: (_) => sl<AlertPlannerProvider>()..initialize(),
      child: const _AlertPlannerView(),
    );
  }
}

class _AlertPlannerView extends StatefulWidget {
  const _AlertPlannerView();

  @override
  State<_AlertPlannerView> createState() => _AlertPlannerViewState();
}

class _AlertPlannerViewState extends State<_AlertPlannerView> {
  late final TextEditingController _thresholdController;

  @override
  void initState() {
    super.initState();
    _thresholdController = TextEditingController();
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alertar quando cair')),
      body: Consumer2<AlertPlannerProvider, DollarQuoteProvider>(
        builder: (context, planner, quotes, _) {
          if (planner.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final accent = quotes.accentForCode(
            planner.selectedCurrency?.code ??
                quotes.state.selectedCurrency?.code ??
                'USD',
          );

          final thresholdValue = planner.threshold;
          final formatted = thresholdValue != null
              ? thresholdValue.toStringAsFixed(4)
              : '';
          if (_thresholdController.text != formatted) {
            _thresholdController.text = formatted;
            _thresholdController.selection = TextSelection.collapsed(
              offset: formatted.length,
            );
          }

          final currencies = planner.currencies.isNotEmpty
              ? planner.currencies
              : quotes.state.currencies;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderCard(planner: planner, accent: accent),
                const SizedBox(height: 24),
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Moeda',
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Currency>(
                      value:
                          planner.selectedCurrency ??
                          (currencies.isNotEmpty ? currencies.first : null),
                      items: currencies
                          .map(
                            (currency) => DropdownMenuItem(
                              value: currency,
                              child: Text(
                                '${currency.name} (${currency.code})',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (currency) {
                        if (currency != null) {
                          planner.selectCurrency(currency);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _thresholdController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText:
                        'Avisar quando o valor de venda estiver abaixo de',
                    border: OutlineInputBorder(),
                    prefixText: 'R\$ ',
                  ),
                  onChanged: planner.updateThreshold,
                ),
                const SizedBox(height: 16),
                _SchedulePicker(planner: planner),
                const SizedBox(height: 16),
                SwitchListTile(
                  value: planner.repeatDaily,
                  onChanged: planner.updateRepeatDaily,
                  title: const Text(
                    'Repetir diariamente enquanto estiver abaixo',
                  ),
                ),
                const SizedBox(height: 24),
                _SummaryCard(planner: planner),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: planner.isSubmitting ? null : planner.submitAlert,
                  icon: const Icon(Icons.notifications_active),
                  label: const Text('Salvar alerta'),
                ),
                const SizedBox(height: 32),
                Text(
                  'Alertas ativos',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if (planner.alerts.isEmpty)
                  const Text('Você ainda não possui alertas configurados.'),
                for (final alert in planner.alerts)
                  Card(
                    child: ListTile(
                      title: Text(
                        '${alert.currencyCode} < R\$ ${alert.threshold.toStringAsFixed(4)}',
                      ),
                      subtitle: Text(
                        'A partir de ${DateFormat('dd/MM/yyyy HH:mm').format(alert.startDate)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: alert.isActive,
                            onChanged: (value) =>
                                planner.toggleAlertActive(alert.id, value),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => planner.deleteAlert(alert.id),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.planner, required this.accent});

  final AlertPlannerProvider planner;
  final CurrencyAccent accent;

  @override
  Widget build(BuildContext context) {
    final currency = planner.selectedCurrency;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: accent.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currency != null
                ? '${currency.name} (${currency.code})'
                : 'Selecione uma moeda',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: accent.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            planner.currentPrice != null
                ? 'Valor atual: R\$ ${planner.currentPrice!.toStringAsFixed(4)}'
                : 'Sem cotação disponível',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: accent.onPrimary),
          ),
        ],
      ),
    );
  }
}

class _SchedulePicker extends StatelessWidget {
  const _SchedulePicker({required this.planner});

  final AlertPlannerProvider planner;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Vigente a partir de'),
      subtitle: Text(dateFormat.format(planner.startDate)),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final initialDate = planner.startDate;
        final date = await showDatePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          initialDate: initialDate,
        );
        if (date == null) return;
        if (!context.mounted) return;
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initialDate),
        );
        if (time == null) return;
        if (!context.mounted) return;
        final combined = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        planner.updateStartDate(combined);
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.planner});

  final AlertPlannerProvider planner;

  @override
  Widget build(BuildContext context) {
    final currency = planner.selectedCurrency;
    if (currency == null || planner.threshold == null) {
      return const SizedBox.shrink();
    }
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Avisaremos quando ${currency.code} venda < '
          'R\$ ${planner.threshold!.toStringAsFixed(4)} '
          'após ${dateFormat.format(planner.startDate)}'
          '${planner.repeatDaily ? ' (repetindo diariamente)' : ''}',
        ),
      ),
    );
  }
}
