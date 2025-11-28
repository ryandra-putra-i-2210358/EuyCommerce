import 'dart:io';
import 'package:image/image.dart' as img;

Future<File> convertToJpeg(File file) async {
  final bytes = await file.readAsBytes();

  // decode image (HEIC / JPG / PNG / TIFF / GIF)
  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    throw Exception("Gambar tidak dapat dibaca / corrupt");
  }

  final jpegBytes = img.encodeJpg(decoded, quality: 90);

  // save as jpg
  final newPath = file.path.replaceAll(RegExp(r'\.\w+$'), ".jpg");
  final newFile = File(newPath);

  await newFile.writeAsBytes(jpegBytes);

  return newFile;
}
