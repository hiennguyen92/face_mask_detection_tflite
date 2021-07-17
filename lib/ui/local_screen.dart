import 'dart:io';

import 'package:face_mask_detection_tflite/app/app_resources.dart';
import 'package:face_mask_detection_tflite/view_models/local_view_model.dart';
import 'package:face_mask_detection_tflite/view_states/base_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class LocalScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocalScreenState();
  }
}

class _LocalScreenState extends BaseState<LocalScreen, LocalViewModel> {

  ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    pageName = "Local";
    viewModel = LocalViewModel(context);
    viewModel.showLoading(isShowLoading: true);
    loadModel();
    viewModel.showLoading(isShowLoading: false);
  }

  selectImage() async {
    viewModel.showLoading(isShowLoading: true);
    XFile? _imageFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (_imageFile == null) {
      viewModel.showLoading(isShowLoading: false);
      return;
    }
    viewModel.updateImageSelected(File(_imageFile.path));
    runModelOnImage();
  }

  runModelOnImage() async {
    var fileSelected = viewModel.getFileSelected();
    if (mounted && fileSelected != null) {
      await viewModel.runModelOnImage(fileSelected);
      viewModel.showLoading(isShowLoading: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: viewModel,
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: AppColors.black,
              ),
              elevation: 0.0,
              centerTitle: true,
              backgroundColor: AppColors.yellow,
              title: Text(
                AppStrings.title,
                style: AppTextStyles.boldTextStyle(
                    color: AppColors.black, fontSize: AppFontSizes.large),
              ),
            ),
            body: initView(),
            floatingActionButton: FloatingActionButton(
              child: Icon(
                AppIcons.plus,
                color: AppColors.green,
              ),
              tooltip: AppStrings.pickFromGallery,
              backgroundColor: AppColors.yellow,
              onPressed: selectImage,
            )));
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              viewModel.getFileSelected() == null
                  ? Container(
                      child: Text(
                        AppStrings.selectImagePreview,
                        style: AppTextStyles.regularTextStyle(
                            color: AppColors.green,
                            fontSize: AppFontSizes.medium),
                      ),
                    )
                  : Image.file(
                      viewModel.getFileSelected()!,
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                    ),
              SizedBox(
                height: 20,
              ),
              Text(
                viewModel.getTextDetected(),
                style: AppTextStyles.regularTextStyle(
                    color: viewModel.getTextDetected() == AppStrings.withoutMask
                        ? AppColors.red
                        : AppColors.green,
                    fontSize: AppFontSizes.medium),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loadModel() async {
    await viewModel.loadModel();
  }
}
