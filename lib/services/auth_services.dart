import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> cadastroUser({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: senha);

      await userCredential.user!.updateDisplayName(nome);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "O usuário já existe!";
      }
      return "Erro desconhecido";
    }
  }

  Future<String?> entrarUser({
    required String email,
    required String senha
})async{
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: senha);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found" || e.code == "wrong-password") {
        return "Email ou senha incorretos!";
      }
      return "Email ou senha incorretos!";
    }
  }

  Future<void> logoutUser(){
    return _firebaseAuth.signOut();
  }

}