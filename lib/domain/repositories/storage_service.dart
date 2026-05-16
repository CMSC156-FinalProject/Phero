abstract class StorageService {
  /// Uploads a report image to Cloud Storage and returns the download URL.
  Future<String?> uploadReportImage(String userId, String reportId, String filePath);
}
