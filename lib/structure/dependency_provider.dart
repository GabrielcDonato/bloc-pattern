import 'package:bloc_pattern/structure/core.dart';
import 'package:bloc_pattern/structure/structure.dart';
import 'package:flutter/material.dart';

class DependencyInheritedWidget extends InheritedWidget {
  final Core core;

  const DependencyInheritedWidget({
    Key? key,
    required this.core,
    required Widget child,
  }) : super(key: key, child: child);

  static DependencyInheritedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DependencyInheritedWidget>();
  }

  @override
  bool updateShouldNotify(DependencyInheritedWidget oldWidget) {
    return false; // Não notifica rebuilds desnecessários
  }
}

class DependencyProvider extends StatelessWidget {
  final String tagText;
  final List<Dependency> dependencies;
  final Widget child;

  const DependencyProvider({
    Key? key,
    required this.tagText,
    required this.dependencies,
    required this.child,
  }) : super(key: key);

  static final Map<String, Core> _coreMap = {};

  static Core getCore(String tag) {
    print('DependencyProvider: Getting core for tag: $tag');
    return _coreMap[tag] ??= Core(dependencies: [], tag: tag);
  }

  static void registerDependencies(List<Dependency> dependencies, String tag) {
    print('DependencyProvider: Registering dependencies for tag: $tag');
    if (!_coreMap.containsKey(tag)) {
      _coreMap[tag] = Core(dependencies: dependencies, tag: tag);
      print('DependencyProvider: New core created for tag: $tag');
    } else {
      print('DependencyProvider: Core already exists for tag: $tag');
    }
  }

  static T dependency<T>(BuildContext context, [Map<String, dynamic>? params]) {
    print('DependencyProvider: Getting dependency of type: $T');
    final inherited = DependencyInheritedWidget.of(context);
    if (inherited == null) {
      print('DependencyProvider: Error - InheritedWidget not found');
      throw Exception('DependencyInheritedWidget not found in the widget tree');
    }
    return inherited.core.dependency<T>(params);
  }

  static T getDependency<T>(
      [Map<String, dynamic>? params, String tag = "global"]) {
    print('DependencyProvider: Getting dependency of type: $T with tag: $tag');
    final core = _coreMap[tag];
    if (core == null) {
      print('DependencyProvider: Error - Module "$tag" not found');
      throw Exception("Module \"$tag\" is not in the widget tree");
    }
    return core.dependency<T>(params);
  }

  static Inject tag(String tagText) => Inject(tag: tagText);

  static void disposeDependency<T>(String tag) {
    print('DependencyProvider: Disposing dependency for tag: $tag');
    _coreMap[tag]?.dispose();
    _coreMap.remove(tag);
    print('DependencyProvider: Dependency disposed and removed for tag: $tag');
  }

  @override
  Widget build(BuildContext context) {
    print('DependencyProvider: Building provider for tag: $tagText');
    final core = getCore(tagText);
    return DependencyInheritedWidget(
      core: core,
      child: child,
    );
  }
}
