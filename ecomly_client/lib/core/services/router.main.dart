part of 'router.dart';

/// Global navigator key for routes that should be presented above the shell
/// (e.g., full-screen modals like Search, Cart, Profile, Checkout).
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Navigator key for the ShellRoute (bottom navigation/dashboard area).
///
/// Routes inside the shell share this navigator, which allows nested navigation
/// within the dashboard tabs while keeping the app bar and bottom navigation
/// persistent.
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Central application router configured with GoRouter.
///
/// Responsibilities and behavior:
/// - Handles first-time user onboarding (OnBoardingScreen)
/// - Handles splash/auth bootstrap and login redirection
/// - Provides a ShellRoute for the dashboard tabs (Home, Explore, Wishlist)
/// - Defines top-level modal routes that sit above the shell (Search, Cart, etc.)
/// - Supports parameterized routes (product details, reviews, categories)
/// - Uses [state.extra] to pass complex objects where necessary
///
/// Notes:
/// - [debugLogDiagnostics] is enabled to help debug route issues in dev.
/// - [initialLocation] is set to '/'. The '/' route redirects/builds based on
///   onboarding state and authentication cache.
final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    // Root route ('/') bootstraps the app and decides where to go next.
    //
    // Behavior:
    // - If first app launch: show OnBoardingScreen
    // - Else if no auth session: redirect to LoginScreen
    // - Else: show SplashScreen to bootstrap user/session, then navigate
    // - If state.extra == 'home': jump directly to HomeView
    GoRoute(
      path: '/',
      redirect: (context, state) {
        final cacheHelper = sl<CacheHelper>()
          ..getSessionToken()
          ..getUserId();
        // Not first-time and no session => force login
        if ((Cache.instance.sessionToken == null ||
                Cache.instance.userId == null) &&
            !cacheHelper.isFirstTime()) {
          return LoginScreen.path;
        }
        // Shortcut to home (used after successful flows)
        if (state.extra == 'home') return HomeView.path;
        return null; // proceed to builder
      },
      builder: (_, __) {
        final cacheHelper = sl<CacheHelper>()
          ..getSessionToken()
          ..getUserId();
        if (cacheHelper.isFirstTime()) {
          return const OnBoardingScreen();
        }
        // Splash handles token validation, user fetching, and initial navigation
        return const SplashScreen();
      },
    ),
    // Authentication routes
    GoRoute(path: LoginScreen.path, builder: (_, __) => const LoginScreen()),
    GoRoute(
      path: ForgotPasswordScreen.path,
      builder: (_, __) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: VerifyOTPScreen.path,
      // Expects state.extra to be the email String used for OTP verification.
      builder: (_, state) => VerifyOTPScreen(email: state.extra as String),
    ),
    GoRoute(
      path: ResetPasswordScreen.path,
      // Expects state.extra to be the email String used for password reset.
      builder: (_, state) => ResetPasswordScreen(email: state.extra as String),
    ),
    GoRoute(
      path: RegistrationScreen.path,
      builder: (_, __) => const RegistrationScreen(),
    ),
    // Top-level full-screen modal routes (presented above the shell)
    GoRoute(
      path: SearchView.path,
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, __) => const SearchView(),
    ),
    // Product details expects :productId as a path parameter
    GoRoute(
      path: '/products/:productId',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) =>
          ProductDetailsView(state.pathParameters['productId'] as String),
    ),
    // Product reviews expects a full Product instance in state.extra
    GoRoute(
      path: '/products/:productId/reviews',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) => ProductReviews(state.extra as Product),
    ),
    /// Dashboard shell (bottom navigation)
    ///
    /// Hosts the main app tabs and maintains their navigation stacks.
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return DashboardScreen(state: state, child: child);
      },
      routes: [
        // Home tab and nested sub-routes
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
        // Explore tab
        GoRoute(
          path: ExploreView.path,
          builder: (_, __) => const ExploreView(),
        ),
        // Wishlist tab
        GoRoute(
          path: WishlistView.path,
          builder: (_, __) => const WishlistView(),
        ),
      ],
    ),
    // Cart (top-level modal above the shell)
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: CartView.path,
      builder: (_, __) => const CartView(),
    ),
    // Profile (top-level modal above the shell)
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: ProfileView.path,
      builder: (_, __) => const ProfileView(),
    ),
    // Payment profile expects a sessionUrl in state.extra
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: PaymentProfileView.path,
      builder: (_, state) =>
          PaymentProfileView(sessionUrl: state.extra as String),
    ),
    // Checkout expects a sessionUrl in state.extra
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: CheckoutView.path,
      builder: (_, state) => CheckoutView(sessionUrl: state.extra as String),
    ),
    // Checkout success (no params expected)
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: CheckoutSuccessfulView.path,
      builder: (_, state) => const CheckoutSuccessfulView(),
    ),
    // Category listing route
    //
    // Path includes a category name purely for readability/SEO-like paths,
    // while the actual ProductCategory object must be provided via state.extra.
    // If extra is missing or invalid, redirect to Home.
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
