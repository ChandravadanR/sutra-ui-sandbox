import 'dart:ui';
import 'package:flutter/material.dart';

class SutraColors extends ThemeExtension<SutraColors> {
  const SutraColors({
    required this.primary,
    required this.primaryVariant,
    required this.onPrimary,
    required this.secondary,
    required this.secondaryContainer,
    required this.onSecondary,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceElevated,
    required this.onSurface,
    required this.onSurfaceSecondary,
    required this.outline,
    required this.outlineVariant,
    required this.error,
    required this.onError,
    required this.warning,
    required this.success,
    required this.scrim,
    required this.overlay,
    required this.chatBubbleOutgoingBg,
    required this.chatBubbleOutgoingText,
    required this.chatBubbleIncomingBg,
    required this.chatBubbleIncomingText,
    required this.chatTimestampColor,
    required this.chatReadReceiptColor,
    required this.chatReplyStripColor,
    required this.chatLinkColor,
    required this.chatCodeBg,
    required this.chatCodeText,
    required this.buttonPrimaryBg,
    required this.buttonPrimaryText,
    required this.buttonDestructiveBg,
    required this.buttonDestructiveText,
    required this.inputBarBg,
    required this.inputBarBorder,
    required this.inputBarText,
    required this.inputBarPlaceholder,
    required this.glassSurfaceOpacity,
    required this.glassBlurRadius,
    required this.glassBorderColor,
  });
  // ── Tier 2: Semantic Colors ─────────────────────────────────────────────
  final Color primary;
  final Color primaryVariant;
  final Color onPrimary;
  final Color secondary;
  final Color secondaryContainer;
  final Color onSecondary;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color surfaceVariant;
  final Color surfaceElevated;
  final Color onSurface;
  final Color onSurfaceSecondary;
  final Color outline;
  final Color outlineVariant;
  final Color error;
  final Color onError;
  final Color warning;
  final Color success;
  final Color scrim;
  final Color overlay;

  // ── Tier 3: Chat Component Colors ───────────────────────────────────────
  final Color chatBubbleOutgoingBg;
  final Color chatBubbleOutgoingText;
  final Color chatBubbleIncomingBg;
  final Color chatBubbleIncomingText;
  final Color chatTimestampColor;
  final Color chatReadReceiptColor;
  final Color chatReplyStripColor;
  final Color chatLinkColor;
  final Color chatCodeBg;
  final Color chatCodeText;

  // ── Tier 3: Button Component Colors ─────────────────────────────────────
  final Color buttonPrimaryBg;
  final Color buttonPrimaryText;
  final Color buttonDestructiveBg;
  final Color buttonDestructiveText;

  // ── Tier 3: Input Bar Colors ────────────────────────────────────────────
  final Color inputBarBg;
  final Color inputBarBorder;
  final Color inputBarText;
  final Color inputBarPlaceholder;

  // ── Liquid Glass Material ──────────────────────────────────────────────
  final double glassSurfaceOpacity;
  final double glassBlurRadius;
  final Color glassBorderColor;

  // Compatibility getters for Liquid Glass screens
  Color get surfaceContainer => surface;
  Color get surfaceContainerLow => inputBarBg;
  Color get surfaceContainerHigh => surfaceVariant;
  Color get surfaceContainerHighest => surfaceElevated;
  Color get onSurfaceVariant => onSurfaceSecondary;

  // ── Built-in Themes ─────────────────────────────────────────────────────

  static const sutraDark = SutraColors(
    // Exact Stitch "Sutra Chat App" color values
    primary: Color(0xFFA8A4FF), // primary
    primaryVariant: Color(0xFF675DF9), // primary_dim (gradient start)
    onPrimary: Color(0xFF1E009F),
    secondary: Color(0xFFAA8FFD), // secondary
    secondaryContainer: Color(0xFF4E329B), // secondary_container
    onSecondary: Color(0xFF290071),
    onSecondaryContainer: Color(0xFFD7C8FF),
    tertiary: Color(0xFFD946EF), // distinct tertiary fuchsia accent
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF701A75),
    onTertiaryContainer: Color(0xFFFDF4FF),
    background: Color(0xFF0B0E14), // surface / surface_dim
    onBackground: Color(0xFFF2F3FC), // on_surface
    surface: Color(0xFF161A21), // surface_container
    surfaceVariant: Color(0xFF1C2028), // surface_container_high
    surfaceElevated: Color(0xFF22262E), // surface_container_highest
    onSurface: Color(0xFFF2F3FC), // on_surface
    onSurfaceSecondary: Color(0xFFA9ABB3), // on_surface_variant
    outline: Color(0xFF73757D),
    outlineVariant: Color(0xFF45484F),
    error: Color(0xFFFF6E84),
    onError: Color(0xFF490013),
    warning: Color(0xFFF59E0B),
    success: Color(0xFF22C55E),
    scrim: Color(0x99000000),
    overlay: Color(0x66000000),
    // Outgoing: secondary_container; Incoming: surface_container_high
    chatBubbleOutgoingBg: Color(0xFF4E329B), // secondary_container
    chatBubbleOutgoingText: Color(0xFFD7C8FF), // on_secondary_container
    chatBubbleIncomingBg: Color(0xFF1C2028), // surface_container_high
    chatBubbleIncomingText: Color(0xFFF2F3FC),
    chatTimestampColor: Color(0xFFA9ABB3),
    chatReadReceiptColor: Color(0xFFA8A4FF),
    chatReplyStripColor: Color(0xFFA8A4FF),
    chatLinkColor: Color(0xFFAA8FFD),
    chatCodeBg: Color(0xFF22262E),
    chatCodeText: Color(0xFFF2F3FC),
    buttonPrimaryBg: Color(0xFFA8A4FF),
    buttonPrimaryText: Color(0xFF1E009F),
    buttonDestructiveBg: Color(0xFFFF6E84),
    buttonDestructiveText: Color(0xFF490013),
    inputBarBg: Color(0xFF10131A), // surface_container_low
    inputBarBorder: Color(0xFF22262E),
    inputBarText: Color(0xFFF2F3FC),
    inputBarPlaceholder: Color(0xFFA9ABB3),
    glassSurfaceOpacity: 0.60,
    glassBlurRadius: 20,
    glassBorderColor: Color(0x26F2F3FC), // outline_variant at 15% opacity
  );

  static const sutraOled = SutraColors(
    primary: Color(0xFF6C63FF),
    primaryVariant: Color(0xFF4A42BF),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF3B82F6),
    secondaryContainer: Color(0xFF1E3A8A),
    onSecondary: Color(0xFFFFFFFF),
    onSecondaryContainer: Color(0xFFDBEAFE),
    tertiary: Color(0xFF6C63FF),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF4C1D95),
    onTertiaryContainer: Color(0xFFEDE9FE),
    background: Color(0xFF000000), // True black for AMOLED
    onBackground: Color(0xFFE0E0E6),
    surface: Color(0xFF0A0A0A),
    surfaceVariant: Color(0xFF1A1A1A),
    surfaceElevated: Color(0xFF2A2A2A),
    onSurface: Color(0xFFE0E0E6),
    onSurfaceSecondary: Color(0xFF8E949E),
    outline: Color(0xFF3A3A3A),
    outlineVariant: Color(0xFF2A2A2A),
    error: Color(0xFFEF4444),
    onError: Color(0xFFFFFFFF),
    warning: Color(0xFFF59E0B),
    success: Color(0xFF22C55E),
    scrim: Color(0x99000000),
    overlay: Color(0x66000000),
    chatBubbleOutgoingBg: Color(0xFF6C63FF),
    chatBubbleOutgoingText: Color(0xFFFFFFFF),
    chatBubbleIncomingBg: Color(0xFF1A1A1A),
    chatBubbleIncomingText: Color(0xFFE0E0E6),
    chatTimestampColor: Color(0xFF8E949E),
    chatReadReceiptColor: Color(0xFF6C63FF),
    chatReplyStripColor: Color(0xFF6C63FF),
    chatLinkColor: Color(0xFF3B82F6),
    chatCodeBg: Color(0xFF2A2A2A),
    chatCodeText: Color(0xFFE0E0E6),
    buttonPrimaryBg: Color(0xFF6C63FF),
    buttonPrimaryText: Color(0xFFFFFFFF),
    buttonDestructiveBg: Color(0xFFEF4444),
    buttonDestructiveText: Color(0xFFFFFFFF),
    inputBarBg: Color(0xFF000000),
    inputBarBorder: Color(0xFF1A1A1A),
    inputBarText: Color(0xFFE0E0E6),
    inputBarPlaceholder: Color(0xFF8E949E),
    glassSurfaceOpacity: 0.60,
    glassBlurRadius: 20,
    glassBorderColor: Color(0x1AFFFFFF),
  );

  static const sutraLight = SutraColors(
    primary: Color(0xFF6055F2),
    primaryVariant: Color(0xFF4A3EBF),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF3B82F6),
    secondaryContainer: Color(0xFFDBEAFE),
    onSecondary: Color(0xFFFFFFFF),
    onSecondaryContainer: Color(0xFF1E3A8A),
    tertiary: Color(0xFFD946EF),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFDF4FF),
    onTertiaryContainer: Color(0xFF701A75),
    background: Color(0xFFF2F3FC),
    onBackground: Color(0xFF0B0E14),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFE0E0E6),
    surfaceElevated: Color(0xFFD1D1D9),
    onSurface: Color(0xFF0B0E14),
    onSurfaceSecondary: Color(0xFF73757D),
    outline: Color(0xFFA9ABB3),
    outlineVariant: Color(0xFFD1D1D9),
    error: Color(0xFFFF6E84),
    onError: Color(0xFFFFFFFF),
    warning: Color(0xFFF59E0B),
    success: Color(0xFF22C55E),
    scrim: Color(0x99000000),
    overlay: Color(0x66000000),
    chatBubbleOutgoingBg: Color(0xFF6C63FF),
    chatBubbleOutgoingText: Color(0xFFFFFFFF),
    chatBubbleIncomingBg: Color(0xFFFFFFFF),
    chatBubbleIncomingText: Color(0xFF0B0E14),
    chatTimestampColor: Color(0xFF73757D),
    chatReadReceiptColor: Color(0xFF6C63FF),
    chatReplyStripColor: Color(0xFF6C63FF),
    chatLinkColor: Color(0xFF3B82F6),
    chatCodeBg: Color(0xFFE0E0E6),
    chatCodeText: Color(0xFF0B0E14),
    buttonPrimaryBg: Color(0xFF6C63FF),
    buttonPrimaryText: Color(0xFFFFFFFF),
    buttonDestructiveBg: Color(0xFFFF6E84),
    buttonDestructiveText: Color(0xFFFFFFFF),
    inputBarBg: Color(0xFFFFFFFF),
    inputBarBorder: Color(0xFFE0E0E6),
    inputBarText: Color(0xFF0B0E14),
    inputBarPlaceholder: Color(0xFF73757D),
    glassSurfaceOpacity: 0.60,
    glassBlurRadius: 20,
    glassBorderColor: Color(0x1A000000),
  );

  static const sutraHighContrast = SutraColors(
    primary: Color(0xFFFFFF00), // High contrast yellow
    primaryVariant: Color(0xFFAAAA00),
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFF00FFFF),
    secondaryContainer: Color(0xFF008888),
    onSecondary: Color(0xFF000000),
    onSecondaryContainer: Color(0xFFFFFFFF),
    tertiary: Color(0xFFFFFF00),
    onTertiary: Color(0xFF000000),
    tertiaryContainer: Color(0xFF888800),
    onTertiaryContainer: Color(0xFFFFFFFF),
    background: Color(0xFF000000),
    onBackground: Color(0xFFFFFFFF),
    surface: Color(0xFF000000),
    surfaceVariant: Color(0xFF222222),
    surfaceElevated: Color(0xFF444444),
    onSurface: Color(0xFFFFFFFF),
    onSurfaceSecondary: Color(0xFFCCCCCC),
    outline: Color(0xFFFFFFFF),
    outlineVariant: Color(0xFF888888),
    error: Color(0xFFFF0000),
    onError: Color(0xFFFFFFFF),
    warning: Color(0xFFFFFF00),
    success: Color(0xFF00FF00),
    scrim: Color(0x99000000),
    overlay: Color(0x66000000),
    chatBubbleOutgoingBg: Color(0xFFFFFF00),
    chatBubbleOutgoingText: Color(0xFF000000),
    chatBubbleIncomingBg: Color(0xFF222222),
    chatBubbleIncomingText: Color(0xFFFFFFFF),
    chatTimestampColor: Color(0xFFCCCCCC),
    chatReadReceiptColor: Color(0xFFFFFF00),
    chatReplyStripColor: Color(0xFFFFFF00),
    chatLinkColor: Color(0xFF00FFFF),
    chatCodeBg: Color(0xFF444444),
    chatCodeText: Color(0xFFFFFFFF),
    buttonPrimaryBg: Color(0xFFFFFF00),
    buttonPrimaryText: Color(0xFF000000),
    buttonDestructiveBg: Color(0xFFFF0000),
    buttonDestructiveText: Color(0xFFFFFFFF),
    inputBarBg: Color(0xFF000000),
    inputBarBorder: Color(0xFFFFFFFF),
    inputBarText: Color(0xFFFFFFFF),
    inputBarPlaceholder: Color(0xFFCCCCCC),
    glassSurfaceOpacity: 0.80,
    glassBlurRadius: 0,
    glassBorderColor: Color(0xFFFFFFFF),
  );

  @override
  SutraColors copyWith({
    Color? primary,
    Color? primaryVariant,
    Color? onPrimary,
    Color? secondary,
    Color? secondaryContainer,
    Color? onSecondary,
    Color? onSecondaryContainer,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? surfaceVariant,
    Color? surfaceElevated,
    Color? onSurface,
    Color? onSurfaceSecondary,
    Color? outline,
    Color? outlineVariant,
    Color? error,
    Color? onError,
    Color? warning,
    Color? success,
    Color? scrim,
    Color? overlay,
    Color? chatBubbleOutgoingBg,
    Color? chatBubbleOutgoingText,
    Color? chatBubbleIncomingBg,
    Color? chatBubbleIncomingText,
    Color? chatTimestampColor,
    Color? chatReadReceiptColor,
    Color? chatReplyStripColor,
    Color? chatLinkColor,
    Color? chatCodeBg,
    Color? chatCodeText,
    Color? buttonPrimaryBg,
    Color? buttonPrimaryText,
    Color? buttonDestructiveBg,
    Color? buttonDestructiveText,
    Color? inputBarBg,
    Color? inputBarBorder,
    Color? inputBarText,
    Color? inputBarPlaceholder,
    double? glassSurfaceOpacity,
    double? glassBlurRadius,
    Color? glassBorderColor,
  }) {
    return SutraColors(
      primary: primary ?? this.primary,
      primaryVariant: primaryVariant ?? this.primaryVariant,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondary: onSecondary ?? this.onSecondary,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer ?? this.onTertiaryContainer,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceSecondary: onSurfaceSecondary ?? this.onSurfaceSecondary,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      warning: warning ?? this.warning,
      success: success ?? this.success,
      scrim: scrim ?? this.scrim,
      overlay: overlay ?? this.overlay,
      chatBubbleOutgoingBg: chatBubbleOutgoingBg ?? this.chatBubbleOutgoingBg,
      chatBubbleOutgoingText:
          chatBubbleOutgoingText ?? this.chatBubbleOutgoingText,
      chatBubbleIncomingBg: chatBubbleIncomingBg ?? this.chatBubbleIncomingBg,
      chatBubbleIncomingText:
          chatBubbleIncomingText ?? this.chatBubbleIncomingText,
      chatTimestampColor: chatTimestampColor ?? this.chatTimestampColor,
      chatReadReceiptColor: chatReadReceiptColor ?? this.chatReadReceiptColor,
      chatReplyStripColor: chatReplyStripColor ?? this.chatReplyStripColor,
      chatLinkColor: chatLinkColor ?? this.chatLinkColor,
      chatCodeBg: chatCodeBg ?? this.chatCodeBg,
      chatCodeText: chatCodeText ?? this.chatCodeText,
      buttonPrimaryBg: buttonPrimaryBg ?? this.buttonPrimaryBg,
      buttonPrimaryText: buttonPrimaryText ?? this.buttonPrimaryText,
      buttonDestructiveBg: buttonDestructiveBg ?? this.buttonDestructiveBg,
      buttonDestructiveText:
          buttonDestructiveText ?? this.buttonDestructiveText,
      inputBarBg: inputBarBg ?? this.inputBarBg,
      inputBarBorder: inputBarBorder ?? this.inputBarBorder,
      inputBarText: inputBarText ?? this.inputBarText,
      inputBarPlaceholder: inputBarPlaceholder ?? this.inputBarPlaceholder,
      glassSurfaceOpacity: glassSurfaceOpacity ?? this.glassSurfaceOpacity,
      glassBlurRadius: glassBlurRadius ?? this.glassBlurRadius,
      glassBorderColor: glassBorderColor ?? this.glassBorderColor,
    );
  }

  @override
  SutraColors lerp(ThemeExtension<SutraColors>? other, double t) {
    if (other is! SutraColors) return this;

    return SutraColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryVariant: Color.lerp(primaryVariant, other.primaryVariant, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryContainer: Color.lerp(
        secondaryContainer,
        other.secondaryContainer,
        t,
      )!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      onSecondaryContainer: Color.lerp(
        onSecondaryContainer,
        other.onSecondaryContainer,
        t,
      )!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,
      tertiaryContainer: Color.lerp(
        tertiaryContainer,
        other.tertiaryContainer,
        t,
      )!,
      onTertiaryContainer: Color.lerp(
        onTertiaryContainer,
        other.onTertiaryContainer,
        t,
      )!,
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceSecondary: Color.lerp(
        onSurfaceSecondary,
        other.onSurfaceSecondary,
        t,
      )!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      success: Color.lerp(success, other.success, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      chatBubbleOutgoingBg: Color.lerp(
        chatBubbleOutgoingBg,
        other.chatBubbleOutgoingBg,
        t,
      )!,
      chatBubbleOutgoingText: Color.lerp(
        chatBubbleOutgoingText,
        other.chatBubbleOutgoingText,
        t,
      )!,
      chatBubbleIncomingBg: Color.lerp(
        chatBubbleIncomingBg,
        other.chatBubbleIncomingBg,
        t,
      )!,
      chatBubbleIncomingText: Color.lerp(
        chatBubbleIncomingText,
        other.chatBubbleIncomingText,
        t,
      )!,
      chatTimestampColor: Color.lerp(
        chatTimestampColor,
        other.chatTimestampColor,
        t,
      )!,
      chatReadReceiptColor: Color.lerp(
        chatReadReceiptColor,
        other.chatReadReceiptColor,
        t,
      )!,
      chatReplyStripColor: Color.lerp(
        chatReplyStripColor,
        other.chatReplyStripColor,
        t,
      )!,
      chatLinkColor: Color.lerp(chatLinkColor, other.chatLinkColor, t)!,
      chatCodeBg: Color.lerp(chatCodeBg, other.chatCodeBg, t)!,
      chatCodeText: Color.lerp(chatCodeText, other.chatCodeText, t)!,
      buttonPrimaryBg: Color.lerp(buttonPrimaryBg, other.buttonPrimaryBg, t)!,
      buttonPrimaryText: Color.lerp(
        buttonPrimaryText,
        other.buttonPrimaryText,
        t,
      )!,
      buttonDestructiveBg: Color.lerp(
        buttonDestructiveBg,
        other.buttonDestructiveBg,
        t,
      )!,
      buttonDestructiveText: Color.lerp(
        buttonDestructiveText,
        other.buttonDestructiveText,
        t,
      )!,
      inputBarBg: Color.lerp(inputBarBg, other.inputBarBg, t)!,
      inputBarBorder: Color.lerp(inputBarBorder, other.inputBarBorder, t)!,
      inputBarText: Color.lerp(inputBarText, other.inputBarText, t)!,
      inputBarPlaceholder: Color.lerp(
        inputBarPlaceholder,
        other.inputBarPlaceholder,
        t,
      )!,
      glassSurfaceOpacity: lerpDouble(
        glassSurfaceOpacity,
        other.glassSurfaceOpacity,
        t,
      )!,
      glassBlurRadius: lerpDouble(glassBlurRadius, other.glassBlurRadius, t)!,
      glassBorderColor: Color.lerp(
        glassBorderColor,
        other.glassBorderColor,
        t,
      )!,
    );
  }
}
