
import 'package:flutter/material.dart';

ThemeData buildAuraTheme() {
  const bg = Color(0xFF0A0A0A);
  const surface = Color(0xFF0F0F10);
  const border = Color(0xFF1A1A1B);
  const text = Color(0xFFEDEDED);
  const textDim = Color(0xFFB5B5B8);
  const primary = Color(0xFFD4AF37); // gold
  final scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: Colors.black,
    secondary: const Color(0xFF22D3EE),
    onSecondary: Colors.black,
    error: const Color(0xFFEF4444),
    onError: Colors.white,
    surface: surface,
    onSurface: text,
  );
  final base = ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: bg,
    useMaterial3: true,
    fontFamily: 'sans-serif',
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: text),
    ),
    cardTheme: CardTheme(
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: border),
      ),
      elevation: 0,
      margin: const EdgeInsets.all(12),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF131316),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: surface,
      indicatorColor: Color(0x3322D3EE),
      labelTextStyle: MaterialStatePropertyAll(TextStyle(color: text)),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: text, height: 1.35),
      bodySmall: TextStyle(color: textDim, height: 1.35),
      titleMedium: TextStyle(color: text, fontWeight: FontWeight.w600),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: border),
        foregroundColor: text,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
  );
  return base;
}
