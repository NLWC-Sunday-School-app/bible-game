import 'dart:js_interop';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

Future<void> shareScreenshotImpl({
  required Uint8List imageBytes,
  required BuildContext context,
  String subject = '',
}) async {
  // On web, trigger a file download in the browser
  final blob = web.Blob([imageBytes.toJS].toJS, web.BlobPropertyBag(type: 'image/png'));
  final url = web.URL.createObjectURL(blob);
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  anchor.href = url;
  anchor.download = 'bible_game_share.png';
  anchor.click();
  web.URL.revokeObjectURL(url);
}
