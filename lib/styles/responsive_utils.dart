// responsive_utils.dart

// import 'package:flutter/widgets.dart';

// double responsiveSize(BuildContext context, double size, {required double context}) {
//  return MediaQuery.of(context).size.width * size;
// }

// In responsive_utils.dart

import 'package:flutter/widgets.dart';

double responsiveSize(BuildContext context, double size) {
  return MediaQuery.of(context).size.width * size;
}