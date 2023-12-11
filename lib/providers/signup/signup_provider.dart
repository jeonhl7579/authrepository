import 'package:fb_auth_provider/providers/signup/signup_state.dart';
import 'package:fb_auth_provider/repositories/authrepository.dart';
import 'package:flutter/material.dart';

import '../../models/custom_error.dart';

class SignupProvider with ChangeNotifier{
  SignupState _state=SignupState.initial();

  SignupState get state => _state;

  final AuthRepository authRepository;

  SignupProvider({
    required this.authRepository,
  });

  Future<void> signup({required String name, required String email,required String password}) async {
    _state=_state.copyWith(signupstatus: SignupStatus.submitting);
    notifyListeners();

    try{
      await authRepository.signup(name:name ,email: email,password: password);
      _state=_state.copyWith(signupstatus: SignupStatus.success);
      notifyListeners();
    }on CustomError catch(e){
      _state=_state.copyWith(signupstatus: SignupStatus.error,error: e);
      notifyListeners();
      rethrow;
    }

  }
}