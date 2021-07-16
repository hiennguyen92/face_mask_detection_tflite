import 'package:face_mask_detection_tflite/app/app_resources.dart';
import 'package:face_mask_detection_tflite/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                AppIcons.code,
                color: AppColors.green,
                size: 25,
                semanticLabel: AppStrings.codeString,
              ))
        ],
        backgroundColor: AppColors.yellow.withOpacity(0.6),
        title: Text(
          AppStrings.title,
          style: AppTextStyles.boldTextStyle(color: AppColors.black),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppColors.yellow.withOpacity(0.4),
            border: Border.all(color: AppColors.yellow, width: 5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.illustrator, height: 250),
            SizedBox(
              height: 30,
            ),
            ButtonWidget(
                type: ButtonType.MATERIAL,
                onClickListener: () {},
                width: 200,
                color: AppColors.red,
                borderRadius: BorderRadius.circular(15),
                borderWidth: 3.0,
                borderColor: AppColors.white,
                colorSelected: AppColors.red,
                text: AppStrings.liveCamera,
                textStyle:
                    AppTextStyles.regularTextStyle(color: AppColors.white)),
            SizedBox(
              height: 30,
            ),
            ButtonWidget(
                type: ButtonType.MATERIAL,
                onClickListener: () {},
                width: 200,
                color: AppColors.red,
                borderRadius: BorderRadius.circular(15),
                borderWidth: 3.0,
                borderColor: AppColors.white,
                colorSelected: AppColors.red,
                text: AppStrings.fromGallery,
                textStyle:
                    AppTextStyles.regularTextStyle(color: AppColors.white))
          ],
        ),
      ),
    );
  }
}
