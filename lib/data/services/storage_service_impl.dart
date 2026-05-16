import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../../domain/repositories/storage_service.dart';

class StorageServiceImpl implements StorageService {
  final FirebaseStorage _storage;

  StorageServiceImpl({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  @override
  Future<String?> uploadReportImage(String userId, String reportId, String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return null;
      }

      final ref = _storage.ref().child('reports/$userId/$reportId.jpg');
      
      // Upload the file
      final uploadTask = await ref.putFile(file);
      
      // Get the download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}
