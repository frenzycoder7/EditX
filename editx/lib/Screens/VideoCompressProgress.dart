import 'package:flutter/material.dart';

class VideoCompressPro extends StatefulWidget {
  @override
  _VideoCompressProState createState() => _VideoCompressProState();
}

class _VideoCompressProState extends State<VideoCompressPro> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Colors.orangeAccent, Colors.redAccent],
        ),
      ),
      child: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
