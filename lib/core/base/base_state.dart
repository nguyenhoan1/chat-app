import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_bloc_template/core/base/base_view.dart';

// This class has purpose to customize the State class with RouteAware and BaseView
abstract class BaseState<T extends StatefulWidget> extends State<T>
    with RouteAware
    implements BaseView {}
