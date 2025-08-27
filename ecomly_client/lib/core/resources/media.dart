/// Centralized asset management for the Ecomly client app.
///
/// This class provides static constants for referencing image and Lottie
/// animation assets used across the application. Keeping asset paths
/// centralized prevents typos, makes refactoring easier, and improves
/// maintainability.
abstract class Media {
  const Media();

  // Base directories
  static const _baseImage = 'assets/images';
  static const _baseLottie = 'assets/lottie';

  // Images
  static const onBoardingFemale = '$_baseImage/on_boarding_female.png';
  static const onBoardingMale = '$_baseImage/on_boarding_male.png';
  static const user = '$_baseImage/user.png';

  // Lottie animations
  static const search = '$_baseLottie/search.json';
  static const searchLight = '$_baseLottie/search_light.json';
  static const searching = '$_baseLottie/searching.json';
  static const error = '$_baseLottie/error.json';
  static const emptyCart = '$_baseLottie/empty_cart.json';

  /// Animated check mark for checkout completion
  static const checkMark = '$_baseLottie/check.json';
}
