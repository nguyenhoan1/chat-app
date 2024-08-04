import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_bloc_template/core/utility/utility.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);

    if (bloc is Cubit) {
      Utility.appLog(
          title: "AppBlocObserver - onCreated",
          message: "This is a Cubit ${bloc}");
    } else {
      Utility.appLog(
          title: "AppBlocObserver - onCreated",
          message: "This is a BLoC ${bloc}");
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    Utility.appLog(
        title: "AppBlocObserver - onEvent",
        message: "an event Happened in $bloc the event is $event");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    Utility.appLog(
        title: "AppBlocObserver - onTransition",
        message:
            "There was a transition from ${transition.currentState} to ${transition.nextState}");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    Utility.appLog(
        title: "AppBlocObserver - onError",
        message:
            "Error happened in $bloc with error $error and the stacktrace is $stackTrace");
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);

    Utility.appLog(
        title: "AppBlocObserver - onClose", message: "Bloc $bloc is closed.");
  }
}
