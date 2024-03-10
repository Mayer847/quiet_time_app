import 'package:flutter/material.dart';
import 'readings.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: getReadings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final readings = snapshot.data as Map<String, String>;
            return Scaffold(
              appBar: AppBar(title: const Text('Today\'s Readings')),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                        'Morning: ${readings['morningBook']}, Chapter ${readings['morningChapter']}'),
                    Text(
                        'Evening: ${readings['eveningBook']}, Chapter ${readings['eveningChapter']}'),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
