# Face Mask Detection with Tensorflow(Flutter)

Face Mask Detection With TFlite

## Info

An app made with flutter and tensor flow lite for face mask detection.


## :star: Features

* Delect mask on the live camera
* Detect mask from a photo
* MVVM architecture

## 🚀&nbsp; Installation

1. Install Packages
```
camera: get the streaming image buffers
https://pub.dev/packages/camera
```
```
tflite: run our trained model
https://pub.dev/packages/tflite
```
```
image_picker: pick image from gallery
https://pub.dev/packages/image_picker
```
1. Configure Project
* Android
```
android/app/build.gradle

android {
    ...
    aaptOptions {
        noCompress 'tflite'
        noCompress 'lite'
    }
    ...
}


minSdkVersion 21
```
3. Train our model
```
 * Download the dataset for training
    https://www.kaggle.com/prasoonkottarathil/face-mask-lite-dataset

* Training
    - go to https://teachablemachine.withgoogle.com to train our model
    - Get Started
    - Image Project
    - Edit `Class 1` for any Label(example `WithMask`)
    - Edit `Class 2` for any Label(example `WithoutMask`)
    - Update image from dataset download above
    - Click `Train Model` and waiting...
    - Click `Export Model` and select `Tensorflow Lite`
    - Download (include: *.tflite, labels.txt)
```

4. Load model
```
loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/labels.txt");
  }
```
5. Run model
```
  Future<List<dynamic>?> runModelOnFrame(CameraImage image) async {
    var recognitions = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.5,
        asynch: true);
    return recognitions;
  }
```
```
  Future<List<dynamic>?> runModelOnImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    return recognitions;
  }
```
6. Issue

```
* IOS
1.'vector' file not found
Open ios/Runner.xcworkspace in Xcode, click Runner > Tagets > Runner > Build Settings, search Compile Sources As, change the value to Objective-C++

2. 'tensorflow/lite/kernels/register.h' file not found
The plugin assumes the tensorflow header files are located in path "tensorflow/lite/kernels".
However, for early versions of tensorflow the header path is "tensorflow/contrib/lite/kernels".
```


7. Source code
```
please checkout repo github
https://github.com/hiennguyen92/face_mask_detection_tflite
```
## :bulb: Demo