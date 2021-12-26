import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:devkitflutter/model/integration/login_model.dart';
import 'package:devkitflutter/network/api_provider.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if(event is Login){
      yield* _login(event.email, event.password, event.apiToken);
    }
  }
}

Stream<LoginState> _login(String email, password, apiToken) async* {
  ApiProvider _apiProvider = ApiProvider();

  yield LoginWaiting();
  try {
    List<LoginModel> data = await _apiProvider.login(email, password, apiToken);
    yield LoginSuccess(loginData: data);
  } catch (ex){
    if(ex != 'cancel'){
      yield LoginError(errorMessage: ex.toString());
    }
  }
}