import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 👈 1. Importer go_router
import 'package:gesah_inventaire_app/view/dashboard_screen.dart'; // 👈 Importer votre page d'accueil

class HomeScreen extends StatelessWidget {
  // 👈 2. Le widget est maintenant StatelessWidget
  final Widget child; // 👈 3. Il accepte un widget enfant

  const HomeScreen({
    required this.child, // Le child est obligatoire
    Key? key,
  }) : super(key: key);

  // Fonction pour déterminer l'index sélectionné en fonction de la route actuelle
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState
        .of(context)
        .uri
        .toString();
    if (location.startsWith('/dashboard')) {
      return 0;
    }
    if (location.startsWith('/stock')) {
      return 1;
    }
    if (location.startsWith('/caisse')) {
      return 2;
    }
    if (location.startsWith('/immo')) {
      return 3;
    }
    if (location.startsWith('/menu')) {
      return 4;
    }
    return 0; // Par défaut, retourne à l'accueil
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard'); // Navigue vers la route du dashboard
        break;
      case 1:
        context.go('/stock'); // Navigue vers la route du stock
        break;
      case 2:
        context.go('/caisse'); // Navigue vers la route de la caisse
        break;
      case 3:
        context.go('/immo'); // Navigue vers la route immo
        break;
      case 4:
        context.go('/menu'); // Navigue vers la route du menu
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // L'AppBar est maintenant supprimée d'ici pour être gérée par chaque page enfant si nécessaire.
      // Cela offre plus de flexibilité. Si vous voulez une AppBar commune, vous pouvez la garder.
      body: child, // 👈 4. Le corps du Scaffold est maintenant le widget enfant
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Stock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale_outlined),
            activeIcon: Icon(Icons.point_of_sale),
            label: 'Caisse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_outlined),
            activeIcon: Icon(Icons.business),
            label: 'Immo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_outlined),
            activeIcon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),

        // --- Styles (inchangés) ---
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme
            .of(context)
            .primaryColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        showUnselectedLabels: true,
      ),
    );
  }
}