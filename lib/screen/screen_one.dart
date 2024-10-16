import 'dart:math' as math;
import 'package:flutter/material.dart';

class ScreenOne extends StatefulWidget {
  const ScreenOne({super.key});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> positionAnimation;
  late final Animation<double> fadeAnimation;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    positionAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: controller,
    );
    fadeAnimation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: controller,
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
        title: const Text('스크린 One'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 40.0,
          right: 40.0,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            _OpenedFab(
              toggle: toggle,
            ),
            _ExpandedIcons(
              animation: positionAnimation,
              children: [
                _ActionButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings_outlined),
                ),
                _ActionButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_outline),
                ),
                _ActionButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline),
                ),
              ],
            ),
            _ClosedFab(
              isOpen: isOpen,
              toggle: toggle,
              fadeAnimation: fadeAnimation,
            ),
          ],
        ),
      ),
    );
  }

  void toggle() {
    setState(() {
      if (isOpen) {
        controller.reverse();
      } else {
        controller.forward();
      }
      isOpen = !isOpen;
    });
  }
}

class _ClosedFab extends StatelessWidget {
  final bool isOpen;
  final VoidCallback toggle;
  final Animation<double> fadeAnimation;

  const _ClosedFab({
    required this.isOpen,
    required this.toggle,
    required this.fadeAnimation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        shape: const CircleBorder(),
        onPressed: toggle,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ExpandedIcons extends StatelessWidget {
  final Animation<double> animation;
  final List<Widget> children;

  const _ExpandedIcons({
    Key? key,
    required this.animation,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [];
    final count = children.length;
    final step = 90.0 / (count - 1);
    const distance = 112;

    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      buttons.add(
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final offset = Offset.fromDirection(
              angleInDegrees * (math.pi / 180.0),
              animation.value * distance,
            );
            return Positioned(
              right: offset.dx,
              bottom: offset.dy,
              child: child!,
            );
          },
          child: children[i],
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: buttons,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;

  const _ActionButton({
    this.onPressed,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100), color: Colors.deepPurple),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: Colors.white,
      ),
    );
  }
}

class _OpenedFab extends StatelessWidget {
  final VoidCallback toggle;

  const _OpenedFab({required this.toggle, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.2),
          ),
          child: InkWell(
            onTap: toggle,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
