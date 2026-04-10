import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareScreenshotImpl({
  required Uint8List imageBytes,
  required BuildContext context,
  String subject = '',
}) async {
  final directory = await getApplicationDocumentsDirectory();
  final imagePath = File('${directory.path}/share_image.png');
  await imagePath.writeAsBytes(imageBytes);

  final box = context.findRenderObject() as RenderBox?;
  await Share.shareFiles(
    [imagePath.path],
    subject: subject,
    sharePositionOrigin: box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null,
  );
}
