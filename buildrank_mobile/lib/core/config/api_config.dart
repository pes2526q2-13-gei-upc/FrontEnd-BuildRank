class ApiConfig {
  // Emulador Android Studio
  static const String emulatorBaseUrl = 'http://10.0.2.2:8000';

  // Móvil físico en la misma Wi-Fi que PC
  // IP la real de ordenador
  static const String physicalDeviceBaseUrl = 'http://192.168.1.34:8000';

  // Usamos el emulador
  static const String baseUrl = emulatorBaseUrl;

  static const String register = '$baseUrl/api/accounts/register/';
  static const String login = '$baseUrl/api/accounts/login/';
  static const String logout = '$baseUrl/api/accounts/logout/';
  static const String me = '$baseUrl/api/accounts/me/';
  static const String refresh = '$baseUrl/api/accounts/refresh/';
}