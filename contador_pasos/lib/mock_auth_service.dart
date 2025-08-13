// Nosso "banco de dados" em memória. Começa com um usuário padrão.
import 'package:flutter/foundation.dart'; // Adicione esta importação no topo do arquivo

final List<Map<String, String>> _usuariosMock = [
  {"email": "teste@email.com", "senha": "123"},
];

class MockAuthService {
  // Simula o login
  Future<bool> login(String email, String password) async {
    // Simula a demora da rede
    await Future.delayed(const Duration(seconds: 2));

    // Procura na nossa lista em memória se existe um usuário com esse email e senha
    final usuarioEncontrado = _usuariosMock.any(
      (user) => user['email'] == email && user['senha'] == password,
    );

    return usuarioEncontrado;
  }

  // Simula o cadastro de um novo usuário
  Future<bool> cadastrar(String nome, String email, String password) async {
    // Simula a demora da rede
    await Future.delayed(const Duration(seconds: 2));

    // Verifica se o email já existe
    if (_usuariosMock.any((user) => user['email'] == email)) {
      // Retorna 'false' se o email já estiver em uso
      return false;
    }

    // Se não existe, adiciona o novo usuário à nossa lista em memória
    _usuariosMock.add({"nome": nome, "email": email, "senha": password});

    debugPrint('Usuário cadastrado! Banco de dados mock agora: $_usuariosMock');

    // Retorna 'true' para indicar sucesso
    return true;
  }
}
