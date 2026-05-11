import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SoundWaveAnimation extends StatefulWidget {
  final bool isPlaying;
  final int barCount;

  const SoundWaveAnimation({
    super.key,
    this.isPlaying = true,
    this.barCount = 5,
  });

  @override
  State<SoundWaveAnimation> createState() => _SoundWaveAnimationState();
}

class _SoundWaveAnimationState extends State<SoundWaveAnimation> {
  final Random _random = Random();
  late List<double> _heights;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _heights = List.generate(widget.barCount, (_) => 8.0);
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      if (!mounted) return;
      if (widget.isPlaying) {
        setState(() {
          _heights = List.generate(
            widget.barCount,
            (_) => _random.nextDouble() * 24 + 4,
          );
        });
      }
    });
  }

  @override
  void didUpdateWidget(SoundWaveAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.isPlaying) {
      setState(() {
        _heights = List.generate(widget.barCount, (_) => 4.0);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(widget.barCount, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 4,
            height: _heights[index],
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}