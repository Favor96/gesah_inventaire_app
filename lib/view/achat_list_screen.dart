import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gesah_inventaire_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AchatPage extends StatefulWidget {
  const AchatPage({Key? key}) : super(key: key);

  @override
  State<AchatPage> createState() => _AchatPageState();
}

class _AchatPageState extends State<AchatPage> {
  List<Map<String, dynamic>> achats = [
    {
      'id': '1',
      'numero_facture': 'ACH-2024-001',
      'fournisseur': 'Fournisseur A',
      'employe_paye': 'Jean Dupont',
      'montant_ht': 100000,
      'montant_tva': 18000,
      'montant_ttc': 118000,
      'date_achat': '2024-01-15',
      'date_paiement': '2024-01-20',
      'mode_paiement': 'Virement',
      'lignes': [
        {
          'produit': 'Ordinateur portable',
          'package': 'Unité',
          'quantite': 2,
          'prix_unitaire': 50000,
          'montant_ligne': 100000,
        },
      ],
    },
    {
      'id': '2',
      'numero_facture': 'ACH-2024-002',
      'fournisseur': 'Fournisseur B',
      'employe_paye': 'Marie Martin',
      'montant_ht': 50000,
      'montant_tva': 9000,
      'montant_ttc': 59000,
      'date_achat': '2024-01-16',
      'date_paiement': '2024-01-25',
      'mode_paiement': 'Espèces',
      'lignes': [
        {
          'produit': 'Clavier',
          'package': 'Unité',
          'quantite': 5,
          'prix_unitaire': 10000,
          'montant_ligne': 50000,
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
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'fr_FR');
    return '${formatter.format(amount)} CFA';
  }

  String _formatDate(String date) {
    final dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  void _addAchat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ajouter un nouvel achat')),
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
                leading: const Icon(Icons.payment),
                title: const Text('Filtrer par mode de paiement'),
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

  void _editAchat(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Modifier ${achats[index]['numero_facture']}')),
    );
  }

  void _deleteAchat(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'achat'),
        content: Text('Voulez-vous supprimer l\'achat ${achats[index]['numero_facture']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                achats.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Achat supprimé')),
              );
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAchatDetails(Map<String, dynamic> achat) {
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
                    'Détails de l\'achat',
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
                      _buildDetailRow('N° Facture', achat['numero_facture']),
                      _buildDetailRow('Fournisseur', achat['fournisseur']),
                      _buildDetailRow('Employé payé', achat['employe_paye']),
                      _buildDetailRow('Date d\'achat', _formatDate(achat['date_achat'])),
                      _buildDetailRow('Date de paiement', _formatDate(achat['date_paiement'])),
                      _buildDetailRow('Mode de paiement', achat['mode_paiement']),
                    ]),
                    const SizedBox(height: 20),
                    _buildDetailSection('Montants', [
                      _buildDetailRow('Montant HT', _formatCurrency(achat['montant_ht'].toDouble())),
                      _buildDetailRow('TVA', _formatCurrency(achat['montant_tva'].toDouble())),
                      _buildDetailRow('Montant TTC', _formatCurrency(achat['montant_ttc'].toDouble()),
                          isBold: true),
                    ]),
                    const SizedBox(height: 20),
                    _buildLignesSection(achat['lignes']),
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

  Widget _buildLignesSection(List<dynamic> lignes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lignes d\'achat (${lignes.length})',
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
          'Achats',
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
            onPressed: _addAchat,
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
                  '${achats.length} achat(s)',
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

          // Liste des achats
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: achats.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final achat = achats[index];
                return _buildAchatCard(
                  numeroFacture: achat['numero_facture'],
                  fournisseur: achat['fournisseur'],
                  employePaye: achat['employe_paye'],
                  montantTTC: achat['montant_ttc'].toDouble(),
                  dateAchat: achat['date_achat'],
                  modePaiement: achat['mode_paiement'],
                  nombreLignes: (achat['lignes'] as List).length,
                  onEdit: () => _editAchat(index),
                  onDelete: () => _deleteAchat(index),
                  onTap: () => _showAchatDetails(achat),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchatCard({
    required String numeroFacture,
    required String fournisseur,
    required String employePaye,
    required double montantTTC,
    required String dateAchat,
    required String modePaiement,
    required int nombreLignes,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required VoidCallback onTap,
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
            // En-tête avec numéro facture et actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        numeroFacture,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        fournisseur,
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
            _buildInfoRow('Employé', employePaye),
            const SizedBox(height: 12),
            _buildInfoRow('Date d\'achat', _formatDate(dateAchat)),
            const SizedBox(height: 12),
            _buildInfoRow('Mode de paiement', modePaiement, isPayment: true),
            const SizedBox(height: 12),
            _buildInfoRow('Montant TTC', _formatCurrency(montantTTC), isMontant: true),
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

  Widget _buildInfoRow(String label, String value, {bool isPayment = false, bool isMontant = false}) {
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
        if (isPayment)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
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
        else
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
}