import 'package:equatable/equatable.dart';

import '../../models/custom_error.dart';

enum SignupStatus{
  initial,
  submitting,
  success,
  error
}

class SignupState extends Equatable{
  final SignupStatus signupstatus;
  final CustomError error;

  const SignupState({
    required this.signupstatus,
    required this.error,
  });

  factory SignupState.initial(){
    return SignupState(signupstatus: SignupStatus.initial, error: CustomError());
  }

  @override
  // TODO: implement props
  List<Object?> get props => [signupstatus,error];



  @override
  String toString() {
    return 'SigninState{signinState: $signupstatus, error: $error}';
  }

  SignupState copyWith({
    SignupStatus? signupstatus,
    CustomError? error,
  }) {
    return SignupState(
      signupstatus: signupstatus ?? this.signupstatus,
      error: error ?? this.error,
    );
  }
}