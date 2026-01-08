class AppConstants {
  static const appName = 'Workout App';
  static const appVersion = '1.0.0';
  
  // API endpoints (mock)
  static const baseUrl = 'https://api.workoutapp.mock';
  static const loginEndpoint = '/auth/login';
  static const registerEndpoint = '/auth/register';
  static const postsEndpoint = '/posts';
  static const commentsEndpoint = '/comments';
  
  // Storage keys
  static const authTokenKey = 'auth_token';
  static const userDataKey = 'user_data';
  static const themeKey = 'app_theme';
  
  // Pagination
  static const postsPerPage = 10;
  static const commentsPerPage = 20;
}
