import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
   automaticallyImplyLeading: false,
        title: const Text(
          'Mon compte',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Section Profil
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/avatar.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Nom et rôle
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ABBEY Favor',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Agent',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 30.0),
              child: const Divider(height: 1, thickness: 0,color: Colors.grey,),
            ),
            const SizedBox(height: 20),

            // Grille de cartes - Ligne 1
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMenuCard(
                      icon: Icons.people,
                      iconColor: const Color(0xFF7C3AED),
                      label: 'Clients',
                      onTap: () {
                        context.pushNamed('client-list');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMenuCard(
                      icon: Icons.people,
                      iconColor: const Color(0xFF7C3AED),
                      label: 'Agents',
                      onTap: () {
                        context.pushNamed('agent-list');
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Grille de cartes - Ligne 2
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMenuCard(
                      icon: Icons.grid_view,
                      iconColor: const Color(0xFFEF4444),
                      label: 'Categorie produit',
                      onTap: () {
                       context.pushNamed('category-list');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMenuCard(
                      icon: Icons.description_outlined,
                      iconColor: Colors.black,
                      label: 'Rapports des inventaires',
                      onTap: () {
                        // Navigation vers Rapports
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Grille de cartes - Ligne 3
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMenuCard(
                      icon: Icons.shopping_bag,
                      iconColor: Colors.black,
                      label: 'Produit',
                      onTap: () {
                        context.pushNamed('product-list');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMenuCard(
                      icon: Icons.shopping_cart_outlined,
                      iconColor: Colors.black,
                      label: 'Achat',
                      onTap: () {
                        context.pushNamed('achat-list');
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Grille de cartes - Ligne 4
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMenuCard(
                      icon: Icons.attach_money,
                      iconColor: Colors.black,
                      label: 'Vente',
                      onTap: () {
                        context.pushNamed('vente-list');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMenuCard(
                      icon: Icons.apartment,
                      iconColor: Colors.black,
                      label: 'Immobilisation',
                      onTap: () {
                        context.pushNamed('immobilisation-list');
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Liste des paramètres
            _buildSettingItem(
              icon: Icons.person_outline,
              label: 'Informations personnelles',
              onTap: () {
                // Navigation vers Informations personnelles
              },
            ),
            const SizedBox(height: 8),
            _buildSettingItem(
              icon: Icons.settings_outlined,
              label: 'Paramètre',
              onTap: () {
                // Navigation vers Paramètres
              },
            ),
            const SizedBox(height: 8),
            _buildSettingItem(
              icon: Icons.lock_outline,
              label: 'Mot de passe',
              onTap: () {
                // Navigation vers Mot de passe
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.black,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.black,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}