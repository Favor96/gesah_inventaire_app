import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 Importer le package de services
import 'package:gesah_inventaire_app/utils/app_theme.dart';
import 'app_router.dart';

void main() {
  // 1. Assure que les bindings Flutter sont initialisés avant de configurer l'UI
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Définit le mode d'affichage de l'UI système
  //    'edgeToEdge' permet à votre app de dessiner sous les barres de statut et de navigation
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // 3. Applique un style personnalisé aux barres système
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // Rend la barre de statut (en haut) transparente
      statusBarColor: Colors.transparent,

      // Rend la barre de navigation (en bas) transparente
      systemNavigationBarColor: Colors.transparent,

      // --- IMPORTANT POUR LA VISIBILITÉ ---
      // Définit la couleur des icônes de la barre de statut (heure, batterie, WiFi)
      // Utilisez Brightness.dark pour des icônes sombres (sur fond clair)
      // Utilisez Brightness.light pour des icônes claires (sur fond sombre)
      statusBarIconBrightness: Brightness.dark,

      // Définit la couleur des icônes de la barre de navigation (gestes, boutons retour/home)
      // Utilisez Brightness.dark pour des icônes sombres (sur fond clair)
      // Utilisez Brightness.light pour des icônes claires (sur fond sombre)
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.lightTheme,
    );
  }
}