class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  
  factory ServiceLocator() {
    return _instance;
  }
  
  ServiceLocator._internal();

  // We will register our services, repositories, and viewmodels here.
  void setup() {
    // Initialization logic will go here
  }
}

final locator = ServiceLocator();
