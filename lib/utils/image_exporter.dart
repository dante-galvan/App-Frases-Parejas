import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';
import '../models/phrase.dart';

Future<Uint8List?> _loadAssetImageBytes(String imageFileName) async {
  try {
    final byteData = await rootBundle.load('Imagenes/$imageFileName');
    return byteData.buffer.asUint8List();
  } catch (_) {
    return null;
  }
}

Future<bool> exportPhraseImage(Phrase phrase) async {
  try {
    final hasAccess = await Gal.hasAccess(toAlbum: true);
    if (!hasAccess) {
      final granted = await Gal.requestAccess(toAlbum: true);
      if (!granted) return false;
    }

    final bytes = await _loadAssetImageBytes(phrase.image);
    if (bytes == null) return false;

    await Gal.putImageBytes(
      bytes,
      album: 'Frases de Amor',
      name: 'frase-de-amor-${phrase.id}',
    );
    return true;
  } catch (_) {
    return false;
  }
}

Future<void> exportAndShare(Phrase phrase, BuildContext context) async {
  try {
    final bytes = await _loadAssetImageBytes(phrase.image);
    if (bytes == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo cargar la imagen')),
        );
      }
      return;
    }

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/frase-de-amor-${phrase.id}.jpg');
    await file.writeAsBytes(bytes, flush: true);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'image/jpeg')],
      text: phrase.text,
    );
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo compartir: $e')),
      );
    }
  }
}
