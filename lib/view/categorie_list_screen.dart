import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryProductPage extends StatefulWidget {
  const CategoryProductPage({Key? key}) : super(key: key);

  @override
  State<CategoryProductPage> createState() => _CategoryProductPageState();
}

class _CategoryProductPageState extends State<CategoryProductPage> {
  List<Map<String, dynamic>> products = [
    {
      'name': 'Macbook Pro 16 inch (2020) For Sale',
      'code': 'BA9212320',
      'id': '1374',
      'status': 'Status',
      'nom': '4517 Washington Ave. Manchester...',
      'selected': false,
    },
  ];

  bool selectAll = false;
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleSelectAll() {
    setState(() {
      selectAll = !selectAll;
      for (var product in products) {
        product['selected'] = selectAll;
      }
    });
  }

  void _toggleProduct(int index) {
    setState(() {
      products[index]['selected'] = !products[index]['selected'];
      selectAll = products.every((product) => product['selected']);
    });
  }

  void _addProduct() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Indicateur de drag
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Titre
              const Text(
                'Ajouter une catégorie',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              // Champ Nom
              TextField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),

              // Champ Description
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 24),

              // Boutons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _nomController.clear();
                        _descriptionController.clear();
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Annuler',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_nomController.text.isNotEmpty) {
                          // Ajoutez ici la logique pour sauvegarder
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Catégorie "${_nomController.text}" ajoutée'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          _nomController.clear();
                          _descriptionController.clear();
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF3B82F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Ajouter',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _shareProducts() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Partager les produits sélectionnés')),
    );
  }

  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Voulez-vous supprimer les produits sélectionnés ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                products.removeWhere((product) => product['selected']);
                selectAll = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Produits supprimés')),
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
    int selectedCount = products.where((p) => p['selected']).length;

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
          'Catégorie de produit',
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
            onPressed: _addProduct,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Barre d'actions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${products.length} of 64 results',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      onPressed: selectedCount > 0 ? _shareProducts : null,
                      iconSize: 24,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: selectedCount > 0 ? _deleteSelected : null,
                      iconSize: 24,
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _toggleSelectAll,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: selectAll ? const Color(0xFF3B82F6) : Colors.transparent,
                          border: Border.all(
                            color: selectAll ? const Color(0xFF3B82F6) : Colors.grey[400]!,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: selectAll
                            ? const Icon(Icons.check, color: Colors.white, size: 18)
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Liste des produits
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: products.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(
                  name: product['name'],
                  code: product['code'],
                  id: product['id'],
                  status: product['status'],
                  nom: product['nom'],
                  isSelected: product['selected'],
                  onTap: () => _toggleProduct(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required String name,
    required String code,
    required String id,
    required String status,
    required String nom,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF3B82F6) : Colors.grey[200]!,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  code,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                _buildInfoRow('ID', id),
                const SizedBox(height: 12),
                _buildInfoRow('Status', status, isStatus: true),
                const SizedBox(height: 12),
                _buildInfoRow('Nom', nom),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
                border: Border.all(
                  color: isSelected ? const Color(0xFF3B82F6) : Colors.grey[400]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
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
            : Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}