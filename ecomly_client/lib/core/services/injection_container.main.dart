part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _cacheInit();
  await _authInit();
  await _userInit();
  await _productInit();
  await _wishlistInit();
  await _cartInit();
}

Future<void> _cacheInit() async {
  final prefs = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton(() => CacheHelper(sl()))
    ..registerLazySingleton(() => prefs);
}

Future<void> _authInit() async {
  sl
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => Login(sl()))
    ..registerLazySingleton(() => Register(sl()))
    ..registerLazySingleton(() => ResetPassword(sl()))
    ..registerLazySingleton(() => VerifyOTP(sl()))
    ..registerLazySingleton(() => VerifyToken(sl()))
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImplementation(sl()),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImplementation(sl()),
    )
    ..registerLazySingleton(http.Client.new);
}

Future<void> _userInit() async {
  sl
    ..registerLazySingleton(() => GetUser(sl()))
    ..registerLazySingleton(() => GetUserPaymentProfile(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton<UserRepository>(
      () => UserRepositoryImplementation(sl()),
    )
    ..registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(sl()),
    );
}

Future<void> _productInit() async {
  sl
    ..registerLazySingleton(() => GetCategories(sl()))
    ..registerLazySingleton(() => GetCategory(sl()))
    ..registerLazySingleton(() => GetNewArrivals(sl()))
    ..registerLazySingleton(() => GetPopular(sl()))
    ..registerLazySingleton(() => GetProduct(sl()))
    ..registerLazySingleton(() => GetProductReviews(sl()))
    ..registerLazySingleton(() => GetProducts(sl()))
    ..registerLazySingleton(() => GetProductsByCategory(sl()))
    ..registerLazySingleton(() => LeaveReview(sl()))
    ..registerLazySingleton(() => SearchAllProducts(sl()))
    ..registerLazySingleton(() => SearchByCategory(sl()))
    ..registerLazySingleton(() => SearchByCategoryAndGenderAgeCategory(sl()))
    ..registerLazySingleton<ProductRepo>(() => ProductRepoImpl(sl()))
    ..registerLazySingleton<ProductRemoteDataSrc>(
      () => ProductRemoteDataSrcImpl(sl()),
    );
}

Future<void> _wishlistInit() async {
  sl
    ..registerLazySingleton(() => GetWishlist(sl()))
    ..registerLazySingleton(() => AddToWishlist(sl()))
    ..registerLazySingleton(() => RemoveFromWishlist(sl()))
    ..registerLazySingleton<WishlistRepo>(() => WishlistRepoImpl(sl()))
    ..registerLazySingleton<WishlistRemoteDataSrc>(
      () => WishlistRemoteDataSrcImpl(sl()),
    );
}

Future<void> _cartInit() async {
  sl
    ..registerLazySingleton(() => AddToCart(sl()))
    ..registerLazySingleton(() => ChangeCartProductQuantity(sl()))
    ..registerLazySingleton(() => GetCart(sl()))
    ..registerLazySingleton(() => GetCartCount(sl()))
    ..registerLazySingleton(() => GetCartProduct(sl()))
    ..registerLazySingleton(() => RemoveFromCart(sl()))
    ..registerLazySingleton(() => InitiateCheckout(sl()))
    ..registerLazySingleton<CartRepo>(() => CartRepoImpl(sl()))
    ..registerLazySingleton<CartRemoteDataSrc>(
      () => CartRemoteDataSrcImpl(sl()),
    );
}
