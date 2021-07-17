
class CameraViewState {

  int cameraIndex;

  List<dynamic> recognitions = <dynamic>[];


  CameraViewState({ this.cameraIndex = 1, this.recognitions = const <dynamic>[]});


  bool isFrontCamera() {
    return cameraIndex == 1;
  }

  bool isBackCamera() {
    return cameraIndex == 0;
  }


}