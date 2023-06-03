import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ilk_proje/screens/login.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _kullaniciAdi = TextEditingController();
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
                          controller: _kullaniciAdi,
                          decoration: InputDecoration(
                              hintText: "Kullanıcı adını giriniz...",
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
    if (_formKey.currentState!.validate()) {
      if (_parola.text == _parolaKontrol.text) {
      } else {
        final snackBar = SnackBar(
          content: const Text('Şifren eşleşmiyor!'),
          action: SnackBarAction(
            label: 'Kapat',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      try {
        final response = await http.post(
            Uri.parse("http://localhost:5000/kayit"),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: jsonEncode(
                {"kullaniciAdi": _kullaniciAdi.text, "parola": _parola.text}));
        final responseJson = json.decode(response.body);
        if (responseJson["sonuc"] == "OK") {
          Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(responseJson["sonuc"])));
        }
      } on SocketException {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Sunucuya bağlanılamadı")));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Bir hata oluştu")));
      }
    }
  }

  void geriGit () {
    Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
  }
}
