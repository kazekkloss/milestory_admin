class ApiConstants {
  //static const String baseUrl = 'http://192.168.1.11:3000/api';
  static const String baseUrl = 'https://milestory.pl/api';

  static const String refreshToken = '$baseUrl/refresh-token';
  static const String platform = 'web';

  // AUTH
  static const String signIn = '$baseUrl/sign-in';
  static const String checkAuth = '$baseUrl/check-auth';
  static const String logout = '$baseUrl/logout';
  static const String sendPasswordRecoveryLink =
      '$baseUrl/send-link-password-recovery';

  // AUDIO
  static const String getAudioUrl = '$baseUrl/get-audio-url';

  // TOUR
  static const String getToursByAuthorId = '$baseUrl/get-tours-by-authorId';

  // TOUR POINT
  static const String getTourPoints = '$baseUrl/get-tour-points';

  // USER
  static const String updateUser = '$baseUrl/update-user';
  static const String deleteUser = '$baseUrl/delete-user';

  // GUIDE USER
  static const String getGuideUser = '$baseUrl/get-guide-user';
  static const String updateGuideUser = '$baseUrl/update-guide-user';
}
