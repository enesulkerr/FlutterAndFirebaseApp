import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ilk_proje/screens/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter_ilk_proje/service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 50,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text("Email"),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black12)),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                          hintText: "Email giriniz...",
                          filled: true,
                          fillColor: Colors.blueGrey.shade50),
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text("Parola"),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    decoration:
                        BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20), topRight:  Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20),
                          ),
                          border: Border.all(color: Colors.black12),),
                    child: TextFormField(
                      decoration: const InputDecoration(border: InputBorder.none),
                      controller: _passwordController,
                      obscureText: true,
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: 150,
                      child: ElevatedButton(
                          onPressed: giris, child: const Text("Giriş"),),),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: kayitOl,
                      child: const Text("Kayıt Ol"),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _prefs.then((pref) {
      _emailController.text = pref.getString("Email")!;
      _passwordController.text = pref.getString("Parola")!;
    });
  }

  void giris() async {
    final prefs = await _prefs;
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      prefs.setString("Email", email);
      prefs.setString("Parola", password);

      try {
        var authService = AuthService();
        User? user = await authService.signIn(email, password);

        if (user != null) {
          // Kullanıcı girişi başarılı
          // Burada anasayfaya yönlendirme kodunu ekleyebilirsiniz
          Navigator.of(context).pushReplacementNamed("/index",arguments: email);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Sunucuya bağlanılamadı")));
          // Kullanıcı girişi başarısız
          // Hata mesajını kullanıcıya gösterebilirsiniz
        }
      } catch (error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Bir hata oluştu")));
        // Hata oluştu
        // Hata mesajını kullanıcıya gösterebilirsiniz
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen e-posta ve parola giriniz")),
      );
    }
  }

  void kayitOl() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil("/register", (route) => false);
  }
}
