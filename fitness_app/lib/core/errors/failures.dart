abstract class Failure {
  final String message;
  Failure(this.message);
}

// Generic server error (500, 404)
class ServerFailure extends Failure {
  ServerFailure([String message = 'Ocorreu um erro no servidor']) : super(message);
}

// Conextion error
class NetworkFailure extends Failure {
  NetworkFailure([String message = 'Verifique a conexão à internet']) : super(message);
}

// Auth error
class AuthFailure extends Failure {
  AuthFailure([String message = 'Credenciais inválidas']) : super(message);
}