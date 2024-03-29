import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  //giriş yap fonksiyonu
  Future<User?> signIn(String email, String password) async {

    print("email : $email");
    print("email : $password");

    var user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,

    );
    return user.user; // Doğru dönüş değeri
  }


  //çıkış yap fonksiyonu
  signOut() async {
    return await _auth.signOut();
  }

  //kayıt ol fonksiyonu
  Future<User?> createPerson(String email, String password) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await _firestore
        .collection("Person")
        .doc(user.user!.uid)
        .set({'email': email, 'password': password });

    return user.user;
  }
}
