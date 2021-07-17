import 'package:face_mask_detection_tflite/app/app_resources.dart';
import 'package:face_mask_detection_tflite/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

abstract class BaseState<T extends StatefulWidget, E extends BaseViewModel>
    extends State<T> {
  late String pageName;
  late E viewModel;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 500), () {
      print("initState ${pageName}");
    });
  }

  Widget initView() {
    return Consumer<E>(builder: (build, provide, _) {
      return viewModel.isLoading ? loadingWidget() : buildView();
    });
  }

  Widget loadingWidget(){
    return Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppColors.yellow.withOpacity(0.4),
            border: Border.all(color: AppColors.yellow, width: 5)),
        child: Center(child: CircularProgressIndicator(color: AppColors.yellow))
    );
  }


  Widget buildView();




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }


}
