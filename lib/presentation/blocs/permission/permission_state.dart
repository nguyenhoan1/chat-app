part of 'permission_bloc.dart';

abstract class PermissionHandlerState extends Equatable {
  const PermissionHandlerState();

  @override
  List<Object> get props => [];
}

class PermissionHandlerInitial extends PermissionHandlerState {}

class PermissionHandlerLoading extends PermissionHandlerState {}

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

class PermissionHandlerError extends PermissionHandlerState {
  final String message;

  const PermissionHandlerError(this.message);

  @override
  List<Object> get props => [message];
}
