import 'package:flutter/material.dart';
import 'providers/photos_provider.dart';
import 'package:provider/provider.dart';
import 'screens/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PhotosProvider())],
      child: MaterialApp(
        title: 'Omni Pro Test',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const Home(),
      ),
    );
  }
}
