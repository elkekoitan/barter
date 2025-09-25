import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../repositories/storage_repository.dart';
import '../../../core/errors/failures.dart';

class UploadFileUseCase {
  final StorageRepository _repository;

  const UploadFileUseCase(this._repository);

  Future<Either<Failure, UploadTask>> call({
    required String filePath,
    required String fileName,
    String? folder,
    Map<String, dynamic>? metadata,
  }) async {
    // Validation
    if (filePath.isEmpty) {
      return const Left(ValidationFailure('File path cannot be empty'));
    }

    if (fileName.isEmpty) {
      return const Left(ValidationFailure('File name cannot be empty'));
    }

    // Validate file extension
    final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'mp4', 'mov', 'avi', 'pdf', 'doc', 'docx'];
    final extension = fileName.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      return const Left(ValidationFailure('File type not supported'));
    }

    // Validate file size (max 50MB)
    final file = await _repository.getFileSize(filePath);
    if (file.isLeft()) {
      return file;
    }

    final fileSize = file.getOrElse(() => 0);
    if (fileSize > 50 * 1024 * 1024) { // 50MB
      return const Left(ValidationFailure('File size too large (max 50MB)'));
    }

    return await _repository.uploadFile(
      filePath: filePath,
      fileName: fileName,
      folder: folder,
      metadata: metadata,
    );
  }
}

class UploadImageUseCase {
  final StorageRepository _repository;

  const UploadImageUseCase(this._repository);

  Future<Either<Failure, UploadTask>> call({
    required String imagePath,
    required String imageName,
    String? folder,
    bool compress = true,
    int maxWidth = 1920,
    int maxHeight = 1080,
    int quality = 85,
  }) async {
    // Validation
    if (imagePath.isEmpty) {
      return const Left(ValidationFailure('Image path cannot be empty'));
    }

    if (imageName.isEmpty) {
      return const Left(ValidationFailure('Image name cannot be empty'));
    }

    // Validate image extension
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    final extension = imageName.split('.').last.toLowerCase();
    if (!imageExtensions.contains(extension)) {
      return const Left(ValidationFailure('Invalid image format'));
    }

    return await _repository.uploadImage(
      imagePath: imagePath,
      imageName: imageName,
      folder: folder,
      compress: compress,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      quality: quality,
    );
  }
}

class UploadVideoUseCase {
  final StorageRepository _repository;

  const UploadVideoUseCase(this._repository);

  Future<Either<Failure, UploadTask>> call({
    required String videoPath,
    required String videoName,
    String? folder,
    bool compress = true,
    String preset = 'medium',
  }) async {
    // Validation
    if (videoPath.isEmpty) {
      return const Left(ValidationFailure('Video path cannot be empty'));
    }

    if (videoName.isEmpty) {
      return const Left(ValidationFailure('Video name cannot be empty'));
    }

    // Validate video extension
    final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', 'webm'];
    final extension = videoName.split('.').last.toLowerCase();
    if (!videoExtensions.contains(extension)) {
      return const Left(ValidationFailure('Invalid video format'));
    }

    return await _repository.uploadVideo(
      videoPath: videoPath,
      videoName: videoName,
      folder: folder,
      compress: compress,
      preset: preset,
    );
  }
}

class UploadDocumentUseCase {
  final StorageRepository _repository;

  const UploadDocumentUseCase(this._repository);

  Future<Either<Failure, UploadTask>> call({
    required String documentPath,
    required String documentName,
    String? folder,
  }) async {
    // Validation
    if (documentPath.isEmpty) {
      return const Left(ValidationFailure('Document path cannot be empty'));
    }

    if (documentName.isEmpty) {
      return const Left(ValidationFailure('Document name cannot be empty'));
    }

    // Validate document extension
    final docExtensions = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt'];
    final extension = documentName.split('.').last.toLowerCase();
    if (!docExtensions.contains(extension)) {
      return const Left(ValidationFailure('Invalid document format'));
    }

    return await _repository.uploadDocument(
      documentPath: documentPath,
      documentName: documentName,
      folder: folder,
    );
  }
}

class DownloadFileUseCase {
  final StorageRepository _repository;

  const DownloadFileUseCase(this._repository);

  Future<Either<Failure, String>> call(String fileUrl, String localPath) async {
    // Validation
    if (fileUrl.isEmpty) {
      return const Left(ValidationFailure('File URL cannot be empty'));
    }

    if (localPath.isEmpty) {
      return const Left(ValidationFailure('Local path cannot be empty'));
    }

    return await _repository.downloadFile(fileUrl, localPath);
  }
}

class GetFileUrlUseCase {
  final StorageRepository _repository;

  const GetFileUrlUseCase(this._repository);

  Future<Either<Failure, String>> call(String fileName, String folder) async {
    // Validation
    if (fileName.isEmpty) {
      return const Left(ValidationFailure('File name cannot be empty'));
    }

    return await _repository.getFileUrl(fileName, folder);
  }
}

class DeleteFileUseCase {
  final StorageRepository _repository;

  const DeleteFileUseCase(this._repository);

  Future<Either<Failure, void>> call(String fileName, String folder) async {
    // Validation
    if (fileName.isEmpty) {
      return const Left(ValidationFailure('File name cannot be empty'));
    }

    return await _repository.deleteFile(fileName, folder);
  }
}

class ListFilesUseCase {
  final StorageRepository _repository;

  const ListFilesUseCase(this._repository);

  Future<Either<Failure, List<Reference>>> call(String folder, {
    int maxResults = 100,
    String? pageToken,
  }) async {
    // Validation
    if (folder.isEmpty) {
      return const Left(ValidationFailure('Folder cannot be empty'));
    }

    if (maxResults < 1 || maxResults > 1000) {
      return const Left(ValidationFailure('Max results must be between 1 and 1000'));
    }

    return await _repository.listFiles(folder, maxResults: maxResults, pageToken: pageToken);
  }
}

class GetFileMetadataUseCase {
  final StorageRepository _repository;

  const GetFileMetadataUseCase(this._repository);

  Future<Either<Failure, FullMetadata>> call(String fileName, String folder) async {
    // Validation
    if (fileName.isEmpty) {
      return const Left(ValidationFailure('File name cannot be empty'));
    }

    return await _repository.getFileMetadata(fileName, folder);
  }
}

class UpdateFileMetadataUseCase {
  final StorageRepository _repository;

  const UpdateFileMetadataUseCase(this._repository);

  Future<Either<Failure, void>> call(String fileName, String folder, Map<String, dynamic> metadata) async {
    // Validation
    if (fileName.isEmpty) {
      return const Left(ValidationFailure('File name cannot be empty'));
    }

    if (metadata.isEmpty) {
      return const Left(ValidationFailure('Metadata cannot be empty'));
    }

    return await _repository.updateFileMetadata(fileName, folder, metadata);
  }
}

class CopyFileUseCase {
  final StorageRepository _repository;

  const CopyFileUseCase(this._repository);

  Future<Either<Failure, String>> call(String sourceFileName, String sourceFolder, String destFileName, String destFolder) async {
    // Validation
    if (sourceFileName.isEmpty) {
      return const Left(ValidationFailure('Source file name cannot be empty'));
    }

    if (destFileName.isEmpty) {
      return const Left(ValidationFailure('Destination file name cannot be empty'));
    }

    return await _repository.copyFile(sourceFileName, sourceFolder, destFileName, destFolder);
  }
}

class MoveFileUseCase {
  final StorageRepository _repository;

  const MoveFileUseCase(this._repository);

  Future<Either<Failure, String>> call(String sourceFileName, String sourceFolder, String destFileName, String destFolder) async {
    // Validation
    if (sourceFileName.isEmpty) {
      return const Left(ValidationFailure('Source file name cannot be empty'));
    }

    if (destFileName.isEmpty) {
      return const Left(ValidationFailure('Destination file name cannot be empty'));
    }

    return await _repository.moveFile(sourceFileName, sourceFolder, destFileName, destFolder);
  }
}

class GetFileSizeUseCase {
  final StorageRepository _repository;

  const GetFileSizeUseCase(this._repository);

  Future<Either<Failure, int>> call(String fileName, String folder) async {
    // Validation
    if (fileName.isEmpty) {
      return const Left(ValidationFailure('File name cannot be empty'));
    }

    return await _repository.getFileSizeFromStorage(fileName, folder);
  }
}

class GenerateThumbnailUseCase {
  final StorageRepository _repository;

  const GenerateThumbnailUseCase(this._repository);

  Future<Either<Failure, String>> call(String imageName, String imageFolder, {
    int width = 200,
    int height = 200,
    bool keepAspectRatio = true,
  }) async {
    // Validation
    if (imageName.isEmpty) {
      return const Left(ValidationFailure('Image name cannot be empty'));
    }

    if (width < 1 || width > 1000) {
      return const Left(ValidationFailure('Width must be between 1 and 1000'));
    }

    if (height < 1 || height > 1000) {
      return const Left(ValidationFailure('Height must be between 1 and 1000'));
    }

    return await _repository.generateThumbnail(
      imageName,
      imageFolder,
      width: width,
      height: height,
      keepAspectRatio: keepAspectRatio,
    );
  }
}

class CompressImageUseCase {
  final StorageRepository _repository;

  const CompressImageUseCase(this._repository);

  Future<Either<Failure, String>> call(String imageName, String imageFolder, {
    int quality = 85,
    int maxWidth = 1920,
    int maxHeight = 1080,
  }) async {
    // Validation
    if (imageName.isEmpty) {
      return const Left(ValidationFailure('Image name cannot be empty'));
    }

    if (quality < 1 || quality > 100) {
      return const Left(ValidationFailure('Quality must be between 1 and 100'));
    }

    if (maxWidth < 1 || maxWidth > 4000) {
      return const Left(ValidationFailure('Max width must be between 1 and 4000'));
    }

    if (maxHeight < 1 || maxHeight > 4000) {
      return const Left(ValidationFailure('Max height must be between 1 and 4000'));
    }

    return await _repository.compressImage(
      imageName,
      imageFolder,
      quality: quality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
  }
}

class GetStorageUsageUseCase {
  final StorageRepository _repository;

  const GetStorageUsageUseCase(this._repository);

  Future<Either<Failure, StorageUsage>> call(String folder) async {
    // Validation
    if (folder.isEmpty) {
      return const Left(ValidationFailure('Folder cannot be empty'));
    }

    return await _repository.getStorageUsage(folder);
  }
}

class BatchUploadFilesUseCase {
  final StorageRepository _repository;

  const BatchUploadFilesUseCase(this._repository);

  Future<Either<Failure, List<String>>> call(List<FileUploadRequest> requests) async {
    // Validation
    if (requests.isEmpty) {
      return const Left(ValidationFailure('Requests cannot be empty'));
    }

    if (requests.length > 10) {
      return const Left(ValidationFailure('Maximum 10 files can be uploaded at once'));
    }

    for (final request in requests) {
      if (request.filePath.isEmpty || request.fileName.isEmpty) {
        return const Left(ValidationFailure('Invalid file request'));
      }
    }

    return await _repository.batchUploadFiles(requests);
  }
}

class FileUploadRequest {
  final String filePath;
  final String fileName;
  final String? folder;
  final Map<String, dynamic>? metadata;
  final bool compress;

  const FileUploadRequest({
    required this.filePath,
    required this.fileName,
    this.folder,
    this.metadata,
    this.compress = false,
  });
}

class StorageUsage {
  final int totalBytes;
  final int usedBytes;
  final int availableBytes;
  final double usagePercentage;
  final Map<String, int> folderSizes;

  const StorageUsage({
    required this.totalBytes,
    required this.usedBytes,
    required this.availableBytes,
    required this.usagePercentage,
    this.folderSizes = const {},
  });

  String get totalFormatted => _formatBytes(totalBytes);
  String get usedFormatted => _formatBytes(usedBytes);
  String get availableFormatted => _formatBytes(availableBytes);

  String _formatBytes(int bytes) {
    const units = ['B', 'KB', 'MB', 'GB'];
    int unitIndex = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(1)} ${units[unitIndex]}';
  }
}

class FileUploadProgress {
  final String fileName;
  final double progress;
  final int bytesTransferred;
  final int totalBytes;
  final UploadTask? task;
  final bool isCompleted;
  final bool isPaused;
  final bool hasError;

  const FileUploadProgress({
    required this.fileName,
    required this.progress,
    required this.bytesTransferred,
    required this.totalBytes,
    this.task,
    this.isCompleted = false,
    this.isPaused = false,
    this.hasError = false,
  });

  String get progressPercentage => '${(progress * 100).toInt()}%';
  String get transferredFormatted => _formatBytes(bytesTransferred);
  String get totalFormatted => _formatBytes(totalBytes);

  String _formatBytes(int bytes) {
    const units = ['B', 'KB', 'MB', 'GB'];
    int unitIndex = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(1)} ${units[unitIndex]}';
  }
}

class FileValidationResult {
  final bool isValid;
  final String? errorMessage;
  final Map<String, dynamic> metadata;

  const FileValidationResult({
    required this.isValid,
    this.errorMessage,
    this.metadata = const {},
  });
}

class FileUploadOptions {
  final bool compress;
  final bool generateThumbnail;
  final bool addWatermark;
  final int quality;
  final int maxWidth;
  final int maxHeight;
  final Map<String, dynamic> customMetadata;

  const FileUploadOptions({
    this.compress = true,
    this.generateThumbnail = false,
    this.addWatermark = false,
    this.quality = 85,
    this.maxWidth = 1920,
    this.maxHeight = 1080,
    this.customMetadata = const {},
  });
}

class BatchUploadResult {
  final List<String> successfulUploads;
  final List<String> failedUploads;
  final Map<String, String> errors;

  const BatchUploadResult({
    this.successfulUploads = const [],
    this.failedUploads = const [],
    this.errors = const {},
  });

  bool get hasFailures => failedUploads.isNotEmpty;
  bool get hasSuccess => successfulUploads.isNotEmpty;
  int get totalFiles => successfulUploads.length + failedUploads.length;
  int get successCount => successfulUploads.length;
  int get failureCount => failedUploads.length;
}
