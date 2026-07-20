//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:fijkplayer/fijkplayer.dart';
// import 'package:quadsu_app/widget/custom_appbar.dart';
//
// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;
//
//   VideoPlayerScreen({required this.videoUrl});
//
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late FijkPlayer _player;
//   ValueNotifier<bool> reload=ValueNotifier(false);
//   @override
//   void initState() {
//     super.initState();
//     _player = FijkPlayer();
//     _player.setDataSource(widget.videoUrl, autoPlay: true);
//     reload!=reload;
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _player.release(); // Release the player when the widget is removed
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         titleText: "Video Preview",
//       ),
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Flexible(
//                 child: FijkView(
//                   color: Colors.black,
//                   player: _player,
//                 ),
//               ),
//               // VideoControls(player: _player),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // class VideoControls extends StatelessWidget {
// //   final FijkPlayer player;
// //
// //   VideoControls({required this.player});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(8.0),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: <Widget>[
// //           IconButton(
// //             icon: Icon(
// //               player.value. ? Icons.pause : Icons.play_arrow,
// //             ),
// //             onPressed: () {
// //               if (player.value.isPlaying) {
// //                 player.pause();
// //               } else {
// //                 player.play();
// //               }
// //             },
// //           ),
// //           IconButton(
// //             icon: Icon(Icons.stop),
// //             onPressed: () {
// //               player.pause();
// //               player.seekTo(Duration.zero);
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
