import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ilk_proje/screens/login.dart';
import 'package:flutter_ilk_proje/service/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _parola = TextEditingController();
  final TextEditingController _parolaKontrol = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text("Kullanıcı Adı"),
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12)),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              hintText: "Lütfen geçerli bir email giriniz...",
                              filled: true,
                              fillColor: Colors.blueGrey.shade50),
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("Parola"),
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12)),
                        child: TextFormField(
                          controller: _parola,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Lütfen parolanızı giriniz';
                            }
                            if (value.length < 6) {
                              return 'Parolanız 6 karakterden küçük olamaz';
                            }
                            return null;
                          },
                          obscureText: true,
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("Parolayı onayla"),
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12)),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Lütfen parola tekrarını giriniz';
                            }
                            if (value.length < 6) {
                              return 'Parola tekrarı 6 karakterden küçük olamaz';
                            }
                            if (value != _parola.text) {
                              return "Parola eşleşmiyor";
                            }
                            return null;
                          },
                          controller: _parolaKontrol,
                          obscureText: true,
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: kayitOldun,
                            child: const Text("Kayıt Ol"),
                          ),
                        ),
                        Container(
                          width:  150,
                          child: ElevatedButton(onPressed: geriGit, child: const Text("Geri gel")),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }






  void kayitOldun() async {

    final email = _emailController.text;
    final password = _parola.text;

    if (email.isNotEmpty && password.isNotEmpty) {

      try {
        var authService = AuthService();
        User? user = await authService.createPerson(email, password);

        if (user != null) {
          // Kullanıcı girişi başarılı
          // Burada anasayfaya yönlendirme kodunu ekleyebilirsiniz
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
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

  void geriGit () {
    Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
  }
}
