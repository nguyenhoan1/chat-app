import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class StoryUploadEvent extends Equatable {
  const StoryUploadEvent();

  @override
  List<Object?> get props => [];
}

class StoryUploadStartedEvent extends StoryUploadEvent {
  final File file;
  final String mediaType; // 'image' or 'video'
  final String userId;
  final String visibility;
  final String caption;
  final Duration duration;

  const StoryUploadStartedEvent({
    required this.file,
    required this.mediaType,
    required this.userId,
    required this.visibility,
    required this.caption,
    required this.duration,
  });

  @override
  List<Object?> get props => [file, mediaType, userId, visibility, caption, duration];
}