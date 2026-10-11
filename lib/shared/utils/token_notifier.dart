import 'package:flutter/material.dart';

class TokenNotifier extends ValueNotifier<String?> {
  TokenNotifier() : super(null);

  void setToken(String? newToken) {
    value = newToken;
  }
}
