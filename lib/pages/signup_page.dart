import 'package:fb_auth_provider/models/custom_error.dart';
import 'package:fb_auth_provider/pages/signup_page.dart';
import 'package:fb_auth_provider/providers/signin/singin_state.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:provider/provider.dart';

import '../providers/signup/signup_provider.dart';
import '../utils/error_dialog.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  static const String routeName="/signup";

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey=GlobalKey<FormState>();
  // form이 한번 submit되기 전까지는 validation을 하지 않겠다.
  AutovalidateMode _autovalidateMode=AutovalidateMode.disabled;
  String? _name, _email,_password;
  final _passwordController=TextEditingController();

  void _submit() async {
    setState(() {
      _autovalidateMode=AutovalidateMode.always;
    });
    final form=_formKey.currentState;

    if(form == null || !form.validate()) return;
    form.save();
    print("name : $_name, email: $_email , password : $_password");

    //singinProvider에서 오류생기면 rethrow한 부분이 일로 옴
    try{
      await context.read<SignupProvider>().signup(name: _name!, email: _email!, password: _password!);
    } on CustomError catch(e){
      errorDialog(context,e);
    }

  }
  @override
  Widget build(BuildContext context) {
    final signupState=context.watch<SignupProvider>().state;
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: ListView(
              reverse: true,
              shrinkWrap: true,
              children: [
                Image.asset("assets/images/flutter_logo.png",width:250,height: 250,),
                SizedBox(height:20),
                TextFormField(
                  autocorrect: false,
                  decoration:InputDecoration(border:OutlineInputBorder(),filled: true,labelText: "Name",prefixIcon: Icon(Icons.account_box)),
                  validator: (String? value){
                    if(value ==null || value.trim().isEmpty){
                      return 'Name required';
                    }
                    //isEmail은 Validator 패키지 내의 내부함수
                    if(value.trim().length <2){
                      return 'Name must be at least 2 characters long';
                    }
                    // 모든 검증을 통과하면 null을 리턴
                    return null;
                  },
                  // submit 되었을 때
                  onSaved: (String? value){
                    _name=value;
                  },
                ),
                SizedBox(height:20),
                TextFormField(
                  keyboardType:TextInputType.emailAddress,
                  autocorrect: false,
                  decoration:InputDecoration(border:OutlineInputBorder(),filled: true,labelText: "Email",prefixIcon: Icon(Icons.email)),
                  validator: (String? value){
                    if(value ==null || value.trim().isEmpty){
                      return 'Email required';
                    }
                    //isEmail은 Validator 패키지 내의 내부함수
                    if(!isEmail(value.trim())){
                      return 'Enter a valid email';
                    }
                    // 모든 검증을 통과하면 null을 리턴
                    return null;
                  },
                  // submit 되었을 때
                  onSaved: (String? value){
                    _email=value;
                  },
                ),
                SizedBox(height:20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration:InputDecoration(border:OutlineInputBorder(),filled: true,labelText: "Password",prefixIcon: Icon(Icons.password)),
                  validator: (String? value){
                    if(value ==null || value.trim().isEmpty){
                      return 'Password required';
                    }
                    //isEmail은 Validator 패키지 내의 내부함수
                    if(value.trim().length < 6){
                      return 'Password must be at least 6 characters long';
                    }
                    // 모든 검증을 통과하면 null을 리턴
                    return null;
                  },
                  // submit 되었을 때
                  onSaved: (String? value){
                    _password=value;
                  },
                ),
                SizedBox(height:20),
                TextFormField(
                  obscureText: true,
                  decoration:InputDecoration(border:OutlineInputBorder(),filled: true,labelText: "Confirm Password",prefixIcon: Icon(Icons.password)),
                  validator: (String? value){
                    if(_passwordController.text!=value){
                      return 'Passwords not match';
                    }

                    // 모든 검증을 통과하면 null을 리턴
                    return null;
                  },
                ),
                SizedBox(height:20),
                ElevatedButton(
                    onPressed: signupState.signupstatus == SigninStatus.submitting? null: _submit,
                    child: Text(signupState.signupstatus == SigninStatus.submitting? "Loading......":"Sign Up"),
                    style:ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize:20,
                        fontWeight: FontWeight.w600,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    )),
                SizedBox(height:10),
                TextButton(onPressed: signupState.signupstatus == SigninStatus.submitting? null:(){
                  Navigator.pop(context);
                },child:Text("Already a member? Sign in!"),
                  style: TextButton.styleFrom(
                      textStyle: TextStyle(
                          fontSize:20,
                          decoration: TextDecoration.underline

                      )
                  ),
                )
              ].reversed.toList(),),
          ),
        )),
      ),
    );
  }
}
