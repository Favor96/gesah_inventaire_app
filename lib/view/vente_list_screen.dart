import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gesah_inventaire_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class VentePage extends StatefulWidget {
  const VentePage({Key? key}) : super(key: key);

  @override
  State<VentePage> createState() => _VentePageState();
}

class _VentePageState extends State<VentePage> {
  List<Map<String, dynamic>> ventes = [
    {
      'id': '1',
      'numero_vente': 'VEN-2024-001',
      'client': 'Client A',
      'client_id': '1',
      'date_vente': '2024-01-15',
      'statut': 'payee',
      'montant_total': 150000,
      'lignes': [
        {
          'produit': 'Ordinateur portable',
          'package': 'Unité',
          'quantite': 3,
          'prix_unitaire': 50000,
          'montant_ligne': 150000,
        },
      ],
    },
    {
      'id': '2',
      'numero_vente': 'VEN-2024-002',
      'client': 'Client B',
      'client_id': '2',
      'date_vente': '2024-01-16',
      'statut': 'en_attente',
      'montant_total': 75000,
      'lignes': [
        {
          'produit': 'Clavier',
          'package': 'Unité',
          'quantite': 5,
          'prix_unitaire': 15000,
          'montant_ligne': 75000,
        },
      ],
    },
    {
      'id': '3',
      'numero_vente': 'VEN-2024-003',
      'client': 'Client C',
      'client_id': '3',
      'date_vente': '2024-01-17',
      'statut': 'annule',
      'montant_total': 200000,
      'lignes': [
        {
          'produit': 'Écran 27"',
          'package': 'Unité',
          'quantite': 4,
          'prix_unitaire': 50000,
          'montant_ligne': 200000,
        },
      ],
    },
  ];
  final List<String> _produitPackage = [
    'Macbook Pro 16-inch - 16GB RAM / 1TB SSD',
    'iPhone 14 Pro - 128GB',
    'Samsung Galaxy S23 - 256GB',
    'Dell XPS 13 - 16GB RAM / 512GB SSD',
    'Canon EOS R6 Camera',
    'Sony WH-1000XM5 Headphones',
    'Apple Watch Series 9',
    'iPad Pro 12.9-inch',
    'Logitech MX Master 3 Mouse',
    'HP Envy 13 Laptop',
  ];
  String? _selectedClient;
  String? _selectProduitPackage;
  final List<String> _clients = ['Gesmo & Fils', 'Client 2', 'Client 3'];
  List<Map<String, dynamic>> productRow = [];
  String? _selectedStatut;
  final List<String> _statuts = ['en_attente', 'payee', 'annule'];

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'fr_FR');
    return '${formatter.format(amount)} CFA';
  }
  void _clearForm() {
  }
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  String _formatDate(String date) {
    final dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  Color _getStatutColor(String statut) {
    switch (statut) {
      case 'payee':
        return const Color(0xFF10B981);
      case 'en_attente':
        return const Color(0xFFF59E0B);
      case 'annule':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  Color _getStatutBgColor(String statut) {
    switch (statut) {
      case 'payee':
        return const Color(0xFFD1FAE5);
      case 'en_attente':
        return const Color(0xFFFEF3C7);
      case 'annule':
        return const Color(0xFFFEE2E2);
      default:
        return Colors.grey[200]!;
    }
  }

  String _getStatutLabel(String statut) {
    switch (statut) {
      case 'payee':
        return 'Payée';
      case 'en_attente':
        return 'En attente';
      case 'annule':
        return 'Annulée';
      default:
        return statut;
    }
  }

  void _addVente() {
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
                            'Nouvelle vente',
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
                         Text(
                          'Client *',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.inputLabel,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                      DropdownSearch<String>(
                        items: (filter, infiniteScrollProps) {
                          return _clients;
                        },
                        selectedItem: _selectedClient,
                        popupProps: const PopupProps.menu(
                          showSearchBox: true, // permet de chercher dans la liste
                          fit: FlexFit.loose,
                        ),
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                            hintText: 'Gesmo & Fils',
                            filled: true,
                            fillColor: Colors.white,
                            labelStyle: TextStyle(  fontSize: 16,
                                color: AppTheme.inputText,
                                fontWeight: FontWeight.w600),
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: AppTheme.inputText,
                                fontWeight: FontWeight.w600
                            ),
                            contentPadding: const EdgeInsets.all(16),
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
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedClient = newValue;
                          });
                        },
                      ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Date *',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () async {
                                      final DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: _selectedDate ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          _selectedDate = pickedDate;
                                          _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                        });
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: TextField(
                                        controller: _dateController,
                                        decoration: InputDecoration(
                                          hintText: 'Sélectionner une date',
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
                                            borderSide: BorderSide(color: Colors.grey.shade300),
                                          ),
                                          contentPadding: const EdgeInsets.all(16),
                                          suffixIcon: const Icon(Icons.calendar_today),
                                        ),
                                        readOnly: true,
                                      ),
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
                                    'Status *',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  DropdownButtonFormField<String>(
                                    value: _selectedStatut,
                                    decoration:  InputDecoration(
                                      hintText: 'Selectionnez un status',
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelStyle: TextStyle(  fontSize: 16,
                                          color: AppTheme.inputText,
                                          fontWeight: FontWeight.w600),
                                      hintStyle: TextStyle(
                                          fontSize: 10,
                                          color: AppTheme.inputText,
                                          fontWeight: FontWeight.w600
                                      ),
                                      contentPadding: const EdgeInsets.all(16),
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
                                    items: _statuts.map((status) {
                                      return DropdownMenuItem<String>(
                                        value: status,
                                        child: Text(
                                          status == 'en_attente'
                                              ? 'En attente'
                                              : status == 'payee'
                                              ? 'Payée'
                                              : 'Annulée',
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedStatut = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Section Packages
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Produit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                setModalState(() {
                                  productRow.add({
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
                        ...productRow.asMap().entries.map((entry) {
                          int index = entry.key;
                          var package = entry.value;
                          return _buildPackageCard(
                            index: index,
                            package: package,
                            onRemove: () {
                              setModalState(() {

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
                          onPressed: () => (),
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
                'Produit ${index + 1}',
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
                child:    DropdownSearch<String>(
                  items: (filter, infiniteScrollProps) {
                    return _produitPackage;
                  },
                  selectedItem: _selectProduitPackage,
                  popupProps: const PopupProps.menu(
                    showSearchBox: true, // permet de chercher dans la liste
                    fit: FlexFit.loose,
                  ),
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      hintText: 'Gesmo & Fils',
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(  fontSize: 16,
                          color: AppTheme.inputText,
                          fontWeight: FontWeight.w600),
                      hintStyle: TextStyle(
                          fontSize: 16,
                          color: AppTheme.inputText,
                          fontWeight: FontWeight.w600
                      ),
                      contentPadding: const EdgeInsets.all(16),
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
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectProduitPackage = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: package['prix'],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantité',
                    hintText: '0',
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
        ],
      ),
    );
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
                leading: const Icon(Icons.calendar_today),
                title: const Text('Trier par date'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Trier par montant'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text('Filtrer par statut'),
                onTap: () {
                  _showStatutFilter();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStatutFilter() {
    Navigator.pop(context);
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
              const Text(
                'Filtrer par statut',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.check_circle, color: _getStatutColor('payee')),
                title: const Text('Payée'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.access_time, color: _getStatutColor('en_attente')),
                title: const Text('En attente'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel, color: _getStatutColor('annule')),
                title: const Text('Annulée'),
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

  void _editVente(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Modifier ${ventes[index]['numero_vente']}')),
    );
  }

  void _deleteVente(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la vente'),
        content: Text('Voulez-vous supprimer la vente ${ventes[index]['numero_vente']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                ventes.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vente supprimée')),
              );
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _changeStatut(int index) {
    final currentStatut = ventes[index]['statut'];
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
              const Text(
                'Changer le statut',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.check_circle, color: _getStatutColor('payee')),
                title: const Text('Payée'),
                trailing: currentStatut == 'payee'
                    ? const Icon(Icons.check, color: Color(0xFF10B981))
                    : null,
                onTap: () {
                  setState(() {
                    ventes[index]['statut'] = 'payee';
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Statut mis à jour')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.access_time, color: _getStatutColor('en_attente')),
                title: const Text('En attente'),
                trailing: currentStatut == 'en_attente'
                    ? const Icon(Icons.check, color: Color(0xFFF59E0B))
                    : null,
                onTap: () {
                  setState(() {
                    ventes[index]['statut'] = 'en_attente';
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Statut mis à jour')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel, color: _getStatutColor('annule')),
                title: const Text('Annulée'),
                trailing: currentStatut == 'annule'
                    ? const Icon(Icons.check, color: Color(0xFFEF4444))
                    : null,
                onTap: () {
                  setState(() {
                    ventes[index]['statut'] = 'annule';
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Statut mis à jour')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showVenteDetails(Map<String, dynamic> vente) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
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
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Détails de la vente',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailSection('Informations générales', [
                      _buildDetailRow('N° Vente', vente['numero_vente']),
                      _buildDetailRow('Client', vente['client']),
                      _buildDetailRow('Date de vente', _formatDate(vente['date_vente'])),
                      _buildDetailRowWithBadge('Statut', vente['statut']),
                    ]),
                    const SizedBox(height: 20),
                    _buildDetailSection('Montant', [
                      _buildDetailRow('Montant Total', _formatCurrency(vente['montant_total'].toDouble()),
                          isBold: true),
                    ]),
                    const SizedBox(height: 20),
                    _buildLignesSection(vente['lignes']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithBadge(String label, String statut) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatutBgColor(statut),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getStatutLabel(statut),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _getStatutColor(statut),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLignesSection(List<dynamic> lignes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lignes de vente (${lignes.length})',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...lignes.map((ligne) => _buildLigneItem(ligne)).toList(),
      ],
    );
  }

  Widget _buildLigneItem(Map<String, dynamic> ligne) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              Expanded(
                child: Text(
                  ligne['produit'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                _formatCurrency(ligne['montant_ligne'].toDouble()),
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
                child: Text(
                  'Package: ${ligne['package']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Text(
                'Qté: ${ligne['quantite']} × ${_formatCurrency(ligne['prix_unitaire'].toDouble())}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
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
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Ventes',
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
            onPressed: _addVente,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Barre de filtres et statistiques
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${ventes.length} vente(s)',
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

          // Liste des ventes
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: ventes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final vente = ventes[index];
                return _buildVenteCard(
                  index: index,
                  numeroVente: vente['numero_vente'],
                  client: vente['client'],
                  dateVente: vente['date_vente'],
                  statut: vente['statut'],
                  montantTotal: vente['montant_total'].toDouble(),
                  nombreLignes: (vente['lignes'] as List).length,
                  onEdit: () => _editVente(index),
                  onDelete: () => _deleteVente(index),
                  onTap: () => _showVenteDetails(vente),
                  onStatutTap: () => _changeStatut(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVenteCard({
    required int index,
    required String numeroVente,
    required String client,
    required String dateVente,
    required String statut,
    required double montantTotal,
    required int nombreLignes,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required VoidCallback onTap,
    required VoidCallback onStatutTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec numéro vente et actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        numeroVente,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        client,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: onEdit,
                      color: const Color(0xFF3B82F6),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: onDelete,
                      color: Colors.red[400],
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Informations principales
            _buildInfoRow('Date de vente', _formatDate(dateVente)),
            const SizedBox(height: 12),
            _buildInfoRowWithStatut('Statut', statut, onStatutTap),
            const SizedBox(height: 12),
            _buildInfoRow('Montant Total', _formatCurrency(montantTotal), isMontant: true),
            const SizedBox(height: 16),

            // Badge nombre de lignes
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.list_alt,
                    size: 16,
                    color: Colors.blue[700],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$nombreLignes ligne(s)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isMontant = false}) {
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
        Text(
          value,
          style: TextStyle(
            fontSize: isMontant ? 16 : 15,
            fontWeight: isMontant ? FontWeight.bold : FontWeight.w500,
            color: isMontant ? const Color(0xFF3B82F6) : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowWithStatut(String label, String statut, VoidCallback onTap) {
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
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: _getStatutBgColor(statut),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getStatutLabel(statut),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getStatutColor(statut),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_drop_down,
                  size: 18,
                  color: _getStatutColor(statut),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}