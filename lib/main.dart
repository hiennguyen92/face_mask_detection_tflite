import 'package:face_mask_detection_tflite/app/app_router.dart';
import 'package:face_mask_detection_tflite/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tflite/tflite.dart';

late List<CameraDescription> listCamera;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  listCamera = await availableCameras();
  runApp(Application());
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(375, 812),
        builder: () {
          return new MaterialApp(
            theme: ThemeData.light(),
            onGenerateRoute: AppRoute.generateRoute,
            initialRoute: AppRoute.splashScreen,
            navigatorKey: NavigationService.navigationKey
          );
        });
  }
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  late CameraImage _cameraImage;
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  String result = "";

  @override
  void initState() {
    super.initState();
    initCamera();
    loadModel();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Face Mask Detector"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: MediaQuery.of(context).size.height - 170,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, display the preview.
                      return AspectRatio(
                        aspectRatio: _cameraController.value.aspectRatio,
                        child: CameraPreview(_cameraController),
                      );
                    } else {
                      // Otherwise, display a loading indicator.
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
            Text(
              result,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            )
          ],
        ),
      ),
    );
  }

  void initCamera() {
    _cameraController =
        CameraController(listCamera[1], ResolutionPreset.medium);
    _initializeControllerFuture =
        _cameraController.initialize().then((value) => {
              setState(() {
                _cameraController.startImageStream((image) {
                  _cameraImage = image;
                  runModel();
                });
              })
            });
  }

  void loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/labels.txt");
  }

  void runModel() async {
    var recognitions = await Tflite.runModelOnFrame(
        bytesList: _cameraImage.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: _cameraImage.height,
        imageWidth: _cameraImage.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true);
    recognitions!.forEach((element) {
      setState(() {
        result = element["label"];
        print(result);
      });
    });
  }
}
