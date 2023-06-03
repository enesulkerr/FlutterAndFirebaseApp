import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({super.key});

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  List<String>? fotograflar = [];

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _prefs.then((value) {
      setState(() {
        fotograflar = value.getStringList("fotograflar");
        if (fotograflar == null) {
          fotograflar = [];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: fotograflar!.map((e) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      height: 250,
                      child: Center(
                        child: Image.file(File(e), fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
