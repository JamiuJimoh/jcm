import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class BoolBloc {
  final _boolBehaviorSubject = BehaviorSubject<bool>();

  Stream<bool> get boolStream => _boolBehaviorSubject.stream;
  void addBoolVal() => _boolBehaviorSubject.add(true);
  void dispose() {
    _boolBehaviorSubject.close();
  }
}
