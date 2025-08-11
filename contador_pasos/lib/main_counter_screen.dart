import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async'; // Para simular a contagem

class MainCounterScreen extends StatefulWidget {
  @override
  _MainCounterScreenState createState() => _MainCounterScreenState();
}

class _MainCounterScreenState extends State<MainCounterScreen> {
  int _stepCount = 0;
  double _calories = 0.0;
  bool _isRunning = false;
  Timer? _timer;

  // Função para o botão Iniciar/Parar
  void _startStop() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        // Inicia um timer para simular a contagem de passos
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            _stepCount++;
            // Fórmula de exemplo: 1 passo = 0.04 calorias
            _calories = _stepCount * 0.04;
          });
        });
      } else {
        // Para o timer se o contador for pausado
        _timer?.cancel();
      }
    });
  }

  // Função para o botão Reiniciar
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
    _timer?.cancel(); // Garante que o timer seja cancelado ao sair da tela
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Contador de Passos', style: GoogleFonts.poppins(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mostrador de Passos
            Text(
              'Passos',
              style: GoogleFonts.poppins(fontSize: 24, color: Colors.grey[600]),
            ),
            Text(
              '$_stepCount',
              style: GoogleFonts.poppins(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 40),

            // Mostrador de Calorias
            Text(
              'Calorias',
              style: GoogleFonts.poppins(fontSize: 24, color: Colors.grey[600]),
            ),
            Text(
              _calories.toStringAsFixed(2), // Mostra com 2 casas decimais
              style: GoogleFonts.poppins(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFA7A7A),
              ),
            ),
            SizedBox(height: 60),

            // Botões de Controle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botão Iniciar/Parar
                ElevatedButton(
                  onPressed: _startStop,
                  child: Text(_isRunning ? 'Parar' : 'Iniciar', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning ? Colors.grey : Color(0xFFFA7A7A),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                // Botão Reiniciar
                ElevatedButton(
                  onPressed: _reset,
                  child: Text('Reiniciar', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}