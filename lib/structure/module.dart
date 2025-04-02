import 'package:bloc_pattern/structure/dependency.dart';
import 'package:bloc_pattern/structure/dependency_provider.dart';
import 'package:bloc_pattern/structure/inject.dart';
import 'package:flutter/material.dart';

/// Representa um módulo que gerencia dependências e fornece uma interface de widget.
abstract class ModuleWidget extends StatelessWidget {
  /// Lista de dependências do módulo.
  List<Dependency> get dependencies;

  /// Widget principal do módulo.
  Widget get view;

  /// Obtém o injetor associado ao módulo.
  Inject get inject => DependencyProvider.tag(this.runtimeType.toString());

  @override
  Widget build(BuildContext context) {
    return DependencyProvider(
      tagText: this.runtimeType.toString(),
      dependencies: dependencies,
      child: view,
    );
  }
}
