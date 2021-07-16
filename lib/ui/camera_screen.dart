import 'package:camera/camera.dart';
import 'package:face_mask_detection_tflite/app/app_resources.dart';
import 'package:face_mask_detection_tflite/main.dart';
import 'package:face_mask_detection_tflite/view_models/camera_view_model.dart';
import 'package:face_mask_detection_tflite/view_states/base_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tflite/tflite.dart';

class CameraScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends BaseState<CameraScreen, CameraViewModel>
    with AutomaticKeepAliveClientMixin {
  late CameraImage _cameraImage;
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  String result = "";
  int cameraIdx = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    pageName = "Camera";
    viewModel = CameraViewModel(context);
    viewModel.loadData(isShowLoading: true);
    initCamera();
    loadModel();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void initCamera() {
    _cameraController =
        CameraController(listCamera[cameraIdx], ResolutionPreset.medium);
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
      if (mounted) {
        setState(() {
          result = element["label"];
          print(result);
        });
      }
    });
  }

  handleMenuItemClick(int item) {
    switch (item) {
      case 0:
        this.setState(() {
          cameraIdx = 0;
          initCamera();
        });
        break;
      case 1:
        this.setState(() {
          cameraIdx = 1;
          initCamera();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
        value: viewModel,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: AppColors.black,
            ),
            elevation: 0.0,
            centerTitle: true,
            actions: [
              PopupMenuButton<int>(
                  onSelected: (item) => handleMenuItemClick(item),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.camera_rear, color: AppColors.black),
                                Text(' Back'),
                              ],
                            ),
                            value: 0),
                        PopupMenuItem(
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.camera_front, color: AppColors.black),
                                Text(' Front'),
                              ],
                            ),
                            value: 0),
                      ])
            ],
            brightness: Brightness.light,
            backgroundColor: AppColors.yellow.withOpacity(0.6),
            title: Text(
              "Face Mask Detector",
              style: AppTextStyles.boldTextStyle(color: AppColors.black),
            ),
          ),
          body: initView(),
        ));
  }

  @override
  Widget buildView() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppColors.yellow.withOpacity(0.4),
            border: Border.all(color: AppColors.yellow, width: 5)),
        child: Column(
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
        ));
  }
}
