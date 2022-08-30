import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in_dartio/google_sign_in_dartio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_pesa/utils/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<Directory> getConfigDir() async {
  final documentsDirectory = await getApplicationDocumentsDirectory();
  // Changing this causes updates to lose old data
  final configDir = Directory(p.join(documentsDirectory.path, 'sarafu'));
  log.d(configDir.path);
  if (configDir.existsSync()) {
    return configDir;
  }
  return configDir.create();
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
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    await GoogleSignInDart.register(
      clientId:
          // ignore: lines_longer_than_80_chars
          '1022854879658-mlt4j7plt9uogtjch9uh28nqjquf5sa9.apps.googleusercontent.com',
    );
  }
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final storageDirectoryPath =
          kIsWeb ? HydratedStorage.webStorageDirectory : await getConfigDir();
      final storage = await HydratedStorage.build(
        storageDirectory: storageDirectoryPath,
      );
      log.d(storageDirectoryPath);
      await HydratedBlocOverrides.runZoned(
        () async => runApp(await builder()),
        storage: storage,
        blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) => log.e(error.toString(), [stackTrace]),
  );
}
