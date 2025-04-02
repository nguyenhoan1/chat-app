part of 'post_upload_bloc.dart';


@immutable
abstract class PostUploadEvent {}

class PostUploadStartedEvent extends PostUploadEvent {
  final List<MediaItem> media;
  final String userId;
  final String caption;
  final String? location;
  final String visibility;

  PostUploadStartedEvent({
    required this.media,
    required this.userId,
    required this.caption,
    this.location,
    this.visibility = 'Public',
  });
}

enum MediaType { image, video }

class MediaItem {
  final File file;
  final MediaType type;
  final Duration? duration;

  MediaItem({
    required this.file,
    required this.type,
    this.duration,
  });
}
