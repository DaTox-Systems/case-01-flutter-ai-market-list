abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Ошибка соединения с сервером']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Ошибка локального хранилища']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
