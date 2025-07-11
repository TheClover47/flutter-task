import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/inspection_cubit.dart';
import 'cubit/swing_cubit.dart';
import 'pages/home.dart';
import 'model/swing_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SwingData>>(
      future: loadSwingsFromAssets(), // loads .json swings from assets
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(body: Center(child: Text('Error: ${snapshot.error}'))),
          );
        } else {
          final swings = snapshot.data!;

          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => SwingCubit(swings)),
              BlocProvider(create: (_) => InspectionCubit()),
            ],
            child: MaterialApp(
              title: 'HackMotion Task',
              theme: ThemeData(primarySwatch: Colors.blue),
              home: Home(),
            ),
          );
        }
      },
    );
  }
}
