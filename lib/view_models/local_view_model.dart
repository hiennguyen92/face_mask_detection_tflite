import 'dart:io';

import 'package:face_mask_detection_tflite/services/tensorflow_service.dart';
import 'package:face_mask_detection_tflite/view_models/base_view_model.dart';
import 'package:face_mask_detection_tflite/view_states/local_view_state.dart';
import 'package:flutter/material.dart';

class LocalViewModel extends BaseViewModel<LocalViewState>{

  final TensorFlowService _tensorFlowService = TensorFlowService();

  bool _isLoadModel = false;

  LocalViewModel(BuildContext context) : super(context, LocalViewState());


  @override
  Future showLoading({bool isShowLoading = true}) async {
    this.isLoading = isShowLoading;
    this.notifyListeners();
  }

  Future updateImageSelected(File file) async {
    viewState.imageSelected = file;
    this.notifyListeners();
  }

  File? getFileSelected() {
    return viewState.imageSelected;
  }

  Future updateRecognitions(List<dynamic> recognitions) async {
    viewState.recognitions = recognitions;
    this.notifyListeners();
  }

  List<dynamic> getRecognitions() {
    return viewState.recognitions;
  }

  String getTextDetected() {
    return viewState.getTextDetected();
  }

  Future loadModel() async {
    await _tensorFlowService.loadModel();
    this._isLoadModel = true;
  }

  Future runModelOnImage(File image) async {
    if(_isLoadModel) {
      var recognitions = await _tensorFlowService.runModelOnImage(image);
      if (recognitions != null) {
        updateRecognitions(recognitions);
      }
    }else{
      throw 'Please run `loadModel()` before running `runModelOnImage(file)`';
    }
  }

}

