class ApiConstants {
  static const String baseUrl = 'http://192.168.1.10:3000/api';
  //static const String baseUrl = 'https://milestory.pl/api';
  //static const String baseUrl = 'https://milestory-backend.onrender.com/api';

  static const String refreshToken = '$baseUrl/refresh-token';

  // AUTH
  static const String signUp = '$baseUrl/sign-up';
  static const String signIn = '$baseUrl/sign-in';
  static const String checkAuth = '$baseUrl/check-auth';
  static const String logout = '$baseUrl/logout';

  // USERS
  static const String getUsers = '$baseUrl/get-users';
  static const String updateUser = '$baseUrl/update-user';
  static const String deleteUser = '$baseUrl/delete-user';
  static const String logoutUser = '$baseUrl/logout-user';
  static const String getUserByNme = '$baseUrl/get-user-by-name';
  static const String getGuideApplications = '$baseUrl/get-guide-applications';

  // IMAGE / AUDIO
  static const String saveAudio = '$baseUrl/save-audio';
  static const String saveImage = '$baseUrl/save-image';
  static const String getAudio = '$baseUrl/get-audio';

  // TOUR
  static const String saveTour = '$baseUrl/save-tour';
  static const String getToursByAuthorId = '$baseUrl/get-tours-by-authorId';
  static const String deleteTour = '$baseUrl/delete-tour';

  // TOUR POINT
  static const String saveTourPoint = '$baseUrl/save-tour-point';
  static const String getTourPoints = '$baseUrl/get-tour-points';
  static const String deleteTourPoint = '$baseUrl/delete-tour-point';
}
