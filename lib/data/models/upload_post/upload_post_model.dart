import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPostModel {
  final String id;
  final String userId;
  final List<String> mediaUrls;
  final String caption;
  final String location;
  final String visibility;
  final String media_type;
  final Timestamp created_at;

  UploadPostModel({
    required this.id,
    required this.userId,
    required this.mediaUrls,
    required this.caption,
    required this.location,
    required this.visibility,
    required this.media_type,
    required this.created_at,
  });

  factory UploadPostModel.fromJson(Map<String, dynamic> json) {
    return UploadPostModel(
        id: json['id'],
        userId: json['userId'],
         mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
        caption: json['caption'] ?? '',
        location: json['location'] ?? '',
        visibility: json['visibility'] ?? 'Public',
        media_type: json['media_type'] ?? 'image',
        created_at: json['created_at'] ?? Timestamp.now());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'mediaUrls': mediaUrls,
      'caption': caption,
      'location': location,
      'visibility': visibility,
      'media_type': media_type,
      'created_at': created_at,
    };
  }
}
