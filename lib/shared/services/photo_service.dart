import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class PhotoService {
  static const _subDir = 'product_photos';
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickFromCamera() => _pick(ImageSource.camera);
  Future<String?> pickFromGallery() => _pick(ImageSource.gallery);

  Future<String?> _pick(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (picked == null) return null;
    return _persist(File(picked.path));
  }

  Future<String> _persist(File source) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/$_subDir');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final ext = source.path.split('.').last.toLowerCase();
    final name = '${const Uuid().v4()}.$ext';
    final destination = File('${dir.path}/$name');
    await source.copy(destination.path);
    return destination.path;
  }

  Future<void> deletePhoto(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
