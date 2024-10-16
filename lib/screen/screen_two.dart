import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/widgets.dart';

class ScreenTwo extends StatefulWidget {
  @override
  _ScreenTwoState createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> with TickerProviderStateMixin {
  /// Rectangle
  late AnimationController rectangleController;
  late Animation<double> rightPositionAnimation,
      bottomPositionAnimation,
      rectangleScaleAnimation,
      borderRadiusAnimation;
  late List<Animation<double>> textAnimation, iconAngleAnimation;
  final List<String> itemTexts = ['PHOTO', 'FILES', 'RECORD', 'NEW EMAIL'];
  final List<IconData> itemIcons = [
    Icons.camera_alt,
    Icons.insert_drive_file,
    Icons.mic,
    Icons.email
  ];
  bool isClosed = true;

  /// FAB
  late AnimationController fabController;
  late Animation<double> outerInkwellAnimation,
      innerInkwellAnimation,
      outerInkwellFadeAnimation,
      innerInkwellFadeAnimation,
      rotationAnimation,
      fabScaleAnimation;

  late Animation<Offset> slideInAnimation, slideOutAnimation;

  @override
  void initState() {
    super.initState();

    /// RECTANGLE
    rectangleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // FAB와 사각형의 Positioned 상 우측 위치 애니메이션
    rightPositionAnimation = Tween<double>(
      begin: 30.0,
      end: 45.0,
    ).animate(CurvedAnimation(
        parent: rectangleController,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn)));

    // FAB와 사각형의 Positioned 상 하단 위치 애니메이션
    bottomPositionAnimation = Tween<double>(
      begin: 30.0,
      end: 120.0,
    ).animate(CurvedAnimation(
        parent: rectangleController,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn)));

    // 사각형 크기 애니메이션
    rectangleScaleAnimation = Tween<double>(begin: 56, end: 250).animate(
      CurvedAnimation(
          parent: rectangleController,
          curve: Interval(
            0.0,
            0.2,
            curve: Curves.easeIn,
          )),
    );

    // 사각형 모서리 둥글기 애니메이션
    borderRadiusAnimation = Tween<double>(begin: 28, end: 20).animate(
      CurvedAnimation(
          parent: rectangleController,
          curve: Interval(
            0.45,
            0.65,
            curve: Curves.easeIn,
          )),
    );

    // 각 아이콘이 반시계/시계방향으로 순차적으로 나타나는 애니메이션
    iconAngleAnimation = List.generate(
      itemIcons.length,
      (index) {
        double startInterval = index * 0.2;
        double endInterval = startInterval + 0.2;

        bool isClockwise = index % 2 == 0;
        double endRotation = isClockwise ? 2 * pi : -2 * pi;

        return Tween<double>(begin: 0, end: endRotation).animate(
          CurvedAnimation(
            parent: rectangleController,
            // Apply a collective easeIn curve to all intervals
            curve: Interval(startInterval, endInterval, curve: Curves.easeIn),
          ),
        );
      },
    );

    // 글씨가 위에서 아래로 나타나는 애니메이션
    textAnimation = List.generate(
      itemTexts.length,
      (index) {
        double startInterval = 0.2 * index;
        double endInterval = startInterval + 0.2;
        return Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: rectangleController,
            curve: Interval(startInterval, endInterval, curve: Curves.easeIn),
          ),
        );
      },
    );

    /// FAB POSITION
    fabController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    /// FAB INKWELL
    // FAB 바깥 테두리 원 (InkWell 원 나타남)
    outerInkwellAnimation = Tween<double>(begin: 0, end: 100).animate(
      CurvedAnimation(
          parent: fabController,
          curve: Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    // FAB 내부 테두리 원 (InkWell 원 나타남)
    innerInkwellAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
          parent: fabController,
          curve: Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    // FAB 바깥 테두리 원 (InkWell 원 사라짐)
    outerInkwellFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: fabController,
        curve: Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );

    // FAB 내부 테두리 원 (InkWell 원 사라짐)
    innerInkwellFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: fabController,
        curve: Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    /// FAB INNER ICON
    // FAB 내부 + 아이콘 회전 애니메이션
    rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: fabController, curve: Interval(0.0, 0.5)),
    );
    // FAB 내부 + 아이콘 크기 애니메이션
    fabScaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: fabController, curve: Interval(0.0, 0.5)),
    );

    // FAB 내부 send 아이콘 슬라이드 하면 나타나는 애니메이션
    slideInAnimation = Tween<Offset>(begin: Offset(-1.5, 1.5), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: fabController, curve: Interval(0.5, 1.0)));

    // FAB 내부 send 아이콘 슬라이드 하며 사라지는 애니메이션
    slideOutAnimation =
        Tween<Offset>(begin: Offset(1.5, -1.5), end: Offset.zero).animate(
            CurvedAnimation(
                parent: fabController,
                curve: Interval(0.5, 1.0)));
  }

  @override
  void dispose() {
    rectangleController.dispose();
    fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('스크린 Two'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          _BlackRectangle(
            rectangleController: rectangleController,
            rightPositionAnimation: rightPositionAnimation,
            bottomPositionAnimation: bottomPositionAnimation,
            rectangleScaleAnimation: rectangleScaleAnimation,
            borderRadiusAnimation: borderRadiusAnimation,
            isClosed: isClosed,
            iconAngleAnimation: iconAngleAnimation,
            textAnimation: textAnimation,
            itemIcons: itemIcons,
            itemTexts: itemTexts,
          ),
          _Fab(
            fabController: fabController,
            outerInkwellAnimation: outerInkwellAnimation,
            isClosed: isClosed,
            rotationAnimation: rotationAnimation,
            scaleAnimation: fabScaleAnimation,
            slideInAnimation: slideInAnimation,
            slideOutAnimation: slideOutAnimation,
            innerInkwellAnimation: innerInkwellAnimation,
            onFabPressed: onFabPressed,
            outerInkwellFadeAnimation: outerInkwellFadeAnimation,
            innerInkwellFadeAnimation: innerInkwellFadeAnimation,
          ),
        ],
      ),
    );
  }

  void onFabPressed() {
    setState(() {
      if (isClosed) {
        rectangleController.duration = Duration(milliseconds: 1500);
        fabController.forward();
        rectangleController.forward();
      } else {
        rectangleController.duration = Duration(milliseconds: 500);
        rectangleController.reverse();
        fabController.reverse();
      }
      isClosed = !isClosed;
    });
  }
}

class _Fab extends StatelessWidget {
  final AnimationController fabController;
  final Animation<double> outerInkwellAnimation;
  final bool isClosed;
  final Animation<double> rotationAnimation;
  final Animation<double> scaleAnimation;
  final Animation<Offset> slideInAnimation;
  final Animation<Offset> slideOutAnimation;
  final Animation<double> innerInkwellAnimation;
  final VoidCallback onFabPressed;
  final Animation<double> outerInkwellFadeAnimation;
  final Animation<double> innerInkwellFadeAnimation;

  const _Fab(
      {required this.fabController,
      required this.outerInkwellAnimation,
      required this.isClosed,
      required this.rotationAnimation,
      required this.scaleAnimation,
      required this.slideInAnimation,
      required this.slideOutAnimation,
      required this.innerInkwellAnimation,
      required this.onFabPressed,
      required this.outerInkwellFadeAnimation,
      required this.innerInkwellFadeAnimation,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 30,
      bottom: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _OuterInkWell(
            fabController: fabController,
            outerInkwellAnimation: outerInkwellAnimation,
            fadeAnimation: outerInkwellFadeAnimation,
          ),
          _FabButton(
            fabController: fabController,
            isClosed: isClosed,
            innerInkwellAnimation: innerInkwellAnimation,
            onFabPressed: onFabPressed,
            rotationAnimation: rotationAnimation,
            scaleAnimation: scaleAnimation,
            slideInAnimation: slideInAnimation,
            slideOutAnimation: slideOutAnimation,
          ),
          _InnerInkWell(
            fabController: fabController,
            innerInkwellAnimation: innerInkwellAnimation,
            fadeAnimation: innerInkwellFadeAnimation,
          ),
        ],
      ),
    );
  }
}

class _InnerInkWell extends StatelessWidget {
  final AnimationController fabController;
  final Animation<double> innerInkwellAnimation;
  final Animation<double> fadeAnimation;

  const _InnerInkWell(
      {required this.fabController,
      required this.innerInkwellAnimation,
      required this.fadeAnimation,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fabController,
      builder: (context, child) {
        return IgnorePointer(
          ignoring: true,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.purple.shade50.withOpacity(0.5),
                  width: innerInkwellAnimation.value,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FabButton extends StatelessWidget {
  final AnimationController fabController;
  final bool isClosed;
  final Animation<double> innerInkwellAnimation;
  final VoidCallback onFabPressed;
  final Animation<double> rotationAnimation;
  final Animation<double> scaleAnimation;
  final Animation<Offset> slideInAnimation;
  final Animation<Offset> slideOutAnimation;

  const _FabButton(
      {required this.fabController,
      required this.isClosed,
      required this.innerInkwellAnimation,
      required this.onFabPressed,
      required this.rotationAnimation,
      required this.scaleAnimation,
      required this.slideInAnimation,
      required this.slideOutAnimation,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: onFabPressed,
          child: AnimatedBuilder(
            animation: fabController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  if (fabController.isDismissed) Icon(Icons.add),
                  if (isClosed)
                    SlideTransition(
                      position: slideOutAnimation,
                      child: Icon(Icons.send),
                    ),
                  if (!isClosed)
                    SlideTransition(
                      position: slideInAnimation,
                      child: Icon(Icons.send),
                    ),
                  Transform.rotate(
                    angle: rotationAnimation.value * pi,
                    child: Transform.scale(
                      scale: scaleAnimation.value,
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OuterInkWell extends StatelessWidget {
  final AnimationController fabController;
  final Animation<double> outerInkwellAnimation;
  final Animation<double> fadeAnimation;

  const _OuterInkWell(
      {required this.fabController,
      required this.outerInkwellAnimation,
      required this.fadeAnimation,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fabController,
      builder: (context, child) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: Container(
            width: outerInkwellAnimation.value,
            height: outerInkwellAnimation.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.purple.shade50.withOpacity(0.5),
                width: 4,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BlackRectangle extends StatelessWidget {
  final AnimationController rectangleController;
  final Animation<double> rightPositionAnimation;
  final Animation<double> bottomPositionAnimation;
  final Animation<double> rectangleScaleAnimation;
  final Animation<double> borderRadiusAnimation;
  final bool isClosed;
  final List<Animation<double>> textAnimation;
  final List<Animation<double>> iconAngleAnimation;
  final List<IconData> itemIcons;
  final List<String> itemTexts;

  const _BlackRectangle(
      {required this.rectangleController,
      required this.rightPositionAnimation,
      required this.bottomPositionAnimation,
      required this.rectangleScaleAnimation,
      required this.borderRadiusAnimation,
      required this.isClosed,
      required this.iconAngleAnimation,
      required this.textAnimation,
      required this.itemIcons,
      required this.itemTexts,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: rectangleController,
      builder: (context, child) {
        return Positioned(
          right: rightPositionAnimation.value,
          bottom: bottomPositionAnimation.value,
          child: Container(
            width: rectangleScaleAnimation.value,
            height: rectangleScaleAnimation.value,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(borderRadiusAnimation.value),
            ),
            child: rectangleScaleAnimation.value == 250 && !isClosed
                ? _Items(
                    items: itemTexts,
                    iconAngleAnimation: iconAngleAnimation,
                    icons: itemIcons,
                    textAnimation: textAnimation,
                  )
                : null,
          ),
        );
      },
    );
  }
}

class _Items extends StatelessWidget {
  final List<String> items;
  final List<Animation<double>> iconAngleAnimation;
  final List<IconData> icons;
  final List<Animation<double>> textAnimation;

  const _Items(
      {required this.items,
      required this.iconAngleAnimation,
      required this.icons,
      required this.textAnimation,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 16, 12),
          child: Row(
            children: [
              CustomPaint(
                painter: IconAndCirclePainter(
                    iconAngleAnimation[entry.key], icons[entry.key]),
                child: Container(
                  width: 32,
                  height: 32,
                ),
              ),
              SizedBox(width: 18),
              Expanded(
                child: SizeTransition(
                  sizeFactor: textAnimation[entry.key],
                  axisAlignment: 1.0,
                  child: Text(
                    items[entry.key],
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class IconAndCirclePainter extends CustomPainter {
  final Animation<double> animation;
  final IconData icon;

  IconAndCirclePainter(this.animation, this.icon) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    double sweepAngle = animation.value;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      0,
      sweepAngle,
      false,
      paint,
    );

    if (sweepAngle.abs() > 0) {
      final iconPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontSize: size.width * 0.7,
            fontFamily: icon.fontFamily,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      iconPainter.layout();
      Path path = Path();

      path.addArc(Rect.fromLTWH(0, 0, size.width, size.height), 0, sweepAngle);

      canvas.clipPath(path);

      iconPainter.paint(
        canvas,
        Offset((size.width - iconPainter.width) / 2,
            (size.height - iconPainter.height) / 2),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
