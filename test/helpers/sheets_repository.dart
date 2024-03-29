import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_pesa/data/sheet_repository.dart';

class MockSheetRepository extends Mock implements SheetRepository {
  MockSheetRepository();
}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {
  MockGoogleSignInAccount();
}
