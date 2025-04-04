import 'package:bloc_pattern/structure/structure.dart';

class Dependency<T> {
  final T Function(Inject i) inject;
  final bool singleton;

  Dependency(this.inject, {this.singleton = true});
}

class EmptyDependency extends Dependency {
  EmptyDependency() : super((Inject i) {});
}
