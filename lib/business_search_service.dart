// lib/services/culture_search_service.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'business_models.dart';

class CultureSearchService {
  List<CultureEvent> _cultureEvents = [];
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  List<CultureEvent> get cultureEvents => _cultureEvents;

  Future<void> loadCultureData() async {
    try {
      print('=== 문화업체 데이터 로딩 시작 ===');

      await _loadCultureBusinesses();

      _isLoaded = true;
      print('=== 문화업체 데이터 로딩 완료 ===');
      print('문화업체: ${_cultureEvents.length}개');
    } catch (e) {
      print('문화업체 데이터 로딩 실패: $e');
      _isLoaded = false;
    }
  }

  Future<void> _loadCultureBusinesses() async {
    try {
      print('문화업체 정보 로딩 중...');
      final String jsonData = await rootBundle.loadString('assets/data/programs.json');
      final Map<String, dynamic> data = json.decode(jsonData);

      final List<dynamic> businesses = data['culture_businesses'] ?? [];
      _cultureEvents = businesses.map<CultureEvent>((business) => CultureEvent(
        eventName: business['name']?.toString() ?? '',
        venue: business['address']?.toString() ?? '',
        organizer: business['category_medium']?.toString() ?? '',
        genre: business['our_category']?.toString() ?? '',
        category: business['category_large']?.toString() ?? '',
        content: business['road_address']?.toString() ?? business['old_address']?.toString() ?? '',
        date: business['district']?.toString() ?? '',
        url: '', // 필수 매개변수 추가 (빈 문자열)
        // 다른 필수 매개변수들도 있을 수 있음
      )).toList();

      print('문화업체 정보 로딩 완료: ${_cultureEvents.length}개');
    } catch (e) {
      print('문화업체 정보 로딩 실패: $e');
    }
  }

  // 문화업체 검색
  List<CultureEvent> searchCultureEvents({String? keyword, String? genre, String? organizer, String? location}) {
    List<CultureEvent> results = _cultureEvents;

    if (keyword != null && keyword.isNotEmpty) {
      final searchTerm = keyword.toLowerCase();
      results = results.where((event) {
        return event.eventName.toLowerCase().contains(searchTerm) ||
            event.content.toLowerCase().contains(searchTerm) ||
            event.venue.toLowerCase().contains(searchTerm) ||
            event.organizer.toLowerCase().contains(searchTerm) ||
            event.category.toLowerCase().contains(searchTerm) ||
            event.genre.toLowerCase().contains(searchTerm);
      }).toList();
    }

    if (genre != null && genre != '전체') {
      results = results.where((event) => event.genre == genre).toList();
    }

    if (organizer != null && organizer != '전체') {
      results = results.where((event) => event.organizer.contains(organizer)).toList();
    }

    if (location != null && location != '전체') {
      results = results.where((event) =>
      event.date.contains(location) || // date 필드에 구 정보 저장
          event.venue.contains(location)
      ).toList();
    }

    return results;
  }

  // 카테고리별 분류
  Map<String, List<CultureEvent>> getEventsByGenre() {
    Map<String, List<CultureEvent>> categorized = {};

    for (var event in _cultureEvents) {
      String genre = event.genre;
      if (!categorized.containsKey(genre)) {
        categorized[genre] = [];
      }
      categorized[genre]!.add(event);
    }

    return categorized;
  }

  // 업종별 분류
  Map<String, List<CultureEvent>> getEventsByOrganizer() {
    Map<String, List<CultureEvent>> categorized = {};

    for (var event in _cultureEvents) {
      String organizer = event.organizer;
      if (!categorized.containsKey(organizer)) {
        categorized[organizer] = [];
      }
      categorized[organizer]!.add(event);
    }

    return categorized;
  }

  // 지역별 분류
  Map<String, List<CultureEvent>> getEventsByLocation() {
    Map<String, List<CultureEvent>> categorized = {};

    for (var event in _cultureEvents) {
      String district = event.date; // date 필드에 구 정보 저장됨
      if (!categorized.containsKey(district)) {
        categorized[district] = [];
      }
      categorized[district]!.add(event);
    }

    return categorized;
  }

  // 통계 정보
  Map<String, int> getStatistics() {
    Map<String, int> stats = {};

    // 카테고리별 통계
    for (var event in _cultureEvents) {
      stats[event.genre] = (stats[event.genre] ?? 0) + 1;
    }

    return stats;
  }
}

class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({Key? key, this.initialQuery}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String selectedGenreFilter = '전체';
  String selectedOrganizerFilter = '전체';
  String selectedLocationFilter = '전체';
  bool showFilters = false;
  late TextEditingController searchController;

  final CultureSearchService _cultureSearchService = CultureSearchService();
  List<CultureEvent> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  // 카테고리 필터 (상단 탭 형태)
  final List<String> categoryTabs = ['공연', '전시', '축제', '교육', '체험'];
  String selectedCategoryTab = '';

  // 정렬 옵션
  String selectedSort = '추천순';
  final List<String> sortOptions = ['추천순', '거리순', '가격순'];

  final List<String> locationFilters = ['전체', '유성구', '서구', '중구', '동구', '대덕구'];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.initialQuery ?? '');

    if (_cultureSearchService.isLoaded) {
      _isLoading = false;
      // 데이터가 로드되어 있으면 바로 전체 결과 표시
      _showAllResults();
      if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _performSearch();
        });
      }
    } else {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _cultureSearchService.loadCultureData();
      // 데이터 로드 완료 후 전체 결과 표시
      _showAllResults();
    } catch (e) {
      print('데이터 로딩 오류: $e');
    }

    setState(() {
      _isLoading = false;
    });

    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _performSearch();
    }
  }

  // 전체 데이터를 표시하는 함수 추가
  void _showAllResults() {
    setState(() {
      _searchResults = _cultureSearchService.cultureEvents;
      _hasSearched = true;
    });
  }

  void _performSearch() {
    if (!_cultureSearchService.isLoaded) {
      print('데이터가 아직 로딩되지 않음');
      return;
    }

    List<CultureEvent> results = _cultureSearchService.searchCultureEvents(
      keyword: searchController.text,
      // 카테고리 탭이 '전체'가 아닌 경우에만 genre 필터 적용하지 않음
      genre: null, // 카테고리별 필터링을 제거하여 모든 결과 표시
      organizer: selectedOrganizerFilter == '전체'
          ? null
          : selectedOrganizerFilter,
      location: selectedLocationFilter == '전체' ? null : selectedLocationFilter,
    );

    setState(() {
      _searchResults = results;
      _hasSearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.auto_stories,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '문화잇다',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
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
          IconButton(
            icon: Icon(Icons.chat_bubble_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색창
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: '장르, 장소, 키워드 검색',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  Future.delayed(Duration(milliseconds: 500), () {
                    if (searchController.text == value) {
                      _performSearch();
                    }
                  });
                },
                onSubmitted: (value) => _performSearch(),
              ),
            ),
          ),

          // 카테고리 탭
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: categoryTabs.map((category) {
                final isSelected = selectedCategoryTab == category;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        // 이미 선택된 카테고리를 다시 누르면 선택 해제
                        if (selectedCategoryTab == category) {
                          selectedCategoryTab = '';
                        } else {
                          selectedCategoryTab = category;
                        }
                      });
                      _performSearch();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[300]!,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // 필터 및 정렬
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // 리스트/지도 토글
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      _buildToggleButton('리스트', true),
                      _buildToggleButton('지도', false),
                    ],
                  ),
                ),
                Spacer(),
                // 필터 버튼
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showFilters = !showFilters;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.tune, color: Colors.blue, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '필터',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 검색 결과 개수 및 정렬
          if (_hasSearched && _searchResults.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: _showSortOptions,
                    child: Row(
                      children: [
                        Text(
                          selectedSort,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 필터 옵션 (확장 시)
          if (showFilters) ...[
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey[50],
              child: Column(
                children: [
                  _buildFilterSection(
                      '지역', locationFilters, selectedLocationFilter, (value) {
                    setState(() {
                      selectedLocationFilter = value;
                    });
                    _performSearch();
                  }),
                ],
              ),
            ),
          ],

          Expanded(
            child: _buildResultsArea(),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isSelected ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ] : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '정렬 기준',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ...sortOptions.map((option) {
                return ListTile(
                  title: Text(option),
                  trailing: selectedSort == option
                      ? Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedSort = option;
                    });
                    Navigator.pop(context);
                    _performSearch();
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSection(String title, List<String> options,
      String selected, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            bool isSelected = selected == option;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[600] : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildResultsArea() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // 검색하지 않았을 때도 전체 데이터 표시
    if (!_hasSearched && _cultureSearchService.isLoaded) {
      _showAllResults();
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[300],
            ),
            SizedBox(height: 16),
            Text(
              '검색 결과가 없습니다',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: _searchResults.length > 30 ? 30 : _searchResults.length,
      itemBuilder: (context, index) {
        final business = _searchResults[index];
        return _buildCultureEventCard(business, index); // 인덱스 전달
      },
    );

  }

  // 새로운 카드 디자인 (이미지와 비슷하게)
  Widget _buildCultureEventCard(CultureEvent event, int cardIndex) { // cardIndex 매개변수 추가
    final backgroundImages = _getCultureEventImages(event.organizer, event.eventName);

    // 랜덤 대신 카드 순서대로 이미지 선택
    final imageIndex = cardIndex % backgroundImages.length;
    final backgroundImage = backgroundImages[imageIndex];
    // 인덱스를 기반으로 다양한 거리 생성
    final distances = [
      '0.5km',
      '0.8km',
      '1.2km',
      '1.5km',
      '2.1km',
      '2.7km',
      '3.2km',
      '4.1km'
    ];
    final distanceIndex = event.eventName.hashCode % distances.length;
    final distance = distances[distanceIndex.abs()];

    // 랜덤 바우처 정보 생성
    final vouchers = ['', '바우처 가능', '온누리 가능', '문화누리 가능', '지역사랑 가능'];
    final voucherIndex = (event.eventName.hashCode + 2) % vouchers.length;
    final voucher = vouchers[voucherIndex.abs()];

    // 랜덤 별점 생성
    final ratings = ['4.1', '4.2', '4.3', '4.5', '4.6', '4.7', '4.8', '4.9'];
    final ratingIndex = (event.eventName.hashCode + 3) % ratings.length;
    final rating = ratings[ratingIndex.abs()];

    // 랜덤 리뷰 개수 생성
    final reviewCounts = [
      '12',
      '25',
      '38',
      '47',
      '56',
      '73',
      '89',
      '124',
      '156',
      '203',
      '287',
      '345'
    ];
    final reviewIndex = (event.eventName.hashCode + 4) % reviewCounts.length;
    final reviewCount = reviewCounts[reviewIndex.abs()];

    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // 왼쪽 이미지 박스
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  // NetworkImage에서 AssetImage로 변경
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16),
            // 오른쪽 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.eventName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red, size: 14),
                      SizedBox(width: 4),
                      Text(
                        distance,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.star, color: Colors.orange, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '$rating ($reviewCount)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      // 바우처 정보가 있을 때만 표시
                      if (voucher.isNotEmpty) ...[
                        SizedBox(width: 12),
                        Text(
                          voucher,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    event.organizer,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Spacer(),
                      Icon(
                        Icons.favorite_border,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// category_medium 기준으로 이미지 배열 반환
  List<String> _getCultureEventImages(String categoryMedium, String eventName) {
    final allImages = [
      // 기존 이미지들
      'assets/images/sports_bowling.jpg',
      'assets/images/sports_golf.jpg',
      'assets/images/sports_billiard.jpg',
      'assets/images/sports_fitness.jpg',
      'assets/images/entertainment_game.jpg',
      'assets/images/entertainment_karaoke.jpg',
      'assets/images/entertainment_park.jpg',
      'assets/images/library_main.jpg',
      'assets/images/library_study.jpg',
      'assets/images/library_cafe.jpg',
      'assets/images/library_space.jpg',
      'assets/images/health_massage.jpg',
      'assets/images/health_sauna.jpg',
      'assets/images/health_spa.jpg',
      'assets/images/hotel_main.jpg',
      'assets/images/hotel_motel.jpg',
      'assets/images/sports_swimming.jpg',
      'assets/images/sports_tennis.jpg',
      'assets/images/sports_basketball.jpg',
      'assets/images/sports_badminton.jpg',
      'assets/images/sports_yoga.jpg',
      'assets/images/sports_pilates.jpg',
      'assets/images/sports_climbing.jpg',
      'assets/images/entertainment_pc_cafe.jpg',
      'assets/images/entertainment_vr.jpg',
      'assets/images/entertainment_comic_cafe.jpg',
      'assets/images/entertainment_board_game.jpg',
      'assets/images/entertainment_escape_room.jpg',
      'assets/images/library_reading_room.jpg',
      'assets/images/library_book_cafe.jpg',
      'assets/images/library_study_room.jpg',
      'assets/images/library_seminar_room.jpg',
      'assets/images/health_nail_salon.jpg',
      'assets/images/health_beauty_salon.jpg',
      'assets/images/health_skincare.jpg',
      'assets/images/hotel_pension.jpg',
      'assets/images/hotel_guesthouse.jpg',
      'assets/images/hotel_camping.jpg',
      'assets/images/food_restaurant.jpg',
      'assets/images/food_cafe.jpg',
      'assets/images/food_bakery.jpg',
      'assets/images/food_traditional.jpg',
    ];

    return allImages;


    @override
    void dispose() {
      searchController.dispose();
      super.dispose();
    }
  }
}