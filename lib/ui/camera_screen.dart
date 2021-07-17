import 'dart:math';

import 'package:camera/camera.dart';
import 'package:face_mask_detection_tflite/app/app_resources.dart';
import 'package:face_mask_detection_tflite/main.dart';
import 'package:face_mask_detection_tflite/services/tensorflow_service.dart';
import 'package:face_mask_detection_tflite/view_models/camera_view_model.dart';
import 'package:face_mask_detection_tflite/view_states/base_state.dart';
import 'package:face_mask_detection_tflite/widgets/confidence_widget.dart';
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
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final TensorFlowService _tensorFlowService = TensorFlowService();
  late CameraImage _cameraImage;
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  List<dynamic> _recognitions = <dynamic>[];
  int cameraIdx = 1;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    pageName = "Camera";
    viewModel = CameraViewModel(context);
    viewModel.loadData(isShowLoading: true);
    WidgetsBinding.instance?.addObserver(this);
    initCamera();
    loadModel();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
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

  void loadModel() {
    _tensorFlowService.loadModel();
  }

  void runModel() async {
    var recognitions = await _tensorFlowService.runModelOnFrame(_cameraImage);
    _updateRecognitions(
      recognitions: recognitions,
    );
  }

  void _updateRecognitions({List<dynamic>? recognitions}) {
    if (mounted && recognitions != null) {
      setState(() {
        _recognitions = recognitions;
      });
    }
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
                            enabled: cameraIdx != 0,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.camera_rear, color: AppColors.black),
                                Text(' Back'),
                              ],
                            ),
                            value: 0),
                        PopupMenuItem(
                            enabled: cameraIdx != 1,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.camera_front,
                                    color: AppColors.black),
                                Text(' Front'),
                              ],
                            ),
                            value: 1),
                      ])
            ],
            backgroundColor: AppColors.yellow,
            title: Text(
              AppStrings.title,
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
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  // return AspectRatio(
                  //   aspectRatio: _cameraController.value.aspectRatio,
                  //   child: CameraPreview(_cameraController),
                  // );
                  final Size screen = MediaQuery.of(context).size;
                  final double screenHeight = max(screen.height, screen.width);
                  final double screenWidth = min(screen.height, screen.width);
                  final Size previewSize = _cameraController.value.previewSize!;
                  final double previewHeight =
                      max(previewSize.height, previewSize.width);
                  final double previewWidth =
                      min(previewSize.height, previewSize.width);
                  final double screenRatio = screenHeight / screenWidth;
                  final double previewRatio = previewHeight / previewWidth;
                  return Stack(
                    children: <Widget>[
                      OverflowBox(
                        maxHeight: screenRatio > previewRatio
                            ? screenHeight
                            : screenWidth / previewWidth * previewHeight,
                        maxWidth: screenRatio > previewRatio
                            ? screenHeight / previewHeight * previewWidth
                            : screenWidth,
                        child: CameraPreview(_cameraController),
                      ),
                      ConfidenceWidget(
                        entities: _recognitions ?? <dynamic>[],
                      )
                    ],
                  );
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!_cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }
}
