import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:xefro_annotations/xefro_annotations.dart';

import 'model_visitor.dart';

class XefroGenerator extends GeneratorForAnnotation<XefroGen> {
  // get annotations => [const CustomAnnotation(),const CustomJsonKey()];
  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final Element enviedEl = element;
    final ModelVisitor visitor = ModelVisitor();
    // Visit class fields and constructor
    element.visitChildren(visitor);
    TypeChecker _typeChecker(Type type) => TypeChecker.fromRuntime(type);
    // Buffer to write each part of generated class
    final buffer = StringBuffer();
    String generatedFromJSon = generateCommandFlagsMethod(
      visitor,
      annotation,
      element as ClassElement,
    );
    buffer.writeln(generatedFromJSon);
    return buffer.toString();
  }

  String generateCommandFlagsMethod(
    ModelVisitor visitor,
    ConstantReader annotation,
    element,
  ) {
    final buffer = StringBuffer();
    final coreChecker = TypeChecker.fromRuntime(CommandLineFlag);
 final className = visitor.className;

  buffer.writeln('// Command Flags Method');
//  buffer.writeln('extension ScrcpyCommandModelExtensions on $className {');
    buffer.writeln('  String _\$${className}toCommand($className instance) {');
    buffer.writeln('    List<String> options = [];');

    // Iterate over the fields of the class
    for (var field in element.fields) {
      String? flagValue;
      if (
        coreChecker.firstAnnotationOfExact(field)?.getField('defaultValue')
        ?.toBoolValue() ==true ||false) {
        flagValue = "${coreChecker.firstAnnotationOfExact(field)!.getField('defaultValue')!.toBoolValue()!}";
      } else {
        flagValue = coreChecker.firstAnnotationOfExact(field)?.getField('defaultValue')?.toStringValue();
      }
 
      final flag = coreChecker.firstAnnotationOfExact(field)?.getField('flag')?.toStringValue() ?? '';
  
      // Generate command options based on variables
      if(field.type == bool){
          final fieldType = field.type;  // Get
       print("Field Type: $fieldType");
print('Field declared type: ${fieldType.getDisplayString(withNullability: true)}');
          if(
            coreChecker.firstAnnotationOfExact(field)?.getField(field.name)
        ?.toBoolValue() ==true
          ){
            buffer.writeln('    if (instance.${field.name}  == true) {');
          

      buffer.writeln('          options.add("$flag}" }");');
      buffer.writeln('    }');
          }else{

          }
          
        }else{

          // print("FieldName : ${field.name}");
          //  print("FieldRunTimeStype:${coreChecker.firstAnnotationOfExact(field)?.runtimeType} ");
  buffer.writeln('    if (instance.${field.name} != null) {');

      buffer.writeln('          options.add("$flag${flagValue ?? " \${instance.${field.name}}" }");');
      buffer.writeln('    }');
        }
    
   
    }
      buffer.writeln(" return 'scrcpy \${options.join(' ')}';");
  buffer.writeln('}');
  // buffer.writeln('}');
  buffer.writeln("//sssssssssssssss");

    return buffer.toString();
  }
}
