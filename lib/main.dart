import 'package:flutter/material.dart';
import 'package:flutter_ilk_proje/screens/index.dart';
import 'package:flutter_ilk_proje/screens/login.dart';
import 'package:flutter_ilk_proje/screens/preview.dart';
import 'package:flutter_ilk_proje/screens/register.dart';
import 'package:flutter_ilk_proje/screens/photos.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  Myapp({super.key});

  final TextEditingController kullaniciAdi = TextEditingController();
  final TextEditingController parola = TextEditingController();
  @override
  Widget build(BuildContext context) {
    debugPrint("build metodu çalıştı");
    return MaterialApp(
      title: "My Counter App",
      initialRoute: "/",
      routes: {
        "/": (context) => const LoginScreen(),
        "/index": (context) => const IndexScreen(),
        "/register": (context) => const RegisterScreen(),
        "/preview": (context) => const PreviewScreen(),
        "/photos": (context) => const PhotosScreen(),
      },
      theme: ThemeData(
          primarySwatch: Colors.purple,
          textTheme: const TextTheme(
              displayLarge: TextStyle(
                  color: Colors.purple, fontWeight: FontWeight.bold))),
    );
  }
}

Container dartDersleri() {
  return Container(
    decoration: const BoxDecoration(color: Colors.teal),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 50,
              color: Colors.red.shade200,
              child: const Center(
                  child: Text(
                "D",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              )),
            ),
            Container(
              width: 40,
              height: 50,
              color: Colors.red.shade200,
              child: const Center(child: Text("A")),
            ),
            Container(
              width: 40,
              height: 50,
              color: Colors.red.shade200,
              child: const Center(child: Text("R")),
            ),
            Container(
              width: 40,
              height: 50,
              color: Colors.red.shade200,
              child: const Center(child: Text("T")),
            ),
          ],
        ),
        Container(
          width: 40,
          height: 50,
          color: Colors.red.shade300,
          child: const Center(child: Text("E")),
        ),
        Container(
          width: 40,
          height: 50,
          color: Colors.red.shade400,
          child: const Center(child: Text("R")),
        ),
        Container(
          width: 40,
          height: 50,
          color: Colors.red.shade500,
          child: const Center(child: Text("S")),
        ),
        Container(
          width: 40,
          height: 50,
          color: Colors.red.shade600,
          child: const Center(child: Text("L")),
        ),
        Container(
          width: 40,
          height: 50,
          color: Colors.red.shade700,
          child: const Center(child: Text("E")),
        ),
        Container(
          width: 40,
          height: 50,
          color: Colors.red.shade800,
          child: const Center(child: Text("R")),
        ),
        Container(
          width: 40,
          height: 50,
          color: Colors.red.shade900,
          child: const Center(child: Text("İ")),
        ),
      ],
    ),
  );
}

List<Widget> get sorunluContainer {
  return [
    Container(
      width: 75,
      height: 75,
      color: Colors.yellow,
    ),
    Container(
      width: 75,
      height: 75,
      color: Colors.red,
    ),
    Container(
      width: 75,
      height: 75,
      color: Colors.blue,
    ),
    Container(
      width: 75,
      height: 75,
      color: Colors.orange,
    ),
    Container(
      width: 75,
      height: 75,
      color: Colors.red,
    ),
    Container(
      width: 75,
      height: 75,
      color: Colors.yellow,
    ),
  ];
}

List<Widget> get flexibleContainer {
  return [
    Flexible(
      flex: 2,
      child: Container(
        width: 200,
        height: 300,
        color: Colors.yellow,
      ),
    ),
    Flexible(
      flex: 2,
      child: Container(
        width: 200,
        height: 300,
        color: Colors.green,
      ),
    ),
    Flexible(
      flex: 2,
      child: Container(
        width: 200,
        height: 300,
        color: Colors.red,
      ),
    ),
  ];
}

List<Widget> get expandedContainer {
  return [
    Expanded(
      child: Container(
        width: 75,
        height: 75,
        color: Colors.yellow,
      ),
    ),
    Expanded(
      child: Container(
        width: 75,
        height: 75,
        color: Colors.red,
      ),
    ),
    Expanded(
      flex: 2,
      child: Container(
        width: 75,
        height: 75,
        color: Colors.blue,
      ),
    ),
    Expanded(
      flex: 2,
      child: Container(
        width: 75,
        height: 75,
        color: Colors.orange,
      ),
    ),
    Expanded(
      child: Container(
        width: 75,
        height: 75,
        color: Colors.red,
      ),
    ),
    Expanded(
      child: Container(
        width: 75,
        height: 75,
        color: Colors.yellow,
      ),
    ),
  ];
}

Padding kullaniciadiParola() {
  // ignore: prefer_typing_uninitialized_variables
  var kullaniciAdi;
  // ignore: prefer_typing_uninitialized_variables
  var parola;
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Kullanıcı Adı"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: TextFormField(
                obscureText: false,
                textAlign: TextAlign.left,
                controller: kullaniciAdi,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Parola"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: TextFormField(
                obscureText: true,
                textAlign: TextAlign.left,
                controller: parola,
              ),
            ),
            const Icon(
              Icons.add_circle,
              size: 46,
              color: Colors.green,
            ),
          ]));
}

Center containerDersleri() {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.yellow,
          shape: BoxShape.rectangle,
          border: Border.all(width: 4, color: Colors.purple),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          image: const DecorationImage(
              image: NetworkImage(
                  'https://www.leagueoflegends.com/static/logo-1200-589b3ef693ce8a750fa4b4704f1e61f2.png'),
              fit: BoxFit.contain),
          boxShadow: const [
            BoxShadow(
                color: Colors.yellow, offset: Offset(10, 15), blurRadius: 10)
          ]),
      child: const Text(
        "Muhammet İhsan Ertürk",
        style: TextStyle(fontSize: 20),
      ),
    ),
  );
}
