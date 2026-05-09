import '../../domain/models/counter.dart';
import '../../domain/repositories/counter_repository.dart';

class CounterRepositoryImpl implements CounterRepository {
  int _currentValue = 0;

  @override
  Future<Counter> getCounter() async {
    // Simulate network or database delay
    await Future.delayed(const Duration(milliseconds: 100));
    return Counter(_currentValue);
  }

  @override
  Future<void> saveCounter(Counter counter) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _currentValue = counter.value;
  }
}
