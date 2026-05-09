import 'package:flutter_test/flutter_test.dart';
import 'package:phero_app/domain/models/counter.dart';
import 'package:phero_app/domain/repositories/counter_repository.dart';
import 'package:phero_app/presentation/viewmodels/counter_viewmodel.dart';

class MockCounterRepository implements CounterRepository {
  int _value = 0;
  
  @override
  Future<Counter> getCounter() async => Counter(_value);
  
  @override
  Future<void> saveCounter(Counter counter) async {
    _value = counter.value;
  }
}

void main() {
  test('CounterViewModel increments counter and updates state', () async {
    final repo = MockCounterRepository();
    final viewModel = CounterViewModel(repo);
    
    // Wait for initial load
    await Future.delayed(Duration.zero);
    
    expect(viewModel.count, 0);
    
    await viewModel.increment();
    
    expect(viewModel.count, 1);
    final saved = await repo.getCounter();
    expect(saved.value, 1);
  });
}
