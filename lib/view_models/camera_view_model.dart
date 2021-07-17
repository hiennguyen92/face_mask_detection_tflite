import 'package:camera/camera.dart';
import 'package:face_mask_detection_tflite/services/tensorflow_service.dart';
import 'package:face_mask_detection_tflite/view_models/base_view_model.dart';
import 'package:face_mask_detection_tflite/view_states/camera_view_stare.dart';
import 'package:flutter/material.dart';

class CameraViewModel extends BaseViewModel<CameraViewState> {
  final TensorFlowService _tensorFlowService = TensorFlowService();

  bool _isLoadModel = false;

  CameraViewModel(BuildContext context) : super(context, CameraViewState());

  @override
  Future showLoading({bool isShowLoading = true}) async {
    this.isLoading = isShowLoading;
    this.notifyListeners();
  }

  Future switchCamera() async {
    viewState.cameraIndex = viewState.cameraIndex == 0 ? 1 : 0;
    this.notifyListeners();
  }

  int cameraIndex() {
    return viewState.cameraIndex;
  }

  bool isFrontCamera() {
    return viewState.isFrontCamera();
  }

  bool isBackCamera() {
    return viewState.isBackCamera();
  }

  Future updateRecognitions(List<dynamic> recognitions) async {
    viewState.recognitions = recognitions;
    this.notifyListeners();
  }

  List<dynamic> getRecognitions() {
    return viewState.recognitions;
  }

  Future loadModel() async {
    await _tensorFlowService.loadModel();
    this._isLoadModel = true;
  }

  Future runModel(CameraImage cameraImage) async {
    if(_isLoadModel) {
      var recognitions = await _tensorFlowService.runModelOnFrame(cameraImage);
      if (recognitions != null) {
        updateRecognitions(recognitions);
      }
    }else{
      throw 'Please run `loadModel()` before running `runModel(cameraImage)`';
    }
  }
}
