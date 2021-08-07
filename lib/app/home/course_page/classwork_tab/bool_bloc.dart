import 'package:flutter_bloc/flutter_bloc.dart';

class BoolCubit extends Cubit<int> {
  BoolCubit() : super(0);

  void truthify() => emit(state +1);
  void falsify() => emit(state-1);


}
