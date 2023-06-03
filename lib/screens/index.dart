import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

List<CameraDescription> _cameras = <CameraDescription>[];

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  // This enum is from a different package, so a new value could be added at
  // any time. The example should keep working if that happens.
  // ignore: dead_code
  return Icons.camera;
}

void _logError(String code, String? message) {
  // ignore: avoid_print
  print('Error: $code${message == null ? '' : '\nError Message: $message'}');
}

class _IndexScreenState extends State<IndexScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  XFile? videoFile;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  XFile? imageFile;

  bool ready = false;

  String kullaniciAdi = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    init();
  }

  Future<void> init() async {
    try {
      _cameras = await availableCameras();
      setState(() {
        ready = true;
        controller = CameraController(_cameras[0], ResolutionPreset.high);
      });

      await controller!.initialize();
    } on CameraException catch (_) {
      debugPrint("Camera hatası");
    }
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // #docregion AppLifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  // #enddocregion AppLifecycle
  Widget drawer() {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(
              child: Text("Menü",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 32)),
            ),
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: myBoxDecoration(),
                child: ListTile(
                  leading: const Icon(Icons.photo_album, size: 40),
                  title: const Text(
                    "Çekilen Fotoğraflar",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      "/photos",
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }

  @override
  Widget build(BuildContext context) {
    kullaniciAdi = ModalRoute.of(context)!.settings.arguments as String? ?? "Varsayılan Kullanıcı Adı";
    return Scaffold(
      drawer: drawer(),
      body: SafeArea(
          child: Material(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          width: double.infinity,
          height: double.infinity,
          child: Visibility(
              visible: ready,
              child: Stack(
                children: [
                  Positioned.fill(
                      child: ready == true
                          ? CameraPreview(controller!)
                          : Container()),
                  Positioned(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(kullaniciAdi,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white)),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/', arguments: "deneme");
                            },
                            child: const Text("Çıkış",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)))
                      ],
                    ),
                  )),
                  Positioned(
                    bottom: 50,
                    width: MediaQuery.of(context).size.width,
                    child: IconButton(
                        alignment: Alignment.center,
                        onPressed: () async {
                          try {
                            if (controller != null) {
                              //check if contrller is not null
                              if (controller!.value.isInitialized) {
                                //check if controller is initialized
                                imageFile = await controller!
                                    .takePicture(); //capture image
                                var content = await imageFile?.readAsBytes();
                                Navigator.of(context)
                                    .pushNamed //navigate to preview screen
                                    ('/preview', arguments: {
                                  "foto": content,
                                  "adres": imageFile!.path
                                });
                                setState(() {
                                  //update UI
                                });
                              }
                            }
                          } catch (e) {
                            if (kDebugMode) {
                              print("e");
                            }
                          }
                          debugPrint("Kamera çekim  yaptı");
                        },
                        icon: const Icon(
                          Icons.camera,
                          size: 72,
                        )),
                  )
                ],
              )),
        ),
      )),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final CameraController? oldController = controller;
    if (oldController != null) {
      // `controller` needs to be set to null before getting disposed,
      // to avoid a race condition when we use the controller that is being
      // disposed. This happens when camera permission dialog shows up,
      // which triggers `didChangeAppLifecycleState`, which disposes and
      // re-creates the controller.
      controller = null;
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() async {
    takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          imageFile = file;
          videoController?.dispose();
          videoController = null;
        });
        if (file != null) {
          showInSnackBar('Picture saved to ${file.path}');
        }
      }
    });
  }

  Future<void> setExposureOffset(double offset) async {
    if (controller == null) {
      return;
    }

    setState(() {});
    try {
      offset = await controller!.setExposureOffset(offset);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}
