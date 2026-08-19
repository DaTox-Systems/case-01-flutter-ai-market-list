class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Ошибка соединения с сервером']);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Ошибка базы данных']);

  @override
  String toString() => message;
}
