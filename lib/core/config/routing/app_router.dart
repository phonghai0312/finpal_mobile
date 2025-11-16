import 'package:flutter/material.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/core/presentation/widget/navigation/custom_bottom_navigation.dart';
import 'package:fridge_to_fork_ai/core/utils/navigation_key.dart';
import 'package:fridge_to_fork_ai/features/auth/presentation/page/forgotpassword/send_request_page.dart';
import 'package:fridge_to_fork_ai/features/auth/presentation/page/register/register_page.dart';
import 'package:fridge_to_fork_ai/features/home/presentation/home_page.dart';
import 'package:fridge_to_fork_ai/features/onboarding/presentation/page/onboarding_page.dart';
import 'package:fridge_to_fork_ai/features/onboarding/presentation/page/splash_page.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/pages/transactions_page.dart';
import 'package:fridge_to_fork_ai/features/analytics/presentation/analytics_page.dart';
import 'package:fridge_to_fork_ai/features/profile/presentation/profile_page.dart';
import 'package:fridge_to_fork_ai/features/suggestions/presentation/suggestions_page.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/page/login/login_page.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/pages/transaction_detail_page.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/pages/create_transaction_page.dart';

class AppRouter {
  static final customerRouter = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      // Auth
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.sendrequest,
        builder: (context, state) => const SendRequestPage(),
      ),
      GoRoute(
        path: AppRoutes.transactionDetail,
        builder: (context, state) {
          final transactionId = state.pathParameters['id']!;
          return TransactionDetailPage(transactionId: transactionId);
        },
      ),
      GoRoute(
        path: AppRoutes.createTransaction,
        builder: (context, state) => const CreateTransactionPage(),
      ),
      // Shell router have nav bar
      ShellRoute(
        builder: (context, state, child) {
          final int currentIndex = _getUserGuestNavIndex(state.uri.path);
          return Scaffold(
            body: child,
            bottomNavigationBar: CustomBottomNavBar(initialIndex: currentIndex),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.transactions,
            builder: (context, state) => const TransactionsPage(),
          ),
          GoRoute(
            path: AppRoutes.analytics,
            builder: (context, state) => const AnalyticsPage(),
          ),
          GoRoute(
            path: AppRoutes.suggestions,
            builder: (context, state) => const SuggestionsPage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
  static int _getUserGuestNavIndex(String path) {
    if (path == AppRoutes.home) return 0;
    if (path.startsWith(AppRoutes.transactions)) return 1;
    if (path.startsWith(AppRoutes.analytics)) return 2;
    if (path.startsWith(AppRoutes.suggestions)) return 3;
    if (path.startsWith(AppRoutes.profile)) return 4;
    return 0;
  }
}
