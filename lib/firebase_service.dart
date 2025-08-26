// lib/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, Timestamp;
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models.dart';
import 'constants.dart';

class FirebaseService {
  static final fba.FirebaseAuth _auth = fba.FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =============================================================================
  // Converter가 적용된 컬렉션 레퍼런스 정의
  // =============================================================================
  static CollectionReference<BlogPost> get _postsCollection =>
      _firestore.collection('blog_posts').withConverter<BlogPost>(
        fromFirestore: (snapshot, _) => BlogPost.fromFirestore(snapshot),
        toFirestore: (post, _) => post.toFirestore(),
      );
  static Future<void> deleteUserData(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
      print('Firestore에서 사용자 데이터($userId) 삭제 완료');
    } catch (e) {
      print('사용자 데이터 삭제 오류: $e');
      rethrow;
    }
  }
  static CollectionReference<Comment> get _commentsCollection =>
      _firestore.collection('comments').withConverter<Comment>(
        fromFirestore: (snapshot, _) => Comment.fromFirestore(snapshot),
        toFirestore: (comment, _) => comment.toFirestore(),
      );

  static CollectionReference<SavedExperience> get _savedExperiencesCollection =>
      _firestore.collection('saved_experiences').withConverter<SavedExperience>(
        fromFirestore: (snapshot, _) => SavedExperience.fromFirestore(snapshot),
        toFirestore: (experience, _) => experience.toFirestore(),
      );

  static CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  static CollectionReference<Map<String, dynamic>> get _dailyMoodsCollection =>
      _firestore.collection('user_moods');

  static CollectionReference<Map<String, dynamic>> get _chatHistoriesCollection =>
      _firestore.collection('chat_histories');

  static CollectionReference<Map<String, dynamic>> get _aiFeedbackCollection =>
      _firestore.collection('ai_feedback');

  // =============================================================================
  // 현재 사용자 정보
  // =============================================================================
  static fba.User? get currentUser => _auth.currentUser;
  static String? get currentUserId => _auth.currentUser?.uid;
  static String get userEmail => _auth.currentUser?.email ?? '';
  static String get userName => _auth.currentUser?.displayName ?? '사용자';

  // =============================================================================
  // 인증 관련 메서드들
  // =============================================================================

  /// 회원가입
  static Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    List<String> interests = const [], // 새로 추가된 매개변수
  }) async {
    try {
      fba.UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        await result.user!.updateDisplayName(name);

        await _usersCollection.doc(result.user!.uid).set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
          'postCount': 0,
          'likeCount': 0,
          'interests': interests, // Firestore에 저장
          'preferences': {},
        });

        return null;
      }

      return '회원가입에 실패했습니다.';
    } on fba.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          return '비밀번호가 너무 약합니다.';
        case 'email-already-in-use':
          return '이미 사용 중인 이메일입니다.';
        case 'invalid-email':
          return '올바르지 않은 이메일 형식입니다.';
        default:
          return '회원가입 중 오류가 발생했습니다: ${e.message}';
      }
    } catch (e) {
      return '회원가입 중 오류가 발생했습니다.';
    }
  }

  /// 로그인
  static Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (currentUserId != null) {
        await _usersCollection.doc(currentUserId).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      }

      return null;
    } on fba.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return '존재하지 않는 계정입니다.';
        case 'wrong-password':
          return '비밀번호가 올바르지 않습니다.';
        case 'invalid-email':
          return '올바르지 않은 이메일 형식입니다.';
        case 'user-disabled':
          return '비활성화된 계정입니다.';
        default:
          return '로그인 중 오류가 발생했습니다: ${e.message}';
      }
    } catch (e) {
      return '로그인 중 오류가 발생했습니다.';
    }
  }

  /// 로그아웃
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  /// 비밀번호 재설정
  static Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on fba.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return '존재하지 않는 계정입니다.';
        case 'invalid-email':
          return '올바르지 않은 이메일 형식입니다.';
        default:
          return '비밀번호 재설정 중 오류가 발생했습니다.';
      }
    } catch (e) {
      return '비밀번호 재설정 중 오류가 발생했습니다.';
    }
  }

  // =============================================================================
  // 사용자 프로필 관련
  // =============================================================================

  /// 사용자 프로필 가져오기
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (currentUserId == null) return null;
      DocumentSnapshot<Map<String, dynamic>> doc = await _usersCollection.doc(currentUserId).get();
      return doc.data();
    } catch (e) {
      print('프로필 조회 오류: $e');
      return null;
    }
  }

  /// 사용자 프로필 업데이트
  static Future<String?> updateUserProfile({
    String? name,
    String? bio,
    String? profileImage,
  }) async {
    try {
      if (currentUserId == null) return '로그인이 필요합니다.';
      Map<String, dynamic> updateData = {};
      if (name != null) updateData['name'] = name;
      if (bio != null) updateData['bio'] = bio;
      if (profileImage != null) updateData['profileImage'] = profileImage;
      if (updateData.isNotEmpty) {
        await _usersCollection.doc(currentUserId).update(updateData);
        if (name != null) {
          await _auth.currentUser?.updateDisplayName(name);
        }
      }
      return null;
    } catch (e) {
      print('프로필 업데이트 오류: $e');
      return '프로필 업데이트에 실패했습니다.';
    }
  }

  // =============================================================================
  // 블로그 포스트 관련
  // =============================================================================

  /// 블로그 포스트 저장
  static Future<String?> saveBlogPost({
    required String title,
    required String content,
    required String emotion,
    required String experience,
  }) async {
    try {
      if (currentUserId == null) return '로그인이 필요합니다.';

      final newPost = BlogPost(
        id: '',
        title: title,
        content: content,
        authorId: currentUserId!,
        authorName: userName,
        emotion: emotion,
        experience: experience,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        likeCount: 0,
        likedBy: [],
        tags: [emotion, experience],
      );

      await _postsCollection.add(newPost);
      await _usersCollection.doc(currentUserId).update({
        'postCount': FieldValue.increment(1),
      });

      return null;
    } catch (e) {
      print('포스트 저장 오류: $e');
      return '게시글 저장에 실패했습니다.';
    }
  }

  /// 블로그 포스트 업데이트
  static Future<String?> updateBlogPost({
    required String postId,
    required String title,
    required String content,
    required String emotion,
    required String experience,
  }) async {
    try {
      if (currentUserId == null) return '로그인이 필요합니다.';
      await _postsCollection.doc(postId).update({
        'title': title,
        'content': content,
        'emotion': emotion,
        'experience': experience,
        'updatedAt': FieldValue.serverTimestamp(),
        'tags': [emotion, experience],
      });
      return null;
    } catch (e) {
      print('포스트 업데이트 오류: $e');
      return '게시글 수정에 실패했습니다.';
    }
  }

  /// 블로그 포스트 삭제
  static Future<String?> deleteBlogPost(String postId) async {
    try {
      if (currentUserId == null) return '로그인이 필요합니다.';
      await _postsCollection.doc(postId).delete();
      await _usersCollection.doc(currentUserId).update({
        'postCount': FieldValue.increment(-1),
      });
      return null;
    } catch (e) {
      print('포스트 삭제 오류: $e');
      return '게시글 삭제에 실패했습니다.';
    }
  }

  /// 모든 블로그 포스트 가져오기
  static Stream<QuerySnapshot<BlogPost>> getAllBlogPosts() {
    return _postsCollection
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// 감정별 블로그 포스트 가져오기
  static Stream<QuerySnapshot<BlogPost>> getBlogPostsByEmotion(String emotion) {
    return _postsCollection
        .where('emotion', isEqualTo: emotion)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// 인기 블로그 포스트 가져오기
  static Stream<QuerySnapshot<BlogPost>> getPopularBlogPosts({int limit = 10}) {
    return _postsCollection
        .orderBy('likeCount', descending: true)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots();
  }

  /// 사용자의 블로그 포스트 가져오기
  static Stream<QuerySnapshot<BlogPost>> getUserBlogPosts({int? limit}) {
    fba.User? user = _auth.currentUser;
    if (user == null) {
      return Stream.empty();
    }
    Query<BlogPost> query = _postsCollection
        .where('authorId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true);
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots();
  }

  // =============================================================================
  // 좋아요 관련
  // =============================================================================

  /// 좋아요 토글
  static Future<void> toggleLike(String postId) async {
    if (currentUserId == null) return;
    DocumentReference<BlogPost> postRef = _postsCollection.doc(postId);

    await _firestore.runTransaction((transaction) async {
      final postSnapshot = await transaction.get(postRef);
      if (postSnapshot.exists) {
        final post = postSnapshot.data()!;
        final likedBy = List<String>.from(post.likedBy);
        if (likedBy.contains(currentUserId)) {
          likedBy.remove(currentUserId);
        } else {
          likedBy.add(currentUserId!);
        }
        transaction.update(postRef, {
          'likedBy': likedBy,
          'likeCount': likedBy.length,
        });
      }
    });
  }

  /// 사용자가 좋아요한 게시글인지 확인
  static Future<bool> isLikedByCurrentUser(String postId) async {
    if (currentUserId == null) return false;
    try {
      final doc = await _postsCollection.doc(postId).get();
      if (doc.exists) {
        final post = doc.data()!;
        return post.likedBy.contains(currentUserId);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 좋아한 게시글 목록 가져오기
  static Stream<QuerySnapshot<BlogPost>> getLikedPosts() {
    if (currentUserId == null) {
      return Stream.empty();
    }
    return _postsCollection
        .where('likedBy', arrayContains: currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // =============================================================================
  // 댓글 관련
  // =============================================================================

  /// 댓글 추가
  static Future<String?> addComment({
    required String postId,
    required String content,
  }) async {
    try {
      if (currentUserId == null) return '로그인이 필요합니다.';
      final newComment = Comment(
        id: '',
        postId: postId,
        content: content,
        authorId: currentUserId!,
        authorName: userName,
        createdAt: Timestamp.now(),
        likeCount: 0,
        likedBy: [],
      );
      await _commentsCollection.add(newComment);
      return null;
    } catch (e) {
      print('댓글 추가 오류: $e');
      return '댓글 작성에 실패했습니다.';
    }
  }

  /// 댓글 목록 가져오기
  static Stream<QuerySnapshot<Comment>> getComments(String postId) {
    return _commentsCollection
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  // =============================================================================
  // 챗봇 관련 메서드들
  // =============================================================================

  /// LLM API를 통한 챗봇 응답 생성
  static Future<String> getChatbotResponse(String userMessage) async {
    try {
      await Future.delayed(Duration(seconds: 1, milliseconds: 500));
      return _generateSampleResponse(userMessage);
    } catch (error) {
      print('챗봇 응답 생성 오류: $error');
      return '죄송합니다. 일시적인 오류가 발생했습니다. 다시 시도해주세요.';
    }
  }

  /// 샘플 응답 생성 (실제 LLM 대신 사용)
  static String _generateSampleResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('좋아요') || lowerMessage.contains('기분이 좋') || lowerMessage.contains('행복')) {
      return """기분이 좋으시다니 정말 멋져요! 🎉
이런 즐거운 대전 문화체험은 어떠세요?
🎨 **은행동 예술공방 도자기 체험**
• 소상공인: 김민수 작가님
• 📍 대전 중구 은행동 123-45
• ⏰ 매주 토요일 오후 2시-5시 (3시간)
• 💰 25,000원
• 👥 최대 8명 (친구와 함께 참여 가능)
창의적인 활동으로 좋은 기분을 더욱 업그레이드해보세요! 직접 만든 도자기를 가져갈 수 있어요.""";
    }

    if (lowerMessage.contains('우울') || lowerMessage.contains('슬프') || lowerMessage.contains('힘들')) {
      return """마음이 힘드시는군요... 😔 괜찮아요, 천천히 회복해나가면 됩니다.
마음을 달래줄 따뜻한 체험을 추천드려요:
🍞 **성심당 전통 베이킹 클래스**
• 전통 베이커리 체험 · 마음치유 프로그램
• 📍 대전 중구 대흥동 성심당 본점 2층
• ⏰ 평일 오전 10시-1시 (3시간)
• 💰 35,000원 (재료비 포함)
• 🤗 혼자 참여해도 편안한 분위기
따뜻한 빵을 만들며 마음도 따뜻해져보세요. 집중하다 보면 마음이 차분해질 거예요.""";
    }

    if (lowerMessage.contains('불안') || lowerMessage.contains('걱정') || lowerMessage.contains('스트레스')) {
      return """불안한 마음이 드시는군요 🫂 마음을 진정시키는 체험을 찾아드릴게요:
🧘‍♀️ **대청호반 힐링 명상 체험**
• 자연 속 마음챙김 프로그램
• 📍 대전 대덕구 대청호 생태공원
• ⏰ 매일 오전 9시-11시 / 오후 3시-5시
• 💰 15,000원
• 🌿 소규모 그룹 (최대 6명)
자연의 소리를 들으며 마음을 차분히 가라앉혀보세요. 전문 명상 지도사가 함께합니다.""";
    }

    if (lowerMessage.contains('화') || lowerMessage.contains('짜증') || lowerMessage.contains('분노')) {
      return """화가 나는 일이 있으셨군요 😤 스트레스를 건강하게 풀 수 있는 체험을 추천드려요:
🥊 **태권도원 전통 무예 체험**
• 스트레스 해소 · 전통 무예 배우기
• 📍 대전 유성구 태권도원
• ⏰ 매주 화/목/토 오후 7시-9시
• 💰 20,000원
• 💪 체력 상관없이 누구나 참여 가능
몸을 움직이며 건강하게 스트레스를 풀어보세요!""";
    }

    return """안녕하세요! 😊 대전시의 다양한 문화체험을 추천해드릴 수 있어요.
현재 기분이나 원하는 활동을 알려주시면:
• 🎨 예술/공예 체험
• 🍳 요리/베이킹 클래스  
• 🌿 자연/힐링 프로그램
• 🏛️ 전통문화 체험
• 🎵 음악/공연 관람
맞춤 추천을 해드릴게요! 어떤 기분이신지 자유롭게 말씀해주세요.""";
  }

  /// 대화 내역 저장
  static Future<String?> saveChatHistory(List<ChatMessage> messages) async {
    try {
      if (currentUserId == null) return '로그인이 필요합니다.';
      await _chatHistoriesCollection
          .doc(currentUserId)
          .collection('sessions')
          .add({
        'messages': messages.map((msg) => msg.toJson()).toList(),
        'createdAt': FieldValue.serverTimestamp(),
        'messageCount': messages.length,
      });
      return null;
    } catch (error) {
      print('대화 저장 오류: $error');
      return '대화 저장에 실패했습니다.';
    }
  }

  /// 사용자 일일 기분 저장
  static Future<String?> saveDailyMood(String mood, {String? note}) async {
    try {
      if (currentUserId == null) return '로그인이 필요합니다.';
      final today = DateTime.now();
      final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      await _dailyMoodsCollection
          .doc(currentUserId)
          .collection('daily_moods')
          .doc(dateKey)
          .set({
        'mood': mood,
        'note': note,
        'timestamp': FieldValue.serverTimestamp(),
        'date': dateKey,
      }, SetOptions(merge: true));
      return null;
    } catch (error) {
      print('기분 저장 오류: $error');
      return '기분 저장에 실패했습니다.';
    }
  }

  /// 추천받은 문화체험 저장
  static Future<String?> saveRecommendedExperience({
    required String title,
    required String organizer,
    required String location,
    required String category,
    required String mood,
  }) async {
    try {
      if (currentUserId == null) return '로그인이 필요합니다.';
      final newExperience = SavedExperience(
        id: '',
        userId: currentUserId!,
        title: title,
        organizer: organizer,
        location: location,
        category: category,
        mood: mood,
        savedAt: Timestamp.now(),
      );
      await _savedExperiencesCollection.add(newExperience);
      return null;
    } catch (error) {
      print('체험 저장 오류: $error');
      return '체험 저장에 실패했습니다.';
    }
  }

  /// 저장된 문화체험 목록 가져오기
  static Stream<QuerySnapshot<SavedExperience>> getSavedExperiences() {
    if (currentUserId == null) {
      return Stream.empty();
    }
    return _savedExperiencesCollection
        .where('userId', isEqualTo: currentUserId)
        .orderBy('savedAt', descending: true)
        .snapshots();
  }

  /// 사용자 기분 통계 가져오기
  static Future<Map<String, int>> getMoodStatistics() async {
    try {
      if (currentUserId == null) return {};
      final snapshot = await _dailyMoodsCollection
          .doc(currentUserId)
          .collection('daily_moods')
          .get();
      Map<String, int> moodCounts = {};
      for (var doc in snapshot.docs) {
        String mood = doc.data()['mood'] ?? '';
        moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
      }
      return moodCounts;
    } catch (error) {
      print('기분 통계 조회 오류: $error');
      return {};
    }
  }

  /// AI 피드백 저장
  static Future<String?> saveAIFeedback(String feedback, {double? rating}) async {
    try {
      await _aiFeedbackCollection.add({
        'userId': currentUserId,
        'feedback': feedback,
        'rating': rating,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return null;
    } catch (error) {
      print('피드백 저장 오류: $error');
      return '피드백 저장에 실패했습니다.';
    }
  }
}
