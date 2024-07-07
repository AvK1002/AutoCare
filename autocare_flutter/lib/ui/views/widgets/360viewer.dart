import 'package:flutter/material.dart';
import 'package:imageview360/imageview360.dart';

class Image360Viewer extends StatefulWidget {
  final bool isCar;

  const Image360Viewer({Key? key, required this.isCar}) : super(key: key);

  @override
  State<Image360Viewer> createState() => _Image360ViewerState();
}

class _Image360ViewerState extends State<Image360Viewer> {
  List<ImageProvider> imageList = <ImageProvider>[];
  bool autoRotate = true;
  int rotationCount = 2;
  int swipeSensitivity = 2;
  bool allowSwipeToRotate = true;
  RotationDirection rotationDirection = RotationDirection.anticlockwise;
  Duration frameChangeDuration = const Duration(milliseconds: 500);
  bool imagePrecached = false;

  @override
  void initState() {
    //* To load images from assets after first frame build up.
    WidgetsBinding.instance
        .addPostFrameCallback((_) => updateImageList(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 72.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (imagePrecached == true)
                ? ImageView360(
                    key: UniqueKey(),
                    imageList: imageList,
                    autoRotate: autoRotate,
                    rotationCount: rotationCount,
                    rotationDirection: RotationDirection.anticlockwise,
                    frameChangeDuration: const Duration(milliseconds: 60),
                    swipeSensitivity: swipeSensitivity,
                    allowSwipeToRotate: allowSwipeToRotate,
                    onImageIndexChanged: (currentImageIndex) {
                      // print("currentImageIndex: $currentImageIndex");
                    },
                  )
                : const Text("Pre-Caching images..."),
          ],
        ),
      ),
    );
  }

  void updateImageList(BuildContext context) async {
    for (int i = 1; widget.isCar ? i <= 52 : i <= 35; i++) {
      imageList.add(AssetImage(widget.isCar
          ? 'assets/car/$i.png'
          : 'assets/bike/frame_${i - 1}_delay-0.1s.jpg'));
      //* To precache images so that when required they are loaded faster.
      await precacheImage(
          AssetImage(widget.isCar
              ? 'assets/car/$i.png'
              : 'assets/bike/frame_${i - 1}_delay-0.1s.jpg'),
          context);
    }
    setState(() {
      imagePrecached = true;
    });
  }
}
