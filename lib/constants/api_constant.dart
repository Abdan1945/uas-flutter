class ApiConstant {
  static const String baseUrl = 'https://indonesia-public-static-api.vercel.app';
  static const String volcanoesEndpoint = '/api/volcanoes';

  static String get fullVolcanoesUrl => '$baseUrl$volcanoesEndpoint';
}