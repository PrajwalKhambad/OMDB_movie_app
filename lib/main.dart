import 'package:flutter/material.dart';
import 'package:movie_app/api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      home: OMDBMovieAPI(),
      debugShowCheckedModeBanner: false,
    );
  }
}