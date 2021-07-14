import 'package:face_mask_detection_tflite/app/app_resources.dart';
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
              onPressed: () {

              },
              icon: Icon(
                  AppIcons.code,
                color: AppColors.green,
                size: 25,
                semanticLabel: AppStrings.codeString,
              )
          )
        ],
        backgroundColor: AppColors.yellow.withOpacity(0.6),
        title: Text(
          AppStrings.title,
          style: AppTextStyles.boldTextStyle(color: AppColors.black),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: AppColors.yellow.withOpacity(0.4),
            border: Border.all(color: AppColors.yellow, width: 5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.illustrator),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 3, color: AppColors.white)),
                child: Text(
                  AppStrings.liveCamera,
                  style: AppTextStyles.regularTextStyle(color: AppColors.black),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {

              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 3, color: AppColors.white)),
                child: Text(
                  AppStrings.fromGallery,
                  style: AppTextStyles.regularTextStyle(color: AppColors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}