import 'dart:math';

import 'package:camera/camera.dart';
import 'package:face_mask_detection_tflite/app/app_resources.dart';
import 'package:face_mask_detection_tflite/main.dart';
import 'package:face_mask_detection_tflite/view_models/camera_view_model.dart';
import 'package:face_mask_detection_tflite/view_states/base_state.dart';
import 'package:face_mask_detection_tflite/widgets/confidence_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends BaseState<CameraScreen, CameraViewModel>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    pageName = "Camera";
    viewModel = CameraViewModel(context);
    viewModel.showLoading(isShowLoading: true);
    WidgetsBinding.instance?.addObserver(this);
    initCamera();
    loadModel();
    viewModel.showLoading(isShowLoading: false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _cameraController.dispose();
    super.dispose();
  }

  void initCamera() {
    _cameraController = CameraController(
        listCamera[viewModel.cameraIndex()], ResolutionPreset.high);
    _initializeControllerFuture =
        _cameraController.initialize().then((value) => {
              setState(() {
                _cameraController.startImageStream((image) {
                  runModel(image);
                });
              })
            });
  }

  void loadModel() async {
    await viewModel.loadModel();
  }

  void runModel(CameraImage image) async {
    if(mounted){
       await viewModel.runModel(image);
    }
  }


  handleSwitchCameraClick(int item) {
    switch (item) {
      case 0:
      case 1:
        viewModel.switchCamera();
        initCamera();
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
                  onSelected: (item) => handleSwitchCameraClick(item),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                            enabled: viewModel.isBackCamera(),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.camera_rear, color: AppColors.black),
                                Text(' Back'),
                              ],
                            ),
                            value: 0),
                        PopupMenuItem(
                            enabled: viewModel.isFrontCamera(),
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
              style: AppTextStyles.boldTextStyle(
                  color: AppColors.black, fontSize: AppFontSizes.large),
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
                        entities: viewModel.getRecognitions(),
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
