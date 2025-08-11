import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'main_counter_screen.dart'; // Importe a tela principal que você criou

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // O AppBar cria a seta de "voltar" automaticamente
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove a sombra
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView( // Permite rolar a tela se o teclado aparecer
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Título "Acceso"
              Text(
                'Acceso',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 40),

              // Campo de Email
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Campo de Senha
              TextField(
                obscureText: true, // Esconde o texto da senha
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Botão de Login Principal
              ElevatedButton(
                onPressed: () {
                  // Ação de Login: aqui você colocaria a lógica de autenticação.
                  // Após o sucesso, navega para a tela principal.
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MainCounterScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA7A7A), // Cor rosa/vermelho do design
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Divisor "OR"
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'OR',
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),

              const SizedBox(height: 30),

              // Botões de Login Social
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(
                    icon: FontAwesomeIcons.google,
                    onPressed: () { /* Lógica de login com Google */ },
                  ),
                  const SizedBox(width: 20),
                  _buildSocialButton(
                    icon: FontAwesomeIcons.facebook,
                    onPressed: () { /* Lógica de login com Facebook */ },
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // Link para Criar Conta
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No tienes cuenta? ',
                    style: GoogleFonts.poppins(),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navegar para a tela de criação de conta
                      // Ex: Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateAccountScreen()));
                    },
                    child: Text(
                      'Crear Cuenta',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFFA7A7A),
                        fontWeight: FontWeight.bold,
                      ),
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

  // Widget auxiliar para criar os botões de redes sociais
  Widget _buildSocialButton({required IconData icon, required VoidCallback onPressed}) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: FaIcon(
        icon,
        color: Colors.grey[800],
        size: 24,
      ),
    );
  }
}