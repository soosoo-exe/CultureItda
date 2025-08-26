// lib/constants.dart
import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = '문화패스';
  static const String appDescription = 'AI 기반 맞춤형 문화 콘텐츠 추천 서비스';

  // 회원가입 시 사용할 카테고리 목록
  static const List<String> categories = [
    '공연',
    '전시',
    '교육',
    '체험',
    '역사',
    '과학',
    '예술',
    '음악'
  ];
}

class AppColors {
  static const Color primary = Color(0xFF5B67CA);
  static const Color primaryLight = Color(0xFF8B5DFF);
  static const Color background = Color(0xFFF0F4F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF0EA5E9);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);

  static const Color secondary = Color(0xFF9CA3AF);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // heading2 스타일 추가
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle heading4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: AppTextStyles.heading3,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: AppColors.surface,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
    );
  }
}

class ChatbotConstants {
  static const String systemPrompt =
      'You are a friendly and helpful AI assistant specializing in recommending cultural experiences and activities in the city of Daejeon, South Korea. Your goal is to provide personalized, empathetic, and engaging recommendations based on the user\'s mood and preferences.';
}

class APIConstants {
  static const String openAIModel = 'gpt-3.5-turbo';
  static const int maxTokens = 250;
  static const double temperature = 0.7;
}