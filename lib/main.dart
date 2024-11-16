import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/searchScreen/search_screen.dart';
import 'features/searchScreen/search_screen_provider.dart'; // Import your SearchProvider

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SearchProvider(), // Provide SearchProvider
        ),
      ],
      child: MaterialApp(
        title: 'IMDb Search',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SearchScreen(),
      ),
    );
  }
}
