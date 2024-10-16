import 'dart:math';

import 'package:flutter/material.dart';

class ScreenThree extends StatefulWidget {
  @override
  _ScreenThreeState createState() => _ScreenThreeState();
}

class _ScreenThreeState extends State<ScreenThree>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation, rotateAnimation, fadeAnimation;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 900));

    // 도넛 원 크기 확장 애니메이션 (처음 0.5초)
    scaleAnimation = Tween<double>(begin: 0.0, end: 3.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    // 도넛 원 회전 애니메이션 (다 커진 후 회전 시작, 마지막 0.5초)
    rotateAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    // 아이콘들이 사라지는 애니메이션
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.5, 0.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('스크린 Three'),
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Positioned(
                bottom: 5,
                right: -30,
                child: Transform.scale(
                  scale: scaleAnimation.value,
                  child: Transform.rotate(
                    angle: rotateAnimation.value * -pi,
                    child: Stack(children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.5),
                            width: 40,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 65,
                        top: 10,
                        child: FadeTransition(
                          opacity: fadeAnimation,
                          child: const Icon(Icons.photo,
                              color: Colors.yellow, size: 20),
                        ),
                      ),
                      Positioned(
                        right: 95,
                        top: 20,
                        child: FadeTransition(
                          opacity: fadeAnimation,
                          child: const Icon(Icons.videocam,
                              color: Colors.green, size: 20),
                        ),
                      ),
                      Positioned(
                        left: 15,
                        bottom: 87,
                        child: FadeTransition(
                          opacity: fadeAnimation,
                          child: const Icon(Icons.music_note,
                              color: Colors.red, size: 20),
                        ),
                      ),
                      Positioned(
                        left: 13,
                        top: 75,
                        child: FadeTransition(
                          opacity: fadeAnimation,
                          child: const Icon(Icons.description,
                              color: Colors.blue, size: 20),
                        ),
                      ),
                    ]),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: toggleFab,
        child: Icon(isExpanded ? Icons.close : Icons.add),
      ),
    );
  }

  void toggleFab() {
    setState(() {
      if (!isExpanded) {
        controller.forward();
      } else {
        controller.reverse();
      }
      isExpanded = !isExpanded;
    });
  }
}
