import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart'; // Importe sua tela de login

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Temporizador para mudar de tela após 3 segundos
    Timer(Duration(seconds: 3), () {
      // Usa pushReplacement para que o usuário não possa voltar para a Splash Screen
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Você pode usar o ícone de pegadas do seu design
            Icon(Icons.directions_walk, color: Color(0xFFFA7A7A), size: 80),
            SizedBox(height: 20),
            Text(
              'Step Counter',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 40),
            // Indicador de carregamento
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFA7A7A)),
            ),
          ],
        ),
      ),
    );
  }
}
