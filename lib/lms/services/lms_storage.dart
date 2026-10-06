import 'dart:convert';
import 'dart:io';
import '../models/user_progress.dart';

abstract class LmsStorage {
  Future<UserProgress?> loadProgress();
  Future<void> saveProgress(UserProgress progress);
}

/// File-based local storage that persists to a local JSON file when possible,
/// with automatic in-memory safety.
class LocalFileLmsStorage implements LmsStorage {
  static const String _fileName = '.flutter_lms_progress.json';
  UserProgress? _memoryCache;

  File? _getStorageFile() {
    try {
      // In mobile/desktop environments or local execution
      final dir = Directory.current;
      return File('${dir.path}/$_fileName');
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserProgress?> loadProgress() async {
    if (_memoryCache != null) return _memoryCache;

    try {
      final file = _getStorageFile();
      if (file != null && await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          final data = json.decode(content) as Map<String, dynamic>;
          _memoryCache = UserProgress.fromMap(data);
          return _memoryCache;
        }
      }
    } catch (e) {
      // Graceful fallback to default in memory if file permission or environment is constrained
    }
    return _memoryCache;
  }

  @override
  Future<void> saveProgress(UserProgress progress) async {
    _memoryCache = progress;
    try {
      final file = _getStorageFile();
      if (file != null) {
        await file.writeAsString(progress.toJson());
      }
    } catch (e) {
      // Memory state is maintained even if disk write fails
    }
  }
}
