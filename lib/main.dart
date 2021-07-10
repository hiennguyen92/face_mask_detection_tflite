import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';


List<CameraDescription> listCamera;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  listCamera = await availableCameras();
  runApp(MyApp());
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData.light(),
      home: MainPage(),
    )
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
  String result = "";

  @override
  @override
  void initState() {
    super.initState();
    initCamera();
    loadModel();
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
                child: _cameraController.value.isInitialized
                    ? Container()
                    : AspectRatio(
                  aspectRatio: _cameraController.value.aspectRatio,
                  child: CameraPreview(_cameraController),
                ),
              ),
            ),
            Text(
              result,
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
            )
          ],
        ),
      ),
    );
  }

  void initCamera() {
    _cameraController =
        CameraController(listCamera[0], ResolutionPreset.medium);
    _cameraController
        .initialize()
        .then((value) => {
      setState(() {
        _cameraController.startImageStream((image) => {
          _cameraImage = image;
          runModel();
        });
      })
    });
  }

  void loadModel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
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


