import 'package:equatable/equatable.dart';

abstract class StoryUploadState extends Equatable {
  const StoryUploadState();

  @override
  List<Object?> get props => [];
}

class StoryUploadInitialState extends StoryUploadState {}

class StoryUploadLoadingState extends StoryUploadState {}

class StoryUploadSuccessState extends StoryUploadState {}

class StoryUploadFailureState extends StoryUploadState {
  final String errorMessage;

  const StoryUploadFailureState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
