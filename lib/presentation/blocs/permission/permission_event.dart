part of 'permission_bloc.dart';

abstract class PermissionHandlerEvent extends Equatable {
  const PermissionHandlerEvent();

  @override
  List<Object> get props => [];
}

class RequestPermissionEvent extends PermissionHandlerEvent {
  final PermissionType type;

  const RequestPermissionEvent(this.type);

  @override
  List<Object> get props => [type];
}

class CheckPermissionStatusEvent extends PermissionHandlerEvent {
  final PermissionType type;

  const CheckPermissionStatusEvent(this.type);

  @override
  List<Object> get props => [type];
}
