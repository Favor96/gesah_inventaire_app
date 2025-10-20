import 'package:flutter/material.dart';
import 'package:gesah_inventaire_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Map<String, dynamic>> products = [
    {
      'name': 'Macbook Pro 16-inch (2020) For Sale',
      'code': 'BA9212320',
      'id': '1374',
      'categoryName': 'Ordinateurs',
      'unitPrice': '950000', // Exemple
      'uniteMesure': 'Pièce',
      'description': 'Ordinateur portable haut de gamme avec processeur Intel Core i9.',
      'packages': [
        {
          'unite_mesure': 'Pièce',
          'prix': '950000',
          'stock_actuel': 10,
          'stock_minimum': 2,
          'description': 'Modèle avec 16Go RAM et 1To SSD',
        },
      ],
      'selected': false,
    },
  ];


  bool selectAll = false;

  // Controllers pour le formulaire
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _codeProduitController = TextEditingController();
  final TextEditingController _prixUnitaireController = TextEditingController();
  final TextEditingController _uniteMesureController = TextEditingController();

  // Liste des catégories (à remplacer par vos données réelles)
  List<Map<String, dynamic>> categories = [
    {'id': '1', 'nom': 'Électronique'},
    {'id': '2', 'nom': 'Alimentaire'},
    {'id': '3', 'nom': 'Vêtements'},
  ];

  String? selectedCategoryId;
  List<Map<String, dynamic>> packages = [];

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    _codeProduitController.dispose();
    _prixUnitaireController.dispose();
    _uniteMesureController.dispose();
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
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
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
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Ajouter un produit',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _clearForm();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Formulaire scrollable
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Catégorie
                        const Text(
                          'Catégorie *',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.inputLabel,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: selectedCategoryId,
                          decoration: InputDecoration(
                            hintText: 'Sélectionner une catégorie',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:  BorderSide(color:  Colors.grey.shade300),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          items: categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category['id'],
                              child: Text(category['nom']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setModalState(() {
                              selectedCategoryId = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Nom
                        const Text(
                          'Nom du produit *',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.inputLabel,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nomController,
                          decoration: InputDecoration(
                            hintText: 'Ex: Macbook Pro 16"',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:  BorderSide(color:  Colors.grey.shade300),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Code produit
                        const Text(
                          'Code produit *',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.inputLabel,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _codeProduitController,
                          decoration: InputDecoration(
                            hintText: 'Ex: BA9212320',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:  BorderSide(color:  Colors.grey.shade300),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Prix unitaire et Unité de mesure
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Prix unitaire *',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _prixUnitaireController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: '0.00',
                                      prefixText: 'CFA ',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:  BorderSide(color:  Colors.grey.shade300),
                                      ),
                                      contentPadding: const EdgeInsets.all(16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Unité *',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _uniteMesureController,
                                    decoration: InputDecoration(
                                      hintText: 'Ex: unité, kg',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:  BorderSide(color:  Colors.grey.shade300),
                                      ),
                                      contentPadding: const EdgeInsets.all(16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Description
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.inputLabel,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 4,
                          decoration:InputDecoration(
                            hintText: 'Description du produit...',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:  BorderSide(color:  Colors.grey.shade300),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Section Packages
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Packages (optionnel)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                setModalState(() {
                                  packages.add({
                                    'unite_mesure': TextEditingController(),
                                    'prix': TextEditingController(),
                                    'stock_minimum': TextEditingController(),
                                    'stock_actuel': TextEditingController(),
                                    'description': TextEditingController(),
                                  });
                                });
                              },
                              icon: const Icon(Icons.add, size: 20),
                              label: const Text('Ajouter'),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF3B82F6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Liste des packages
                        ...packages.asMap().entries.map((entry) {
                          int index = entry.key;
                          var package = entry.value;
                          return _buildPackageCard(
                            index: index,
                            package: package,
                            onRemove: () {
                              setModalState(() {
                                // Dispose des controllers
                                package['unite_mesure'].dispose();
                                package['prix'].dispose();
                                package['stock_minimum'].dispose();
                                package['stock_actuel'].dispose();
                                package['description'].dispose();
                                packages.removeAt(index);
                              });
                            },
                          );
                        }).toList(),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Boutons d'action
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _clearForm();
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
                          onPressed: () => _submitForm(context),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPackageCard({
    required int index,
    required Map<String, dynamic> package,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Package ${index + 1}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                onPressed: onRemove,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: package['unite_mesure'],
                  decoration: InputDecoration(
                    hintText: 'Ex: unité, kg',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:  BorderSide(color:  Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: package['prix'],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Prix *',
                    hintText: '0.00',
                    prefixText: 'CFA ',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:  BorderSide(color:  Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: package['stock_minimum'],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Stock minimum',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:  BorderSide(color:  Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: package['stock_actuel'],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Stock actuel',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:  BorderSide(color:  Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: package['description'],
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Description',
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:  BorderSide(color:  Colors.grey.shade300),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm(BuildContext context) {
    // Validation
    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une catégorie'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_nomController.text.isEmpty ||
        _codeProduitController.text.isEmpty ||
        _prixUnitaireController.text.isEmpty ||
        _uniteMesureController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs obligatoires'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Construire les données
    Map<String, dynamic> productData = {
      'categorie_id': selectedCategoryId,
      'nom': _nomController.text,
      'description': _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
      'code_produit': _codeProduitController.text,
      'prix_unitaire': double.tryParse(_prixUnitaireController.text) ?? 0,
      'unite_mesure': _uniteMesureController.text,
      'packages': packages.map((pkg) {
        return {
          'unite_mesure': pkg['unite_mesure'].text,
          'prix': double.tryParse(pkg['prix'].text) ?? 0,
          'stock_minimum': pkg['stock_minimum'].text.isNotEmpty
              ? int.tryParse(pkg['stock_minimum'].text)
              : null,
          'stock_actuel': pkg['stock_actuel'].text.isNotEmpty
              ? int.tryParse(pkg['stock_actuel'].text)
              : null,
          'description': pkg['description'].text.isNotEmpty
              ? pkg['description'].text
              : null,
        };
      }).toList(),
    };

    // TODO: Envoyer au backend
    print('Product Data: $productData');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Produit "${_nomController.text}" ajouté avec succès'),
        backgroundColor: Colors.green,
      ),
    );

    _clearForm();
    Navigator.pop(context);
  }

  void _clearForm() {
    _nomController.clear();
    _descriptionController.clear();
    _codeProduitController.clear();
    _prixUnitaireController.clear();
    _uniteMesureController.clear();
    selectedCategoryId = null;

    // Dispose et clear des packages
    for (var pkg in packages) {
      pkg['unite_mesure'].dispose();
      pkg['prix'].dispose();
      pkg['stock_minimum'].dispose();
      pkg['stock_actuel'].dispose();
      pkg['description'].dispose();
    }
    packages.clear();
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
          'Produits',
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
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: products.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final product = products[index] as Map<String, dynamic>;

                // Récupérations avec fallback sur plusieurs clés possibles
                final name = (product['name'] ?? product['nom'] ?? '') as String;
                final code = (product['code'] ?? product['reference'] ?? '') as String;
                final id = (product['id'] ?? product['product_id'] ?? '')?.toString() ?? '';
                final categoryName = (product['categoryName'] ??
                    product['categorie'] ??
                    product['category'] ??
                    '') as String;
                final unitPrice = (product['unitPrice'] ??
                    product['prix_unitaire'] ??
                    product['prix'] ??
                    '0')?.toString() ?? '0';
                final uniteMesure = (product['uniteMesure'] ??
                    product['unite_mesure'] ??
                    product['unit'] ??
                    '') as String;
                final description = (product['description'] ??
                    product['desc'] ??
                    product['detail']) as String?;
                final packages = (product['packages'] ??
                    product['packets'] ??
                    product['variants']) as List<dynamic>?;

                final isSelected = (product['selected'] ?? product['isSelected'] ?? false) as bool;

                return _buildProductCard(
                  name: name,
                  code: code,
                  id: id,
                  categoryName: categoryName,
                  unitPrice: unitPrice,
                  uniteMesure: uniteMesure,
                  description: description,
                  packages: packages != null
                      ? packages.map<Map<String, dynamic>>((p) {
                    if (p is Map<String, dynamic>) return p;
                    return Map<String, dynamic>.from(p as Map);
                  }).toList()
                      : null,
                  isSelected: isSelected,
                  onTap: () => _toggleProduct(index),
                  onEdit: () => {},
                  onDelete: () => {},
                );
              },

            ),
          ),
        ],
      ),
    );
  }
  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 70, // ajuste la largeur fixe du label selon ton besoin
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: isStatus
              ? _buildStatusBadge(value)
              : Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              status,
              style: TextStyle(
                fontSize: 13,
                color: Colors.red, // see note below about darken
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Retourne une couleur suivant le texte de status.
  /// Ajuste / étends les cas selon tes besoins.
  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('pay') || s.contains('payé') || s.contains('paid')) {
      return const Color(0xFF16A34A); // vert
    } else if (s.contains('encours') || s.contains('en cours') || s.contains('pending')) {
      return const Color(0xFFF59E0B); // orange
    } else if (s.contains('échoué') || s.contains('echec') || s.contains('failed')) {
      return const Color(0xFFEF4444); // rouge
    }
    return const Color(0xFF6B7280); // gris par défaut
  }

  Widget _buildProductCard({
    required String name,
    required String code,
    required String id,
    required String categoryName,
    required String unitPrice,
    required String uniteMesure,
    String? description,
    List<Map<String, dynamic>>? packages,
    required bool isSelected,
    required VoidCallback onTap,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
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
      child: Column(
        children: [
          Row(
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
                    if (description != null && description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    _buildInfoRow('Catégorie', categoryName),
                    const SizedBox(height: 12),
                    _buildInfoRow('Prix', '$unitPrice CFA / $uniteMesure'),
                    const SizedBox(height: 12),
                    _buildInfoRow('ID', id),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onTap,
                child: Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  size: 28,
                  color: isSelected ? const Color(0xFF3B82F6) : Colors.grey[400],
                ),
              ),
            ],
          ),

          // Section Packages
          if (packages != null && packages.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.inventory_2_outlined, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Packages (${packages.length})',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...packages.map((package) => _buildPackageItem(package)).toList(),
          ],
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

  Widget _buildPackageItem(Map<String, dynamic> package) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                package['unite_mesure'] ?? 'N/A',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${package['prix'] ?? '0'} CFA',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B82F6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildPackageInfo(
                  'Stock actuel',
                  package['stock_actuel']?.toString() ?? '0',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPackageInfo(
                  'Stock min',
                  package['stock_minimum']?.toString() ?? '0',
                ),
              ),
            ],
          ),
          if (package['description'] != null &&
              package['description'].toString().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              package['description'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPackageInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
