import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    // get argument from navigator
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Stack(children: [
        Image.memory(args["foto"] as Uint8List),
        Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 150,
                  child: ElevatedButton(
                      onPressed: () async {
                        // post image to server with http
                        var imageEncoded =
                            base64Encode(args["foto"] as Uint8List);
                        try {
                          _prefs.then((value) {
                            var fotolar = value.getStringList("fotograflar");
                            if (fotolar == null) {
                              fotolar = [];
                            }

                            fotolar.add(args["adres"]);

                            value.setStringList("fotograflar", fotolar);
                          });
                          final response = await http.post(
                              Uri.parse("http://localhost:5000/kontrolet"),
                              body: jsonEncode({"resim": imageEncoded}));
                          final responseJson = json.decode(response.body);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(responseJson["sonuc"])));
                        } on SocketException {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Sunucuya bağlanılamadı")));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Bir hata oluştu")));
                        }
                      },
                      child: const Text("Kontrol Et")),
                ),
                Container(
                  width: 150,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Yeniden Çek")),
                ),
              ],
            ))
      ])),
    );
  }
}
