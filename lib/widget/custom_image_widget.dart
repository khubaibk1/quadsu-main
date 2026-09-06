import 'package:quadsu_app/services/custom_navigation_services.dart';
import 'package:quadsu_app/widget/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:quadsu_app/widget/custom_text.dart';
import '../constants/my_colors.dart';
import '../services/download_services.dart';
import 'custom_loader.dart';
import 'custom_scaffold.dart';


class ImageWidget extends StatelessWidget {
  final List image;
  final double? width;
  final double borderRadius;
  final Color? color;
  final bool isBoxShadow;
  final bool isDownloadIcon;
  final bool isShareIcon;
  final CustomFileType fileType;
  final Function()? onTap;
  ValueNotifier<bool> isDownload = ValueNotifier(false);

  ImageWidget(
      {super.key,
      required this.image,
      this.color,
      this.fileType = CustomFileType.asset,
      this.borderRadius = 12.0,
      this.isBoxShadow = true,
      this.isDownloadIcon = false,
      this.isShareIcon = true,
      this.onTap,
      this.width = 30});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: AppBar(
            backgroundColor: MyColors.primaryColor,
            leading: CloseButton(
              onPressed: () {
                CustomNavigation.pop(context);
              },
            ),
            actions: [
              isDownloadIcon
                  ? IconButton(
                      onPressed: () async {
                        isDownload.value = true;
                        await DownloadServices.saveNetworkImage(
                            url: image.first,
                            name: '${DateTime.now().millisecondsSinceEpoch}',
                            ext: 'png');
                        var snackBar = SnackBar(
                            content: CustomText.bodyText1(
                              'Download complete!',
                              color: MyColors.whiteColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                            duration: const Duration(seconds: 2));
                        isDownload.value = false;
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      icon: const Icon(
                        Icons.download_rounded,
                        size: 30,
                        color: MyColors.whiteColor,
                      ))
                  : Container(),
              isShareIcon
                  ? IconButton(
                      onPressed: () async {
                        isDownload.value = true;
                        String? path = await DownloadServices.getFilePath(
                            url: image.first,
                            name: '${DateTime.now().millisecondsSinceEpoch}',
                            ext: 'png');
                        isDownload.value = false;

                        ///Todo commented
                        // if (path != null) {
                        //   final file = XFile(path);
                        //   await FileServices.shareFiles(files: [file.path]);
                        // }
                      },
                      padding: const EdgeInsets.only(
                        right: 7,
                      ),
                      icon: const Icon(
                        Icons.share,
                        size: 26,
                        color: MyColors.whiteColor,
                      ) /*Image.asset(
                      MyImagesUrl.userWalkReportShare,
                      color: MyColors.whiteColor,
                      scale: 7.5,
                    )*/
                      ,
                    )
                  : Container()
            ]),
        backgroundColor: MyColors.blackColor,
        body: ValueListenableBuilder(
            valueListenable: isDownload,
            builder: (context, downloadValue, child) {
              return Stack(
                children: [
                  GestureDetector(
                      onTap: onTap,
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: [
                            if (isBoxShadow)
                              BoxShadow(
                                  color: MyColors.blackColor05,
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                  offset: const Offset(0, 0))
                          ],
                          borderRadius: BorderRadius.circular(borderRadius),
                          color: color,
                        ),
                        child: PinchZoom(
                          // clipBehavior: true,
                          // height: double.infinity,
                          // width: double.infinity,
                          child: CustomImage(
                            height: double.infinity,
                            width: double.infinity,
                            isBackgroundImage: false,
                            fit: BoxFit.contain,
                            borderRadius: 0,
                            imageUrl: image[0],
                            /*  loadingBuilder: (context, child, loadingProgress) {
                            print("loadingProgress:::::::::::${loadingProgress}");
                            if (loadingProgress == null) {
                              // If there's no loading progress, return the child (the image)
                              return child;
                            } else {
                              return const Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ParagraphText("Picture is Loading",
                                      color: MyColors.whiteColor),
                                  vSizedBox,
                                  CustomLoader(color: Colors.white),
                                ],
                              ));
                            }
                          },*/
                          ),
                        ), /*PhotoViewGallery.builder(
                          scrollPhysics: const BouncingScrollPhysics(),
                          scaleStateChangedCallback: (scaleState) {
                            // Logic to restrict zoom out beyond the original size

                            print("adtadtadtdatdatdatdt:::::::::::${scaleState}");
                            if (scaleState == PhotoViewScaleState.zoomedOut) {
                              scaleState = PhotoViewScaleState.initial;
                            }
                          },
                          builder: (BuildContext context, int index) {
                            switch (fileType) {
                              case CustomFileType.network:
                                {
                                  return PhotoViewGalleryPageOptions(
                                      imageProvider:
                                          // fileType==CustomFileType.network?
                                          NetworkImage(image[index]),

                                      // :
                                      // AssetImage(image[index]),
                                      initialScale:
                                          PhotoViewComputedScale.contained * 1,
                                      scaleStateCycle: (scaleState) {
                                        print("datdatdatdtadtadatta::::::");
                                        var state = scaleState;
                                        if (state == PhotoViewScaleState.zoomedOut) {
                                          state = PhotoViewScaleState.initial;
                                        }

                                        return state;
                                      },
                                      minScale: PhotoViewComputedScale.contained * 1);
                                }
                              default:
                                return PhotoViewGalleryPageOptions(
                                    imageProvider:
                                        // fileType==CustomFileType.network?
                                        AssetImage(image[index]),
                                    // :
                                    // AssetImage(image[index]),
                                    initialScale: PhotoViewComputedScale.contained * 1,
                                    minScale: 0.2);
                            }
                          },
                          itemCount: image.length,
                          // loadingBuilder: (context, event) => Center(
                          //   child: Container(
                          //     width: 20.0,
                          //     height: 20.0,
                          //     child: CircularProgressIndicator(
                          //       value: event == null
                          //           ? 0
                          //           : event.cumulativeBytesLoaded
                          //     ),
                          //   ),
                          // ),
                          // backgroundDecoration: widget.backgroundDecoration,
                          // pageController: widget.pageController,
                          // onPageChanged: onPageChanged,
                        )*/
                      )),
                  if (downloadValue)
                    Container(
                      color: Colors.black.withOpacity(0.8),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomLoader(color: MyColors.whiteColor),
                        ],
                      ),
                    )
                ],
              );
            }));

    // PageView(
    //   children:  image.map((i) {
    //     return Builder(
    //       builder: (BuildContext context) {
    //         return Image.asset(image[i],width: width,fit: BoxFit.fitWidth,);
    //       },
    //     );
    //   }).toList(),
    //       // ),
    //     ),
    //   ),
    // );
  }
}

class ZoomableImage extends StatefulWidget {
  final ImageProvider imageProvider;

  const ZoomableImage({super.key, required this.imageProvider});

  @override
  _ZoomableImageState createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  double _scale = 1.0;
  double _previousScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        _previousScale = _scale;
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          _scale = _previousScale * details.scale;
          // Restrict zoom out beyond original size
          _scale = _scale.clamp(
              1.0, 3.0); // Change the maximum scale factor as needed
        });
      },
      child: Center(
        child: Transform.scale(
          scale: _scale,
          child: Image(image: widget.imageProvider),
        ),
      ),
    );
  }
}
