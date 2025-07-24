import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:se_gay_components/examples/main_wrapper_example.dart';
import 'package:se_gay_components/screens/dashboard/daily_report_screen.dart';
import 'package:se_gay_components/screens/dashboard/monthly_report_screen.dart';
import 'package:se_gay_components/screens/dashboard/weekly_report_screen.dart';
import 'package:se_gay_components/screens/customer/customer_group_screen.dart';
import 'package:se_gay_components/screens/customer/customer_list_screen.dart';
import 'package:se_gay_components/screens/product/add_product_screen.dart';
import 'package:se_gay_components/screens/product/product_list_screen.dart';
import 'package:se_gay_components/screens/report_screen.dart';
import 'package:se_gay_components/screens/settings_screen.dart';
import 'package:se_gay_components/screens/not_found_screen.dart';

// Cấu hình router toàn cục
final appRouter = GoRouter(
  initialLocation: '/dashboard/daily',
  errorBuilder: (context, state) => const NotFoundScreen(),
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        // Sử dụng MainWrapperExample như shell navigation
        return MainWrapperExample(child: child);
      },
      routes: [
        // Dashboard routes
        GoRoute(
          path: '/dashboard',
          redirect: (_, __) => '/dashboard/daily',
        ),
        GoRoute(
          path: '/dashboard/daily',
          name: 'dashboard-daily',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const DailyReportScreen(),
          ),
        ),
        GoRoute(
          path: '/dashboard/weekly',
          name: 'dashboard-weekly',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const WeeklyReportScreen(),
          ),
        ),
        GoRoute(
          path: '/dashboard/monthly',
          name: 'dashboard-monthly',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const MonthlyReportScreen(),
          ),
        ),

        // Product routes
        GoRoute(
          path: '/products',
          redirect: (_, __) => '/products/list',
        ),
        GoRoute(
          path: '/products/list',
          name: 'products-list',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const ProductListScreen(),
          ),
        ),
        GoRoute(
          path: '/products/add',
          name: 'products-add',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const AddProductScreen(),
          ),
        ),

        // Customer routes
        GoRoute(
          path: '/customers',
          redirect: (_, __) => '/customers/list',
        ),
        GoRoute(
          path: '/customers/list',
          name: 'customers-list',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const CustomerListScreen(),
          ),
        ),
        GoRoute(
          path: '/customers/groups',
          name: 'customer-groups',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const CustomerGroupScreen(),
          ),
        ),

        // Report route
        GoRoute(
          path: '/reports',
          name: 'reports',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const ReportScreen(),
          ),
        ),

        // Settings route
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const SettingsScreen(),
          ),
        ),
      ],
    ),
  ],
); 