class ApiConstants {
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  static const String charactersEndpoint = '/character';
  static const String episodesEndpoint = '/episode';
  static const String locationsEndpoint = '/location';

  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectivityCheckTimeout = Duration(seconds: 5);

  static const int defaultPageSize = 20;

  static const String pageParam = 'page';
  static const String nameParam = 'name';
}
