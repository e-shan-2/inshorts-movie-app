import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:inshort_app/data/models/movie_adaptor_model.dart';
import 'package:inshort_app/data/models/movie_model.dart';
import 'package:inshort_app/di/injector.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inshort_app/routes/app_navigation.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await setupLocator(); // Register dependencies

  runApp(ProviderScope(child: FlutterAppState()));
}

class FlutterAppState extends ConsumerStatefulWidget {
  const FlutterAppState({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FlutterAppStateState();
}

class _FlutterAppStateState extends ConsumerState<FlutterAppState> {


  @override
  void initState() {
  
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        // home: HomeScreen(),
        routerConfig:router ,
      );
    });
  }
}
