import 'package:flutter_test/flutter_test.dart';
import 'package:my_pesa/data/models/transaction.dart';

void main() {
  group('transaction', () {
    group('merge', () {
      test('old values should all be updated', () async {
        final olderTx = Transaction(
          ref: '1',
          notes: 'Older',
          categoryId: '1',
          lastModified: 1665406691164,
        );
        final newerTx = Transaction(ref: '1', notes: 'Newer', categoryId: '2');
        final merged = olderTx.merge(newerTx);
        final merged2 = olderTx.merge(newerTx);

        expect(newerTx.lastModified > olderTx.lastModified, true);

        expect(merged.categoryId, newerTx.categoryId);
        expect(merged.notes, newerTx.notes);

        expect(merged2.categoryId, newerTx.categoryId);
        expect(merged2.notes, newerTx.notes);
      });
      test(
          'older tx should overwrite categoryId if newer categoryId is default',
          () async {
        final olderTx =
            Transaction(ref: '1', categoryId: '2', lastModified: 1665406691164);
        final newerTx = Transaction(ref: '1');
        final merged = olderTx.merge(newerTx);
        expect(newerTx.lastModified > olderTx.lastModified, true);
        expect(merged.categoryId, olderTx.categoryId);
      });
      test('older tx should overwrite notes if newer notes is empty', () async {
        final olderTx =
            Transaction(ref: '1', notes: 'notes', lastModified: 1665406691164);
        final newerTx = Transaction(ref: '1');
        final merged = olderTx.merge(newerTx);
        expect(newerTx.lastModified > olderTx.lastModified, true);
        expect(merged.notes, olderTx.notes);
      });
      test('do not merge different txs', () async {
        final oldTx =
            Transaction(ref: '1', categoryId: '1', lastModified: 1665406691164);
        final newTx = Transaction(ref: '2', categoryId: '2');
        final merged = oldTx.merge(newTx);
        expect(merged.categoryId, oldTx.categoryId);
      });
    });
  });
}
