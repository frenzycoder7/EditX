import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

// import 'package:http/http.dart' as http;
class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  startTimeout() {
    return Timer(Duration(seconds: 2), handleTimeout);
  }

  String platformVersion;
  void handleTimeout() async {
    platformVersion = await GetVersion.platformVersion;
    print(platformVersion);
    changeScreen();
    // try {
    //   final res = await http.get('http://13.126.96.74:3000/get-app-status/editX');
    //   if(json.decode(res.body)['data']['status'] == true){

    //   }
    //   else{
    //     Navigator.of(this.context).pushReplacementNamed('/dev-errorcode');
    //   }
    // } catch (e) {
    //   Navigator.of(this.context).pushReplacementNamed('/network-error');
    // }
    //
  }

  Future createDir() async {
    List<Directory> paths =
        await path_provider.getExternalStorageDirectories(); //only for Android
    List<Directory> filteredPaths = List<Directory>();
    for (Directory dir in paths) {
      filteredPaths.add(removeDataDirectory(dir.path));
    }
    print(filteredPaths[0]);
    String pat = filteredPaths[0].path + 'EditX';
    try {
      await Directory(pat).create();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Directory removeDataDirectory(String path) {
    return Directory(path.split("Android")[0]);
  }

  void changeScreen() async {
    var storage_status = await Permission.storage.status;
    if (!storage_status.isGranted) {
      await Permission.storage.request();
      if (await Permission.storage.isGranted) {
        try {
          await createDir();
          Navigator.of(this.context).pushReplacementNamed('/home');
        } catch (err) {
          Navigator.of(context).pushReplacementNamed('/android-error');
        }
      } else {
        Navigator.of(this.context).pushReplacementNamed('/error');
      }
    } else {
      try {
        await createDir();
        Navigator.of(this.context).pushReplacementNamed('/home');
      } catch (err) {
        Navigator.of(context).pushReplacementNamed('/android-error');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Colors.orangeAccent, Colors.redAccent])),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.crop_rotate_outlined,
              color: Colors.white,
              size: 70,
            ),
          ],
        ),
      ),
    );
  }
}
