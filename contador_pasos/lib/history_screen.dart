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

  DateTime? _fechaSeleccionada;

  Future<void> _seleccionarFecha() async {
    final hoy = DateTime.now();
    final nuevaFecha = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada ?? hoy,
      firstDate: DateTime(hoy.year - 1),
      lastDate: hoy,
      locale: const Locale('es', 'ES'),
    );

    if (nuevaFecha != null) {
      setState(() {
        _fechaSeleccionada = nuevaFecha;
      });
    }
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  Future<Map<String, List<Map<String, dynamic>>>>_getHistorialAgrupado() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList('historial') ?? [];

    final Map<String, List<Map<String, dynamic>>> agrupado = {};

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
      if (fecha != null) {
        // final clave = '${fecha.day}/${fecha.month}/${fecha.year}';
        final clave = _formatearFecha(fecha);
        if (_fechaSeleccionada == null || clave == _formatearFecha(_fechaSeleccionada!)) {
        agrupado.putIfAbsent(clave, () => []);
        agrupado[clave]!.add(map);
      }
      }
    }

    return agrupado;
  }





  @override
  Widget build(BuildContext context) {
    final hoy = DateTime.now();
    final hoyFormateado = '${hoy.day}/${hoy.month}/${hoy.year}';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: _seleccionarFecha,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _fechaSeleccionada == null
                    ? 'Seleccionar fecha'
                    : 'Fecha: ${_formatearFecha(_fechaSeleccionada!)}',
                style: GoogleFonts.poppins(),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFA7A7A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
                future: _getHistorialAgrupado(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final grupos = snapshot.data!;
                  if (grupos.isEmpty) {
                    return Center(
                      child: Text(
                        'No hay registros aún.',
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    );
                  }

                  final fechasOrdenadas = grupos.keys.toList()
                    ..sort((a, b) => b.compareTo(a));

                  return ListView.builder(
                    itemCount: fechasOrdenadas.length,
                    itemBuilder: (context, index) {
                      final fecha = fechasOrdenadas[index];
                      final registros = grupos[fecha]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fecha,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ...registros.map((item) {
                            final pasos =
                                int.tryParse(item['pasos'] ?? '0') ?? 0;
                            final calorias =
                                double.tryParse(item['calorias'] ?? '0.0') ??
                                0.0;
                            final hora = DateTime.tryParse(
                              item['fecha'] ?? '',
                            )?.toLocal();
                            final horaTexto = hora != null
                                ? '${hora.hour}:${hora.minute.toString().padLeft(2, '0')}'
                                : 'Sin hora';
                            final progreso = (pasos / meta).clamp(0.0, 1.0);

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F3F8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hora: $horaTexto',
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
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
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
