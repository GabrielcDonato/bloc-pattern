import 'package:bloc_pattern/structure/dependency.dart';
import 'package:bloc_pattern/structure/disposable.dart';
import 'package:bloc_pattern/structure/inject.dart';

class Core {
  final Map<String, dynamic> _injectMapDependency = {};
  final List<Dependency> dependencies;
  final String tag;

  Core({required this.dependencies, required this.tag});

  T dependency<T>([Map<String, dynamic>? params]) {
    String typeDependency = T.toString();
    T dep;
    if (_injectMapDependency.containsKey(typeDependency)) {
      dep = _injectMapDependency[typeDependency];
    } else {
      Dependency d =
          dependencies.firstWhere((dep) => dep.inject is T Function(Inject));
      dep = d.inject(Inject(params: params, tag: tag));
      if (d.singleton) {
        _injectMapDependency[typeDependency] = dep;
      }
    }
    return dep;
  }

  void removeDependency<T>() {
    String type = T.toString();
    if (_injectMapDependency.containsKey(type)) {
      var dependency = _injectMapDependency[type];
      if (dependency is Disposable) dependency.dispose();
      _injectMapDependency.remove(type);
    }
  }

  void dispose() {
    for (String key in _injectMapDependency.keys) {
      var dependency = _injectMapDependency[key];
      if (dependency is Disposable) dependency.dispose();
    }
    _injectMapDependency.clear();
  }
}
