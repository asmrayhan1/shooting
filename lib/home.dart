import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shooting/start.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Start()),
                );
                print("Start Button Working");
              },
              child: Container(
                height: h/15,
                width: w/2,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(child: Text("Start", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),)),
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: GestureDetector(
              onTap: (){
                print("Hero Button Working");
              },
              child: Container(
                height: h/15,
                width: w/2,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(child: Text("Hero", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),)),
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: GestureDetector(
              onTap: (){
                print("Level Button Working");
              },
              child: Container(
                height: h/15,
                width: w/2,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(child: Text("Level", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),)),
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: GestureDetector(
              onTap: (){
                print("Exit Button Working");
              },
              child: Container(
                height: h/15,
                width: w/2,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(child: Text("Exit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),)),
              ),
            ),
          ),

        ],
      )
    );
  }
}
