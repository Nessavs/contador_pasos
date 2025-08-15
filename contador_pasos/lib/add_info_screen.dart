import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_info.dart';
import 'summary_screen.dart';

class AddInfoScreen extends StatefulWidget {
  const AddInfoScreen({super.key});

  @override
  State<AddInfoScreen> createState() => _AddInfoScreenState();
}

class _AddInfoScreenState extends State<AddInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pesoCtrl = TextEditingController();
  final _alturaCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();
  final _generoCtrl = TextEditingController();

  @override
  void dispose() {
    _pesoCtrl.dispose();
    _alturaCtrl.dispose();
    _edadCtrl.dispose();
    _generoCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      final info = UserInfo(
        pesoKg: double.parse(_pesoCtrl.text.replaceAll(',', '.')),
        alturaCm: double.parse(_alturaCtrl.text.replaceAll(',', '.')),
        edad: int.parse(_edadCtrl.text),
        genero: _generoCtrl.text.isEmpty ? 'N/D' : _generoCtrl.text,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => SummaryScreen(userInfo: info)),
      );
    } catch (e) {
      _showError('Revisa los valores ingresados.');
    }
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Datos inválidos'),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK')),
        ],
      ),
    );
  }

  String? _req(String? v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Agrega\ntu información',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _pesoCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Peso (kg)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: _req,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _alturaCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Altura (cm)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: _req,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _edadCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Edad',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: _req,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _generoCtrl,
                  decoration: InputDecoration(
                    labelText: 'Género',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _guardar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA7A7A),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    'Guardar',
                    style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
