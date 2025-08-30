import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user_info.dart';
import 'history_screen.dart';

class SummaryScreen extends StatefulWidget {
  final UserInfo userInfo;
  final int pasos; // Recibimos los pasos actuales
  final double calorias; // Recibimos las calorías actuales

  const SummaryScreen({
    super.key,
    required this.userInfo,
    required this.pasos,
    required this.calorias,
  });

  final double _kcalPerStep = 0.04;
  final int ritmo = 74; // mock del ritmo cardíaco

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final double _kcalPerStep = 0.04;
  final int ritmo = 74;

  int pasosTotales = 0;
  double caloriasTotales = 0.0;

  @override
  void initState() {
    super.initState();
    _calcularResumenDelDia();
  }

  Future<void> _calcularResumenDelDia() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList('historial') ?? [];

    final hoy = DateTime.now();

    int sumaPasos = 0;
    double sumaCalorias = 0.0;

    for (var e in rawList) {
      final cleaned = e.replaceAll(RegExp(r'[{}]'), '');
      final parts = cleaned.split(', ');
      final map = <String, dynamic>{};
      for (var part in parts) {
        final kv = part.split(': ');
        if (kv.length == 2) {
          map[kv[0]] = kv[1];
        }
      }

      final fecha = DateTime.tryParse(map['fecha'] ?? '');
      if (fecha != null &&
          fecha.day == hoy.day &&
          fecha.month == hoy.month &&
          fecha.year == hoy.year) {
        sumaPasos += int.tryParse(map['pasos'] ?? '0') ?? 0;
        sumaCalorias += double.tryParse(map['calorias'] ?? '0.0') ?? 0.0;
      }
    }

    setState(() {
      pasosTotales = sumaPasos;
      caloriasTotales = sumaCalorias;
    });
  }

  String _mesAnoActual() {
    const meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    final now = DateTime.now();
    return '${meses[now.month - 1]}, ${now.year}';
  }

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Información de hoy',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _mesAnoActual(),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              // Cards superiores (Calorías / Pasos)
              // Row(
              //   children: [
              //     Expanded(
              //       child: _InfoCard(
              //         icon: Icons.local_fire_department,
              //         title: 'Calorías (último)',
              //         value: widget.calorias.toStringAsFixed(2),
              //         unit: 'Kcal',
              //       ),
              //     ),
              //     const SizedBox(width: 14),
              //     Expanded(
              //       child: _InfoCard(
              //         icon: Icons.directions_walk,
              //         title: 'Pasos (último)',
              //         value: '${widget.pasos}',
              //         unit: 'pasos',
              //       ),
              //     ),
              //   ],
              // ),
              Text('Último conteo',style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.local_fire_department,
                      title: 'Calorías',
                      value: widget.calorias.toStringAsFixed(2),
                      unit: 'Kcal',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.directions_walk,
                      title: 'Pasos',
                      value: '${widget.pasos}',
                      unit: 'pasos',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Divider(thickness: 1, color: Colors.grey),
              const SizedBox(height: 14),
              Text('Resumen del día', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.directions_walk,
                      title: 'Pasos\nacumulados',
                      value: '$pasosTotales',
                      unit: 'pasos',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.local_fire_department,
                      title: 'Calorías\nacumuladas',
                      value: caloriasTotales.toStringAsFixed(2),
                      unit: 'Kcal',
                    ),
                  ),
                ],
              ),

              // Card de Ritmo Cardíaco (ancho completo)
              // const SizedBox(height: 14),
              // _BigInfoCard(
              //   icon: Icons.favorite_border,
              //   title: 'Ritmo Cardíaco',
              //   value: '$ritmo',
              //   unit: 'bpm',
              // ),

              const SizedBox(height: 18),
              const _GraphPlaceholder(),

              const Spacer(),

              // Botón Historial
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const HistoryScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA7A7A),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Historial',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // String _mesAnoActual() {
  //   const meses = [
  //     'Enero','Febrero','Marzo','Abril','Mayo','Junio',
  //     'Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'
  //   ];
  //   final now = DateTime.now();
  //   return '${meses[now.month - 1]}, ${now.year}';
  // }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String unit;
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F3F8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                Icon(icon, color: const Color(0xFFFA7A7A)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  unit,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BigInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String unit;
  const _BigInfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F3F8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                Icon(icon, color: const Color(0xFFFA7A7A)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  unit,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GraphPlaceholder extends StatelessWidget {
  const _GraphPlaceholder();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: List.generate(
          16,
          (i) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: (20 + (i * 5) % 60).toDouble(),
                  decoration: BoxDecoration(
                    color: i % 4 == 0
                        ? Colors.black
                        : const Color(0xFFFA7A7A).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
