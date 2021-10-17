import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/question_controller.dart';
import 'package:quizapp/home/home.dart';

class WinnerScreen extends StatelessWidget {
  const WinnerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuestionController>();
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Total Score ${controller.numOfCorrectAns}"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(controller.msg),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        controller.reset();

                        Get.off(() => const Home());
                      },
                      child: const Text("Play Again"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
