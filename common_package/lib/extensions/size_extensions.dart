import 'package:flutter/material.dart';

extension SizeExtensions on BuildContext {
  Size get sizeScreen => MediaQuery.sizeOf(this);
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  double get bodyHeight {
    Size size = sizeScreen;
    double statusBar = viewPadding.top;
    // double kLeadingWidth = kToolbarHeight;
    double bottomBar = viewInsets.bottom;
    double bottomPadding = viewPadding.bottom;
    double bottomSafeArea = padding.bottom;
    return size.height -
        statusBar /*- kLeadingWidth*/ -
        bottomBar -
        bottomPadding -
        bottomSafeArea;
  }

  Size size() => MediaQuery.sizeOf(this);

  /// return screen width
  double get width => MediaQuery.sizeOf(this).width;

  /// return screen height
  double get height => MediaQuery.sizeOf(this).height;

  /// return screen devicePixelRatio
  double get pixelRatio => MediaQuery.devicePixelRatioOf(this);

  /// returns brightness
  Brightness get platformBrightness => MediaQuery.platformBrightnessOf(this);

  /// Return the height of status bar
  double get statusBarHeight => MediaQuery.paddingOf(this).top;

  /// Return the height of navigation bar
  double get navigationBarHeight =>  MediaQuery.paddingOf(this).bottom;
}
