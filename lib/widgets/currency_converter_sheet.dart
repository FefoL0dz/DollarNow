import 'package:flutter/material.dart';
import 'package:dollar_now/model/cotacao_dolar.dart';

class CurrencyConverterSheet extends StatefulWidget {
  final CotacaoDolar cotacaoDolar;

  const CurrencyConverterSheet({Key? key, required this.cotacaoDolar}) : super(key: key);

  @override
  _CurrencyConverterSheetState createState() => _CurrencyConverterSheetState();
}

class _CurrencyConverterSheetState extends State<CurrencyConverterSheet> {
  final TextEditingController _brlController = TextEditingController();
  final TextEditingController _usdController = TextEditingController();

  late double _rate;

  @override
  void initState() {
    super.initState();
    _rate = widget.cotacaoDolar.cotacaoVenda ?? 5.0; // Fallback to 5.0 if null
    
    // Initial values
    _usdController.text = "1.00";
    _updateBrlFromUsd("1.00");
  }

  @override
  void dispose() {
    _brlController.dispose();
    _usdController.dispose();
    super.dispose();
  }

  void _updateUsdFromBrl(String brlText) {
    if (brlText.isEmpty) {
      _usdController.text = "";
      return;
    }
    final brlValue = double.tryParse(brlText.replaceAll(',', '.')) ?? 0.0;
    final usdValue = brlValue / _rate;
    // Update without triggering listener again by not using setState here
    _usdController.value = TextEditingValue(
      text: usdValue.toStringAsFixed(2),
      selection: TextSelection.collapsed(offset: usdValue.toStringAsFixed(2).length),
    );
  }

  void _updateBrlFromUsd(String usdText) {
    if (usdText.isEmpty) {
      _brlController.text = "";
      return;
    }
    final usdValue = double.tryParse(usdText.replaceAll(',', '.')) ?? 0.0;
    final brlValue = usdValue * _rate;
    // Update without triggering listener again
    _brlController.value = TextEditingValue(
      text: brlValue.toStringAsFixed(2),
      selection: TextSelection.collapsed(offset: brlValue.toStringAsFixed(2).length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: Color(0xff2c274c),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Conversor de Moedas',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Cotação atual: R\$ ${_rate.toStringAsFixed(3)}',
            style: TextStyle(color: Colors.greenAccent, fontSize: 14),
          ),
          SizedBox(height: 30),
          _buildTextField(
            controller: _usdController,
            label: 'Dólar (USD)',
            icon: Icons.attach_money,
            onChanged: _updateBrlFromUsd,
          ),
          SizedBox(height: 20),
          Icon(Icons.swap_vert, color: Colors.white54, size: 30),
          SizedBox(height: 20),
          _buildTextField(
            controller: _brlController,
            label: 'Real (BRL)',
            icon: Icons.money,
            onChanged: _updateUsdFromBrl,
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.greenAccent),
        filled: true,
        fillColor: Color(0xff46426c),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.greenAccent, width: 2),
        ),
      ),
    );
  }
}
