import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
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
    final storageStatus = await Permission.storage.request();
    if (!storageStatus.isGranted) {
      final photosStatus = await Permission.photos.request();
      if (!photosStatus.isGranted) return false;
    }

    final bytes = await _loadAssetImageBytes(phrase.image);
    if (bytes == null) return false;

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/frase-de-amor-${phrase.id}.jpg');
    await file.writeAsBytes(bytes);

    await Gal.putImage(file.path, album: 'Frases de Amor');
    return true;
  } catch (_) {
    return false;
  }
}

Future<void> exportAndShare(Phrase phrase, BuildContext context) async {
  try {
    final storageStatus = await Permission.storage.request();
    if (!storageStatus.isGranted) {
      final photosStatus = await Permission.photos.request();
      if (!photosStatus.isGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permiso de almacenamiento denegado')),
          );
        }
        return;
      }
    }

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
    await file.writeAsBytes(bytes);

    await Gal.putImage(file.path, album: 'Frases de Amor');
    await Share.shareXFiles([XFile(file.path)], text: phrase.text);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al compartir: $e')),
      );
    }
  }
}
