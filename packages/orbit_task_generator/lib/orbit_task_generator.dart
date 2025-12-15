import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:orbit_task_annotations/orbit_task_annotations.dart';

class OrbitTaskGenerator extends GeneratorForAnnotation<OrbitTaskAnnotation> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! FunctionElement) {
      throw InvalidGenerationSourceError(
        'Generator cannot target `${element.name}`. '
        '`@orbitTask` can only be applied to top-level functions.',
        todo: 'Move `${element.name}` to a top-level function.',
        element: element,
      );
    }

    if (!element.isAsynchronous || !element.returnType.isDartAsyncFuture) {
       throw InvalidGenerationSourceError(
        'Generator cannot target `${element.name}`. '
        'Task function must be async and return a Future.',
        element: element,
      );
    }
    
    // In a real implementation we would generate the consolidated 
    // `callbackDispatcher` or registration logic here.
    return '// Generated OrbitTask handler for ${element.name}';
  }
}

Builder orbitTaskBuilder(BuilderOptions options) =>
    SharedPartBuilder([OrbitTaskGenerator()], 'orbit_task');
