import '../../../core/network/usecase.dart';
import '../../entities/permission/permission_type.dart';
import '../../repositories/permission/permission_repository.dart';

class CheckPermissionStatusUseCase implements UseCase<bool, PermissionType> {
  final PermissionRepository repository;

  CheckPermissionStatusUseCase(this.repository);

  @override
  Future<bool> call(PermissionType params) async {
    return await execute(params);
  }

  Future<bool> execute(PermissionType type) async {
    return await repository.checkPermissionStatus(type);
  }
}