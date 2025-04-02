import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_clean_architecture_bloc_template/data/models/upload_stories/upload_stories_model.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/upload_stories/stories_upload_event.dart';
import 'package:flutter_clean_architecture_bloc_template/presentation/blocs/upload_stories/stories_upload_state.dart';
import 'package:flutter_clean_architecture_bloc_template/core/services/cloudinary_service.dart';

class StoryUploadBloc extends Bloc<StoryUploadEvent, StoryUploadState> {
  StoryUploadBloc() : super(StoryUploadInitialState()) {
    on<StoryUploadStartedEvent>(_onUploadStory);
  }

  Future<void> _onUploadStory(
    StoryUploadStartedEvent event,
    Emitter<StoryUploadState> emit,
  ) async {
    emit(StoryUploadLoadingState());

    try {
      final String? mediaUrl = await CloudinaryService.uploadFile(event.file);
      if (mediaUrl == null) {
        emit(StoryUploadFailureState("Upload media thất bại"));
        return;
      }

      final String id = const Uuid().v4();
      final DateTime now = DateTime.now();
      final DateTime expireAt = now.add(const Duration(hours: 24));

      final Story story = Story(
        id: id,
        userId: event.userId,
        mediaUrl: mediaUrl,
        mediaType: event.mediaType,
        caption: event.caption,
        visibility: event.visibility,
        createdAt: now,
        expireAt: expireAt,
        duration: event.duration.inSeconds,
      );

      await FirebaseFirestore.instance
          .collection('stories')
          .doc(id)
          .set(story.toJson());

      emit(StoryUploadSuccessState());
    } catch (e) {
      emit(StoryUploadFailureState(e.toString()));
    }
  }
}
