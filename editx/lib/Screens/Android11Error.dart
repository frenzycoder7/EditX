import 'package:flutter/material.dart';

class Android11Error extends StatelessWidget {
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('Android 11 Error'),
          centerTitle: true,
        ),
        body: Container(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Open Settiongs >',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Icon(
                Icons.settings,
                color: Colors.white,
              ),
              Text(
                'Go to Privacy >',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Icon(
                Icons.privacy_tip,
                color: Colors.white,
              ),
              Text(
                'Open Permission Manager >',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'Open Files and Media Permission select EditX and Allow management of all files and Then Restart Application.',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
