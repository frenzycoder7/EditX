import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ErrorPage extends StatefulWidget {
  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  void changeScreen() async {
    var storage_status = await Permission.storage.status;
    var cam_status = await Permission.camera.status;
    if(!storage_status.isGranted || !cam_status.isGranted){
      await Permission.camera.request();
      await Permission.storage.request();
      if(await Permission.camera.status.isGranted && await Permission.storage.isGranted){
        Navigator.of(context).pushReplacementNamed('/home');
      }else{
        Navigator.of(context).pushReplacementNamed('/error');
      }
    }else{
      Navigator.of(context).pushReplacementNamed('/home');
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Colors.orangeAccent, Colors.redAccent],
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text('Permission Error'),
            elevation: 0,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: Text('Please Allow Permission for Start This App \n Press Setting Button'),
                ),
              ),
              Container(
                child: IconButton(
                  icon: Icon(Icons.settings,size: 30,),
                  onPressed: (){
                    changeScreen();
                  },
                ),
              )
            ],
          )),
    );
  }
}
