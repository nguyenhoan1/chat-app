import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  final String id;
  final String userId;
  final String mediaUrl;
  final String mediaType; 
  final String caption;
  final String visibility;
  final DateTime createdAt;
  final DateTime expireAt;
  final int duration;

  Story({
    required this.id,
    required this.userId,
    required this.mediaUrl,
    required this.mediaType,
    required this.caption,
    required this.visibility,
    required this.createdAt,
    required this.expireAt,
    required this.duration,
  });

  factory Story.fromJson(Map<String, dynamic> json) => Story(
        id: json['id'],
        userId: json['userId'],
        mediaUrl: json['mediaUrl'],
        mediaType: json['mediaType'],
        caption: json['caption'],
        visibility: json['visibility'],
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        expireAt: (json['expireAt'] as Timestamp).toDate(),
        duration: json['duration'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'mediaUrl': mediaUrl,
        'mediaType': mediaType,
        'caption': caption,
        'visibility': visibility,
        'createdAt': createdAt,
        'expireAt': expireAt,
        'duration': duration,
      };
}
