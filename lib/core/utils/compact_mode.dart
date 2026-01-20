/// Compact Mode Extension
///
/// Утилита для выбора значений в зависимости от compact режима.
/// Упрощает тернарные операторы для размеров, шрифтов, отступов.
library;

/// Extension для bool для выбора compact/normal значений
///
/// Пример использования:
/// ```dart
/// final fontSize = compact.resolve(
///   _Constants.fontSizeCompact,
///   _Constants.fontSizeNormal,
/// );
/// ```
extension CompactMode on bool {
  /// Возвращает [compactValue] если true, иначе [normalValue]
  T resolve<T>(T compactValue, T normalValue) =>
      this ? compactValue : normalValue;
}
