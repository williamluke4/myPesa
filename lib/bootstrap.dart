import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_pesa/utils/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<Directory> getConfigDir() async {
  final documentsDirectory = await getApplicationDocumentsDirectory();
  final configDir = p.join(documentsDirectory.path, 'sarafu');
  final directory = Directory(configDir);

  if (directory.existsSync()) {
    return Directory(configDir);
  }
  return Directory(configDir).create();
}

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log.d('Bloc created: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    log.d('Bloc changed(${bloc.runtimeType})');
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log.e('Bloc errored(${bloc.runtimeType}, $error', [stackTrace]);
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log.e(details.exceptionAsString(), [details.stack]);
  };

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final storage = await HydratedStorage.build(
        storageDirectory:
            kIsWeb ? HydratedStorage.webStorageDirectory : await getConfigDir(),
      );
      await HydratedBlocOverrides.runZoned(
        () async => runApp(await builder()),
        storage: storage,
        blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) => log.e(error.toString(), [stackTrace]),
  );
}
