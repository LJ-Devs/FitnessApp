// Thrown when there is a server-side error
class ServerException implements Exception {}

// Thrown when there is a local cache error
class CacheException implements Exception {}

// Thrown when the data is corrupted or the format is invalid
class DataParsingException implements Exception {}