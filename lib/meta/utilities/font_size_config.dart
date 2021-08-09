import 'package:afrocom/meta/views/authentication/login/login.exports.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? height;
  static double? width = 0;
  static double? titleSize = 0;
  static double? sfontSize = 0;
  static double? mFontSize = 0;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    width = _mediaQueryData!.size.width;
    height = _mediaQueryData!.size.height;
    titleSize = _mediaQueryData!.size.width * 0.08;
    sfontSize = _mediaQueryData!.size.width * 0.04;
    mFontSize = _mediaQueryData!.size.width * 0.06;
  }

  static double setWidth(
          {required BuildContext context, required double factor}) =>
      MediaQuery.of(context).size.width * factor;
  static double setHeight(
          {required BuildContext context, required double factor}) =>
      MediaQuery.of(context).size.height * factor;
  static double verticalSpacing(
          {required BuildContext context, required double factor}) =>
      MediaQuery.of(context).size.height * factor;
  static double horizontalSpacing(
          {required BuildContext context, required double factor}) =>
      MediaQuery.of(context).size.width * factor;

  static SizedBox verticalSizedBox(
          {required BuildContext context, required double factor}) =>
      SizedBox(
        height: verticalSpacing(context: context, factor: factor),
      );

  static SizedBox horizontalSizedBox(
          {required BuildContext context, required double factor}) =>
      SizedBox(
        width: horizontalSpacing(context: context, factor: factor),
      );
}
