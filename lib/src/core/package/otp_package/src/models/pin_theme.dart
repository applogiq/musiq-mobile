part of '../pinput.dart';

class PinTheme {
  final double? width;

  final double? height;

  final TextStyle? textStyle;

  final EdgeInsetsGeometry? margin;

  final EdgeInsetsGeometry? padding;

  final BoxConstraints? constraints;

  final BoxDecoration? decoration;

  const PinTheme({
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.textStyle,
    this.decoration,
    this.constraints,
  });

  PinTheme apply({required PinTheme theme}) {
    return PinTheme(
      width: width ?? theme.width,
      height: height ?? theme.height,
      textStyle: textStyle ?? theme.textStyle,
      constraints: constraints ?? theme.constraints,
      decoration: decoration ?? theme.decoration,
      padding: padding ?? theme.padding,
      margin: margin ?? theme.margin,
    );
  }

  PinTheme copyWith({
    double? width,
    double? height,
    TextStyle? textStyle,
    BoxConstraints? constraints,
    BoxDecoration? decoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return PinTheme(
      width: width ?? this.width,
      height: height ?? this.height,
      textStyle: textStyle ?? this.textStyle,
      constraints: constraints ?? this.constraints,
      decoration: decoration ?? this.decoration,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
    );
  }

  PinTheme copyDecorationWith({
    Color? color,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape? shape,
  }) {
    assert(decoration != null);
    return copyWith(
      decoration: decoration?.copyWith(
        color: color,
        image: image,
        border: border,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        gradient: gradient,
        backgroundBlendMode: backgroundBlendMode,
        shape: shape,
      ),
    );
  }

  PinTheme copyBorderWith({required Border border}) {
    assert(decoration != null);
    return copyWith(
      decoration: decoration?.copyWith(border: border),
    );
  }
}
