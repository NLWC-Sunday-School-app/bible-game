import 'dart:async';

import 'package:bible_game/models/question.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  late AnimationController _animationController;
  late AnimationController _blinkingAnimationController;
  late Animation _animation;

  AnimationController get blinkingController => _blinkingAnimationController;

  Animation get animation => _animation;

  PageController? _pageController;

  PageController? get pageController => _pageController;

  final List<Question> _questions = questionsData
      .map(
        (question) => Question(
            id: question['id'],
            question: question['question'],
            options: question['options'],
            answer: question['answer_index']),
      )
      .toList();

  List<Question> get questions => _questions;

  bool _isAnswered = false;

  bool get isAnswered => _isAnswered;

  late int _correctAnswer;

  int get correctAnswer => _correctAnswer;

  late int _selectedAnswer;

  int get selectedAnswer => _selectedAnswer;

  final RxInt _questionNumber = 1.obs;

  RxInt get questionNumber => _questionNumber;

  int _numOfCorrectAnswers = 0;

  int get numOfCorrectAnswers => _numOfCorrectAnswers;

  @override
  void onInit() {
    _blinkingAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _blinkingAnimationController.repeat(reverse: true);

    _animationController =
        AnimationController(duration: const Duration(seconds: 20), vsync: this);

    _animation = Tween<double>(begin: 1, end: 0).animate(_animationController)
      ..addListener(() {
        update();
      });
    _animationController.forward().whenComplete(goToNextQuestion);
    _pageController = PageController();
  }

  @override
  void onClose() {
    super.onClose();
    _animationController.dispose();
    _blinkingAnimationController.dispose();
    _pageController?.dispose();
  }

  void checkAnswer(Question question, int selectedIndex) {
    _isAnswered = true;
    _correctAnswer = question.answer;
    _selectedAnswer = selectedIndex;

    if (_correctAnswer == _selectedAnswer) _numOfCorrectAnswers++;
    _animationController.stop();
    update();

    Future.delayed(const Duration(seconds: 2), () {
      goToNextQuestion();
    });
  }

  void goToNextQuestion() {
    if (_questionNumber.value != _questions.length) {
      _isAnswered = false;
      _pageController?.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );

      _animationController.reset();
      _animationController.forward().whenComplete(goToNextQuestion);
    }
  }

  void updateTheQuestionNumber(int index) {
    _questionNumber.value = index + 1;
  }
}
