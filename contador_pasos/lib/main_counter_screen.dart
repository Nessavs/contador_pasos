import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async'; // Para simular el conteo

class MainCounterScreen extends StatefulWidget {
  const MainCounterScreen({super.key});

  @override
  State<MainCounterScreen> createState() => _MainCounterScreenState();
}

class _MainCounterScreenState extends State<MainCounterScreen> {
  int _stepCount = 0;
  double _calories = 0.0;
  bool _isRunning = false;
  Timer? _timer;

  // Constante del modo demo: 1 paso = 0.04 kcal
  static const double _kcalPerStep = 0.04;

  // Botón Iniciar/Parar
  void _startStop() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
      return;
    }
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _stepCount++;
        _calories = _stepCount * _kcalPerStep;
      });
    });
  }

  // Botón Reiniciar
  void _reset() {
    _timer?.cancel();
    setState(() {
      _stepCount = 0;
      _calories = 0.0;
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Asegura cancelar el timer al salir
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Contador de pasos', style: GoogleFonts.poppins(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Banner de modo demo
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEFEF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.info_outline, size: 18, color: Color(0xFFFA7A7A)),
                      SizedBox(width: 8),
                      Text('Modo demo (sin sensor)', style: TextStyle(color: Color(0xFFFA7A7A))),
                    ],
                  ),
                ),
              ),

              // Mostrador de Pasos
              Text('Pasos', style: GoogleFonts.poppins(fontSize: 24, color: Colors.grey[600])),
              Text(
                '$_stepCount',
                style: GoogleFonts.poppins(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 40),

              // Mostrador de Calorías
              Text('Calorías', style: GoogleFonts.poppins(fontSize: 24, color: Colors.grey[600])),
              Text(
                _calories.toStringAsFixed(2), // 2 decimales
                style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFFFA7A7A)),
              ),
              const SizedBox(height: 6),
              Text(
                '$_kcalPerStep kcal por paso (modo demo)',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
              ),

              const SizedBox(height: 60),

              // Botones de Control
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Botón Iniciar/Parar
                  ElevatedButton(
                    onPressed: _startStop,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRunning ? Colors.grey : const Color(0xFFFA7A7A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(_isRunning ? 'Parar' : 'Iniciar', style: const TextStyle(fontSize: 18)),
                  ),

                  // Botón Reiniciar
                  ElevatedButton(
                    onPressed: _reset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Reiniciar', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
