// import 'dart:io';
//
// import 'package:share_plus/share_plus.dart';
// import 'package:video_compress/video_compress.dart';
//
// class FileServices{
//
//   static Future<void> shareFiles({required List<String> files}) async {
//     Share.shareFiles(files,
//         text: "Check out this image from Sidelick! ",
//         subject: "Check out this image from Sidelick! ");
//   }
//
//
//   static Future<File> compressVideo({required String path}) async {
//     MediaInfo? mediaInfo = await VideoCompress.compressVideo(
//       path,
//       quality: VideoQuality.LowQuality,
//       deleteOrigin: false, // It's false by default
//     );
//     File fi = File(path.toString());
//     int fileSize = await fi.length();
//     print('before compress video $fileSize bytes');
//     print('after compress video ${mediaInfo!.filesize}');
//     var f = File(mediaInfo.path.toString());
//     return f;
//   }
// }