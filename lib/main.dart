import 'package:face_mask_detection_tflite/app/app_router.dart';
import 'package:face_mask_detection_tflite/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tflite/tflite.dart';

late List<CameraDescription> listCamera;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  listCamera = await availableCameras();
  runApp(Application());
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(375, 812),
        builder: () {
          return new MaterialApp(
            theme: ThemeData.light(),
            onGenerateRoute: AppRoute.generateRoute,
            initialRoute: AppRoute.splashScreen,
            navigatorKey: NavigationService.navigationKey
          );
        });
  }
}
