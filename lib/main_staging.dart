import 'package:flutter/foundation.dart';
import 'package:my_pesa/app.dart';
import 'package:my_pesa/bootstrap.dart';

void main() {
  BindingBase.debugZoneErrorsAreFatal = true;

  bootstrap(App.new);
}
