// lib/models.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogPost {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final String emotion;
  final String experience;
  final List<String> tags;
  final int likeCount;
  final List<String> likedBy;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final bool isLiked;

  BlogPost({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.emotion,
    required this.experience,
    required this.tags,
    required this.likeCount,
    required this.likedBy,
    required this.createdAt,
    required this.updatedAt,
    this.isLiked = false,
  });

  factory BlogPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return BlogPost(
      id: doc.id,
      title: data?['title'] as String? ?? '',
      content: data?['content'] as String? ?? '',
      authorId: data?['authorId'] as String? ?? '',
      authorName: data?['authorName'] as String? ?? '익명',
      emotion: data?['emotion'] as String? ?? '',
      experience: data?['experience'] as String? ?? '',
      tags: List<String>.from(data?['tags'] ?? []),
      likeCount: data?['likeCount'] as int? ?? 0,
      likedBy: List<String>.from(data?['likedBy'] ?? []),
      createdAt: data?['createdAt'] as Timestamp? ?? Timestamp.now(),
      updatedAt: data?['updatedAt'] as Timestamp? ?? Timestamp.now(),
      isLiked: false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'emotion': emotion,
      'experience': experience,
      'tags': tags,
      'likeCount': likeCount,
      'likedBy': likedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  BlogPost copyWith({
    String? id,
    String? title,
    String? content,
    String? authorId,
    String? authorName,
    String? emotion,
    String? experience,
    List<String>? tags,
    int? likeCount,
    List<String>? likedBy,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    bool? isLiked,
  }) {
    return BlogPost(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      emotion: emotion ?? this.emotion,
      experience: experience ?? this.experience,
      tags: tags ?? this.tags,
      likeCount: likeCount ?? this.likeCount,
      likedBy: likedBy ?? this.likedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class Comment {
  final String id;
  final String postId;
  final String content;
  final String authorId;
  final String authorName;
  final Timestamp createdAt;
  final int likeCount;
  final List<String> likedBy;

  Comment({
    required this.id,
    required this.postId,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    required this.likeCount,
    required this.likedBy,
  });

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return Comment(
      id: doc.id,
      postId: data?['postId'] as String? ?? '',
      content: data?['content'] as String? ?? '',
      authorId: data?['authorId'] as String? ?? '',
      authorName: data?['authorName'] as String? ?? '익명',
      createdAt: data?['createdAt'] as Timestamp? ?? Timestamp.now(),
      likeCount: data?['likeCount'] as int? ?? 0,
      likedBy: List<String>.from(data?['likedBy'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': createdAt,
      'likeCount': likeCount,
      'likedBy': likedBy,
    };
  }
}

class SavedExperience {
  final String id;
  final String userId;
  final String title;
  final String organizer;
  final String location;
  final String category;
  final String mood;
  final Timestamp savedAt;

  SavedExperience({
    required this.id,
    required this.userId,
    required this.title,
    required this.organizer,
    required this.location,
    required this.category,
    required this.mood,
    required this.savedAt,
  });

  factory SavedExperience.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return SavedExperience(
      id: doc.id,
      userId: data?['userId'] as String? ?? '',
      title: data?['title'] as String? ?? '',
      organizer: data?['organizer'] as String? ?? '',
      location: data?['location'] as String? ?? '',
      category: data?['category'] as String? ?? '',
      mood: data?['mood'] as String? ?? '',
      savedAt: data?['savedAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'organizer': organizer,
      'location': location,
      'category': category,
      'mood': mood,
      'savedAt': savedAt,
    };
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final Timestamp timestamp;
  final List<String>? suggestions;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.suggestions,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'] as String? ?? '',
      isUser: json['isUser'] as bool? ?? false,
      timestamp: json['timestamp'] as Timestamp,
      suggestions: json['suggestions'] != null
          ? List<String>.from(json['suggestions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp,
      'suggestions': suggestions,
    };
  }
}