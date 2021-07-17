import 'package:face_mask_detection_tflite/view_models/base_view_model.dart';
import 'package:face_mask_detection_tflite/view_states/camera_view_stare.dart';
import 'package:flutter/material.dart';

class CameraViewModel extends BaseViewModel<CameraViewState>{

  CameraViewModel(BuildContext context) : super(context);


  @override
  Future showLoading({bool isShowLoading = true}) async {
    this.isLoading = isShowLoading;
    this.notifyListeners();
  }

}

