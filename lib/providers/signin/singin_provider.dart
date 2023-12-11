import 'package:fb_auth_provider/providers/signin/singin_state.dart';
import 'package:fb_auth_provider/repositories/authrepository.dart';
import 'package:flutter/material.dart';

import '../../models/custom_error.dart';

class SigninProvider with ChangeNotifier{
  SignupState _state=SignupState.initial();

  SignupState get state => _state;

  final AuthRepository authRepository;

  SigninProvider({
    required this.authRepository,
  });

  Future<void> signin({required String email,required String password}) async {
    _state=_state.copyWith(signinstatus: SigninStatus.submitting);
    notifyListeners();

    try{
      await authRepository.signin(email: email,password: password);
      _state=_state.copyWith(signinstatus: SigninStatus.success);
      notifyListeners();
    }on CustomError catch(e){
      _state=_state.copyWith(signinstatus: SigninStatus.error,error: e);
      notifyListeners();
      rethrow;
    }

  }
}