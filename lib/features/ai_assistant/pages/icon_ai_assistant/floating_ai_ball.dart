import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:timesheet_project/features/ai_assistant/pages/survey/survey_page.dart';

class FloatingAIBall extends StatefulWidget {
  const FloatingAIBall({super.key});

  @override
  State<FloatingAIBall> createState() => _FloatingAIBallState();
}

class _FloatingAIBallState extends State<FloatingAIBall>
    with TickerProviderStateMixin {
  late Offset position;
  late Offset _initialPosition;
  late Offset _lastSnappedPosition;

  late AnimationController _pulseController;
  late AnimationController _snapController;
  late Animation<Offset> _snapAnimation;

  bool isDragging = false;
  bool shouldShowPulse = false;

  @override
  void initState() {
    super.initState();

    _initialPosition = const Offset(300, 600);
    position = _initialPosition;
    _lastSnappedPosition = _initialPosition;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _snapController.dispose();
    super.dispose();
  }

  bool _isNearEdge(Offset pos, Size screenSize) {
    const threshold = 20.0;
    return pos.dx <= threshold ||
        pos.dx >= screenSize.width - 60 - threshold ||
        pos.dy <= threshold ||
        pos.dy >= screenSize.height - 60 - threshold;
  }

  void _snapToLastSnappedPosition() {
    _snapAnimation = Tween<Offset>(
      begin: position,
      end: _lastSnappedPosition,
    ).animate(CurvedAnimation(parent: _snapController, curve: Curves.easeOut));

    _snapAnimation.addListener(() {
      setState(() {
        position = _snapAnimation.value;
      });
    });

    _snapController
      ..reset()
      ..forward().whenComplete(() {
        setState(() {
          position = _lastSnappedPosition;
          shouldShowPulse = false;
        });
        _pulseController.stop();
      });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanStart: (_) {
          setState(() {
            isDragging = true;
            shouldShowPulse = true;
          });
          _pulseController.repeat(reverse: true);
        },
        onPanUpdate: (details) {
          setState(() {
            final newDx = (position.dx + details.delta.dx).clamp(
              0.0,
              screenSize.width - 60,
            );
            final newDy = (position.dy + details.delta.dy).clamp(
              0.0,
              screenSize.height - 60,
            );

            position = Offset(newDx, newDy);
          });
        },
        onPanEnd: (_) {
          setState(() {
            isDragging = false;
          });

          Future.delayed(const Duration(milliseconds: 300), () {
            if (!mounted) return;
            if (_isNearEdge(position, screenSize)) {
              _lastSnappedPosition = position;
              shouldShowPulse = false;
              _pulseController.stop();
            } else {
              _snapToLastSnappedPosition();
            }
          });
        },
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SurveyPage()),
          );
        },
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale:
                  shouldShowPulse ? 0.9 + (_pulseController.value * 0.2) : 1.0,
              // child: Container(
              //   width: 60,
              //   height: 60,
              // decoration: BoxDecoration(
              //   shape: BoxShape.circle,
              //   // color: Color(0xFF00C7F2),
              //   color:const Color(0xFF0957AE),
              // ),
              // child: const Icon(
              //   Icons.smart_toy_outlined,
              //   color: Colors.white,
              //   size: 32,
              // ),
              child: Lottie.asset('assets/image/chatbot.json',
                  width: 85, height: 85, fit: BoxFit.cover),
              // ),
            );
          },
        ),
      ),
    );
  }
}
