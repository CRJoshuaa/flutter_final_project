import 'package:flutter_bloc/flutter_bloc.dart';

class UsernameCubit extends Cubit<String> {
  UsernameCubit() : super('default_user');

  void setUsername(String username) {
    emit(username);
  }
}
