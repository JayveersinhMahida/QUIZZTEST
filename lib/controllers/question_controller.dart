import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:quizapp/database/database.dart';
import 'package:quizapp/model/questions.dart';
import 'package:quizapp/winner/winner_screen.dart';

// I have used get package for our state management

class QuestionController extends GetxController {
  late Timer timer;

  RxInt qtime = 20.obs;
  var rightans = 10;

  RxInt get time => qtime;

  late PageController _pageController;
  PageController get pageController => _pageController;

  int _noOfCorrectans = 0;

  int get noOfCorrectans => _noOfCorrectans;

  String _msg = "you win";

  String get msg => _msg;

  List<Questions> _questions = [];

  List<Questions> get questions => _questions;

  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;

  late String _correctAns;
  String get correctAns => _correctAns;

  late String _selectedAns;
  String get selectedAns => _selectedAns;

  // for more about obs please check documentation
  RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => _questionNumber;

  RxInt _numOfCorrectAns = 0.obs;
  RxInt get numOfCorrectAns => _numOfCorrectAns;

  @override
  void onInit() {
    getQuestions();
    _pageController = PageController();
    update();
    super.onInit();
  }

  getQuestions() async {
    _questions = await DataBaseHelp.instance.queryAll();
  }

  // // called just before the Controller is deleted from memory
  @override
  void onClose() {
    super.onClose();
    timer.cancel();
    _pageController.dispose();
  }

  void checkAns(
    Questions question,
    String selectedIndex,
  ) {
    _isAnswered = true;
    var qu = qtime.value;
    qtime.value = 20;

    _correctAns = question.awnser;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) {
      _noOfCorrectans++;
      _numOfCorrectAns.value = _numOfCorrectAns.value + qu + 10;
    }

    update();
    Future.delayed(const Duration(seconds: 1), () {
      nextQuestion();
      timer.cancel();
      startTimer();
    });
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (qtime.value > 0) {
        qtime.value--;

        update();
      } else {
        nextQuestion();
        timer.cancel();
        qtime.value = 20;

        // startTimer();
      }
    });
  }

  void nextQuestion() {
    if (_questionNumber.value != _questions.length) {
      _isAnswered = false;
      _pageController.nextPage(
          duration: const Duration(milliseconds: 2), curve: Curves.ease);
    } else {
      showWinMsgt();
      timer.cancel();

      Get.to(() => const WinnerScreen());
    }
  }

  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
    timer.cancel();
    startTimer();
  }

  void reset() {
    _noOfCorrectans = 0;
    _numOfCorrectAns.value = 0;

    _questionNumber.value = 1;
    timer.cancel();

    update();
  }

  showWinMsgt() {
    if (_noOfCorrectans == 5) {
      _msg = "You Won!";
    } else if (_noOfCorrectans == 7 || _noOfCorrectans == 6) {
      _msg = "You won! Congratulations.";
    } else if (_noOfCorrectans == 9 || _noOfCorrectans == 8) {
      _msg = "you won! Congratulations and Well";
    } else if (_noOfCorrectans == 10) {
      _msg = "Awesome. you are Genius Congratulations you won the Game";
    } else if (_noOfCorrectans == 3 || _noOfCorrectans == 4) {
      _msg = "Well played but you failed. All the best for next Game";
    } else {
      _msg = "Sorry, You Failed";
    }
  }
}
