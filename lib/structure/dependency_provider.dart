import 'package:flutter/material.dart';
import 'core.dart';
import 'dependency.dart';
import 'inject.dart';

final Map<String, Core> _injectMap = {};

/// Exceção lançada quando um módulo não é encontrado no widget tree.
class DependencyNotFoundException implements Exception {
  final String message;
  DependencyNotFoundException(this.message);

  @override
  String toString() => "DependencyNotFoundException: $message";
}

/// Widget responsável por gerenciar dependências de um módulo.
class DependencyProvider extends StatefulWidget {
  final List<Dependency> dependencies;
  final String tagText;
  final Widget child;

  DependencyProvider({
    Key? key,
    required this.dependencies,
    this.tagText = "global",
    required this.child,
  }) : super(key: key);

  @override
  _DependencyProviderState createState() => _DependencyProviderState();

  /// Obtém uma dependência injetada.
  static T getDependency<T>(
      [Map<String, dynamic>? params, String tag = "global"]) {
    final core = _injectMap[tag];
    if (core == null) {
      throw DependencyNotFoundException(
          "Module \"$tag\" is not in the widget tree");
    }
    return core.dependency<T>(params);
  }

  /// Obtém o injetor associado a um módulo.
  static Inject tag(String tagText) => Inject(tag: tagText);

  /// Descarta uma dependência injetada.
  static void disposeDependency<T>([String tagText = "global"]) {
    final core = _injectMap[tagText];
    core?.removeDependency<T>();
  }
}

class _DependencyProviderState extends State<DependencyProvider> {
  @override
  void initState() {
    super.initState();
    if (!_injectMap.containsKey(widget.tagText)) {
      _injectMap[widget.tagText] = Core(
        dependencies: widget.dependencies,
        tag: widget.tagText,
      );
    }
  }

  @override
  void dispose() {
    final core = _injectMap[widget.tagText];
    core?.dispose();
    _injectMap.remove(widget.tagText);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
