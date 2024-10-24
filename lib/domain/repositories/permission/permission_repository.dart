import 'package:flutter_clean_architecture_bloc_template/domain/entities/permission/permission_type.dart';

abstract class PermissionRepository {
  Future<bool> requestCameraPermission();
  Future<bool> checkPermissionStatus(PermissionType type);
}