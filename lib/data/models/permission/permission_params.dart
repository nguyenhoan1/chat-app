import 'package:equatable/equatable.dart';

import '../../../domain/entities/permission/permission_type.dart';

class RequestPermissionParams extends Equatable {
  final PermissionType type;

  const RequestPermissionParams({required this.type});

  @override
  List<Object> get props => [type];
}