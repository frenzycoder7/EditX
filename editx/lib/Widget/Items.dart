import 'package:flutter/material.dart';

class ItemsF extends StatefulWidget {
  IconData icon;
  String name;
  Function onTap;
  ItemsF({this.icon, this.name, this.onTap});
  @override
  _ItemsFState createState() => _ItemsFState();
}

class _ItemsFState extends State<ItemsF> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Colors.orangeAccent, Colors.redAccent],
            ),
            borderRadius: BorderRadius.circular(20)
          ),
          child: IconButton(
            icon: Icon(
              widget.icon,
              color: Colors.white,
            ),
            onPressed: () {
              widget.onTap();
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Center(
            child: Text(
              widget.name,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
