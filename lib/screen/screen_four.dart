import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class ScreenFour extends StatefulWidget {
  @override
  _ScreenFourState createState() => _ScreenFourState();
}

class _ScreenFourState extends State<ScreenFour>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> scrollableAnimation;
  late Animation<Offset> slideFromBottomAnimation;
  late Animation<Offset> slideFromRightAnimation;
  bool isMoved = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // scrollable 화면 애니메이션 (좌측 상단으로 이동)
    scrollableAnimation = Tween<Offset>(
      begin: const Offset(0, 0), // 원래 위치
      end: const Offset(-0.22, -0.16), // 좌측 상단으로 이동
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    // Textfield: 하단에서 슬라이드하는 애니메이션
    slideFromBottomAnimation = Tween<Offset>(
      begin: const Offset(0, 2), // 스크린 아래에서 시작
      end: const Offset(0, 0), // 원래 위치로 슬라이드
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    // Buttons: 우측에서 슬라이드하는 애니메이션
    slideFromRightAnimation = Tween<Offset>(
      begin: const Offset(2, 0), // 스크린 우측에서 시작
      end: const Offset(0, 0), // 원래 위치로 슬라이드
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('스크린 Four'),
      ),
      body: Stack(
        children: [
          _Skeletons(
            animation: scrollableAnimation,
          ),
          _Icons(animation: slideFromRightAnimation),
          _TextField(
            animation: slideFromBottomAnimation,
          ),
        ],
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: toggleAnimation,
        child: Icon(isMoved ? Icons.close : Icons.add),
      ),
    );
  }

  void toggleAnimation() {
    setState(() {
      if (isMoved) {
        controller.reverse(); // 원래 위치로
      } else {
        controller.forward(); // 좌측 상단으로 이동
      }
      isMoved = !isMoved;
    });
  }
}

class _Skeletons extends StatelessWidget {
  final Animation<Offset> animation;

  const _Skeletons({
    required this.animation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                20,
                (index) => _SkeletonItem(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Icons extends StatelessWidget {
  final Animation<Offset> animation;

  const _Icons({required this.animation, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 130,
      right: 16,
      child: SlideTransition(
        position: animation,
        child: Column(
          children: [
            _renderIcon(Icons.send),
            const SizedBox(height: 10),
            _renderIcon(Icons.image),
            const SizedBox(height: 10),
            _renderIcon(Icons.camera_alt),
          ],
        ),
      ),
    );
  }

  Widget _renderIcon(IconData icon) {
    return Container(
      height: 58,
      width: 58,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

class _TextField extends StatelessWidget {
  final Animation<Offset> animation;

  const _TextField({required this.animation, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 48,
      left: 20,
      right: 100,
      child: SlideTransition(
        position: animation,
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            fillColor: Colors.grey.withOpacity(0.2),
            filled: true,
          ),
        ),
      ),
    );
  }
}

class _SkeletonItem extends StatelessWidget {
  const _SkeletonItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(
      vertical: 20.0,
      horizontal: 20,
    );

    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Padding(
          padding: padding,
          child: Row(
            children: [
              // 원형 Skeleton
              SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  shape: BoxShape.circle,
                  width: 50,
                  height: 50,
                ),
              ),
              SizedBox(width: 20),
              // 텍스트 Skeleton
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TextSkeleton(
                      height: 20,
                      width: double.infinity,
                    ),
                    SizedBox(height: 10),
                    _TextSkeleton(height: 20, width: 150),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextSkeleton extends StatelessWidget {
  final double height;
  final double width;

  const _TextSkeleton({required this.height, required this.width, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonLine(
      style: SkeletonLineStyle(
        height: height,
        width: width,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
