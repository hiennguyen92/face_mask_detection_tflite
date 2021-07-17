import 'package:face_mask_detection_tflite/view_models/base_view_model.dart';
import 'package:face_mask_detection_tflite/view_states/local_view_state.dart';
import 'package:flutter/material.dart';

class LocalViewModel extends BaseViewModel<LocalViewState>{

  LocalViewModel(BuildContext context) : super(context);


  @override
  Future showLoading({bool isShowLoading = true}) async {
    this.isLoading = isShowLoading;
    this.notifyListeners();
  }

}

