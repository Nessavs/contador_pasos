import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos mock para la lista de días
    final data = const [
      {'dia': 'Lunes', 'pasos': 5000},
      {'dia': 'Martes', 'pasos': 4100},
      {'dia': 'Miércoles', 'pasos': 5000},
      {'dia': 'Jueves', 'pasos': 4200},
      {'dia': 'Viernes', 'pasos': 4000},
      {'dia': 'Sábado', 'pasos': 3300},
      {'dia': 'Domingo', 'pasos': 1200},
    ];

    const meta = 4800; // ejemplo

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Historial', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pasos por día', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: data.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = data[index];
                  final pasos = item['pasos'] as int;
                  final progreso = (pasos / meta).clamp(0.0, 1.0);
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F3F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item['dia'] as String, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                    Text('$pasos', style: GoogleFonts.poppins(color: Colors.grey[700])),
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