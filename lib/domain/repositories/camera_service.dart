import '../models/captured_media.dart';

abstract class CameraService {
  Future<CapturedMedia?> takePicture();
}
