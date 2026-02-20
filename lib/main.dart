import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty',
      theme: _buildTheme(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.charactersList,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: Colors.deepPurple,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    );
  }
}
