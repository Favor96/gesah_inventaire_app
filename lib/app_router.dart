import 'package:flutter/material.dart';
import 'package:gesah_inventaire_app/view/Immobilisation_detail_page.dart';
import 'package:gesah_inventaire_app/view/affectation_form_page.dart';
import 'package:gesah_inventaire_app/view/dashboard_screen.dart';
import 'package:gesah_inventaire_app/view/vente_list_screen.dart';
import 'package:gesah_inventaire_app/view/agent_list_screen.dart';
import 'package:gesah_inventaire_app/view/caisse_screen.dart';
import 'package:gesah_inventaire_app/view/categorie_list_screen.dart';
import 'package:gesah_inventaire_app/view/client_list_screen.dart';
import 'package:gesah_inventaire_app/view/creer_client_screen.dart';
import 'package:gesah_inventaire_app/view/creer_inv_caisse.dart';
import 'package:gesah_inventaire_app/view/creer_inv_immo.dart';
import 'package:gesah_inventaire_app/view/creer_inv_stock.dart';
import 'package:gesah_inventaire_app/view/creer_inv_stock.dart';
import 'package:gesah_inventaire_app/view/immobilisation_screen.dart'; // 👈 Importer le nouveau DashboardScreen
import 'package:gesah_inventaire_app/view/home_screen.dart';
import 'package:gesah_inventaire_app/view/immo_screen.dart';
import 'package:gesah_inventaire_app/view/inv_stock_detail.dart';
import 'package:gesah_inventaire_app/view/login_screen.dart';
import 'package:gesah_inventaire_app/view/menu_screen.dart';
import 'package:gesah_inventaire_app/view/product_list_screen.dart';
import 'package:gesah_inventaire_app/view/splash%20screen.dart';
import 'package:gesah_inventaire_app/view/stock_screen.dart';
import 'package:gesah_inventaire_app/view/achat_list_screen.dart';
import 'package:go_router/go_router.dart';

// Clé de navigation globale pour la ShellRoute
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<
    NavigatorState>();

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
        path: '/creer-inventaire-stock',
        name: 'inventaire-stock',
        builder: (context, state) => const CreerInventaireStockPage()),
    GoRoute(
        path: '/creer-inventaire-immo',
        name: 'inventaire-immo',
        builder: (context, state) => const CreerInventaireImmoPage()),
    GoRoute(
        path: '/creer-inventaire-caisse',
        name: 'inventaire-caisse',
        builder: (context, state) => const CreerInventaireCaissePage()),
    GoRoute(
        path: '/client-list',
        name: 'client-list',
        builder: (context, state) => const ClientsPage()),
    GoRoute(
        path: '/agent-list',
        name: 'agent-list',
        builder: (context, state) => const AgentsPage()),
    GoRoute(
        path: '/category-list',
        name: 'category-list',
        builder: (context, state) => const CategoryProductPage()),
    GoRoute(
        path: '/creer-client',
        name: 'creer-client',
        builder: (context, state) => const AjouterClientPage()),
    GoRoute(
        path: '/product-list',
        name: 'product-list',
        builder: (context, state) => const ProductPage()),
    GoRoute(
        path: '/achat-list',
        name: 'achat-list',
        builder: (context, state) =>  AchatPage()),
    GoRoute(
        path: '/vente-list',
        name: 'vente-list',
        builder: (context, state) =>  VentePage()),
    GoRoute(
      path: '/immobilisation-list',
      name: 'immobilisation-list',
      builder: (context, state) => ImmobilisationScreen(),

    ),
    GoRoute(
      path: '/immobilisation-detail',
      name: 'immobilisation-detail',
      builder: (context, state) {
        final immobilisation = state.extra as Immobilisation;
        return ImmobilisationDetailPage(immobilisation: immobilisation);
      },
    ),
    GoRoute(
      path: '/immobilisation-affectation',
      name: 'immobilisation-affectation',
      builder: (context, state) {
        final immobilisation = state.extra as Immobilisation;
        return AffectationFormPage(immobilisation: immobilisation);
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return HomeScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          redirect: (context, state) => '/dashboard',
        ),
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/stock',
          name: 'stock',
          builder: (context, state) => const StockScreen()),
        GoRoute(
            path: '/caisse',
            name: 'caisse',
            builder: (context, state) => const CaisseScreen()),
        GoRoute(
            path: '/immo',
            name: 'immo',
            builder: (context, state) => const ImmoScreen()),
        GoRoute(
            path: '/menu',
            name: 'menu',
            builder: (context, state) => const MenuPage()),

      ],
    ),
  ],
);