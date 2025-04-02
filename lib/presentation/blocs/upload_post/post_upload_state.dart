import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class PostUploadState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostUploadInitialState extends PostUploadState {}

class PostUploadLoadingState extends PostUploadState {}

class PostUploadSuccessState extends PostUploadState {}

class PostUploadFailureState extends PostUploadState {
  final String errorMessage;

  PostUploadFailureState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class PostUploadProgressState extends PostUploadState {
  final double progress;

  PostUploadProgressState(this.progress);

  @override
  List<Object?> get props => [progress];
}