import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DownloadServices {
  /// Saves a network image into app-scoped storage and returns the file.
  ///
  /// This used to request Permission.manageExternalStorage and write to a
  /// hardcoded /storage/emulated/0/Download/. That permission was never
  /// declared in the manifest, so the request always failed and downloads
  /// threw. Declaring it is not an option either: Google Play restricts
  /// MANAGE_EXTERNAL_STORAGE to file managers, antivirus and backup apps.
  ///
  /// App-scoped storage needs no permission on any Android version. Files
  /// land under /Android/data/<package>/files/ rather than the public
  /// Downloads folder, so they are not visible in the gallery.
  static Future<File?> saveNetworkImage({
    required String url,
    required String name,
    required String ext,
  }) async {
    final directory =
        await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to download file: ${response.statusCode}');
    }

    final file = File('${directory.path}/$name.$ext');
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file;
  }

  /// Downloads a file into the app's private documents directory and returns
  /// its path, or null if the download failed.
  static Future<String?> getFilePath({
    required String url,
    required String name,
    required String ext,
  }) async {
    final downloadsDirectory = await getApplicationDocumentsDirectory();

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final filePath = '${downloadsDirectory.path}/$name.$ext';
      final file = File(filePath);
      file.writeAsBytesSync(response.bodyBytes, flush: true);
      return file.path;
    } else {
      return null;
    }
  }
}
