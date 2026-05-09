import '../../data/repositories/counter_repository_impl.dart';
import '../../domain/repositories/counter_repository.dart';
import '../../presentation/viewmodels/counter_viewmodel.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  
  factory ServiceLocator() {
    return _instance;
  }
  
  ServiceLocator._internal();

  late CounterRepository counterRepository;

  // We will register our services, repositories, and viewmodels here.
  void setup() {
    // Data/Domain
    counterRepository = CounterRepositoryImpl();
  }

  // ViewModel factories
  CounterViewModel get counterViewModel => CounterViewModel(counterRepository);
}

final locator = ServiceLocator();
