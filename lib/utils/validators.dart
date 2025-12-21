/// lib/utils/validators.dart
class Validators {
  Validators._();

  /// Название тирлиста (для Create/Edit)
  static String? tierlistTitle(
    String? value, {
    int maxLen = 60,
  }) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Введите название';
    if (v.length > maxLen) return 'Слишком длинное название (>$maxLen)';
    return null;
  }

  /// Описание тирлиста (если используешь)
  static String? description(
    String? value, {
    int maxLen = 280,
  }) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return null; // описание опционально
    if (v.length > maxLen) return 'Слишком длинное описание (>$maxLen)';
    return null;
  }

  /// Email для Supabase Auth (простая проверка формата)
  static String? email(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Введите email';

    // Достаточно для базовой валидации в учебном проекте
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v); // [web:299]
    if (!ok) return 'Некорректный email';

    return null;
  }

  /// Пароль (минимум 6 по умолчанию, но лучше 8)
  static String? password(
    String? value, {
    int minLen = 6,
  }) {
    final v = value ?? '';
    if (v.isEmpty) return 'Введите пароль';
    if (v.length < minLen) return 'Минимум $minLen символов';
    return null;
  }

  /// Логин/ник (если используешь username в profiles)
  static String? username(
    String? value, {
    int minLen = 3,
    int maxLen = 20,
  }) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Введите логин';
    if (v.length < minLen) return 'Слишком короткий логин (<$minLen)';
    if (v.length > maxLen) return 'Слишком длинный логин (>$maxLen)';

    // латиница/цифры/underscore, без пробелов
    final ok = RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v);
    if (!ok) return 'Только латиница, цифры и "_"';

    return null;
  }
}
