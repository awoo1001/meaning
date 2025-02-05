import 'package:flutter/material.dart';
import 'package:imagewordwise/imagescanningpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       
        useMaterial3: true,
        scaffoldBackgroundColor:Color.fromARGB(255, 255, 238, 2)
      ),
      home:  ImagePage(),
    );
  }
}

