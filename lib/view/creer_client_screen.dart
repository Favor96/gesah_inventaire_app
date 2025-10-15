import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppTheme {
  static const Color inputLabel = Color(0xFF6B7280);
  static const Color inputText = Color(0xFF374151);
}

class AjouterClientPage extends StatefulWidget {
  const AjouterClientPage({Key? key}) : super(key: key);

  @override
  State<AjouterClientPage> createState() => _AjouterClientPageState();
}

class _AjouterClientPageState extends State<AjouterClientPage> {
  final TextEditingController _raisonSocialController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();

  String? _selectedSecteur;
  String? _selectedRegime;
  String? _selectedIrccm;

  final List<String> _secteurs = [
    'Commerce',
    'Services',
    'Industrie',
    'Agriculture',
    'Technologie'
  ];

  final List<String> _regimes = [
    'Réel Normal',
    'Réel Simplifié',
    'Micro-entreprise',
    'Auto-entrepreneur'
  ];

  final List<String> _irccms = [
    'IRCCM 1',
    'IRCCM 2',
    'IRCCM 3',
    'IRCCM 4'
  ];

  void _saveClient() {
    if (_raisonSocialController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir la raison sociale'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Client enregistré avec succès'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
    context.pop();
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
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Ajouter un client',
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
            // Raison social
            const Text(
              'Raison social',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.inputLabel,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _raisonSocialController,
              decoration: InputDecoration(
                hintText: 'Entrez la raison sociale',
                filled: true,
                fillColor: Colors.white,
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.inputText,
                  fontWeight: FontWeight.w400,
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
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),

            // Secteur d'activité
            const Text(
              'Secteur d\'activité',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.inputLabel,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            DropdownSearch<String>(
              items: (filter, infiniteScrollProps) {
                return _secteurs;
              },
              selectedItem: _selectedSecteur,
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                fit: FlexFit.loose,
              ),
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: 'Sélectionner',
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.inputText,
                    fontWeight: FontWeight.w600,
                  ),
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.inputText,
                    fontWeight: FontWeight.w400,
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
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSecteur = newValue;
                });
              },
            ),
            const SizedBox(height: 24),

            // Regime fiscale
            const Text(
              'Regime fiscale',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.inputLabel,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            DropdownSearch<String>(
              items: (filter, infiniteScrollProps) {
                return _regimes;
              },
              selectedItem: _selectedRegime,
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                fit: FlexFit.loose,
              ),
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: 'Sélectionner',
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.inputText,
                    fontWeight: FontWeight.w600,
                  ),
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.inputText,
                    fontWeight: FontWeight.w400,
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
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRegime = newValue;
                });
              },
            ),
            const SizedBox(height: 24),

            // Telephone
            const Text(
              'Telephone',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.inputLabel,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            DropdownSearch<String>(
              items: (filter, infiniteScrollProps) {
                return ['+228', '+33', '+1', '+44', '+91'];
              },
              selectedItem: '+228',
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                fit: FlexFit.loose,
              ),
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: 'Sélectionner',
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.inputText,
                    fontWeight: FontWeight.w600,
                  ),
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.inputText,
                    fontWeight: FontWeight.w400,
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
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              onChanged: (String? newValue) {
                // Gérer le changement
              },
            ),
            const SizedBox(height: 24),

            // Irccm
            const Text(
              'Irccm',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.inputLabel,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            DropdownSearch<String>(
              items: (filter, infiniteScrollProps) {
                return _irccms;
              },
              selectedItem: _selectedIrccm,
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                fit: FlexFit.loose,
              ),
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: 'Sélectionner',
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.inputText,
                    fontWeight: FontWeight.w600,
                  ),
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.inputText,
                    fontWeight: FontWeight.w400,
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
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedIrccm = newValue;
                });
              },
            ),
            const SizedBox(height: 40),

            // Bouton Enregistrer
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveClient,
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
    _raisonSocialController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }
}