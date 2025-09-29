// lib/screens.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart'; // rootBundle을 위해 추가
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert'; // json을 위해 추가
import 'package:intl/intl.dart'; // DateFormat을 위해 추가
import 'constants.dart';
import 'firebase_service.dart';
import 'chatbot_screen.dart';
import 'business_search_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart'; // 한글 초기화를 위해 추가
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


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
                '검색',
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

class ChatBot extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionText;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;

  const ChatBot({
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

// 새로운 EventListCard 위젯
class EventListCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String organizer;
  final IconData icon;

  const EventListCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.organizer,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body1,
                ),
                const SizedBox(height: 4),
                Text(
                  '$organizer | $date, $time',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 문화누리카드 혜택 카드 위젯
class CultureCardBenefitWidget extends StatelessWidget {
  const CultureCardBenefitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary, // 부드러운 파란색
            AppColors.primaryDark, // 더 진한 파란색
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.credit_card,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '온누리카드 혜택 적용',
                style: AppTextStyles.heading4.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'NEW!',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '온누리 상품권을 활용해봐요!',
            style: AppTextStyles.body2.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // 혜택 자세히 보기 기능
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('혜택 서비스 준비중입니다')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary, // 버튼 텍스트와 아이콘 색상을 파란색으로 변경
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minimumSize: const Size(120, 32),
            ),
            child: const Text(
              '혜택 자세히 보기',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// ======= 2. 앱 화면 정의 =======

// 스플래시 화면
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF9BB5FF), // 추출한 배경색 적용
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 아이콘 + 텍스트 묶음
            Column(
              children: [
                const Icon(
                  Icons.auto_stories,
                  color: Colors.white,
                  size: 80,
                ),
                const SizedBox(height: 20),

                const Text(
                  '문화잇다',
                  style: TextStyle(
                    fontFamily: 'NotoSansKR', // 고딕체
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  '나에게 딱 맞는 문화생활',
                  style: TextStyle(
                    fontFamily: 'NotoSansKR',
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

// 인증 화면 (로그인/회원가입 모드 선택)
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoginMode = true;
  bool _isLoading = false;

  final List<String> _culturalCategories = [
    '여가',
    '문화체험', // '문화체험' 추가
    '스포츠',
    '음악',
    '미술',
    '공연',
    '교육',
    '역사',
    // '자원봉사' 삭제
  ];
  final List<String> _selectedCategories = [];

  Future<void> _submitAuthForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      String? errorMessage;

      if (_isLoginMode) {
        errorMessage = await FirebaseService.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (errorMessage == null && mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
                (route) => false,
          );
          return;
        }
      } else {
        try {
          final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          await userCredential.user?.updateDisplayName(_nameController.text.trim());

          if (userCredential.user != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential.user!.uid)
                .set({
              'email': _emailController.text.trim(),
              'name': _nameController.text.trim(),
              'address': _addressController.text.trim(),
              'createdAt': FieldValue.serverTimestamp(),
              'lastLoginAt': FieldValue.serverTimestamp(),
              'categories': _selectedCategories,
            });
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('회원가입이 완료되었습니다!')),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false,
            );
            return;
          }
        } on FirebaseAuthException catch (e) {
          switch (e.code) {
            case 'weak-password':
              errorMessage = '비밀번호가 너무 약합니다.';
              break;
            case 'email-already-in-use':
              errorMessage = '이미 사용 중인 이메일입니다.';
              break;
            case 'invalid-email':
              errorMessage = '올바르지 않은 이메일 형식입니다.';
              break;
            default:
              errorMessage = '회원가입 중 오류가 발생했습니다: ${e.message}';
          }
        } catch (e) {
          errorMessage = '회원가입 중 오류가 발생했습니다.';
        }
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
                const Icon(
                  Icons.auto_stories,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  AppConstants.appName,
                  style: AppTextStyles.heading1,
                ),
                const SizedBox(height: 8),
                Text(
                  _isLoginMode ? '다시 만나서 반가워요!' : '함게 즐겨요!',
                  style: AppTextStyles.body2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                if (!_isLoginMode)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: '이름'),
                        validator: (value) => value == null || value.isEmpty ? '이름을 입력하세요.' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: '주소'),
                        validator: (value) => value == null || value.isEmpty ? '주소를 입력하세요.' : null,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),

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

                // 관심 카테고리 섹션 (가로 배치, 체크박스로 변경)
                if (!_isLoginMode)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textSecondary.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '관심 카테고리를 선택하세요',
                          style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 12.0, // 가로 간격
                          runSpacing: 8.0, // 세로 간격
                          children: _culturalCategories.map((category) {
                            final isSelected = _selectedCategories.contains(category);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedCategories.remove(category);
                                  } else {
                                    _selectedCategories.add(category);
                                  }
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (bool? selected) {
                                      setState(() {
                                        if (selected == true) {
                                          _selectedCategories.add(category);
                                        } else {
                                          _selectedCategories.remove(category);
                                        }
                                      });
                                    },
                                    checkColor: Colors.white,
                                    activeColor: AppColors.primary,
                                  ),
                                  Text(
                                    category,
                                    style: AppTextStyles.body2.copyWith(
                                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

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
    _nameController.dispose();
    _addressController.dispose();
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
    const SearchTab(),
    const ReservationTab(),
    const ChatbotTab(),
    const MyTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
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
            icon: Icon(Icons.auto_stories),
            label: 'AI 챗봇',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '마이',
          ),
        ],
      ),
    );
  }
}

// 각 탭 화면 (간소화)

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String _userName = '사용자님';
  List<Map<String, dynamic>> _recommendedEvents = [];
  List<Map<String, dynamic>> _allEvents = [];
  List<Map<String, dynamic>> _nearbyEvents = [];
  List<Map<String, dynamic>> _educationEvents = []; // 교육프로그램 추가
  bool _isLoading = true;
  String _dateRange = '';
  Position? _currentPosition;
  bool _locationLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    _getCurrentLocation();
  }

  void _loadUserData() {
    // 로그인 기능이 주석처리되어 있으므로 기본값 사용
    setState(() {
      _userName = '사용자님';
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _locationLoading = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDialog();
        setState(() {
          _locationLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final bool shouldRequest = await _showPermissionDialog();
        if (!shouldRequest) {
          setState(() {
            _locationLoading = false;
          });
          return;
        }

        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showPermissionDeniedDialog();
        setState(() {
          _locationLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _locationLoading = false;
      });

      _loadNearbyEvents();
    } catch (e) {
      print('위치 정보 가져오기 실패: $e');
      setState(() {
        _locationLoading = false;
      });
    }
  }

  Future<bool> _showPermissionDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('위치 권한 요청'),
          content: const Text(
              '주변 문화체험을 추천하기 위해 위치 정보 접근 권한이 필요합니다. 권한을 허용하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('거부'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('허용'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('위치 서비스 비활성화'),
          content: const Text('위치 서비스가 비활성화되어 있습니다. 설정에서 위치 서비스를 활성화해주세요.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
              },
              child: const Text('설정으로 이동'),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('위치 권한 거부됨'),
          content: const Text('위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해주세요.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openAppSettings();
              },
              child: const Text('설정으로 이동'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadNearbyEvents() async {
    if (_currentPosition == null || _allEvents.isEmpty) return;

    try {
      List<Map<String, dynamic>> nearbyList = [];

      for (var business in _allEvents) {
        final latStr = business['latitude']?.toString() ?? '0';
        final lngStr = business['longitude']?.toString() ?? '0';

        final lat = double.tryParse(latStr);
        final lng = double.tryParse(lngStr);

        if (lat != null && lng != null && lat != 0.0 && lng != 0.0) {
          final distance = Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            lat,
            lng,
          );

          if (distance <= 5000) {
            final businessCopy = Map<String, dynamic>.from(business);
            businessCopy['distance'] = distance;
            businessCopy['distanceText'] = _formatDistance(distance);
            nearbyList.add(businessCopy);
          }
        }
      }

      nearbyList.sort((a, b) =>
          (a['distance'] ?? double.infinity)
              .compareTo(b['distance'] ?? double.infinity));

      setState(() {
        _nearbyEvents = nearbyList.take(10).toList();
      });
    } catch (e) {
      print('주변 이벤트 로드 실패: $e');
    }
  }

  String _formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()}m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)}km';
    }
  }

  Future<void> _loadRecommendedEvents() async {
    try {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1))
          .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
      final endOfWeek = startOfWeek.add(const Duration(days: 6))
          .copyWith(hour: 23, minute: 59, second: 59, millisecond: 999);

      final DateFormat formatter = DateFormat('yyyy년 M월 d일');
      _dateRange =
      '${formatter.format(startOfWeek)} - ${formatter.format(endOfWeek)}';

      try {
        final String jsonString = await rootBundle.loadString(
            'assets/data/merged_events.json');
        final Map<String, dynamic> jsonData = json.decode(jsonString);
        final List<
            dynamic> cultureBusinesses = jsonData['culture_businesses'] ?? [];

        List<Map<String, dynamic>> randomEvents = [];
        List<Map<String, dynamic>> educationEvents = [];

        if (cultureBusinesses.isNotEmpty) {
          final List<Map<String, dynamic>> businessList = cultureBusinesses
              .cast<Map<String, dynamic>>()
              .toList();

          businessList.shuffle();
          randomEvents = businessList.take(4).toList();

          // 교육 관련 이벤트 필터링
          final educationList = businessList.where((business) {
            final category = business['our_category']
                ?.toString()
                .toLowerCase() ?? '';
            return category.contains('교육') || category.contains('학습') ||
                category.contains('체험');
          }).toList();

          if (educationList.isNotEmpty) {
            educationList.shuffle();
            educationEvents = educationList.take(4).toList();
          }
        }

        setState(() {
          _recommendedEvents = randomEvents;
          _educationEvents = educationEvents;
          _allEvents = cultureBusinesses.cast<Map<String, dynamic>>();
          _isLoading = false;
        });

        if (_currentPosition != null) {
          _loadNearbyEvents();
        }
      } catch (fileError) {
        print('문화업체 데이터 로드 실패: $fileError');
        setState(() {
          _recommendedEvents = [];
          _educationEvents = [];
          _allEvents = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('추천 프로그램 로딩 오류: $e');
      setState(() {
        _recommendedEvents = [];
        _educationEvents = [];
        _allEvents = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildGreetingCard(),
              const SizedBox(height: 8),
              _buildAIRecommendationSection(),
              const SizedBox(height: 8), // 20에서 12로 줄임
              _buildCulturalRecommendationSection(),
              const SizedBox(height: 16),
              _buildEducationRecommendationSection(),
              const SizedBox(height: 16),
              _buildVoucherSection(),
              const SizedBox(height: 20),
              _buildBottomIconsSection(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/icons/app_icon.png', // 동일한 앱 아이콘
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '문화잇다',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications_outlined, color: Colors.black),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16), // 20에서 16으로 줄임
      decoration: BoxDecoration(
        color: Colors.blue[600],
        borderRadius: BorderRadius.circular(0), // 배경에 딱 붙도록
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '문화를 잇고 일상에 즐거움을 더하다',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16, // 18에서 16으로 줄임
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6), // 8에서 6으로 줄임
          Text(
            '오늘도 새로운 경험이 당신을 기다립니다',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13, // 14에서 13으로 줄임
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIRecommendationSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.purple, size: 20),
              const SizedBox(width: 8),
              Text(
                '지현님을 위한 오늘의 문화추천',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.palette, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '문화·교육 탐험가',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '한여 활동 12회 · 선호: 전시, 체험',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '관심 분야',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '문화체험, 공연',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      Text(
                        '교육, 음악, 스포츠',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '선호 지역',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '서구, 둔산동',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      Text(
                        '도보 10분 이내',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.orange, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '오늘의 AI 추천',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '모네 특별전 + 도자기 체험',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '사용자님의 관심사와 89% 일치하는 추천입니다',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
          ),
        ],
      ),
    );
  }
  Widget _buildCulturalRecommendationSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite, color: Colors.pink, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '지현님 근처에서 즐길 수 있는 문화 PICK',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  '',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildCulturalCard(
                  '대전 시립미술관 기획전',
                  '대전 시립미술관 · 12월 31일까지',
                  '무료',
                  '5,000원',
                  'assets/images/artConcert.jpg', // 변경됨
                  '전시',
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCulturalCard(
                  '대전예술의전당 콘서트',
                  '대전예술의전당 · 매월 셋째 토요일',
                  '30,000원',
                  null,
                  'assets/images/Piano.jpg', // 변경됨
                  '공연',
                  Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEducationRecommendationSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.school, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '지금 대전에서 배울 수 있는 교육체험 PICK',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  '',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildCulturalCard(
                  '중앙시장 전통 떡 만들기',
                  '중앙시장 떡집 · 매주 토요일',
                  '15,000원',
                  '20,000원',
                  'assets/images/Koreancake.jpg', // 변경됨
                  '체험',
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCulturalCard(
                  '성심당 제빵 클래스',
                  '성심당 본점 · 일요일 오전',
                  '25,000원',
                  null,
                  'assets/images/Bread.jpg', // 변경됨
                  '교육',
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCulturalCard(String title, String venue, String price,
      String? originalPrice, String imageUrl, String category,
      Color categoryColor) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  image: DecorationImage(
                    image: AssetImage(imageUrl), // NetworkImage에서 AssetImage로 변경
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          // 나머지 코드는 동일
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    venue,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      if (originalPrice != null) ...[
                        Text(
                          originalPrice,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[400],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer, color: Colors.orange, size: 16),
              const SizedBox(width: 8),
              Text(
                '바우처로 즐기는 무료 문화 체험',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  '',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.card_giftcard, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '문화누리카드 잔액',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '85,000원 남음',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          color: Colors.orange[300],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '서예 체험 클래스',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '바우처 적용 0원',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          image: DecorationImage(
                            image: AssetImage('assets/images/Coffee.jpg'), // 변경됨
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '전통 차 체험',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '바우처 적용 0원',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildBottomIconsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomIcon(Icons.calendar_today, '내 캘린더', Colors.blue),
          _buildBottomIcon(Icons.remove_red_eye, '최근 본', Colors.grey),
          _buildBottomIcon(Icons.card_giftcard, '혜택', Colors.red),
        ],
      ),
    );
  }

  Widget _buildBottomIcon(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        if (label == '내 캘린더') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CalendarScreen()),
          );
        }
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
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

class ReservationTab extends StatefulWidget {
  const ReservationTab({super.key});

  @override
  State<ReservationTab> createState() => _ReservationTabState();
}

class _ReservationTabState extends State<ReservationTab> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 대전 소상공인 문화체험 데이터
  final List<CulturalExperience> experiences = [
    CulturalExperience(
      title: '대전 성심당 빵 만들기 체험',
      description: '대전의 명물 튀김소보로 만들기 체험 (성심당 협업)',
      duration: '2시간',
      price: '22,000원',
      image: '🥐',
      maxParticipants: 8,
      location: '중구 은행동',
      shopName: '성심당 베이커리 스튜디오',
    ),
    CulturalExperience(
      title: '대청호 전통 도자기 체험',
      description: '대청호반 도예공방에서 진행하는 물레돌리기 체험',
      duration: '3시간',
      price: '35,000원',
      image: '🏺',
      maxParticipants: 6,
      location: '대덕구 대청호반',
      shopName: '호반 도예공방',
    ),
    CulturalExperience(
      title: '유성온천 족욕 & 차 체험',
      description: '유성온천에서 족욕과 함께 전통차 우리기 체험',
      duration: '1시간 30분',
      price: '18,000원',
      image: '♨️',
      maxParticipants: 12,
      location: '유성구 온천동',
      shopName: '온천차방',
    ),
    CulturalExperience(
      title: '대전 한복 체험 & 엑스포공원 산책',
      description: '한복 대여 후 엑스포공원에서 사진 촬영 및 산책',
      duration: '2시간 30분',
      price: '25,000원',
      image: '👘',
      maxParticipants: 10,
      location: '유성구 엑스포로',
      shopName: '한복이야기',
    ),
    CulturalExperience(
      title: '중앙시장 전통 장터 음식 체험',
      description: '중앙시장 상인과 함께하는 대전 향토음식 만들기',
      duration: '2시간',
      price: '20,000원',
      image: '🍜',
      maxParticipants: 8,
      location: '중구 중앙로',
      shopName: '중앙시장 요리교실',
    ),
    CulturalExperience(
      title: '계족산 황토길 명상 & 차 체험',
      description: '계족산 황토길 걷기와 산중 다실에서 차 명상',
      duration: '3시간',
      price: '28,000원',
      image: '🌲',
      maxParticipants: 15,
      location: '대덕구 장동',
      shopName: '산중다원',
    ),
    CulturalExperience(
      title: '보문산 전통 목공예 체험',
      description: '보문산 자락 공방에서 나무 소품 만들기',
      duration: '2시간 30분',
      price: '32,000원',
      image: '🪵',
      maxParticipants: 8,
      location: '중구 대사동',
      shopName: '보문목공방',
    ),
    CulturalExperience(
      title: '갑천 생태공원 천연염색 체험',
      description: '갑천변에서 자란 식물로 손수건 천연염색 체험',
      duration: '2시간',
      price: '24,000원',
      image: '🎨',
      maxParticipants: 12,
      location: '서구 갑천로',
      shopName: '갑천공방',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          '문화체험 예약',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // MainScreen의 홈탭으로 이동 (인덱스 0)
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // 알림 기능
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // 더보기 메뉴
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 캘린더 섹션
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TableCalendar<String>(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                selectedDecoration: BoxDecoration(
                  color: Colors.blue[600],
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blue[300],
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle(color: Colors.red[400]),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 선택된 날짜 표시
          if (_selectedDay != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.blue[600], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '선택된 날짜: ${_selectedDay!.year}년 ${_selectedDay!.month}월 ${_selectedDay!.day}일',
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // 문화체험 목록 제목
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '문화체험 프로그램',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // 전체보기 기능
                  },
                  child: const Text('전체보기'),
                ),
              ],
            ),
          ),

          // 문화체험 목록
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: experiences.length,
              itemBuilder: (context, index) {
                final experience = experiences[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          experience.image,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    title: Text(
                      experience.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          experience.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.store, size: 14, color: Colors.orange[600]),
                            const SizedBox(width: 4),
                            Text(
                              experience.shopName,
                              style: TextStyle(
                                color: Colors.orange[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              experience.location,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              experience.duration,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.people, size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              '최대 ${experience.maxParticipants}명',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              experience.price,
                              style: TextStyle(
                                color: Colors.blue[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _selectedDay != null
                                  ? () => _showReservationDialog(experience)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text('예약하기'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showReservationDialog(CulturalExperience experience) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(experience.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.store, size: 16, color: Colors.orange[600]),
                  const SizedBox(width: 6),
                  Text('업체: ${experience.shopName}'),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text('위치: ${experience.location}'),
                ],
              ),
              const SizedBox(height: 8),
              Text('날짜: ${_selectedDay!.year}년 ${_selectedDay!.month}월 ${_selectedDay!.day}일'),
              const SizedBox(height: 8),
              Text('시간: ${experience.duration}'),
              const SizedBox(height: 8),
              Text('가격: ${experience.price}'),
              const SizedBox(height: 8),
              Text('최대 참여자: ${experience.maxParticipants}명'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${experience.title} 예약이 완료되었습니다!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('예약 확정'),
            ),
          ],
        );
      },
    );
  }
}

class CulturalExperience {
  final String title;
  final String description;
  final String duration;
  final String price;
  final String image;
  final int maxParticipants;
  final String location;
  final String shopName;

  CulturalExperience({
    required this.title,
    required this.description,
    required this.duration,
    required this.price,
    required this.image,
    required this.maxParticipants,
    required this.location,
    required this.shopName,
  });
}

class ChatbotTab extends StatelessWidget {
  const ChatbotTab({super.key});

  @override
  Widget build(BuildContext context) {
    // 혜택 탭 선택 시 바로 챗봇 화면으로 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push( // pushReplacement에서 push로 변경
        context,
        MaterialPageRoute(builder: (context) => const ChatbotScreen()),
      );
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.textPrimary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
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
                  return const Text('지현님 반갑습니다.');
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyInfoScreen()),
                );
              },
            ),
            MyPageMenu(
              icon: Icons.analytics_outlined,
              label: '결제 관리',
              onTap: () {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalendarScreen()),
                );
              },
            ),

            MyPageMenu(
              icon: Icons.logout,
              label: '로그아웃',
              onTap: () async {
                // 1. Firebase에서 로그아웃
                await FirebaseAuth.instance.signOut();

                // 2. 로그인 화면으로 이동 (스택 전체 삭제)
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                      (Route<dynamic> route) => false,
                );
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
          TextButton(
            onPressed: () async {
              try {
                final credential = EmailAuthProvider.credential(
                  email: user.email!,
                  password: passwordController.text,
                );
                await user.reauthenticateWithCredential(credential);
                await user.delete();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('계정이 삭제되었습니다.')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('계정 삭제 실패: $e')),
                );
              }
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '결제 관리',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          '서비스 준비중입니다',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
// InterestCategoryScreen 위젯 수정 (관심 카테고리 수정 화면)
class InterestCategoryScreen extends StatefulWidget {
  const InterestCategoryScreen({super.key});

  @override
  State<InterestCategoryScreen> createState() => _InterestCategoryScreenState();
}

class _InterestCategoryScreenState extends State<InterestCategoryScreen> {
  final List<String> _culturalCategories = [
    '여가',
    '문화체험',
    '스포츠',
    '음악',
    '미술',
    '공연',
    '교육',
    '역사',
  ];
  List<String> _selectedCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final List<dynamic> categories = doc.data()?['categories'] ?? [];
    setState(() {
      _selectedCategories = categories.cast<String>();
      _isLoading = false;
    });
  }

  Future<void> _saveCategories() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'categories': _selectedCategories});

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('관심 카테고리가 업데이트되었습니다.')),
      );
      Navigator.pop(context); // 이전 화면으로 돌아가기
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('관심 카테고리 설정'),
        actions: [
          IconButton(
            icon: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveCategories,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '관심 있는 문화 활동을 모두 선택하세요.',
              style: AppTextStyles.body1,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12.0,
              runSpacing: 8.0,
              children: _culturalCategories.map((category) {
                final isSelected = _selectedCategories.contains(category);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedCategories.remove(category);
                      } else {
                        _selectedCategories.add(category);
                      }
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isSelected,
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              _selectedCategories.add(category);
                            } else {
                              _selectedCategories.remove(category);
                            }
                          });
                        },
                        checkColor: Colors.white,
                        activeColor: AppColors.primary,
                      ),
                      Text(
                        category,
                        style: AppTextStyles.body2.copyWith(
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 예약 이벤트 더미 데이터 (나중에 DB에서 불러올 부분)
  final Map<DateTime, List<dynamic>> _events = {
    DateTime.utc(2025, 10, 20): ['독서 모임'],
    DateTime.utc(2025, 10, 25): ['전시회 관람', '미술 워크숍'],
    DateTime.utc(2025, 11, 5): ['음악회'],
  };

  // 특정 날짜의 이벤트 목록을 가져오는 함수
  List<dynamic> _getEventsForDay(DateTime day) {
    // 날짜의 년, 월, 일만 비교하기 위해 normalize합니다.
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    // _events 맵에서 normalized된 날짜를 키로 사용
    return _events[normalizedDay] ?? [];
  }

  @override
  void initState() {
    super.initState();
    // 한글 날짜 데이터를 초기화합니다.
    initializeDateFormatting('ko_KR', null);
  }

  @override
  Widget build(BuildContext context) {
    // 현재 선택된 날짜에 이벤트가 있는지 확인합니다.
    final selectedEvents = _getEventsForDay(_selectedDay ?? _focusedDay);

    return Scaffold(
      appBar: AppBar(
        title: const Text('캘린더 및 예약'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'ko_KR',
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '예약 리스트',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (selectedEvents.isEmpty)
                    const Center(child: Text('해당 날짜에 예약된 일정이 없습니다.'))
                  else
                    ...selectedEvents.map((event) =>
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.event, color: Colors.blue),
                              const SizedBox(width: 10),
                              Text(event.toString()),
                            ],
                          ),
                        ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 프로그램 모델 (기존과 동일)
class Program {
  final String id;
  final String title;
  final String description;
  final String theme;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final List<String> tags;
  final String? imageUrl; // 추가

  Program({
    required this.id,
    required this.title,
    required this.description,
    required this.theme,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.tags,
    this.imageUrl, // 추가
  });
}

// 전화번호 인증 화면 (별도 파일: phone_certification_screen.dart에 위치해야 함)
class PhoneCertificationScreen extends StatefulWidget {
  final String phoneNumber;

  const PhoneCertificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<PhoneCertificationScreen> createState() => _PhoneCertificationScreenState();
}

class _PhoneCertificationScreenState extends State<PhoneCertificationScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _verificationId;
  bool _isCodeSent = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _sendVerificationCode();
  }

  Future<void> _sendVerificationCode() async {
    setState(() => _isLoading = true);

    String phoneNumber = widget.phoneNumber;
    if (!phoneNumber.startsWith('+82')) {
      phoneNumber = '+82${phoneNumber.replaceFirst('0', '')}';
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // 자동 인증 시에도 성공 처리
        Navigator.pop(context, true);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('인증 실패: ${e.message}')),
          );
          Navigator.pop(context, false);
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
        setState(() => _isLoading = false);
      },
    );
  }

  Future<void> _verifyCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _codeController.text.trim(),
      );

      // 임시 사용자로 인증만 확인 (실제 계정 생성은 회원가입 폼에서)
      await FirebaseAuth.instance.signInWithCredential(credential);
      await FirebaseAuth.instance.signOut(); // 바로 로그아웃

      if (mounted) {
        Navigator.pop(context, true); // 인증 성공으로 돌아가기
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증 실패: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('전화번호 인증'),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.phone_android,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                '전화번호 인증',
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.phoneNumber}로\n인증 코드가 전송되었습니다.',
                style: AppTextStyles.body2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              if (_isCodeSent)
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: '인증 코드',
                    hintText: '6자리 숫자 입력',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? '인증 코드를 입력하세요.'
                      : null,
                ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isLoading || !_isCodeSent) ? null : _verifyCode,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('인증 확인'),
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: _isLoading ? null : _sendVerificationCode,
                child: const Text('인증 코드 재전송'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
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
      // 1. 먼저 이메일/비밀번호로 계정 생성
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

      // 2. 사용자 프로필 업데이트 (이름 저장)
      await userCredential.user?.updateDisplayName(widget.name);

      // 3. 전화번호 인증 확인
      final phoneCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _codeController.text,
      );

      // 4. 전화번호 인증 연결 (선택사항)
      try {
        await userCredential.user?.linkWithCredential(phoneCredential);
      } catch (e) {
        print('전화번호 연결 실패: $e (계정은 생성됨)');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입이 완료되었습니다!')),
        );
        // 메인 화면으로 이동
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
              (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: ${e.message}')),
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
  final _confirmPasswordController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhoneAuthScreen(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: '비밀번호 확인'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 다시 입력하세요.';
                  }
                  if (value != _passwordController.text) {
                    return '비밀번호가 일치하지 않습니다.';
                  }
                  return null;
                },
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
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
// 설정 화면
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 알림 설정 섹션
            _buildSectionTitle('알림 설정'),
            const SizedBox(height: 10),
            _buildSwitchTile(
              icon: Icons.notifications,
              title: '푸시 알림',
              subtitle: '새로운 활동 및 예약 알림',
              value: true,
              onChanged: (value) {
                // TODO: 알림 설정 저장
              },
            ),
            _buildSwitchTile(
              icon: Icons.email,
              title: '이메일 알림',
              subtitle: '이벤트 및 프로모션 알림',
              value: false,
              onChanged: (value) {
                // TODO: 이메일 알림 설정 저장
              },
            ),

            const SizedBox(height: 30),

            // 앱 설정 섹션
            _buildSectionTitle('앱 설정'),
            const SizedBox(height: 10),
            MyPageMenu(
              icon: Icons.language,
              label: '언어 설정',
              onTap: () {
                _showLanguageDialog(context);
              },
            ),
            MyPageMenu(
              icon: Icons.dark_mode,
              label: '다크 모드',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('서비스 준비중입니다')),
                );
              },
            ),

            const SizedBox(height: 30),

            // 지원 섹션
            _buildSectionTitle('지원'),
            const SizedBox(height: 10),
            MyPageMenu(
              icon: Icons.help,
              label: '도움말 및 FAQ',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpScreen()),
                );
              },
            ),
            MyPageMenu(
              icon: Icons.feedback,
              label: '피드백 보내기',
              onTap: () {
                _showFeedbackDialog(context);
              },
            ),
            MyPageMenu(
              icon: Icons.info,
              label: '앱 정보',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AppInfoScreen()),
                );
              },
            ),

            const SizedBox(height: 30),

            // 개인정보 섹션
            _buildSectionTitle('개인정보'),
            const SizedBox(height: 10),
            MyPageMenu(
              icon: Icons.privacy_tip,
              label: '개인정보 처리방침',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                );
              },
            ),
            MyPageMenu(
              icon: Icons.description,
              label: '이용약관',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
                );
              },
            ),
            MyPageMenu(
              icon: Icons.code,
              label: '오픈소스 라이센스',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OpenSourceLicenseScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.heading4.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTextStyles.body2),
        subtitle: Text(subtitle, style: AppTextStyles.caption),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('언어 설정'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('한국어'),
              leading: Radio(
                value: 'ko',
                groupValue: 'ko',
                onChanged: (value) {
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('English'),
              leading: Radio(
                value: 'en',
                groupValue: 'ko',
                onChanged: (value) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('서비스 준비중입니다')),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final feedbackController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('피드백 보내기'),
        content: TextField(
          controller: feedbackController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: '의견이나 제안사항을 입력해주세요',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('피드백이 전송되었습니다')),
              );
            },
            child: const Text('보내기'),
          ),
        ],
      ),
    );
  }
}

// 도움말 화면
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도움말 및 FAQ'),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFAQItem(
              '문화잇다는 무엇인가요?',
              '문화잇다는 다양한 문화 활동을 찾고 예약할 수 있는 플랫폼입니다.',
            ),
            _buildFAQItem(
              '예약은 어떻게 하나요?',
              '원하는 프로그램을 선택한 후 예약 버튼을 눌러 예약할 수 있습니다.',
            ),
            _buildFAQItem(
              '취소 정책은 어떻게 되나요?',
              '예약 취소는 프로그램 시작 24시간 전까지 가능합니다.',
            ),
            _buildFAQItem(
              '결제는 어떻게 하나요?',
              '카드 결제, 계좌이체, 온누리상품권 등 다양한 결제 수단을 지원합니다.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            answer,
            style: AppTextStyles.body2,
          ),
        ),
      ],
    );
  }
}

// 앱 정보 화면
class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('앱 정보'),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_stories,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),
            Text(
              AppConstants.appName,
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 10),
            Text(
              '버전 1.0.0',
              style: AppTextStyles.body2,
            ),
            const SizedBox(height: 30),
            Text(
              '문화생활을 같이 즐겨요',
              style: AppTextStyles.body1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Text(
              '© 2025 문화잇다. All rights reserved.',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}

// 개인정보 처리방침 화면
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보 처리방침'),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '''개인정보 처리방침

문화잇다는 개인정보보호법에 따라 이용자의 개인정보 보호 및 권익을 보호하고 개인정보와 관련한 이용자의 고충을 원활하게 처리할 수 있도록 다음과 같은 처리방침을 두고 있습니다.

1. 개인정보의 처리목적
- 회원가입 및 관리
- 서비스 제공 및 계약의 이행
- 고객상담 및 불만처리

2. 개인정보의 처리 및 보유기간
회원탈퇴시까지 보유하며, 탈퇴시 즉시 파기합니다.

3. 개인정보의 제3자 제공
원칙적으로 개인정보를 제3자에게 제공하지 않습니다.

자세한 내용은 앱 내 고객센터로 문의하시기 바랍니다.''',
          style: TextStyle(height: 1.6),
        ),
      ),
    );
  }
}

// 이용약관 화면
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이용약관'),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '''이용약관

제1조 (목적)
본 약관은 문화잇다가 제공하는 서비스의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항 등을 규정함을 목적으로 합니다.

제2조 (정의)
1. "서비스"란 문화잇다가 제공하는 모든 서비스를 의미합니다.
2. "이용자"란 본 약관에 따라 서비스를 이용하는 회원 및 비회원을 말합니다.

제3조 (약관의 효력 및 변경)
1. 본 약관은 서비스를 이용하고자 하는 모든 이용자에 대하여 그 효력을 발생합니다.
2. 회사는 필요한 경우 본 약관을 변경할 수 있습니다.

자세한 내용은 앱 내 고객센터로 문의하시기 바랍니다.''',
          style: TextStyle(height: 1.6),
        ),
      ),
    );
  }
}
// 오픈소스 라이센스 화면 (완전한 버전)
class OpenSourceLicenseScreen extends StatelessWidget {
  const OpenSourceLicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오픈소스 라이센스'),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이 앱은 다음 오픈소스 라이브러리들을 사용합니다',
              style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),

            // Flutter 프레임워크
            _buildLicenseSection(
              'Flutter',
              'BSD 3-Clause License',
              'Google에서 개발한 크로스 플랫폼 UI 프레임워크',
              'https://github.com/flutter/flutter',
            ),

            // Firebase 라이브러리들
            _buildLicenseSection(
              'Firebase Core',
              'Apache License 2.0',
              'Firebase SDK의 핵심 라이브러리',
              'https://github.com/firebase/flutterfire',
            ),
            _buildLicenseSection(
              'Firebase Auth',
              'Apache License 2.0',
              'Firebase 인증 서비스 라이브러리',
              'https://github.com/firebase/flutterfire',
            ),
            _buildLicenseSection(
              'Cloud Firestore',
              'Apache License 2.0',
              'Firebase 실시간 NoSQL 데이터베이스',
              'https://github.com/firebase/flutterfire',
            ),

            // 상태 관리
            _buildLicenseSection(
              'Provider',
              'MIT License',
              'Flutter용 상태 관리 라이브러리',
              'https://github.com/rrousselGit/provider',
            ),

            // 네트워킹
            _buildLicenseSection(
              'HTTP',
              'BSD 3-Clause License',
              'Dart용 HTTP 클라이언트 라이브러리',
              'https://github.com/dart-lang/http',
            ),

            // 웹뷰
            _buildLicenseSection(
              'Flutter InAppWebView',
              'Apache License 2.0',
              'Flutter용 인앱 웹뷰 플러그인',
              'https://github.com/pichillilorenzo/flutter_inappwebview',
            ),
            _buildLicenseSection(
              'WebView Flutter',
              'BSD 3-Clause License',
              'Flutter 공식 웹뷰 플러그인',
              'https://github.com/flutter/plugins',
            ),

            // 데이터 저장
            _buildLicenseSection(
              'Shared Preferences',
              'BSD 3-Clause License',
              'Flutter용 로컬 데이터 저장 플러그인',
              'https://github.com/flutter/plugins',
            ),

            // 국제화
            _buildLicenseSection(
              'Intl',
              'BSD 3-Clause License',
              'Dart 국제화 및 지역화 라이브러리',
              'https://github.com/dart-lang/intl',
            ),

            // UI 라이브러리
            _buildLicenseSection(
              'Flukit',
              'MIT License',
              'Flutter용 UI 컴포넌트 라이브러리',
              'https://github.com/flutterchina/flukit',
            ),
            _buildLicenseSection(
              'Table Calendar',
              'Apache License 2.0',
              'Flutter용 캘린더 위젯',
              'https://github.com/aleksanderwozniak/table_calendar',
            ),

            // 유틸리티
            _buildLicenseSection(
              'URL Launcher',
              'BSD 3-Clause License',
              'Flutter용 URL 실행 플러그인',
              'https://github.com/flutter/plugins',
            ),
            _buildLicenseSection(
              'Cupertino Icons',
              'MIT License',
              'iOS 스타일 아이콘 패키지',
              'https://github.com/flutter/cupertino_icons',
            ),

            // 개발 도구
            _buildLicenseSection(
              'Flutter Lints',
              'BSD 3-Clause License',
              'Flutter 코드 품질 검사 도구',
              'https://github.com/flutter/packages',
            ),
            _buildLicenseSection(
              'Hive Generator',
              'Apache License 2.0',
              'Hive 데이터베이스 코드 생성기',
              'https://github.com/hivedb/hive',
            ),
            _buildLicenseSection(
              'Build Runner',
              'BSD 3-Clause License',
              'Dart 코드 생성 도구',
              'https://github.com/dart-lang/build',
            ),
            _buildLicenseSection(
              'Flutter Launcher Icons',
              'MIT License',
              'Flutter 앱 아이콘 생성기',
              'https://github.com/fluttercommunity/flutter_launcher_icons',
            ),

            // AI/ML 백엔드 (Python)
            _buildLicenseSection(
              'KoBERT',
              'Apache License 2.0',
              'SKT에서 개발한 한국어 BERT 모델',
              'https://github.com/SKTBrain/KoBERT',
            ),
            _buildLicenseSection(
              'Transformers',
              'Apache License 2.0',
              'Hugging Face 자연어 처리 라이브러리',
              'https://github.com/huggingface/transformers',
            ),
            _buildLicenseSection(
              'PyTorch',
              'BSD 3-Clause License',
              'Facebook 딥러닝 프레임워크',
              'https://github.com/pytorch/pytorch',
            ),
            _buildLicenseSection(
              'FastAPI',
              'MIT License',
              '고성능 웹 API 프레임워크',
              'https://github.com/tiangolo/fastapi',
            ),
            _buildLicenseSection(
              'Pydantic',
              'MIT License',
              'Python 데이터 검증 라이브러리',
              'https://github.com/pydantic/pydantic',
            ),
            _buildLicenseSection(
              'Geolocator',
              'MIT License',
              'Flutter용 위치 서비스 플러그인',
              'https://github.com/Baseflow/flutter-geolocator',
            ),
            _buildLicenseSection(
              'Permission Handler',
              'MIT License',
              'Flutter용 권한 관리 플러그인',
              'https://github.com/Baseflow/flutter-permission_handler',
            ),

            const SizedBox(height: 30),

            // 라이센스 고지사항
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '라이센스 고지',
                    style: AppTextStyles.heading4.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '문화잇다 앱은 위에 명시된 오픈소스 소프트웨어를 사용하여 개발되었습니다. 각 라이브러리의 라이센스 조건을 준수하며, 해당 라이센스의 전문은 각 프로젝트의 공식 저장소에서 확인하실 수 있습니다.',
                    style: AppTextStyles.body2.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '오픈소스 커뮤니티의 기여에 감사드립니다.',
                    style: AppTextStyles.caption.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLicenseSection(String name, String license, String description, String url) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: AppTextStyles.body2.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _getLicenseColor(license),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    license,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              url,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontSize: 10,
                decoration: TextDecoration.underline,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getLicenseColor(String license) {
    switch (license) {
      case 'MIT License':
        return Colors.green;
      case 'Apache License 2.0':
        return Colors.blue;
      case 'BSD 3-Clause License':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}