import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

class AppSurfaces extends ThemeExtension<AppSurfaces> {
  final Color chrome, sidebar, footer, header, detail;
  const AppSurfaces({
    required this.chrome,
    required this.sidebar,
    required this.footer,
    required this.header,
    required this.detail,
  });
  static const light = AppSurfaces(
    chrome: Color(0xFFD8DAE0),
    sidebar: Color(0xFFF2F3F5),
    footer: Color(0xFFE3E5E8),
    header: Color(0xFFECEEF2),
    detail: Color(0xFFF5F6F8),
  );
  static const dark = AppSurfaces(
    chrome: Color(0xFF17181B),
    sidebar: Color(0xFF2B2D31),
    footer: Color(0xFF1E1F22),
    header: Color(0xFF3B3D44),
    detail: Color(0xFF232428),
  );
  static AppSurfaces of(BuildContext c) =>
      Theme.of(c).extension<AppSurfaces>() ??
      (Theme.of(c).brightness == Brightness.dark ? dark : light);
  @override
  AppSurfaces copyWith({
    Color? chrome,
    Color? sidebar,
    Color? footer,
    Color? header,
    Color? detail,
  }) => AppSurfaces(
    chrome: chrome ?? this.chrome,
    sidebar: sidebar ?? this.sidebar,
    footer: footer ?? this.footer,
    header: header ?? this.header,
    detail: detail ?? this.detail,
  );
  @override
  AppSurfaces lerp(covariant AppSurfaces? other, double t) => other == null
      ? this
      : AppSurfaces(
          chrome: Color.lerp(chrome, other.chrome, t)!,
          sidebar: Color.lerp(sidebar, other.sidebar, t)!,
          footer: Color.lerp(footer, other.footer, t)!,
          header: Color.lerp(header, other.header, t)!,
          detail: Color.lerp(detail, other.detail, t)!,
        );
}

FThemeData appTheme({required bool dark, required bool touch}) => FThemeData(
  touch: touch,
  colors: (dark ? FColors.neutralDark : FColors.neutralLight).copyWith(
    background: dark ? const Color(0xFF313338) : const Color(0xFFFFFFFF),
    foreground: dark ? const Color(0xFFF2F3F5) : const Color(0xFF24262B),
    primary: dark ? const Color(0xFFADB4FF) : const Color(0xFF4752C4),
    primaryForeground: dark ? const Color(0xFF18191C) : const Color(0xFFFFFFFF),
    card: dark ? const Color(0xFF383A40) : const Color(0xFFFFFFFF),
    secondary: dark ? const Color(0xFF404249) : const Color(0xFFE3E5E8),
    secondaryForeground: dark
        ? const Color(0xFFF2F3F5)
        : const Color(0xFF24262B),
    muted: dark ? const Color(0xFF2B2D31) : const Color(0xFFF2F3F5),
    mutedForeground: dark ? const Color(0xFFB5BAC1) : const Color(0xFF555962),
    border: const Color(0xFF858994),
    errorForeground: dark ? const Color(0xFF18191C) : const Color(0xFFFFFFFF),
    error: dark ? const Color(0xFFFFB4B4) : const Color(0xFFA82432),
    destructive: const Color(0xFFB52D3B),
    destructiveForeground: const Color(0xFFFFFFFF),
  ),
);

ThemeData materialTheme(FThemeData data, {required bool dark}) {
  final base = data.toApproximateMaterialTheme();
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(color: const Color(0xFF858994)),
  );
  final surfaces = dark ? AppSurfaces.dark : AppSurfaces.light;
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      surface: data.colors.card,
      onSurface: data.colors.foreground,
      surfaceContainerLowest: data.colors.background,
      surfaceContainerLow: surfaces.detail,
      surfaceContainer: surfaces.sidebar,
      surfaceContainerHigh: data.colors.secondary,
      surfaceContainerHighest: data.colors.secondary,
      surfaceDim: surfaces.chrome,
      surfaceBright: data.colors.card,
      surfaceTint: Colors.transparent,
      onSurfaceVariant: data.colors.mutedForeground,
      primary: data.colors.primary,
      onPrimary: data.colors.primaryForeground,
      primaryContainer: data.colors.secondary,
      onPrimaryContainer: data.colors.foreground,
      secondary: data.colors.secondary,
      onSecondary: data.colors.foreground,
      secondaryContainer: data.colors.secondary,
      onSecondaryContainer: data.colors.foreground,
      tertiary: data.colors.primary,
      onTertiary: data.colors.primaryForeground,
      tertiaryContainer: data.colors.muted,
      onTertiaryContainer: data.colors.foreground,
      outline: data.colors.border,
      outlineVariant: data.colors.border,
      error: data.colors.error,
      onError: dark ? const Color(0xFF18191C) : const Color(0xFFFFFFFF),
    ),
    textTheme: base.textTheme.copyWith(
      headlineSmall: base.textTheme.headlineSmall!.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      titleLarge: base.textTheme.titleLarge!.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleMedium: base.textTheme.titleMedium!.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.35,
      ),
      bodyMedium: base.textTheme.bodyMedium!.copyWith(
        fontSize: 14,
        height: 1.4,
      ),
      bodySmall: base.textTheme.bodySmall!.copyWith(fontSize: 12, height: 1.4),
    ),
    extensions: [dark ? AppSurfaces.dark : AppSurfaces.light],
    scaffoldBackgroundColor: data.colors.background,
    visualDensity: VisualDensity.standard,
    iconTheme: base.iconTheme.copyWith(
      color: data.colors.mutedForeground,
      size: 20,
    ),
    primaryIconTheme: base.primaryIconTheme.copyWith(
      color: data.colors.mutedForeground,
      size: 20,
    ),
    dividerColor: dark ? const Color(0xFF44474E) : const Color(0xFFD7D9DE),
    hintColor: data.colors.mutedForeground,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: data.colors.primary,
      selectionColor: data.colors.primary.withValues(alpha: .25),
    ),
    chipTheme: base.chipTheme.copyWith(
      labelStyle: base.textTheme.bodySmall!.copyWith(
        color: data.colors.foreground,
      ),
      backgroundColor: data.colors.background,
      selectedColor: data.colors.secondary,
      side: BorderSide(color: data.colors.border),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: data.colors.foreground,
      unselectedLabelColor: data.colors.mutedForeground,
      indicatorColor: data.colors.primary,
      dividerHeight: 0,
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 14),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: dark ? const Color(0xFF232428) : const Color(0xFFF9F9FB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(color: data.colors.primary, width: 2),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: base.textTheme.bodyMedium!.copyWith(
        color: data.colors.mutedForeground,
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: data.colors.mutedForeground,
      textColor: data.colors.foreground,
      selectedColor: data.colors.foreground,
      selectedTileColor: data.colors.secondary,
      minLeadingWidth: 20,
      horizontalTitleGap: 10,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: data.colors.card,
      surfaceTintColor: Colors.transparent,
      textStyle: base.textTheme.bodyMedium!.copyWith(
        color: data.colors.foreground,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: data.colors.background,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF111214) : const Color(0xFF24262B),
        borderRadius: BorderRadius.circular(5),
      ),
      textStyle: const TextStyle(
        color: Color(0xFFF2F3F5),
        fontSize: 12,
        height: 1.4,
      ),
    ),
  );
}
