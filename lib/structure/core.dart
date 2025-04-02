import 'package:bloc_pattern/structure/dependency.dart';
import 'package:bloc_pattern/structure/disposable.dart';
import 'package:bloc_pattern/structure/inject.dart';

/// Gerencia as dependências de um módulo, permitindo injeção e descarte dinâmico.
class Core {
  final Map<String, dynamic> _injectMapDependency = {};
  final List<Dependency> dependencies;
  final String tag;

  Core({required this.dependencies, required this.tag});

  /// Obtém uma dependência injetada.
  ///
  /// [params] pode ser usado para passar parâmetros adicionais para a injeção.
  /// Retorna uma instância do tipo [T].
  T dependency<T>([Map<String, dynamic>? params]) {
    final typeDependency = T.toString();
    if (_injectMapDependency.containsKey(typeDependency)) {
      return _injectMapDependency[typeDependency];
    }

    final dependency = dependencies.firstWhere(
      (dep) => dep.inject is T Function(Inject),
      orElse: () => throw Exception("Dependency $typeDependency not found"),
    );

    final instance = dependency.inject(Inject(params: params, tag: tag));
    if (dependency.singleton) {
      _injectMapDependency[typeDependency] = instance;
    }
    return instance;
  }

  /// Remove uma dependência injetada.
  void removeDependency<T>() {
    final type = T.toString();
    if (_injectMapDependency.containsKey(type)) {
      _disposeDependency(type);
    }
  }

  /// Descarta todas as dependências.
  void dispose() {
    for (final key in _injectMapDependency.keys) {
      _disposeDependency(key);
    }
    _injectMapDependency.clear();
  }

  /// Método auxiliar para descartar uma dependência.
  void _disposeDependency(String type) {
    final dependency = _injectMapDependency[type];
    if (dependency is Disposable) dependency.dispose();
    _injectMapDependency.remove(type);
  }
}
