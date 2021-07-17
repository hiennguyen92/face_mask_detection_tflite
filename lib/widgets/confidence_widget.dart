import 'dart:async';

import 'package:face_mask_detection_tflite/app/app_resources.dart';
import 'package:flutter/material.dart';




class ConfidenceWidget extends StatefulWidget {

  final List<dynamic> _entities;
  final double threshold;

  const ConfidenceWidget({required List<dynamic> entities, this.threshold = 0.5}) : _entities = entities;

  @override
  State<StatefulWidget> createState() {
    return _ConfidenceWidgetState();
  }
}

class _ConfidenceWidgetState extends State<ConfidenceWidget> {

  String _label = "";
  double _confidence = 0;

  set label(String value) => setState(() {
    _label = value;
  });

  set confidence(double value) => setState(() {
    _confidence = value;
  });

  String get label => _label;

  double get confidence => _confidence;

  Color _changeBorderColor(
      BuildContext context,
      List<dynamic>? divisions,
      ) {
    if (divisions == null) {
      return AppColors.transparent;
    }

    if (divisions.length > 1) {
      final String firstLabel = divisions.first['label'] as String;
      final double firstConfidence =
      divisions.first['confidence'] as double;

      final String secondLabel = divisions.last['label'] as String;
      final double secondConfidence =
      divisions.last['confidence'] as double;

      if (firstConfidence > secondConfidence) {
        label = firstLabel;
        confidence = firstConfidence;
      } else {
        label = secondLabel;
        confidence = secondConfidence;
      }
    }
    if (divisions.length == 1) {
      label = divisions.first['label'] as String;
      confidence = divisions.first['confidence'] as double;
    }

    if (confidence < widget.threshold) {
      return AppColors.transparent;
    }

    if (label == AppStrings.withoutMask) {
      return AppColors.red;
    }

    if (label == AppStrings.withMask) {
      return AppColors.green;
    }

    return AppColors.transparent;
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.fromBorderSide(BorderSide(
              color: _changeBorderColor(
                context,
                widget._entities,
              ),
              width: 5,
            )),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 85,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  color: AppColors.black,
                  child: Text(_textDisplay(label),
                    style: AppTextStyles.regularTextStyle(color: _textStyleColor(label), fontSize: 12),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  color: AppColors.black,
                  child: Text(_textAlertDisplay(),
                    style: AppTextStyles.regularTextStyle(color: _textStyleColor(label), fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _textAlertDisplay() {
    if (confidence < widget.threshold && confidence != 0) {
      return AppStrings.dontShake;
    }
    return "";
  }

  String _textDisplay(String label) {
    if(confidence == 0){
      return AppStrings.dontShake;
    }
    if(label == AppStrings.withMask){
      return "${AppStrings.withMask} ${(confidence * 100).toStringAsFixed(0)}%";
    }
    return "${AppStrings.withoutMask} ${(confidence * 100).toStringAsFixed(0)}%";
  }

  Color _textStyleColor(String label) {
    if(label == AppStrings.withMask)
      return AppColors.green;
    return AppColors.red;
  }

}