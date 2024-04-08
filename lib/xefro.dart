library xefro;



import 'package:build/build.dart';

import 'package:source_gen/source_gen.dart';

import 'src/xefro_generator.dart';

Builder xefroMethodsGenerator(BuilderOptions options) {
  // Step 1
  return SharedPartBuilder(
    //Main Class For Generating
    [XefroGenerator(),], // Step 2
    // Step 3 filename of the generator
    // Path:xefro_gen\lib\src\xefro_generator.dart
    'xefro_generator', 
 
  );
}