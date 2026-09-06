import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widget/show_snackbar.dart';

class DownloadServices {
  //static saveNetworkImage({required String url, required String name}) async {
  //  await Permission.manageExternalStorage.request();
  //  // var response = await Dio().get(
  //  //     "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg",
  //  //     options: Options(responseType: ResponseType.bytes));

  //  //Multicomment by manish

  //   var response = await http.post(Uri.parse(url));
  //  final result = await ImageGallerySaver.saveImage(
  //    response.bodyBytes,
  //    quality: 100,
  //    name: name,
  //  );

  //  // final result = await ImageGallerySaver.saveImage(
  //  //     Uint8List.fromList(response.body),
  //  //     quality: 60,
  //  //     name: "hello");
  //   print('asdfkljas f${result}');

  //
  //}

  static saveNetworkImage(
      {required String url, required String name, required String ext}) async {
    //For Android Only

    // Request permission to manage external storage
    await Permission.manageExternalStorage.request();

    // Check if permission is granted
    if (!(await Permission.manageExternalStorage.isGranted)) {
      throw Exception('Permission not granted');
    }

    // Get the downloads directory
    String downloadsDirectory = "/storage/emulated/0/Download/";

    final downloadDir = Directory(downloadsDirectory);
    if (!downloadDir.existsSync()) {
      downloadDir.createSync(recursive: true);
    }
    // Download the file and save it
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final filePath = '$downloadsDirectory/$name.$ext';
      final file = File(filePath);
      file.writeAsBytesSync(response.bodyBytes, flush: true);
    } else {
      throw Exception('Failed to download file: ${response.statusCode}');
    }
  }

  static Future<String?> getFilePath(
      {required String url, required String name, required String ext}) async {
    //For Android Only

    // Request permission to manage external storage
    await Permission.manageExternalStorage.request();

    // Check if permission is granted
    if (!(await Permission.manageExternalStorage.isGranted)) {
      showSnackbar("Please give access!");
      return null;

    }

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
