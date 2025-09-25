import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../core/errors/failures.dart';

abstract class StorageRepository {
  // File Upload Operations
  Future<Either<Failure, UploadTask>> uploadFile({
    required String filePath,
    required String fileName,
    String? folder,
    Map<String, dynamic>? metadata,
  });

  Future<Either<Failure, UploadTask>> uploadImage({
    required String imagePath,
    required String imageName,
    String? folder,
    bool compress = true,
    int maxWidth = 1920,
    int maxHeight = 1080,
    int quality = 85,
  });

  Future<Either<Failure, UploadTask>> uploadVideo({
    required String videoPath,
    required String videoName,
    String? folder,
    bool compress = true,
    String preset = 'medium',
  });

  Future<Either<Failure, UploadTask>> uploadDocument({
    required String documentPath,
    required String documentName,
    String? folder,
  });

  Future<Either<Failure, String>> downloadFile(String fileUrl, String localPath);

  Future<Either<Failure, String>> getFileUrl(String fileName, String folder);

  Future<Either<Failure, void>> deleteFile(String fileName, String folder);

  Future<Either<Failure, List<Reference>>> listFiles(String folder, {
    int maxResults = 100,
    String? pageToken,
  });

  Future<Either<Failure, FullMetadata>> getFileMetadata(String fileName, String folder);

  Future<Either<Failure, void>> updateFileMetadata(String fileName, String folder, Map<String, dynamic> metadata);

  Future<Either<Failure, String>> copyFile(String sourceFileName, String sourceFolder, String destFileName, String destFolder);

  Future<Either<Failure, String>> moveFile(String sourceFileName, String sourceFolder, String destFileName, String destFolder);

  Future<Either<Failure, int>> getFileSize(String filePath);

  Future<Either<Failure, int>> getFileSizeFromStorage(String fileName, String folder);

  Future<Either<Failure, String>> generateThumbnail(String imageName, String imageFolder, {
    int width = 200,
    int height = 200,
    bool keepAspectRatio = true,
  });

  Future<Either<Failure, String>> compressImage(String imageName, String imageFolder, {
    int quality = 85,
    int maxWidth = 1920,
    int maxHeight = 1080,
  });

  Future<Either<Failure, StorageUsage>> getStorageUsage(String folder);

  Future<Either<Failure, List<String>>> batchUploadFiles(List<FileUploadRequest> requests);

  // Stream Operations
  Stream<Either<Failure, FileUploadProgress>> uploadProgress(String fileName);

  Stream<Either<Failure, List<Reference>>> filesListStream(String folder);

  Stream<Either<Failure, StorageUsage>> storageUsageStream(String folder);

  // Validation Operations
  Future<Either<Failure, FileValidationResult>> validateFile(String filePath, String fileName);

  Future<Either<Failure, bool>> isFileTypeAllowed(String fileName, List<String> allowedTypes);

  Future<Either<Failure, bool>> isFileSizeAllowed(String filePath, int maxSizeBytes);

  Future<Either<Failure, String>> getOptimizedFileName(String originalName, String folder);

  // Batch Operations
  Future<Either<Failure, BatchUploadResult>> uploadFilesBatch(List<FileUploadRequest> requests);

  Future<Either<Failure, void>> deleteFilesBatch(List<String> fileNames, String folder);

  Future<Either<Failure, List<String>>> copyFilesBatch(List<FileCopyRequest> requests);

  Future<Either<Failure, List<String>>> moveFilesBatch(List<FileMoveRequest> requests);

  // Advanced Operations
  Future<Either<Failure, String>> uploadWithProgressTracking({
    required String filePath,
    required String fileName,
    String? folder,
    Map<String, dynamic>? metadata,
    Function(double progress)? onProgress,
    Function()? onComplete,
    Function(String error)? onError,
  });

  Future<Either<Failure, void>> pauseUpload(String fileName);

  Future<Either<Failure, void>> resumeUpload(String fileName);

  Future<Either<Failure, void>> cancelUpload(String fileName);

  Future<Either<Failure, List<String>>> searchFiles(String folder, String query);

  Future<Either<Failure, void>> setStorageQuota(String folder, int maxBytes);

  Future<Either<Failure, int>> getStorageQuota(String folder);

  // CDN Operations
  Future<Either<Failure, String>> getCDNUrl(String fileName, String folder);

  Future<Either<Failure, void>> invalidateCDNCache(String fileName, String folder);

  Future<Either<Failure, void>> purgeCDNCache(String folder);

  // Security Operations
  Future<Either<Failure, void>> setFileAccessControl(String fileName, String folder, String accessLevel);

  Future<Either<Failure, String>> generateSignedUrl(String fileName, String folder, Duration expiration);

  Future<Either<Failure, void>> setCorsPolicy(List<CorsRule> rules);

  Future<Either<Failure, List<CorsRule>>> getCorsPolicy();

  // Analytics Operations
  Future<Either<Failure, StorageAnalytics>> getStorageAnalytics(String folder, DateTime startDate, DateTime endDate);

  Future<Either<Failure, List<FileAccessLog>>> getFileAccessLogs(String fileName, String folder, {
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  });

  Future<Either<Failure, Map<String, int>>> getPopularFiles(String folder, {
    DateTime? startDate,
    DateTime? endDate,
    int limit = 20,
  });

  // Backup & Recovery
  Future<Either<Failure, String>> backupFolder(String folder, String backupName);

  Future<Either<Failure, void>> restoreFolder(String folder, String backupName);

  Future<Either<Failure, List<String>>> listBackups(String folder);

  Future<Either<Failure, void>> deleteBackup(String backupName);

  // Real-time Operations
  Stream<Either<Failure, FileUploadProgress>> getUploadProgress(String fileName);

  Stream<Either<Failure, StorageEvent>> getStorageEvents(String folder);

  Stream<Either<Failure, bool>> getConnectionStatus();
}

// Supporting Classes
class FileUploadRequest {
  final String filePath;
  final String fileName;
  final String? folder;
  final Map<String, dynamic>? metadata;
  final FileUploadOptions? options;

  const FileUploadRequest({
    required this.filePath,
    required this.fileName,
    this.folder,
    this.metadata,
    this.options,
  });
}

class FileCopyRequest {
  final String sourceFileName;
  final String sourceFolder;
  final String destFileName;
  final String destFolder;
  final Map<String, dynamic>? metadata;

  const FileCopyRequest({
    required this.sourceFileName,
    required this.sourceFolder,
    required this.destFileName,
    required this.destFolder,
    this.metadata,
  });
}

class FileMoveRequest {
  final String sourceFileName;
  final String sourceFolder;
  final String destFileName;
  final String destFolder;

  const FileMoveRequest({
    required this.sourceFileName,
    required this.sourceFolder,
    required this.destFileName,
    required this.destFolder,
  });
}

class FileValidationResult {
  final bool isValid;
  final String? errorMessage;
  final Map<String, dynamic> metadata;
  final FileTypeInfo? fileTypeInfo;

  const FileValidationResult({
    required this.isValid,
    this.errorMessage,
    this.metadata = const {},
    this.fileTypeInfo,
  });
}

class FileTypeInfo {
  final String mimeType;
  final String extension;
  final String category;
  final bool isImage;
  final bool isVideo;
  final bool isDocument;
  final bool isAudio;
  final int? width;
  final int? height;
  final int duration; // for video/audio

  const FileTypeInfo({
    required this.mimeType,
    required this.extension,
    required this.category,
    this.isImage = false,
    this.isVideo = false,
    this.isDocument = false,
    this.isAudio = false,
    this.width,
    this.height,
    this.duration = 0,
  });
}

class StorageUsage {
  final int totalBytes;
  final int usedBytes;
  final int availableBytes;
  final double usagePercentage;
  final Map<String, int> folderSizes;
  final DateTime lastUpdated;

  const StorageUsage({
    required this.totalBytes,
    required this.usedBytes,
    required this.availableBytes,
    required this.usagePercentage,
    this.folderSizes = const {},
    required this.lastUpdated,
  });
}

class FileUploadProgress {
  final String fileName;
  final String? folder;
  final double progress;
  final int bytesTransferred;
  final int totalBytes;
  final UploadState state;
  final String? errorMessage;
  final DateTime startedAt;
  final DateTime? completedAt;

  const FileUploadProgress({
    required this.fileName,
    this.folder,
    required this.progress,
    required this.bytesTransferred,
    required this.totalBytes,
    required this.state,
    this.errorMessage,
    required this.startedAt,
    this.completedAt,
  });
}

enum UploadState {
  initializing('initializing', 'Başlatılıyor'),
  uploading('uploading', 'Yükleniyor'),
  pausing('pausing', 'Durduruluyor'),
  paused('paused', 'Durduruldu'),
  resuming('resuming', 'Devam Ediyor'),
  completed('completed', 'Tamamlandı'),
  cancelled('cancelled', 'İptal Edildi'),
  failed('failed', 'Başarısız');

  const UploadState(this.value, this.displayName);
  final String value;
  final String displayName;
}

class StorageEvent {
  final String fileName;
  final String folder;
  final StorageEventType type;
  final DateTime timestamp;
  final String? userId;
  final Map<String, dynamic>? metadata;

  const StorageEvent({
    required this.fileName,
    required this.folder,
    required this.type,
    required this.timestamp,
    this.userId,
    this.metadata,
  });
}

enum StorageEventType {
  uploadStarted('upload_started', 'Yükleme Başladı'),
  uploadProgress('upload_progress', 'Yükleme Devam Ediyor'),
  uploadCompleted('upload_completed', 'Yükleme Tamamlandı'),
  uploadFailed('upload_failed', 'Yükleme Başarısız'),
  downloadStarted('download_started', 'İndirme Başladı'),
  downloadCompleted('download_completed', 'İndirme Tamamlandı'),
  downloadFailed('download_failed', 'İndirme Başarısız'),
  fileDeleted('file_deleted', 'Dosya Silindi'),
  metadataUpdated('metadata_updated', 'Meta Veriler Güncellendi'),
  accessGranted('access_granted', 'Erişim Verildi'),
  accessRevoked('access_revoked', 'Erişim Kaldırıldı');

  const StorageEventType(this.value, this.displayName);
  final String value;
  final String displayName;
}

class StorageAnalytics {
  final String folder;
  final DateTime startDate;
  final DateTime endDate;
  final int totalUploads;
  final int totalDownloads;
  final int totalDeletes;
  final Map<String, int> uploadsByType;
  final Map<String, int> downloadsByType;
  final Map<String, int> errorsByType;
  final Map<String, double> averageFileSizes;
  final Map<String, double> uploadSpeeds;
  final Map<String, int> popularFiles;
  final Map<String, int> userActivity;

  const StorageAnalytics({
    required this.folder,
    required this.startDate,
    required this.endDate,
    required this.totalUploads,
    required this.totalDownloads,
    required this.totalDeletes,
    this.uploadsByType = const {},
    this.downloadsByType = const {},
    this.errorsByType = const {},
    this.averageFileSizes = const {},
    this.uploadSpeeds = const {},
    this.popularFiles = const {},
    this.userActivity = const {},
  });
}

class FileAccessLog {
  final String fileName;
  final String folder;
  final String userId;
  final String action;
  final String ipAddress;
  final String userAgent;
  final DateTime timestamp;
  final bool isSuccessful;
  final int fileSize;
  final String? errorMessage;

  const FileAccessLog({
    required this.fileName,
    required this.folder,
    required this.userId,
    required this.action,
    required this.ipAddress,
    required this.userAgent,
    required this.timestamp,
    required this.isSuccessful,
    required this.fileSize,
    this.errorMessage,
  });
}

class CorsRule {
  final String origin;
  final List<String> methods;
  final List<String> headers;
  final int maxAgeSeconds;

  const CorsRule({
    required this.origin,
    this.methods = const ['GET', 'POST', 'PUT', 'DELETE'],
    this.headers = const ['*'],
    this.maxAgeSeconds = 3600,
  });

  Map<String, dynamic> toJson() {
    return {
      'origin': origin,
      'methods': methods,
      'headers': headers,
      'maxAgeSeconds': maxAgeSeconds,
    };
  }

  factory CorsRule.fromJson(Map<String, dynamic> json) {
    return CorsRule(
      origin: json['origin'],
      methods: List<String>.from(json['methods'] ?? ['GET', 'POST', 'PUT', 'DELETE']),
      headers: List<String>.from(json['headers'] ?? ['*']),
      maxAgeSeconds: json['maxAgeSeconds'] ?? 3600,
    );
  }
}

class StorageQuota {
  final String folder;
  final int maxBytes;
  final int currentUsage;
  final bool isUnlimited;

  const StorageQuota({
    required this.folder,
    required this.maxBytes,
    required this.currentUsage,
    this.isUnlimited = false,
  });

  bool get isExceeded => !isUnlimited && currentUsage >= maxBytes;

  double get usagePercentage => isUnlimited ? 0.0 : (currentUsage / maxBytes) * 100;

  int get remainingBytes => isUnlimited ? -1 : (maxBytes - currentUsage);

  String get maxFormatted => _formatBytes(maxBytes);
  String get currentFormatted => _formatBytes(currentUsage);
  String get remainingFormatted => isUnlimited ? 'Sınırsız' : _formatBytes(remainingBytes);

  String _formatBytes(int bytes) {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    int unitIndex = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(1)} ${units[unitIndex]}';
  }
}

class BatchUploadResult {
  final List<String> successfulUploads;
  final List<String> failedUploads;
  final Map<String, String> errors;
  final Duration totalDuration;
  final int totalBytesUploaded;

  const BatchUploadResult({
    this.successfulUploads = const [],
    this.failedUploads = const [],
    this.errors = const {},
    required this.totalDuration,
    this.totalBytesUploaded = 0,
  });

  bool get hasFailures => failedUploads.isNotEmpty;
  bool get hasSuccess => successfulUploads.isNotEmpty;
  int get totalFiles => successfulUploads.length + failedUploads.length;
  int get successCount => successfulUploads.length;
  int get failureCount => failedUploads.length;
  double get successRate => totalFiles > 0 ? (successCount / totalFiles) * 100 : 0.0;
}
