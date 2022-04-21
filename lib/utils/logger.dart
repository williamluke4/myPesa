import 'package:logger/logger.dart';

Logger log = Logger(
  printer: PrettyPrinter(),
);

Logger logNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);
