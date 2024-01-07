import 'package:flutter/material.dart';
import 'package:leafshield/Screens/upload_screen.dart';
import 'package:leafshield/utilities/utilities.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(child: Image.asset('images/leadfshield_logo.jpg', height: 250,)),
            Container(
              padding: EdgeInsets.only(left: 40.0, right: 20.0),
              child: const Text('Welcome to Leafshield !! Upload an image of the diseased leaf to get the remedy',
              style: kTextStyle,),
            ),
            SizedBox(height: 20.0,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Upload_Screen()),);
              },
              child: Container(
                child: Center(child: Text('PROCEED'),),
                width: 180.0,
                height: 40.0,
                decoration: const ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: Colors.orangeAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}