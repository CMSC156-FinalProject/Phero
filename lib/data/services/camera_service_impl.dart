import 'package:image_picker/image_picker.dart';
import '../../domain/models/captured_media.dart';
import '../../domain/repositories/camera_service.dart';

class CameraServiceImpl implements CameraService {
  final ImagePicker _picker;

  CameraServiceImpl({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  @override
  Future<CapturedMedia?> takePicture() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80, // Optional: compress to save space
      );

      if (photo != null) {
        return CapturedMedia(path: photo.path);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
