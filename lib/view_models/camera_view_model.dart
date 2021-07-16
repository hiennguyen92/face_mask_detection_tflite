import 'package:face_mask_detection_tflite/view_models/base_viewmodels.dart';
import 'package:flutter/material.dart';

class CameraViewModel extends BaseViewModel{

  CameraViewModel(BuildContext context) : super(context);


  @override
  Future loadData({bool isShowLoading = true}) async {
    this.isLoading = isShowLoading;
    Future.delayed(Duration(microseconds: 2000), (){
      this.isLoading = false;
      this.notifyListeners();
    });
  }

}

