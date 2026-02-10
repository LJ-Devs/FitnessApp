abstract class Failure {
  final String message;
  Failure(this.message);
}

// Generic server error (500, 404)
class ServerFailure extends Failure {
  ServerFailure([super.message = 'Ocorreu um erro no servidor']);
}

// Connection error
class NetworkFailure extends Failure {
  NetworkFailure([super.message = 'Verifique a conexão à internet']);
}

// Auth error
class AuthFailure extends Failure {
  AuthFailure([super.message = 'Credenciais inválidas']);
}