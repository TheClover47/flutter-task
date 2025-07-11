import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/swing_cubit.dart';
import '../cubit/inspection_cubit.dart';
import 'inspection.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final swingCubit = context.watch<SwingCubit>();
    final swings = swingCubit.swings;

    return Scaffold(
      appBar: AppBar(title: Text("Home"), centerTitle: true),
      body: swings.isEmpty
          ? Center(child: Text("No swings available"))
          : ListView.separated(
              itemCount: swings.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, index) {
                final swing = swings[index];
                return ListTile(
                  title: Text("Swing ${swing.id}"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    swingCubit.setSwing(swing.id);  // set the active swing
                    context.read<InspectionCubit>().loadSwing(swing.id); // load swing data
                    Navigator.push(   // navigate to inspection screen
                      context,
                      MaterialPageRoute(
                        builder: (_) => InspectionScreen(),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
