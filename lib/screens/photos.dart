
import 'package:firebase_storage/firebase_storage.dart';
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
    load();

    // Firebase Storage bağlantısını başlat

    // İlgili klasördeki dosyaların referansını al

  }


  void load() async {

    var value = await _prefs;
    var email = value.getString("Email");
    FirebaseStorage storage = FirebaseStorage.instance;
    ListResult result = await storage.ref().child(email!).listAll();
    // Dosyaların download URL'lerini al
    for (Reference ref in result.items) {
      String url = await ref.getDownloadURL();
      setState(() {
        fotograflar!.add(url);
      });
    }

    // Download URL'leri yazdır
    print('Download URLs for files in "your_folder":');
    for (String url in fotograflar!) {
      print(url);
    }
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
                        child: Image.network(e, fit: BoxFit.cover),
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
