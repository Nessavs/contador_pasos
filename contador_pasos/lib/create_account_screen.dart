import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_info_screen.dart';
import 'mock_auth_service.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  // Controladores para pegar os valores dos campos
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Instância do nosso serviço de autenticação mockado
  final _authService = MockAuthService();
  
  // Variáveis para gerenciar o estado da UI
  bool _termsAccepted = false;
  bool _isLoading = false;

  // Função para lidar com o processo de cadastro
  Future<void> _handleCadastro() async {
    // Validação simples para garantir que os campos não estão vazios
    if (_nomeController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog('Por favor, preencha todos os campos.');
      return;
    }

    if (!_termsAccepted) {
      _showErrorDialog('Você precisa aceitar os Termos de Serviço.');
      return;
    }

    setState(() => _isLoading = true);

    final success = await _authService.cadastrar(
      _nomeController.text,
      _emailController.text,
      _passwordController.text,
    );

    // O setState é chamado dentro de um 'if (mounted)' para garantir que o widget ainda está na tela
    // Isso evita erros caso o usuário saia da tela durante o loading.
    if (mounted) {
      setState(() => _isLoading = false);
    
      if (success) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddInfoScreen()),
        );
      } else {
        _showErrorDialog('Este email já está em uso. Tente outro.');
      }
    }
  }

  // Função para exibir um pop-up de erro
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Erro no Cadastro'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Crear\nnueva cuenta',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome completo',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _termsAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                    },
                    activeColor: const Color(0xFFFA7A7A),
                  ),
                  const Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Acepto los ',
                        style: TextStyle(color: Colors.grey),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Terminos de Servicio',
                            style: TextStyle(color: Color(0xFFFA7A7A), decoration: TextDecoration.underline),
                          ),
                          TextSpan(text: ' y '),
                          TextSpan(
                            text: 'Política de Privacidad',
                            style: TextStyle(color: Color(0xFFFA7A7A), decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleCadastro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA7A7A),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Crear Cuenta',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ya tienes cuenta? ', style: GoogleFonts.poppins()),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      'Login',
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
}