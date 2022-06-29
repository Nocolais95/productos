import 'package:flutter/material.dart';

// No necesita el changenotifier porque no necesita redibujar nada, solo son metodos y propiedades estaticas
class NotificationServices {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
    // Ahora hay que llamar este snackBar
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
