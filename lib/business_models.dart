// lib/models/business_models.dart
class BusinessInfo {
  final String businessName;
  final String businessType;
  final String industry;
  final String location;
  final String address;
  final String phone;

  BusinessInfo({
    required this.businessName,
    required this.businessType,
    required this.industry,
    required this.location,
    required this.address,
    required this.phone,
  });

  factory BusinessInfo.fromCsv(List<String> csvRow) {
    // CSV 헤더 기준으로 정확한 인덱스 사용
    return BusinessInfo(
      businessName: csvRow.length > 1 ? csvRow[1] : '', // "상호명"
      businessType: csvRow.length > 4 ? csvRow[4] : '', // "상권업종대분류명"
      industry: csvRow.length > 6 ? csvRow[6] : '', // "상권업종중분류명"
      location: csvRow.length > 12 ? '${csvRow[12]} ${csvRow.length > 14 ? csvRow[14] : ''}' : '', // "시도명" + "시군구명"
      address: csvRow.length > 31 ? csvRow[31] : csvRow.length > 24 ? csvRow[24] : '', // "도로명주소" 또는 "지번주소"
      phone: '', // CSV에 전화번호 없음
    );
  }
}

class TraditionalMarket {
  final String marketCode;
  final String marketName;
  final String marketType;
  final String address;
  final String roadAddress;
  final String city;
  final String district;

  TraditionalMarket({
    required this.marketCode,
    required this.marketName,
    required this.marketType,
    required this.address,
    required this.roadAddress,
    required this.city,
    required this.district,
  });

  factory TraditionalMarket.fromCsv(List<String> csvRow) {
    return TraditionalMarket(
      marketCode: csvRow.length > 0 ? csvRow[0] : '',
      marketName: csvRow.length > 1 ? csvRow[1] : '',
      marketType: csvRow.length > 2 ? csvRow[2] : '',
      address: csvRow.length > 3 ? csvRow[3] : '',
      roadAddress: csvRow.length > 4 ? csvRow[4] : '',
      city: csvRow.length > 5 ? csvRow[5] : '',
      district: csvRow.length > 6 ? csvRow[6] : '',
    );
  }
}

class OnNuriStore {
  final String storeName;
  final String marketName;
  final String location;
  final String businessType;
  final String cardAccept;
  final String paperAccept;
  final String mobileAccept;

  OnNuriStore({
    required this.storeName,
    required this.marketName,
    required this.location,
    required this.businessType,
    required this.cardAccept,
    required this.paperAccept,
    required this.mobileAccept,
  });

  factory OnNuriStore.fromCsv(List<String> csvRow) {
    return OnNuriStore(
      storeName: csvRow.length > 0 ? csvRow[0] : '',
      marketName: csvRow.length > 1 ? csvRow[1] : '',
      location: csvRow.length > 2 ? csvRow[2] : '',
      businessType: csvRow.length > 3 ? csvRow[3] : '',
      cardAccept: csvRow.length > 4 ? csvRow[4] : '',
      paperAccept: csvRow.length > 5 ? csvRow[5] : '',
      mobileAccept: csvRow.length > 6 ? csvRow[6] : '',
    );
  }
}

// 문화행사 모델 클래스 추가
class CultureEvent {
  final String eventName;
  final String content;
  final String date;
  final String venue;
  final String organizer;
  final String category;
  final String genre;
  final String url;

  CultureEvent({
    required this.eventName,
    required this.content,
    required this.date,
    required this.venue,
    required this.organizer,
    required this.category,
    required this.genre,
    required this.url,
  });

  factory CultureEvent.fromJson(Map<String, dynamic> json) {
    return CultureEvent(
      eventName: json['행사명'] ?? '',
      content: json['내용'] ?? '',
      date: json['날짜'] ?? '',
      venue: json['장소'] ?? '',
      organizer: json['주최기관'] ?? '',
      category: json['카테고리'] ?? '',
      genre: json['장르분류'] ?? '',
      url: json['URL'] ?? '',
    );
  }
}