// lib/screens.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants.dart';
import 'firebase_service.dart';
import 'chatbot_screen.dart'; // <-- chatbot_screen.dart를 임포트

// ======= 1. 공통 위젯 정의 =======
class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.textSecondary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '문화·교육 프로그램 검색',
                style: AppTextStyles.body2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryIcon({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(initialQuery: label),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: AppColors.primary, size: 30),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class BenefitCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionText;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;

  const BenefitCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: backgroundColor.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading4.copyWith(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.body2,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              actionText,
              style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class PopularProgramCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String rating;
  final String reviews;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const PopularProgramCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading4,
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: AppTextStyles.body2,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.warning, size: 16),
                    const SizedBox(width: 4),
                    Text(rating, style: AppTextStyles.body2),
                    const SizedBox(width: 8),
                    Text('($reviews)', style: AppTextStyles.body2),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.bookmark_border, color: AppColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }
}
// ======= 2. 앱 화면 정의 =======

// 스플래시 화면
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.lightbulb_outline,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppConstants.appName,
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppConstants.appDescription,
              style: AppTextStyles.body2,
            ),
          ],
        ),
      ),
    );
  }
}


// 인증 화면
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoginMode = true;
  bool _isLoading = false;

  Future<void> _submitAuthForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      String? errorMessage;

      if (_isLoginMode) {
        errorMessage = await FirebaseService.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        errorMessage = await FirebaseService.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: '사용자', // 회원가입 시 기본 이름 설정
        );
      }

      setState(() => _isLoading = false);

      if (errorMessage != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.psychology_alt, size: 80, color: AppColors.primary),
                const SizedBox(height: 24),
                Text(
                  AppConstants.appName,
                  style: AppTextStyles.heading1,
                ),
                const SizedBox(height: 8),
                Text(
                  _isLoginMode ? '다시 만나서 반가워요!' : '좋은 생각을 함께 나눠요',
                  style: AppTextStyles.body2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // 이메일 및 비밀번호 입력 필드
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: '이메일'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || value.isEmpty ? '이메일을 입력하세요.' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: '비밀번호'),
                  obscureText: true,
                  validator: (value) => value == null || value.length < 6 ? '비밀번호는 6자 이상이어야 합니다.' : null,
                ),
                const SizedBox(height: 32),

                // 로그인/회원가입 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitAuthForm,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(_isLoginMode ? '로그인' : '회원가입'),
                  ),
                ),
                const SizedBox(height: 24),

                TextButton(
                  onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
                  child: Text(
                    _isLoginMode ? '계정이 없으신가요? 회원가입' : '이미 계정이 있으신가요? 로그인',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// 메인 화면 (하단 탭 포함)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const SearchTab(), // SearchTab은 여전히 존재하지만, 네비게이션으로 대체됩니다.
    const ReservationTab(),
    const BenefitsTab(),
    const MyTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) { // '검색' 탭(인덱스 1)을 눌렀을 때
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: '예약',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label: '혜택',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '마이',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotScreen()),
          );
        },
        child: const Icon(Icons.psychology_alt),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// 각 탭 화면 (간소화)
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SearchBar(),
              ),
              const SizedBox(height: 20),
              _buildCategorySection(),
              const SizedBox(height: 20),
              _buildBenefitsSection(),
              const SizedBox(height: 20),
              _buildPopularProgramsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.lightbulb_outline, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Text(
            AppConstants.appName,
            style: AppTextStyles.heading3,
          ),
          const Spacer(),
          const Icon(Icons.notifications_none, color: AppColors.textPrimary),
          const SizedBox(width: 10),
          const Icon(Icons.person_outline, color: AppColors.textPrimary),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '카테고리',
            style: AppTextStyles.heading4,
          ),
        ),
        const SizedBox(height: 10),
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              CategoryIcon(icon: Icons.movie_outlined, label: '공연'),
              CategoryIcon(icon: Icons.palette_outlined, label: '전시'),
              CategoryIcon(icon: Icons.school_outlined, label: '교육'),
              CategoryIcon(icon: Icons.local_activity_outlined, label: '체험'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitsSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 혜택',
            style: AppTextStyles.heading4,
          ),
          SizedBox(height: 10),
          BenefitCard(
            title: '문화누리카드',
            subtitle: '잔액 85,000원',
            actionText: '자동적용',
            backgroundColor: Color(0xFFE8F5E9),
            icon: Icons.credit_card,
            iconColor: Colors.green,
          ),
          SizedBox(height: 10),
          BenefitCard(
            title: '청년 할인',
            subtitle: '최대 30% 할인',
            actionText: '자동적용',
            backgroundColor: Color(0xFFE3F2FD),
            icon: Icons.emoji_people,
            iconColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildPopularProgramsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '인기 프로그램',
            style: AppTextStyles.heading4,
          ),
          const SizedBox(height: 10),
          PopularProgramCard(
            title: '대전 사이언스 페스티벌',
            subtitle: '과학 체험 · 가족 참여',
            price: '무료',
            rating: '4.8',
            reviews: '1.2K',
            icon: Icons.science_outlined,
            iconColor: Colors.deepPurple,
            backgroundColor: Colors.deepPurple.withOpacity(0.1),
          ),
          const SizedBox(height: 10),
          PopularProgramCard(
            title: '시민 오케스트라 정기연주회',
            subtitle: '클래식 음악 · 문예회관',
            price: '15,000원',
            rating: '4.6',
            reviews: '856',
            icon: Icons.music_note_outlined,
            iconColor: Colors.blue,
            backgroundColor: Colors.blue.withOpacity(0.1),
          ),
        ],
      ),
    );
  }
}

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('검색 화면'));
  }
}

class ReservationTab extends StatelessWidget {
  const ReservationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('예약 화면'));
  }
}

class BenefitsTab extends StatelessWidget {
  const BenefitsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('혜택 화면'));
  }
}

class MyTab extends StatelessWidget {
  const MyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 정보 섹션
            StreamBuilder(
              stream: FirebaseAuth.instance.userChanges(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('로그인 정보가 없습니다.');
                }
                final user = snapshot.data!;
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textSecondary.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: user.photoURL != null
                            ? NetworkImage(user.photoURL!)
                            : null,
                        child: user.photoURL == null
                            ? const Icon(Icons.person, size: 30)
                            : null,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.displayName ?? '사용자',
                            style: AppTextStyles.heading4.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email ?? '이메일 없음',
                            style: AppTextStyles.body2,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
            const Text('내 활동', style: AppTextStyles.heading4),
            const SizedBox(height: 10),

            // 메뉴 목록
            MyPageMenu(
              icon: Icons.info_outline,
              label: '내 정보',
              onTap: () {
                // '내 정보' 화면으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyInfoScreen()),
                );
              },
            ),
            MyPageMenu(
              icon: Icons.analytics_outlined,
              label: '취향 분석',
              onTap: () {
                // '취향 분석' 화면으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PreferenceAnalysisScreen()),
                );
              },
            ),
            MyPageMenu(
              icon: Icons.category_outlined,
              label: '관심 카테고리',
              onTap: () {
                // '관심 카테고리' 화면으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InterestCategoryScreen()),
                );
              },
            ),
            MyPageMenu(
              icon: Icons.calendar_month_outlined,
              label: '캘린더',
              onTap: () {
                // '캘린더' 화면으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalendarScreen()),
                );
              },
            ),

            const SizedBox(height: 30),
            MyPageMenu(
              icon: Icons.logout,
              label: '로그아웃',
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 마이페이지 메뉴 위젯
class MyPageMenu extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const MyPageMenu({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: AppTextStyles.body2),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// 하위 페이지 (간소화된 버전, 필요에 따라 구현)
class MyInfoScreen extends StatelessWidget {
  const MyInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              final user = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : null,
                    child: user.photoURL == null
                        ? const Icon(Icons.person, size: 60, color: AppColors.primary)
                        : null,
                    backgroundColor: AppColors.surface,
                  ),
                  const SizedBox(height: 30),
                  _buildInfoRow('이름', user.displayName ?? '이름 없음'),
                  const SizedBox(height: 15),
                  _buildInfoRow('이메일', user.email ?? '이메일 없음'),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showDeleteAccountDialog(context, user),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('회원 탈퇴'),
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: Text('로그인 정보가 없습니다.'),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, User user) {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('회원 탈퇴'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('정말 탈퇴하시겠습니까? 계정을 삭제하려면 비밀번호를 입력하세요.'),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // 다이얼로그 닫기

              try {
                final credential = EmailAuthProvider.credential(
                  email: user.email!,
                  password: passwordController.text,
                );
                await user.reauthenticateWithCredential(credential);

                await FirebaseService.deleteUserData(user.uid);
                await user.delete();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('회원 탈퇴가 완료되었습니다.')),
                  );
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              } on FirebaseAuthException catch (e) {
                // 오류가 발생하면, 오류 코드를 출력합니다.
                print('회원 탈퇴 실패: ${e.code}, ${e.message}');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('회원 탈퇴 실패: ${e.message}')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('탈퇴하기'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          Text(
            value,
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class PreferenceAnalysisScreen extends StatelessWidget {
  const PreferenceAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('취향 분석')),
      body: const Center(child: Text('취향 분석 페이지')),
    );
  }
}

class InterestCategoryScreen extends StatelessWidget {
  const InterestCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('관심 카테고리')),
      body: const Center(child: Text('관심 카테고리 설정 페이지')),
    );
  }
}

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('캘린더')),
      body: const Center(child: Text('캘린더 및 예약 확인 페이지')),
    );
  }
}
class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = '전체';
  final List<String> _categories = ['전체', '공연', '전시', '교육', '체험'];

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      _selectedCategory = widget.initialQuery!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색'),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '찾으시는 프로그램이나 행사를 입력하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.surface,
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              ),
              onSubmitted: (query) {
                // TODO: 검색 로직 구현
                print('검색어: $query, 카테고리: $_selectedCategory');
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedCategory = category;
                          _searchController.text = category;
                        } else {
                          _selectedCategory = '전체';
                          _searchController.text = '';
                        }
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: _selectedCategory == category ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          // TODO: 여기에 검색 결과를 표시하는 위젯을 추가하세요.
          const Expanded(
            child: Center(
              child: Text('검색어를 입력하여 프로그램을 찾아보세요.'),
            ),
          ),
        ],
      ),
    );
  }
}
class PhoneAuthScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;

  const PhoneAuthScreen({
    super.key,
    required this.name,      // <-- 매개변수 추가
    required this.email,     // <-- 매개변수 추가
    required this.password,  // <-- 매개변수 추가
  });

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _verificationId;
  bool _isCodeSent = false;
  bool _isLoading = false;

  Future<void> _verifyPhoneNumber() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('전화번호 인증 성공!')),
          );
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('인증 실패: ${e.message}')),
          );
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        setState(() {
          _isCodeSent = true;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('인증 코드가 전송되었습니다.')),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _signInWithPhoneNumber() async {
    if (_verificationId == null) return;
    if (_codeController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _codeController.text,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('인증 성공!')),
        );
        // TODO: 인증 성공 후 다음 단계로 이동하는 로직 추가
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증 실패: ${e.message}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('전화번호 인증')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isCodeSent)
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: '전화번호',
                    hintText: '+82 10-1234-5678',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty
                      ? '전화번호를 입력하세요.'
                      : null,
                ),
              if (_isCodeSent)
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(labelText: '인증 코드'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? '인증 코드를 입력하세요.'
                      : null,
                ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _isCodeSent ? _signInWithPhoneNumber : _verifyPhoneNumber,
                child: Text(_isCodeSent ? '인증 확인' : '인증 코드 전송'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }
}
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // PhoneAuthScreen으로 이동하면서 이름, 이메일, 비밀번호를 전달합니다.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhoneAuthScreen(
            name: _nameController.text,        // <-- name 매개변수 전달
            email: _emailController.text,      // <-- email 매개변수 전달
            password: _passwordController.text, // <-- password 매개변수 전달
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '이름'),
                validator: (value) => value == null || value.isEmpty ? '이름을 입력하세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: '이메일'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty ? '이메일을 입력하세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                validator: (value) => value == null || value.length < 6 ? '비밀번호는 6자 이상이어야 합니다.' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: const Text('다음'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

