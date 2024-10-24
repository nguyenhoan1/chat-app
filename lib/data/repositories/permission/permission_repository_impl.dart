import 'package:flutter_clean_architecture_bloc_template/domain/entities/permission/permission_type.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/repositories/permission/permission_repository.dart';
import 'package:permission_handler/permission_handler.dart' as handler;

class PermissionRepositoryImpl implements PermissionRepository {
  @override
  Future<bool> requestCameraPermission() async {
    final status = await handler.Permission.camera.request();
    return status.isGranted;
  }

  @override
  Future<bool> checkPermissionStatus(PermissionType type) async {
    handler.Permission permission;
    switch (type) {
      case PermissionType.camera:
        permission = handler.Permission.camera;
        break;
    }
    final status = await permission.status;
    return status.isGranted;
  }
}
