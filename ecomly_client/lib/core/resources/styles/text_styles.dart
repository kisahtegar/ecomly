import 'package:flutter/widgets.dart';

/// A collection of predefined [TextStyle] constants used throughout the Ecomly app.
///
/// This class provides a consistent typography system for headings, paragraphs,
/// and buttons, ensuring uniform design across all screens.
abstract class TextStyles {
  /// Bold heading style.
  ///
  /// - Weight: **w700**
  /// - Size: **48**
  /// - Line height: **1.2** → 57.6px
  static const TextStyle headingBold = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// Bold heading style for smaller titles.
  ///
  /// - Weight: **w700**
  /// - Size: **20**
  /// - Line height: **1.5** → 30px
  static const TextStyle headingBold1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  /// Regular heading style for subheadings or body headers.
  ///
  /// - Weight: **w400**
  /// - Size: **20**
  /// - Line height: **1.5** → 30px
  static const TextStyle headingRegular = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Bold heading style (medium-large).
  ///
  /// - Weight: **w700**
  /// - Size: **30**
  /// - Line height: **1.5** → 45px
  static const TextStyle headingBold3 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  /// Semi-bold heading style (slightly larger).
  ///
  /// - Weight: **w600**
  /// - Size: **22**
  /// - Line height: **1.5** → 33px
  static const TextStyle headingSemiBold = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  /// Semi-bold heading style (compact).
  ///
  /// - Weight: **w600**
  /// - Size: **16**
  /// - Line height: **1.5** → 24px
  static const TextStyle headingSemiBold1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  /// Medium weight heading style.
  ///
  /// - Weight: **w500**
  /// - Size: **28**
  /// - Line height: **1.5** → 42px
  static const TextStyle headingMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  /// Medium weight heading style.
  ///
  /// - Weight: **w500**
  /// - Size: **24**
  /// - Line height: **1.5** → 36px
  static const TextStyle headingMedium1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  /// Medium weight heading style.
  ///
  /// - Weight: **w500**
  /// - Size: **22**
  /// - Line height: **1.5** → 33px
  static const TextStyle headingMedium2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  /// Medium weight heading style.
  ///
  /// - Weight: **w500**
  /// - Size: **20**
  /// - Line height: **1.5** → 30px
  static const TextStyle headingMedium3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  /// Medium weight heading style (compact).
  ///
  /// - Weight: **w500**
  /// - Size: **16**
  /// - Line height: **1.5** → 24px
  static const TextStyle headingMedium4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  /// Semi-bold style for button text.
  ///
  /// - Weight: **w600**
  /// - Size: **20**
  /// - Line height: **1.5** → 30px
  static const TextStyle buttonTextHeadingSemiBold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  /// Regular paragraph subtext style (small).
  ///
  /// - Weight: **w400**
  /// - Size: **12**
  /// - Line height: **1.5** → 18px
  static const TextStyle paragraphSubTextRegular = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Regular paragraph subtext style (normal).
  ///
  /// - Weight: **w400**
  /// - Size: **16**
  /// - Line height: **1.5** → 24px
  static const TextStyle paragraphSubTextRegular1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Regular paragraph subtext style (slightly smaller).
  ///
  /// - Weight: **w400**
  /// - Size: **13**
  /// - Line height: **1.5** → 19.5px
  static const TextStyle paragraphSubTextRegular2 = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Regular paragraph subtext style (standard body).
  ///
  /// - Weight: **w400**
  /// - Size: **14**
  /// - Line height: **1.5** → 21px
  static const TextStyle paragraphSubTextRegular3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Regular paragraph text style.
  ///
  /// - Weight: **w400**
  /// - Size: **14**
  /// - Line height: **1.71** → 24px
  static const TextStyle paragraphRegular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.71,
  );

  /// Bold style for the app logo text.
  ///
  /// - Weight: **w700**
  /// - Size: **36**
  static const TextStyle appLogo = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
  );
}
