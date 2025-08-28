import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _historial = [];
  final int meta = 4800;

  @override
  void initState() {
    super.initState();
    _loadHistorial();
  }

  Future<void> _loadHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList('historial') ?? [];

    final parsed = rawList.map((e) {
      final cleaned = e.replaceAll(RegExp(r'[{}]'), '');
      final parts = cleaned.split(', ');
      final map = <String, dynamic>{};
      for (var part in parts) {
        final kv = part.split(': ');
        if (kv.length == 2) {
          map[kv[0]] = kv[1];
        }
      }
      return map;
    }).toList();

    // 👇 Aquí ordenamos por fecha descendente
    parsed.sort((a, b) => b['fecha'].compareTo(a['fecha']));

    setState(() {
      _historial = parsed;
    });
  }

  Future<void> _clearHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('historial');
    setState(() => _historial.clear());
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
        title: Text(
          'Historial',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black),
            onPressed: _clearHistorial,
            tooltip: 'Limpiar historial',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _historial.isEmpty
            ? Center(
                child: Text(
                  'No hay registros aún.',
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registros guardados',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _historial.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = _historial[index];
                        final fecha = item['fecha'] ?? 'Sin fecha';
                        final pasos = int.tryParse(item['pasos'] ?? '0') ?? 0;
                        final calorias =
                            double.tryParse(item['calorias'] ?? '0.0') ?? 0.0;
                        final progreso = (pasos / meta).clamp(0.0, 1.0);

                        // 👇 Formatear la fecha
                        final fechaFormateada = DateTime.tryParse(
                          fecha,
                        )?.toLocal();
                        final fechaTexto = (fechaFormateada != null)
                            ? '${fechaFormateada.day}/${fechaFormateada.month}/${fechaFormateada.year} ${fechaFormateada.hour}:${fechaFormateada.minute.toString().padLeft(2, '0')}'
                            : fecha;

                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F3F8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fecha: $fechaTexto',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Pasos: $pasos',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${calorias.toStringAsFixed(2)} kcal',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: progreso,
                                    minHeight: 10,
                                    backgroundColor: Colors.white,
                                    color: const Color(0xFFFA7A7A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
