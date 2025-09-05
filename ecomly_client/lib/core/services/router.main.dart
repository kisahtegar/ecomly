part of 'router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) {
        final cacheHelper = sl<CacheHelper>()
          ..getSessionToken()
          ..getUserId();
        if ((Cache.instance.sessionToken == null ||
                Cache.instance.userId == null) &&
            !cacheHelper.isFirstTime()) {
          return LoginScreen.path;
        }
        if (state.extra == 'home') return HomeView.path;
        return null;
      },
      builder: (_, __) {
        final cacheHelper = sl<CacheHelper>()
          ..getSessionToken()
          ..getUserId();
        if (cacheHelper.isFirstTime()) {
          return const OnBoardingScreen();
        }
        return const SplashScreen();
      },
    ),
    GoRoute(path: LoginScreen.path, builder: (_, __) => const LoginScreen()),
    GoRoute(
      path: ForgotPasswordScreen.path,
      builder: (_, __) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: VerifyOTPScreen.path,
      builder: (_, state) => VerifyOTPScreen(email: state.extra as String),
    ),
    GoRoute(
      path: ResetPasswordScreen.path,
      builder: (_, state) => ResetPasswordScreen(email: state.extra as String),
    ),
    GoRoute(
      path: RegistrationScreen.path,
      builder: (_, __) => const RegistrationScreen(),
    ),
    GoRoute(
      path: SearchView.path,
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, __) => const SearchView(),
    ),
    GoRoute(
      path: '/products/:productId',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) =>
          ProductDetailsView(state.pathParameters['productId'] as String),
    ),
    GoRoute(
      path: '/products/:productId/reviews',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) => ProductReviews(state.extra as Product),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return DashboardScreen(state: state, child: child);
      },
      routes: [
        GoRoute(
          path: HomeView.path,
          builder: (_, __) => const HomeView(),
          routes: [
            GoRoute(
              path: AllNewArrivalsView.path,
              builder: (_, __) => const AllNewArrivalsView(),
            ),
            GoRoute(
              path: AllPopularProductsView.path,
              builder: (_, __) => const AllPopularProductsView(),
            ),
          ],
        ),
        GoRoute(
          path: ExploreView.path,
          builder: (_, __) => const ExploreView(),
        ),
        GoRoute(
          path: WishlistView.path,
          builder: (_, __) => const WishlistView(),
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: CartView.path,
      builder: (_, __) => const CartView(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: ProfileView.path,
      builder: (_, __) => const ProfileView(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: PaymentProfileView.path,
      builder: (_, state) =>
          PaymentProfileView(sessionUrl: state.extra as String),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: CheckoutView.path,
      builder: (_, state) => CheckoutView(sessionUrl: state.extra as String),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: CheckoutSuccessfulView.path,
      builder: (_, state) => const CheckoutSuccessfulView(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/:category_name',
      redirect: (_, state) {
        if (state.extra is! ProductCategory) return '/home';
        return null;
      },
      builder: (_, state) {
        return CategorizedProductsView(state.extra as ProductCategory);
      },
    ),
  ],
);
