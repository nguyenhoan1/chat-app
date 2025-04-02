import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/core/services/cloud_firestore_service.dart';
import 'package:meta/meta.dart';
import 'post_upload_state.dart';

part 'post_upload_event.dart';

class PostUploadBloc extends Bloc<PostUploadEvent, PostUploadState> {
  PostUploadBloc() : super(PostUploadInitialState()) {
    on<PostUploadStartedEvent>(_onPostUploadStarted);
  }

  Future<void> _onPostUploadStarted(
    PostUploadStartedEvent event,
    Emitter<PostUploadState> emit,
  ) async {
    emit(PostUploadLoadingState());
    try {
      await uploadMultipleMediaAsOnePost(
        mediaFiles: event.media.map((e) => e.file).toList(),
        userId: event.userId,
        caption: event.caption,
        location: event.location,
        visibility: event.visibility,
        mediaType:
            event.media.first.type == MediaType.video ? 'video' : 'image',
      );

      emit(PostUploadSuccessState());
    } catch (e) {
      emit(PostUploadFailureState(e.toString()));
    }
  }
}
