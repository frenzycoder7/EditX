import 'package:flutter/material.dart';
import './Screens/index.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Splash(),
      routes: {
        '/home': (context) => Home(),
        '/error': (context)=> ErrorPage(),
        '/img-compress':(context) => ImageCompress(),
        '/vdo-compress': (context) => VideoCompressor(),
        '/crop-image':(context) => ImageCropScreen(),
        '/network-error': (context) => NetworkError(),
        '/dev-error':(context) => DevelopmentError(),
        '/android-error': (context) => Android11Error(),
      },
    );
  }
}

