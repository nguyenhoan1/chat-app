part of 'permission_bloc.dart';

abstract class PermissionHandlerState extends Equatable {
  const PermissionHandlerState();

  @override
  List<Object> get props => [];
}

class PermissionHandlerInitial extends PermissionHandlerState {}

class PermissionHandlerLoading extends PermissionHandlerState {}

class CheckPermissionHandlerLoading extends PermissionHandlerState {}

class PermissionHandlerSuccess extends PermissionHandlerState {
  final PermissionType type;
  final bool isGranted;

  const PermissionHandlerSuccess({
    required this.type,
    required this.isGranted,
  });

  @override
  List<Object> get props => [type, isGranted];
}

class CheckPermissionHandlerSuccess extends PermissionHandlerState {
  final PermissionType type;
  final bool isGranted;

  CheckPermissionHandlerSuccess({required this.type, required this.isGranted});

  @override
  List<Object> get props => [type, isGranted];
}

class PermissionHandlerFailed extends PermissionHandlerState {
  final PermissionType type;
  final bool isGranted;

  const PermissionHandlerFailed({
    required this.type,
    required this.isGranted,
  });

  @override
  List<Object> get props => [type, isGranted];
}

class CheckPermissionHandlerFailed extends PermissionHandlerState {
  final PermissionType type;
  final bool isGranted;

  CheckPermissionHandlerFailed({required this.type, required this.isGranted});
  @override
  List<Object> get props => [type, isGranted];
}

class PermissionHandlerError extends PermissionHandlerState {
  final String message;

  const PermissionHandlerError(this.message);

  @override
  List<Object> get props => [message];
}

class CheckPermissionHandlerError extends PermissionHandlerState {
  final String message;

  CheckPermissionHandlerError({required this.message});
  @override
  List<Object> get props => [message];
}
