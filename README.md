# Face Mask Detection with Tensorflow(Flutter)

Face Mask Detection With TFlite

## Info

An app made with flutter and tensor flow lite for face mask detection.


## :star: Features

* Delect mask on the live camera
* Detect mask from a photo
* MVVM architecture

  <br>

## 🚀&nbsp; Installation

1. Install Packages
```
camera: get the streaming image buffers
https://pub.dev/packages/camera
```
  * <a href='https://pub.dev/packages/camera'>https://pub.dev/packages/camera</a>
```
tflite: run our trained model
https://pub.dev/packages/tflite
```
  * <a href='https://pub.dev/packages/tflite'>https://pub.dev/packages/tflite</a>
```
image_picker: pick image from gallery
https://pub.dev/packages/image_picker
```
  * <a href='https://pub.dev/packages/image_picker'>https://pub.dev/packages/image_picker</a>

  <br>
2. Configure Project

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
  <br>
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
    - Click `Train Model`(using default config) and waiting...
    - Click `Export Model` and select `Tensorflow Lite`
    - Download (include: *.tflite, labels.txt)
```
  * <a href='https://www.kaggle.com/prasoonkottarathil/face-mask-lite-dataset'>https://www.kaggle.com/prasoonkottarathil/face-mask-lite-dataset</a>
  * <a href='https://teachablemachine.withgoogle.com'>https://teachablemachine.withgoogle.com</a>

  <br>
4. Load model

```
loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
        model: "assets/model.tflite", 
        labels: "assets/labels.txt",
        //numThreads: 1, // defaults to 1
        //isAsset: true, // defaults: true, set to false to load resources outside assets
        //useGpuDelegate: false // defaults: false, use GPU delegate
    );
  }
```
  <br>
5. Run model

```
  Future<List<dynamic>?> runModelOnFrame(CameraImage image) async {
    var recognitions = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,   //defaults to 127.5
        imageStd: 127.5,    //defaults to 127.5
        rotation: 90,       // defaults to 90, Android only
        numResults: 2,      // defaults to 5
        threshold: 0.5,     // defaults to 0.1
        asynch: true,       // defaults to true
    );      
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
```
Output format:
  [{
    index: 0,
    label: "WithMask",
    confidence: 0.989
  },...]
```
  <br>
6. Issue

```
* IOS
1.'vector' file not found
Open ios/Runner.xcworkspace in Xcode, click Runner > Tagets > Runner >Build Settings, 
search Compile Sources As, change the value to Objective-C++

2. 'tensorflow/lite/kernels/register.h' file not found
The plugin assumes the tensorflow header files are located in path "tensorflow/lite/kernels".
However, for early versions of tensorflow the header path is "tensorflow/contrib/lite/kernels".
```
  <br>
7. Source code

```
please checkout repo github
https://github.com/hiennguyen92/face_mask_detection_tflite
```
  * <a href='https://github.com/hiennguyen92/face_mask_detection_tflite'>https://github.com/hiennguyen92/face_mask_detection_tflite</a>
## :bulb: Demo

1. Demo Illustration: https://www.youtube.com/watch?v=2er_XZb_oi4&ab_channel=HienNguyen
2. Image
<table>
  <tr>
    <td><img src="https://raw.githubusercontent.com/hiennguyen92/face_mask_detection_tflite/master/images/image1.jpg" width="250"></td>
    <td><img src="https://raw.githubusercontent.com/hiennguyen92/face_mask_detection_tflite/master/images/image2.jpg" width="250"></td>
  </tr>
  <tr>
    <td><img src="https://raw.githubusercontent.com/hiennguyen92/face_mask_detection_tflite/master/images/image3.jpg" width="250"></td>
    <td><img src="https://raw.githubusercontent.com/hiennguyen92/face_mask_detection_tflite/master/images/image4.jpg" width="250"></td>
  </tr>
  <tr>
    <td><img src="https://raw.githubusercontent.com/hiennguyen92/face_mask_detection_tflite/master/images/image5.jpg" width="250"></td>
    <td></td>
  </tr>
 </table>