import 'package:fb_auth_provider/repositories/authrepository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'auth_state.dart';

// provider 자체가 상태 변화될때 알려주는 상태관리하는 곳
// 여기서 signin과 singout이 필요함 그러므로 authrepository를 불러와야 한다.
class AuthProvider with ChangeNotifier{
  AuthState _state = AuthState.unknown();

  AuthState get state => _state;

  // AuthRepository의 user값을 필요로 하므로
  final AuthRepository authRepository;

  AuthProvider({
    required this.authRepository,
  });

  // user의 변화가 생길때마다 update시켜주는 함수
  void update(fbAuth.User? user){
    if(user != null){
      _state=_state.copyWith(authStatus: AuthStatus.authenticated,user:user);
    }else{
      _state=_state.copyWith(authStatus: AuthStatus.unauthenticated);
    }
    print("authState: $_state");
    notifyListeners();
  }


  void signout() async {
    await authRepository.signout();
  }
}