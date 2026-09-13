import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';
import '../models/phrase.dart';

Future<Uint8List?> _loadAssetImageBytes(String imageFileName) async {
  try {
    final byteData = await rootBundle.load('Imagenes/$imageFileName');
    return byteData.buffer.asUint8List();
  } catch (_) {}
  return null;
}

Future<bool> exportPhraseImage(Phrase phrase) async {
  try {
    final bytes = await _loadAssetImageBytes(phrase.image);
    if (bytes == null) return false;

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/frase-amor-${phrase.id}.jpg');
    await file.writeAsBytes(bytes);

    await Gal.putImage(file.path, album: 'Frases de Amor');

    final exists = await file.exists();
    return exists;
  } catch (_) {
    return false;
  }
}

Future<void> exportAndShare(Phrase phrase, BuildContext context, {String? text}) async {
  try {
    final bytes = await _loadAssetImageBytes(phrase.image);
    if (bytes == null) return;

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/frase-amor-${phrase.id}.jpg');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'image/jpeg')],
      text: text ?? phrase.text,
      subject: 'Frase de amor',
    );
  } catch (_) {}
}
