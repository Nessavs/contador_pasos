import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async'; // Para simular el conteo
import 'package:shared_preferences/shared_preferences.dart'; // Para persistencia local
import 'summary_screen.dart'; // Importar pantalla de resumen
import 'models/user_info.dart'; // Importar modelo UserInfo

class MainCounterScreen extends StatefulWidget {
  const MainCounterScreen({super.key});

  @override
  State<MainCounterScreen> createState() => _MainCounterScreenState();
}

class _MainCounterScreenState extends State<MainCounterScreen> {
  int _stepCount = 0;      // Número de pasos
  double _calories = 0.0;  // Calorías quemadas
  bool _isRunning = false; // Estado del contador
  Timer? _timer;           // Timer para simular pasos

  // Constante: 1 paso = 0.04 kcal
  static const double _kcalPerStep = 0.04;

  @override
  void initState() {
    super.initState();
    _loadData(); // Cargar pasos y calorías guardados al iniciar
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancelar timer al salir de la pantalla
    super.dispose();
  }

  /// Cargar pasos y calorías desde SharedPreferences
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _stepCount = prefs.getInt('steps') ?? 0;        // Valor por defecto: 0
      _calories = prefs.getDouble('calories') ?? 0.0; // Valor por defecto: 0.0
    });
  }

  /// Guardar pasos y calorías en SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('steps', _stepCount);
    await prefs.setDouble('calories', _calories);
  }

  /// Iniciar o detener el contador
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

      _saveData(); // Guardar datos cada segundo
    });
  }

  /// Reiniciar el contador
  void _reset() {
    _timer?.cancel();
    setState(() {
      _stepCount = 0;
      _calories = 0.0;
      _isRunning = false;
    });

    _saveData(); // Guardar reinicio
  }

  // /// Navegar a SummaryScreen con los datos actuales
  // void _goToSummary() {
  //   // Aquí puedes crear un UserInfo mock o adaptarlo si tienes datos reales
  //   final userInfo = UserInfo(pesoKg: 70, alturaCm: 175, edad: 30, genero: 'M');

  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (_) => SummaryScreen(userInfo: userInfo),
  //     ),
  //   );
  // }
  /// Navegar a SummaryScreen con los datos actuales
void _goToSummary() {
  // Aquí puedes crear un UserInfo mock o adaptarlo si tienes datos reales
  final userInfo = UserInfo(pesoKg: 70, alturaCm: 175, edad: 30, genero: 'M');

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => SummaryScreen(
        userInfo: userInfo,
        pasos: _stepCount,      // PASO ACTUAL
        calorias: _calories,    // CALORÍAS ACTUALES
      ),
    ),
  );
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

              // Mostrador de pasos
              Text('Pasos', style: GoogleFonts.poppins(fontSize: 24, color: Colors.grey[600])),
              Text(
                '$_stepCount',
                style: GoogleFonts.poppins(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 40),

              // Mostrador de calorías
              Text('Calorías', style: GoogleFonts.poppins(fontSize: 24, color: Colors.grey[600])),
              Text(
                _calories.toStringAsFixed(2),
                style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFFFA7A7A)),
              ),
              const SizedBox(height: 6),
              Text(
                '$_kcalPerStep kcal por paso (modo demo)',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 60),

              // Botones de control
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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

              const SizedBox(height: 20),

              // BOTÓN NUEVO: Ver Resumen
              ElevatedButton(
                onPressed: _goToSummary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA7A7A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Ver Resumen', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
