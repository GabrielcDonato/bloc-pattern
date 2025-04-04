import 'package:bloc_pattern/structure/dependency_provider.dart';
import 'package:bloc_pattern/structure/structure.dart';
import 'package:flutter/material.dart';

abstract class ModuleWidget extends StatefulWidget {
  const ModuleWidget({
    Key? key,
  });

  List<Dependency> get dependencies;

  Widget buildView(BuildContext context);

  @override
  State<ModuleWidget> createState() => _ModuleWidgetState();
}

class _ModuleWidgetState extends State<ModuleWidget> {
  @override
  void initState() {
    super.initState();
    print('Module - Registering module: ${widget.runtimeType}');
    DependencyProvider.registerDependencies(
        widget.dependencies, widget.runtimeType.toString());
  }

  @override
  void dispose() {
    DependencyProvider.disposeDependency<dynamic>(
        widget.runtimeType.toString());

    print('Module - Disposing module: ${widget.runtimeType}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Building: ${widget.runtimeType}');
    return DependencyProvider(
      tagText: widget.runtimeType.toString(),
      dependencies: widget.dependencies,
      child: widget.buildView(context),
    );
  }
}
