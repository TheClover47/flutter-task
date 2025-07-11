import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/swing_data.dart';

class SwingCubit extends Cubit<int?> {
  final List<SwingData> _swings;

  SwingCubit(this._swings)
    : super(_swings.isNotEmpty ? _swings.first.id : null);

  List<SwingData> get swings => _swings;

  SwingData? get current {
    try {
      return _swings.firstWhere((s) => s.id == state);
    } catch (_) {
      return null;
    }
  }

  int get currentIndex => _swings.indexWhere((s) => s.id == state);

  bool get hasPrevious => currentIndex > 0;
  bool get hasNext => currentIndex < _swings.length - 1;

  void next() {
    if (!hasNext) return;
    emit(_swings[currentIndex + 1].id);
  }

  void previous() {
    if (!hasPrevious) return;
    emit(_swings[currentIndex - 1].id);
  }

  void setSwing(int id) {
    if (_swings.any((s) => s.id == id)) {
      emit(id);
    }
  }

  void deleteCurrent() {
    final index = currentIndex;
    if (index == -1) return;

    _swings.removeAt(index);

    if (_swings.isEmpty) {
      emit(0);
    } else if (index >= _swings.length) {
      emit(_swings.last.id);
    } else {
      emit(_swings[index].id);
    }
  }
}
