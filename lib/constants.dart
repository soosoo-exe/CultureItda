import 'package:flutter/material.dart';

// 앱 전체에서 사용되는 상수 정의
class AppConstants {
  static const String appName = '문화잇다';
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

// 색상 팔레트: 심리적 안정감을 주는 파란빛 계열
class AppColors {
  // 기본 색상
  static const primary = Color(0xFF42A5F5); // 부드러운 파란색 (Material Blue 400)
  static const primaryLight = Color(0xFF90CAF9); // 연한 파란색
  static const primaryDark = Color(0xFF1976D2); // 더 짙은 파란색 // 이 부분이 추가되었습니다.
  static const secondary = Color(0xFF81D4FA); // 밝은 하늘색

  // 배경 및 표면
  static const background = Color(0xFFF0F4F8); // 연한 회색/파란색 배경
  static const surface = Color(0xFFFFFFFF); // 흰색 표면
  static const border = Color(0xFFE0E0E0); // 연한 회색 테두리

  // 텍스트 색상
  static const textPrimary = Color(0xFF263238); // 차분한 다크 그레이
  static const textSecondary = Color(0xFF78909C); // 연한 그레이 (부드러운 대비)

  // 상태 색상
  static const error = Color(0xFFE57373); // 부드러운 빨간색
  static const warning = Color(0xFFFFB74D); // 부드러운 주황색
  static const success = Color(0xFF66BB6A); // 부드러운 초록색
  static const info = Color(0xFF4FC3F7); // 밝은 파란색

  // 그라데이션 (심리적 안정감을 주는 색상)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFBBDEFB), Color(0xFF42A5F5)], // 연한 파랑에서 메인 파랑으로
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 차분한 그라데이션
  static const LinearGradient calmGradient = LinearGradient(
    colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)], // 매우 연한 파랑 톤
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

// 텍스트 스타일
class AppTextStyles {
  // 헤딩
  static const heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  static const heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const heading4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // 본문
  static const body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  static const body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // 캡션
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
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
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        background: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        titleTextStyle: AppTextStyles.heading3,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: AppColors.surface,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppColors.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 3,
        shadowColor: AppColors.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
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