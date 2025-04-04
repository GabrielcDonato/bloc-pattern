// ignore_for_file: avoid_shadowing_type_parameters

import 'package:bloc_pattern/structure/dependency_provider.dart';

/// Classe responsável por gerenciar a injeção de dependências.
class Inject<T> {
  Map<String, dynamic>? params = {};
  final String tag;

  Inject({this.params, this.tag = "global"});

  factory Inject.of() => Inject(tag: T.toString());

  /// Obtém uma dependência injetada.
  T get<T>([Map<String, dynamic>? params]) {
    params ??= {};
    return DependencyProvider.getDependency<T>(params, tag);
  }

  /// Descarta uma dependência injetada.
  void disposeDependency() {
    DependencyProvider.disposeDependency<T>(tag);
  }
}
