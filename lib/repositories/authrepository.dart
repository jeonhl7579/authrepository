
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/custom_error.dart';
import '../constants/db_constants.dart';

//FirebaseAuth와 통신하는 부분
class AuthRepository{
  final FirebaseFirestore firebaseFirestore;
  final fbAuth.FirebaseAuth firebaseAuth;

  const AuthRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  Stream<fbAuth.User?> get user=>firebaseAuth.userChanges();

  Future<void> signup({required String name,required String email,required String password}) async {
    // fbAuth의 에러와 그냥 에러를 분리하여 처리
    try{
      final fbAuth.UserCredential userCredential=await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // try에서 코드가 진행되는것은 옳게 생성됬다는 뜻이므로 user는 non nullable
      final signedInUser=userCredential.user!;
      await usersRef.doc(signedInUser.uid).set({
        'name':name,
        "email":email,
        "profileImage": "https://picsum.photos/300",
        "point":0,
        "rank":"bronze",
      });
    } on fbAuth.FirebaseAuthException catch(e){
      throw CustomError(code:e.code,message: e.message!,plugin: e.plugin);
    } catch(e){
      throw CustomError(code:"Exception",message: e.toString(),plugin: 'flutter_error/server_error');
    }

  }

  Future<void> signin({required String email,required String password}) async {
    try{
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      // 맞게 실행되면 user의 값이 변경되어 stream으로 전송됨
    }on fbAuth.FirebaseAuthException catch(e){
      throw CustomError(code:e.code,message: e.message!,plugin: e.plugin);
    } catch(e){
      throw CustomError(code:"Exception",message: e.toString(),plugin: 'flutter_error/server_error');
    }
  }

  Future<void> signout() async {
    await firebaseAuth.signOut();
  }
}
