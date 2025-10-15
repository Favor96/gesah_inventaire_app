import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gesah_inventaire_app/utils/app_theme.dart';

class CreerInventaireImmoPage extends StatefulWidget {
  const CreerInventaireImmoPage({Key? key}) : super(key: key);

  @override
  State<CreerInventaireImmoPage> createState() => _CreerInventaireImmoPageState();
}

class _CreerInventaireImmoPageState extends State<CreerInventaireImmoPage> {
  final TextEditingController _dateDebutController = TextEditingController();
  final TextEditingController _dateFinController = TextEditingController();
  final TextEditingController _qteController = TextEditingController();
  final TextEditingController _observationController = TextEditingController();

  String? _selectedClient;
  String? _selectedProduit;

  final List<String> _clients = ['Gesmo & Fils', 'Client 2', 'Client 3'];
  final List<String> _produits = ['Produit 1', 'Produit 2', 'Produit 3'];

  // Liste des lignes de produits
  List<Map<String, dynamic>> _productLines = [];

  void _addProductLine() {
    setState(() {
      _productLines.add({
        'produit': null,
        'qte': '',
        'observation': '',
      });
    });
  }

  void _removeProductLine(int index) {
    setState(() {
      _productLines.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        controller.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  void _saveInventory() {
    // Logique pour enregistrer l'inventaire
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Inventaire enregistré avec succès'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Creer un inventaire d\'immobilisation',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Client
            const Text(
              'Client',
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
            const SizedBox(height: 24),

            // Date debut et Date fin
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date debut',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.inputLabel,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _dateDebutController,
                        readOnly: true,
                        onTap: () => _selectDate(context, _dateDebutController),
                        decoration: InputDecoration(
                          hintText: 'JJ/MM/AAAA',
                          filled: true,
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputText,
                              fontWeight: FontWeight.w600
                          ),
                          labelStyle: TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputText,
                              fontWeight: FontWeight.w600
                          ),
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
                            borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          suffixIcon: const Icon(Icons.calendar_today, size: 20),
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
                        'Date fin',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.inputLabel,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _dateFinController,
                        readOnly: true,
                        onTap: () => _selectDate(context, _dateFinController),
                        decoration: InputDecoration(
                          hintText: 'JJ/MM/AAAA',
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputText,
                              fontWeight: FontWeight.w600
                          ),
                          labelStyle: TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputText,
                              fontWeight: FontWeight.w600
                          ),
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
                            borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          suffixIcon: const Icon(Icons.calendar_today, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Produit, Qte, Observation
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Produit',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.inputLabel,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownSearch<String>(
                        items: (filter, infiniteScrollProps) {
                          return _produits;
                        },
                        selectedItem: _selectedProduit,
                        popupProps: const PopupProps.menu(
                          showSearchBox: true, // permet de chercher dans la liste
                          fit: FlexFit.loose,
                        ),
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                            hintText: 'Selectionner',
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
                            _selectedProduit = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Qte',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.inputLabel,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _qteController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '0',
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputText,
                              fontWeight: FontWeight.w600
                          ),
                          labelStyle: TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputText,
                              fontWeight: FontWeight.w600
                          ),
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
                            borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Observation',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.inputLabel,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _observationController,
                        decoration: InputDecoration(
                          hintText: 'Note',
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputText,
                              fontWeight: FontWeight.w600
                          ),
                          labelStyle: TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputText,
                              fontWeight: FontWeight.w600
                          ),
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
                            borderSide: const BorderSide(color: Color(0xFF3B82F6)),
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
            ...List.generate(_productLines.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child:  DropdownSearch<String>(
                        items: (filter, infiniteScrollProps) {
                          return _produits;
                        },
                        selectedItem: _selectedProduit,
                        popupProps: const PopupProps.menu(
                          showSearchBox: true, // permet de chercher dans la liste
                          fit: FlexFit.loose,
                        ),
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                            hintText: 'Selectionner',
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
                            _selectedProduit = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Qte',
                          filled: true,
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputText,
                              fontWeight: FontWeight.w600
                          ),
                          labelStyle: TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputText,
                              fontWeight: FontWeight.w600
                          ),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        onChanged: (value) {
                          _productLines[index]['qte'] = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Observation',
                          filled: true,
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputText,
                              fontWeight: FontWeight.w600
                          ),
                          labelStyle: TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputText,
                              fontWeight: FontWeight.w600
                          ),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        onChanged: (value) {
                          _productLines[index]['observation'] = value;
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeProductLine(index),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),
            // Bouton Ajouter une ligne
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _addProductLine,
                child: const Text(
                  'Ajouter une ligne',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3B82F6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Lignes de produits ajoutées dynamiquement


            const SizedBox(height: 40),

            // Bouton Enregistrer
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveInventory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Enregistrer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dateDebutController.dispose();
    _dateFinController.dispose();
    _qteController.dispose();
    _observationController.dispose();
    super.dispose();
  }
}