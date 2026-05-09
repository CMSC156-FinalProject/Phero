import 'package:flutter/foundation.dart';
import '../../domain/models/counter.dart';
import '../../domain/repositories/counter_repository.dart';

class CounterViewModel extends ChangeNotifier {
  final CounterRepository _repository;

  CounterViewModel(this._repository) {
    _loadInitialCounter();
  }

  int _count = 0;
  int get count => _count;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> _loadInitialCounter() async {
    _setLoading(true);
    final counter = await _repository.getCounter();
    _count = counter.value;
    _setLoading(false);
  }

  Future<void> increment() async {
    _count++;
    notifyListeners();
    // Persist in background
    await _repository.saveCounter(Counter(_count));
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
