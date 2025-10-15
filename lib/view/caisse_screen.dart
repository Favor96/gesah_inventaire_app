import 'package:flutter/material.dart';
import 'package:gesah_inventaire_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class CaisseScreen extends StatefulWidget {
  const CaisseScreen({Key? key}) : super(key: key);

  @override
  State<CaisseScreen> createState() => _CaisseScreenState();
}

class _CaisseScreenState extends State<CaisseScreen> {

  List<Map<String, dynamic>> inventories = [
    {
      'inventoryNumber': 'Inv-000-2025',
      'clientName': 'Gesmo é Fils',
      'manager': 'Abbey Favor',
      'dateRange': '11 frv 2025 - 13 fev 2025',
      'status': 'En cours',
    },
    {
      'inventoryNumber': 'Inv-000-2025',
      'clientName': 'Gesmo é Fils',
      'manager': 'Koussa Mathias',
      'dateRange': '11 frv 2025 - 13 fev 2025',
      'status': 'En cours',
    },
    {
      'inventoryNumber': 'Inv-000-2025',
      'clientName': 'Gesmo é Fils',
      'manager': 'Koussa Mathias',
      'dateRange': '11 frv 2025 - 13 fev 2025',
      'status': 'En cours',
    },
  ];

  void _addNewInventory() {
    setState(() {
      inventories.add({
        'inventoryNumber': 'Inv-00${inventories.length + 1}-2025',
        'clientName': 'Nouveau Client',
        'manager': 'Manager',
        'dateRange': '11 frv 2025 - 13 fev 2025',
        'status': 'En cours',
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nouvel inventaire ajouté'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _viewDetails(int index) {
    // Navigation vers les détails
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(inventories[index]['inventoryNumber']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client: ${inventories[index]['clientName']}'),
            const SizedBox(height: 8),
            Text('Géré par: ${inventories[index]['manager']}'),
            const SizedBox(height: 8),
            Text('Période: ${inventories[index]['dateRange']}'),
            const SizedBox(height: 8),
            Text('Statut: ${inventories[index]['status']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
       automaticallyImplyLeading: false,

        title: const Text(
          'Inventaire de caisse',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 15,
              ),
            ),
            onPressed: () => context.pushNamed('inventaire-caisse'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: inventories.isEmpty
          ? const Center(
        child: Text(
          'Aucun inventaire disponible',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: inventories.length,
        itemBuilder: (context, index) {
          final inventory = inventories[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildInventoryCard(
              inventoryNumber: inventory['inventoryNumber'],
              clientName: inventory['clientName'],
              manager: inventory['manager'],
              dateRange: inventory['dateRange'],
              status: inventory['status'],
              onDetailsTap: () => _viewDetails(index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInventoryCard({
    required String inventoryNumber,
    required String clientName,
    required String manager,
    required String dateRange,
    required String status,
    required VoidCallback onDetailsTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo entreprise
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                Icons.business,
                color: Colors.grey[700],
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Informations
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      inventoryNumber,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: status == 'En cours'
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Client : $clientName',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Géré par : $manager',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateRange,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: onDetailsTap,
                      child: Row(
                        children: [
                          Text(
                            'Détails',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            size: 18,
                            color: Colors.blue[700],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}