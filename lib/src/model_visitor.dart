import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:source_gen/source_gen.dart';
import 'package:xefro_annotations/xefro_annotations.dart';

// Step 1
class ModelVisitor extends SimpleElementVisitor<void> {
// Step 2
  String className = '';
  Map<String, dynamic> fields = {};

// Step 3
  @override
  void visitConstructorElement(ConstructorElement element) {
    final String returnType = element.returnType.toString();
// Step 4
    className = returnType.replaceAll("*", ""); // ClassName* -> ClassName
  }

// Step 5
  @override
  void visitFieldElement(FieldElement element) {
    /*
    {
      name: String,
      price: double
    }
     */
   final customJsonKey = const TypeChecker.fromRuntime(CommandLineFlag)
        .firstAnnotationOf(element);
            if (customJsonKey != null) {
      // Extract name and defaultValue from annotation
      final name = customJsonKey.getField('name')?.toStringValue();
      final defaultValue = customJsonKey.getField('defaultValue') as dynamic; // adjust based on expected types
       String elementType = element.type.toString().replaceAll("*", "");
    fields[element.name] = elementType;
      // Store information for code generation (e.g., in a Map)
      fields[element.name] = {
        'type': elementType, 
        'name': name,
        'defaultValue': defaultValue,
      };
      // print(fields.toString());
    } else {
      // ... existing code for handling fields without annotation ...
    }
  
// Step 6
   

  }
}