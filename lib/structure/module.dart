import 'package:bloc_pattern/structure/dependency_provider.dart';
import 'package:bloc_pattern/structure/structure.dart';
import 'package:flutter/material.dart';

abstract class ModuleWidget extends StatefulWidget {
  const ModuleWidget({
    Key? key,
  }) : super(key: key);

  List<Dependency> get dependencies;

  Widget buildView(BuildContext context);

  @override
  State<ModuleWidget> createState() => _ModuleWidgetState();
}

class _ModuleWidgetState extends State<ModuleWidget> {
  @override
  void initState() {
    super.initState();
    print('Module: Initializing module ${widget.runtimeType}');
    print(
        'Module: Registering ${widget.dependencies.length} dependencies for ${widget.runtimeType}');
    DependencyProvider.registerDependencies(
        widget.dependencies, widget.runtimeType.toString());
  }

  @override
  void dispose() {
    print('Module: Disposing module ${widget.runtimeType}');
    DependencyProvider.disposeDependency<dynamic>(
        widget.runtimeType.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Module: Building module ${widget.runtimeType}');
    return DependencyProvider(
      tagText: widget.runtimeType.toString(),
      dependencies: widget.dependencies,
      child: widget.buildView(context),
    );
  }
}
