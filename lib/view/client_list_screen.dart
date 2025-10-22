import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({Key? key}) : super(key: key);

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  List<Map<String, dynamic>> clients = [
    {
      'name': 'Darrell Steward',
      'description': 'Description',
      'status': 'Status',
      'tel': '(684) 555-0102',
      'email': 'nevaeh.simmons@example.com',
      'avatar': 'https://i.pravatar.cc/150?img=1',
    },
    {
      'name': 'Darrell Steward',
      'description': 'Description',
      'status': 'Status',
      'tel': '(684) 555-0102',
      'email': 'nevaeh.simmons@example.com',
      'avatar': 'https://i.pravatar.cc/150?img=2',
    },
  ];

  void _addClient() {
    context.pushNamed('creer-client');
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.sort_by_alpha),
                title: const Text('Trier par nom'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.filter_list),
                title: const Text('Filtrer par statut'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editClient(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Modifier ${clients[index]['name']}')),
    );
  }

  void _deleteClient(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le client'),
        content: Text('Voulez-vous supprimer ${clients[index]['name']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                clients.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Client supprimé')),
              );
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Clients',
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
            onPressed: _addClient,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Barre de filtres
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${clients.length} of 64 results',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                GestureDetector(
                  onTap: _showFilterOptions,
                  child: Icon(
                    Icons.filter_list,
                    color: Colors.grey[700],
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Liste des clients
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: clients.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final client = clients[index];
                return _buildClientCard(
                  name: client['name'],
                  description: client['description'],
                  status: client['status'],
                  tel: client['tel'],
                  email: client['email'],
                  avatar: client['avatar'],
                  onEdit: () => _editClient(index),
                  onDelete: () => _deleteClient(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard({
    required String name,
    required String description,
    required String status,
    required String tel,
    required String email,
    required String avatar,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // En-tête avec avatar et nom
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(avatar),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(
            height: 1,
            thickness: 0.5, // plus fin
            color: Color(0xFFDDDDDD),
          ),
          const SizedBox(height: 16),

          // Informations du client
          _buildInfoRow('Status', status, isStatus: true),
          const SizedBox(height: 12),
          _buildInfoRow('Tel', tel),
          const SizedBox(height: 12),
          _buildInfoRow('Email', email),

          const SizedBox(height: 16),

          // Boutons d'action
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.grey[400],
                  size: 28,
                ),
                onPressed: onDelete,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  color: Colors.grey[400],
                  size: 28,
                ),
                onPressed: onEdit,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
          ),
        ),
        isStatus
            ? Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E5FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7C3AED),
            ),
          ),
        )
            : Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}