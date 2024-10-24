import 'package:flutter_clean_architecture_bloc_template/core/network/usecase.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/entities/permission/permission_type.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/repositories/permission/permission_repository.dart';

class RequestPermissionUseCase implements UseCase<bool, PermissionType> {
  final PermissionRepository repository;

  RequestPermissionUseCase(this.repository);

  @override
  Future<bool> call(PermissionType params) async {
    return await execute(params);
  }

  Future<bool> execute(PermissionType type) async {
    switch (type) {
      case PermissionType.camera:
        return await repository.requestCameraPermission();
    }
  }
}
