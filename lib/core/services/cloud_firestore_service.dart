import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_clean_architecture_bloc_template/core/services/cloudinary_service.dart';
import 'package:flutter_clean_architecture_bloc_template/data/models/upload_post/upload_post_model.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/upload_stories/upload_stories_model.dart';

Future<void> uploadMultipleMediaAsOnePost({
  required List<File> mediaFiles,
  required String userId,
  required String caption,
  required String mediaType,
  String? location,
  String visibility = 'Public',
}) async {
  try {
    List<String> uploadedUrls = [];

    for (var file in mediaFiles) {
      final url = await CloudinaryService.uploadFile(file);
      if (url != null) uploadedUrls.add(url);
    }

    if (uploadedUrls.isNotEmpty) {
      final post = UploadPostModel(
        id: const Uuid().v4(),
        userId: userId,
        mediaUrls: uploadedUrls,
        caption: caption,
        location: location ?? '',
        visibility: visibility,
        media_type: mediaType,
        created_at: Timestamp.now(),
      );

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .set(post.toJson());

      print('✅ Multi-media post uploaded successfully');
    }
  } catch (e) {
    print('🔥 Error uploading multi-media post: $e');
    rethrow;
  }
}
Future<Map<String, dynamic>?> getUserInfo(String uid) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  return doc.exists ? doc.data() : null;
}
Future<void> uploadStory(Story story) async {
  try {
    await FirebaseFirestore.instance
        .collection('stories')
        .doc(story.id)
        .set(story.toJson());
    print('✅ Story uploaded successfully');
  } catch (e) {
    print('🔥 Error uploading story: $e');
    rethrow;
  }
}