import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/home/components/body.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                Get.offAll(() => const Body());
              },
              child: const Text("Play Quizz")),
        ),
      ),
    );
  }
}
