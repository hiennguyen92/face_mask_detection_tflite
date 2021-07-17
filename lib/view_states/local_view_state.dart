import 'dart:io';

class LocalViewState {

  List<dynamic> recognitions = <dynamic>[];

  File? imageSelected;

  LocalViewState({ this.recognitions = const <dynamic>[] });

  String getTextDetected() {
    return (recognitions.isNotEmpty) ? recognitions[0]['label'] : '';
  }

}