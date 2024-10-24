import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/permission/permission_type.dart';
import '../../../domain/usecase/permission/check_permission_usecase.dart';
import '../../../domain/usecase/permission/request_permission_usecase.dart';

part 'permission_event.dart';
part 'permission_state.dart';

class PermissionHandlerBloc
    extends Bloc<PermissionHandlerEvent, PermissionHandlerState> {
  final RequestPermissionUseCase requestPermissionUseCase;
  final CheckPermissionStatusUseCase checkPermissionStatusUseCase;

  PermissionHandlerBloc({
    required this.requestPermissionUseCase,
    required this.checkPermissionStatusUseCase,
  }) : super(PermissionHandlerInitial()) {
    on<RequestPermissionEvent>(_onRequestPermission);
    on<CheckPermissionStatusEvent>(_onCheckPermissionStatus);
  }

  Future<void> _onRequestPermission(
    RequestPermissionEvent event,
    Emitter<PermissionHandlerState> emit,
  ) async {
    try {
      emit(PermissionHandlerLoading());
      final isGranted = await requestPermissionUseCase.execute(event.type);
      if (isGranted) {
        emit(PermissionHandlerSuccess(
          type: event.type,
          isGranted: isGranted,
        ));
      } else {
        emit(PermissionHandlerFailed(
          type: event.type,
          isGranted: isGranted,
        ));
      }
    } catch (e) {
      emit(PermissionHandlerError(e.toString()));
    }
  }

  Future<void> _onCheckPermissionStatus(
    CheckPermissionStatusEvent event,
    Emitter<PermissionHandlerState> emit,
  ) async {
    try {
      emit(PermissionHandlerLoading());
      final isGranted = await checkPermissionStatusUseCase.execute(event.type);
      emit(PermissionHandlerSuccess(
        type: event.type,
        isGranted: isGranted,
      ));
    } catch (e) {
      emit(PermissionHandlerError(e.toString()));
    }
  }
}
