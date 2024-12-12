import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>  //when the screen less than 576 pixel are consider as a mobile phone
      MediaQuery.of(context).size.width < 576;

  static bool isTablet(BuildContext context) =>  // when the screen less than 992 pixel and bigger than 576 are consider as a tablet phone
      MediaQuery.of(context).size.width >= 576 &&
      MediaQuery.of(context).size.width <= 992;

  static bool isDesktop(BuildContext context) =>  //when the screen more than 992 pixel are consider as a desktop
      MediaQuery.of(context).size.width > 992;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width > 992) {
      return desktop;
    } else if (size.width >= 576 && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
