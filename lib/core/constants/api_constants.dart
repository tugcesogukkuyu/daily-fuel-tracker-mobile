class ApiConstants {
  static const String baseUrl = 'http://localhost:3000/api';

  static const String health = '$baseUrl/health';
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';

  static const String foods = '$baseUrl/foods';
  static const String blogs = '$baseUrl/blogs';

  static const String meals = '$baseUrl/meals';
  static const String exercises = '$baseUrl/exercises';
  static const String exerciseCatalogSearch =
      '$baseUrl/exercises/catalog/search';
  static const String water = '$baseUrl/water';
}
