import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../model/swing_data.dart';

part 'inspection_state.dart';

class InspectionCubit extends Cubit<InspectionState> {
  InspectionCubit() : super(InspectionInitial());

  Future<void> loadSwing(int swingId) async {
    emit(InspectionLoading());
    try {
      final jsonStr = await rootBundle.loadString('$swingId.json');
      final jsonData = json.decode(jsonStr);
      final swingData = SwingData.fromJson(jsonData);
      emit(InspectionLoaded(swingData));
    } catch (e) {
      emit(InspectionError("Error loading data for swing $swingId"));
    }
  }
}
