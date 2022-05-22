abstract class AppContentFailure implements Exception {
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

abstract class ConnectivityFailure implements Exception {
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

class ConnectionError implements ConnectivityFailure {
  @override
  final String message;
  ConnectionError({required this.message});
}

abstract class WorkerFailure implements Exception {
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

class ScheduleWorkerError implements WorkerFailure {
  @override
  final String message;
  ScheduleWorkerError({required this.message});
}

class CancelWorkerError implements WorkerFailure {
  @override
  final String message;
  CancelWorkerError({required this.message});
}

abstract class ImageServiceFailure implements Exception {
  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

class CacheImageError implements ImageServiceFailure {
  @override
  final String message;
  CacheImageError({required this.message});
}

class ReadImageError implements ImageServiceFailure {
  @override
  final String message;
  ReadImageError({required this.message});
}
