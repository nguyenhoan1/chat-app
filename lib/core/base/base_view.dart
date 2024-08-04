import 'package:flutter/material.dart';

/// This is Base Structure of Writing Presentation View
/// Bloc -> State Management
/// BodyView -> The View of Presentation UI
/// FooterView -> Bottom Part of Presentation UI

abstract class BaseView {
  Widget bloc();
  Widget bodyView();
  Widget footerView();
}
