import 'package:equatable/equatable.dart';

import '../../models/custom_error.dart';

enum SigninStatus{
  initial,
  submitting,
  success,
  error
}

class SignupState extends Equatable{
  final SigninStatus signinstatus;
  final CustomError error;

  const SignupState({
    required this.signinstatus,
    required this.error,
  });

  factory SignupState.initial(){
    return SignupState(signinstatus: SigninStatus.initial, error: CustomError());
  }

  @override
  // TODO: implement props
  List<Object?> get props => [signinstatus,error];



  @override
  String toString() {
    return 'SigninState{signinState: $signinstatus, error: $error}';
  }

  SignupState copyWith({
    SigninStatus? signinstatus,
    CustomError? error,
  }) {
    return SignupState(
      signinstatus: signinstatus ?? this.signinstatus,
      error: error ?? this.error,
    );
  }
}