import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_info_screen.dart'; // Importa a próxima tela

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _termsAccepted = false; // Variável para controlar o estado do checkbox

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Crear\nnueva cuenta', // '\n' para quebrar a linha
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Vanessa da Silva',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'vanessa@gmail.com',
                   labelStyle: TextStyle(color: Color(0xFFFA7A7A)), // Cor rosa para o texto
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              
              // Checkbox para Termos de Serviço
              Row(
                children: [
                  Checkbox(
                    value: _termsAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                    },
                    activeColor: Color(0xFFFA7A7A),
                  ),
                  // Usamos Expanded para o texto não estourar a tela
                  const Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Acepto los ',
                        style: TextStyle(color: Colors.grey),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Terminos de Servicio',
                            style: TextStyle(color: Color(0xFFFA7A7A), decoration: TextDecoration.underline),
                            // recognizer: TapGestureRecognizer()..onTap = () { /* Abrir link */ },
                          ),
                          TextSpan(text: ' y '),
                          TextSpan(
                            text: 'Política de Privacidad',
                            style: TextStyle(color: Color(0xFFFA7A7A), decoration: TextDecoration.underline),
                             // recognizer: TapGestureRecognizer()..onTap = () { /* Abrir link */ },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Botão Criar Conta
              ElevatedButton(
                onPressed: () {
                   // Navega para a tela de adicionar informações
                   Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddInfoScreen()),
                   );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA7A7A),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('Crear Cuenta', style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 20),

              // Link para Login
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ya tienes cuenta? ', style: GoogleFonts.poppins()),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(), // Volta para a tela de login
                    child: Text(
                      'Login',
                      style: GoogleFonts.poppins(color: const Color(0xFFFA7A7A), fontWeight: FontWeight.bold),
                    ),
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