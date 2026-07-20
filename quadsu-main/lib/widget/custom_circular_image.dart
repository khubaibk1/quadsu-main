// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:quadsu_app/constants/my_image_url.dart';
//
// // import 'customLoader.dart';
//
// enum CustomFileType { asset, network, file }
//
// class CustomCircularImage extends StatelessWidget {
//   final double height;
//   final double width;
//   final double? borderRadius;
//   final String? imageUrl;
//   final String? staticImageUrl;
//   final CustomFileType fileType;
//   final File? image;
//   final BoxFit? fit;
//   final Color? bgColor;
//   final double padding;
//   final BoxBorder? border;
//   final BorderRadius? borderFrom;
//   final bool isCircleBorder;
//   const CustomCircularImage(
//       {Key? key,
//         required this.imageUrl,
//         this.image,
//         this.staticImageUrl,
//         this.height = 60,
//         this.width = 60,
//         this.padding = 0,
//         this.borderRadius,
//         this.fileType = CustomFileType.network,
//         this.fit,
//         this.bgColor,
//         this.borderFrom,
//         this.isCircleBorder=true,
//         this.border})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(padding),
//       clipBehavior: Clip.hardEdge,
//       decoration: BoxDecoration(
//         color: bgColor,
//         border: border,
//         borderRadius:isCircleBorder? BorderRadius.circular(borderRadius??height):borderFrom,
//
//       ),
//       child: Container(
//         height: height,
//         width: width,
//         clipBehavior: Clip.hardEdge,
//         decoration: BoxDecoration(
//             borderRadius:isCircleBorder? BorderRadius.circular(borderRadius??height):borderFrom,
//             image:(imageUrl==null && image==null) || fileType == CustomFileType.asset
//                 ? DecorationImage(
//               image: AssetImage(imageUrl??staticImageUrl??MyImagesUrl.star),
//               fit: fit??BoxFit.cover,
//             )
//                 : fileType == CustomFileType.file
//                 ? DecorationImage(image: FileImage(image!),fit: fit??BoxFit.cover,)
//                 :fileType == CustomFileType.network?
//                DecorationImage(image: CachedNetworkImageProvider(imageUrl!), fit:fit?? BoxFit.cover):
//             // DecorationImage(
//             //   image: NetworkImage(
//             //     imageUrl
//             //   ),
//             //
//             //   fit: fit??BoxFit.cover,
//             // ),
//             null),
//         // child: fileType == CustomFileType.network
//         //     ? CachedNetworkImage(
//         //   imageUrl: imageUrl,
//         //   placeholder: (context, url) => Padding(
//         //     padding: const EdgeInsets.all(8.0),
//         //     child: CustomLoader(),
//         //   ),
//         //   fit: fit??BoxFit.cover,
//         //   errorWidget: (context, url, error) => Icon(Icons.error),
//         // )
//         //     : null,
//       ),
//     );
//   }
// }