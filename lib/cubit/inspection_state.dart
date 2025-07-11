part of 'inspection_cubit.dart';

abstract class InspectionState {}

class InspectionInitial extends InspectionState {}

class InspectionLoading extends InspectionState {}

class InspectionLoaded extends InspectionState {
  final SwingData data;
  InspectionLoaded(this.data);
}

class InspectionError extends InspectionState {
  final String message;
  InspectionError(this.message);
}
