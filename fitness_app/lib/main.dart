import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/presentation/pages/app_error_page.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  // Initialize flutter and hold splash
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await di.init();

    runApp(const MyApp());
  } catch (e, stackTrace) {
    debugPrint("ERRO CRÍTICO NO ARRANQUE: $e");
    debugPrint(stackTrace.toString());

    FlutterNativeSplash.remove();

    runApp(AppErrorPage(error: e.toString()));
  }
}