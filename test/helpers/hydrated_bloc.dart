import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {
  MockStorage();
  Map data = <String, dynamic>{};

  @override
  dynamic read(String key) => data[key];

  @override
  Future<void> write(String key, dynamic value) async {
    data[key] = value;
  }

  @override
  Future<void> delete(String key) async => data[key] = null;
}

FutureOr<T> mockHydratedStorage<T>(
  FutureOr<T> Function() body, {
  Storage? storage,
}) {
  return HydratedBlocOverrides.runZoned(
    body,
    storage: storage ?? _buildMockStorage(),
  );
}

Storage _buildMockStorage() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final storage = MockStorage();
  return storage;
}

final hydratedStorage = MockStorage();
