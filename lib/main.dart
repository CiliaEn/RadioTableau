import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radiotableau/provider/episode_list_provider.dart';
import 'screens/home.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EpisodeListProvider()),
        // Add other providers if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // Theme configuration
          ),
      home: const MyHomePage(title: 'Tablå för P1'),
    );
  }
}
