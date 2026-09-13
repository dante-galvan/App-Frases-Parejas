import 'dart:io';
import 'dart:ui' as ui;
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

Future<ui.Image?> _decodeImage(Uint8List bytes) async {
  try {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  } catch (_) {}
  return null;
}

Future<ui.Image?> _loadAssetImage(String imageFileName) async {
  final bytes = await _loadAssetImageBytes(imageFileName);
  if (bytes == null) return null;
  return _decodeImage(bytes);
}

Future<Uint8List?> generateCompositeImage({
  required String imageFileName,
  required String text,
  int width = 1080,
  int height = 1920,
}) async {
  try {
    final image = await _loadAssetImage(imageFileName);
    if (image == null) return null;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = Size(width.toDouble(), height.toDouble());

    final bgPaint = Paint()..filterQuality = FilterQuality.high;
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      bgPaint,
    );

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.85),
        ],
        stops: const [0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.45, size.width, size.height * 0.55), gradientPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
          height: 1.4,
          shadows: [
            Shadow(
              color: Colors.black54,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final textMaxWidth = size.width * 0.8;
    textPainter.layout(maxWidth: textMaxWidth);

    final textX = (size.width - textPainter.width) / 2;
    final textY = size.height - 280 - textPainter.height;

    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        textX - 24,
        textY - 20,
        textPainter.width + 48,
        textPainter.height + 40,
      ),
      const Radius.circular(12),
    );
    final bgOverlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3);
    canvas.drawRRect(bgRect, bgOverlayPaint);

    textPainter.paint(canvas, Offset(textX, textY));

    final heartIconPainter = TextPainter(
      text: const TextSpan(
        text: '\u2764',
        style: TextStyle(
          color: Color(0xFFE91E63),
          fontSize: 28,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    heartIconPainter.paint(
      canvas,
      Offset((size.width - heartIconPainter.width) / 2, textY + textPainter.height + 24),
    );

    final picture = recorder.endRecording();
    final finalImage = await picture.toImage(width, height);

    final byteData = await finalImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (byteData == null) return null;

    return byteData.buffer.asUint8List();
  } catch (_) {
    return null;
  }
}

Future<bool> exportPhraseImage(Phrase phrase, String text) async {
  try {
    final compositeBytes = await generateCompositeImage(
      imageFileName: phrase.image,
      text: text,
    );
    if (compositeBytes == null) return false;

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/frase-amor-${phrase.id}.png');
    await file.writeAsBytes(compositeBytes);

    await Gal.putImage(file.path, album: 'Frases de Amor');

    return true;
  } catch (_) {
    return false;
  }
}

Future<void> exportAndShare(Phrase phrase, BuildContext context, {String? text}) async {
  try {
    final compositeBytes = await generateCompositeImage(
      imageFileName: phrase.image,
      text: text ?? phrase.text,
    );
    if (compositeBytes == null) return;

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/frase-amor-${phrase.id}.png');
    await file.writeAsBytes(compositeBytes);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'image/png')],
      text: text ?? phrase.text,
      subject: 'Frase de amor',
    );
  } catch (_) {}
}
