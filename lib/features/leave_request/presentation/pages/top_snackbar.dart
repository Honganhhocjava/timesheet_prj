import 'package:flutter/material.dart';

class TopSnackbar {
  static void show(BuildContext context, String message,
      {Color backgroundColor = Colors.red,
      Duration duration = const Duration(seconds: 2)}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration).then((_) => overlayEntry.remove());
  }

  static void showGreen(BuildContext context, String message,
      {Color backgroundColor = Colors.green,
      Duration duration = const Duration(seconds: 2)}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration).then((_) => overlayEntry.remove());
  }
}
