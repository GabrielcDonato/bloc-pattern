import 'package:flutter/material.dart';
import 'core.dart';
import 'dependency.dart';
import 'inject.dart';

final Map<String, Core> _injectMap = {};

class DependencyNotFoundException implements Exception {
  final String message;
  DependencyNotFoundException(this.message);

  @override
  String toString() => "DependencyNotFoundException: $message";
}

class DependencyProvider extends StatefulWidget {
  final List<Dependency> dependencies;
  final String tagText;
  final Widget child;

  const DependencyProvider({
    key,
    required this.dependencies,
    this.tagText = "global",
    required this.child,
  });

  @override
  DependencyProviderState createState() => DependencyProviderState();

//TODO! colocar como private e utilizar part of com o moduleWidget
  static void registerDependencies(List<Dependency> dependencies, String tag) {
    if (!_injectMap.containsKey(tag)) {
      _injectMap[tag] = Core(
        dependencies: dependencies,
        tag: tag,
      );
    } else {
      print('DependencyProvider: $tag already registered');
    }
  }

  static T getDependency<T>(
      [Map<String, dynamic>? params, String tag = "global"]) {
    print('Getting dependency with tag: $tag');
    print('Current registered modules: ${_injectMap.keys}');

    final core = _injectMap[tag];
    if (core == null) {
      throw DependencyNotFoundException(
          "Module \"$tag\" is not in the widget tree");
    }
    print('Dependency found for tag: $tag');
    return core.dependency<T>(params);
  }

  static Inject tag(String tagText) => Inject(tag: tagText);

  static void disposeDependency<T>([String tagText = "global"]) {
    final core = _injectMap[tagText];
    if (core == null) {
      print('DependencyProvider: $tagText already disposed');
    }
    core?.removeDependency<T>();
  }
}

class DependencyProviderState extends State<DependencyProvider> {
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
