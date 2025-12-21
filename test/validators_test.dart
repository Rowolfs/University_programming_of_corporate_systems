import 'package:flutter_test/flutter_test.dart';
import 'package:tier_list_app/utils/validators.dart';

void main() {
  group('Validators.tierlistTitle', () {
    test('null/empty/spaces -> error', () {
      expect(Validators.tierlistTitle(null), isNotNull);
      expect(Validators.tierlistTitle(''), isNotNull);
      expect(Validators.tierlistTitle('   '), isNotNull);
    });

    test('too long -> error', () {
      expect(Validators.tierlistTitle('a' * 61, maxLen: 60), isNotNull);
    });

    test('normal -> ok', () {
      expect(Validators.tierlistTitle('Новый тирлист'), isNull);
    });
  });

  group('Validators.description', () {
    test('empty is allowed -> ok', () {
      expect(Validators.description(null), isNull);
      expect(Validators.description(''), isNull);
      expect(Validators.description('   '), isNull);
    });

    test('too long -> error', () {
      expect(Validators.description('a' * 281, maxLen: 280), isNotNull);
    });

    test('normal -> ok', () {
      expect(Validators.description('Описание'), isNull);
    });
  });

  group('Validators.email', () {
    test('empty -> error', () {
      expect(Validators.email(null), isNotNull);
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('   '), isNotNull);
    });

    test('invalid format -> error', () {
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.email('user@'), isNotNull);
      expect(Validators.email('@domain.com'), isNotNull);
      expect(Validators.email('user@domain'), isNotNull);
    });

    test('valid -> ok', () {
      expect(Validators.email('user@example.com'), isNull);
    });
  });

  group('Validators.password', () {
    test('empty -> error', () {
      expect(Validators.password(null), isNotNull);
      expect(Validators.password(''), isNotNull);
    });

    test('too short -> error', () {
      expect(Validators.password('12345', minLen: 6), isNotNull);
    });

    test('long enough -> ok', () {
      expect(Validators.password('123456', minLen: 6), isNull);
    });
  });

  group('Validators.username', () {
    test('empty -> error', () {
      expect(Validators.username(null), isNotNull);
      expect(Validators.username(''), isNotNull);
      expect(Validators.username('   '), isNotNull);
    });

    test('too short/too long -> error', () {
      expect(Validators.username('ab', minLen: 3, maxLen: 20), isNotNull);
      expect(Validators.username('a' * 21, minLen: 3, maxLen: 20), isNotNull);
    });

    test('invalid chars -> error', () {
      expect(Validators.username('юзер'), isNotNull);
      expect(Validators.username('user name'), isNotNull);
      expect(Validators.username('user-name'), isNotNull);
    });

    test('valid -> ok', () {
      expect(Validators.username('user_name_12'), isNull);
    });
  });
}
