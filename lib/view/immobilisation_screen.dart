import 'package:flutter/material.dart';
import 'package:gesah_inventaire_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class Immobilisation {
  final int id;
  final String nom;
  final String? description;
  final String? numeroSerie;
  final double valeurAcquisition;
  final DateTime dateAcquisition;
  final DateTime? dateMiseService;
  final String? etat;
  final String? localisation;
  final String typeNom;
  final List<Affectation> affectations;

  Immobilisation({
    required this.id,
    required this.nom,
    this.description,
    this.numeroSerie,
    required this.valeurAcquisition,
    required this.dateAcquisition,
    this.dateMiseService,
    this.etat,
    this.localisation,
    required this.typeNom,
    this.affectations = const [],
  });

  bool get isAffecte => affectations.isNotEmpty &&
      affectations.any((a) => a.statut == 'En cours');
}

class Affectation {
  final int id;
  final int immobilisationId;
  final int employeId;
  final String employeNom;
  final DateTime dateAffectation;
  final DateTime? dateRetour;
  final String statut;

  Affectation({
    required this.id,
    required this.immobilisationId,
    required this.employeId,
    required this.employeNom,
    required this.dateAffectation,
    this.dateRetour,
    required this.statut,
  });
}

class Employe {
  final int id;
  final String nom;
  final String prenom;
  final String? service;

  Employe({
    required this.id,
    required this.nom,
    required this.prenom,
    this.service,
  });

  String get nomComplet => '$prenom $nom';
}

// Page principale - Liste des immobilisations
class ImmobilisationScreen extends StatefulWidget {
  const ImmobilisationScreen({Key? key}) : super(key: key);

  @override
  State<ImmobilisationScreen> createState() => _ImmobilisationScreenState();
}

class _ImmobilisationScreenState extends State<ImmobilisationScreen> {
  String _searchQuery = '';
  String _filterEtat = 'Tous';
  String _filterAffectation = 'Tous';

  // Données de test
  final List<Immobilisation> immobilisations = [
    Immobilisation(
      id: 1,
      nom: 'MacBook Pro 16"',
      description: 'Ordinateur portable pour développement',
      numeroSerie: 'MBP2024-001',
      valeurAcquisition: 2500000,
      dateAcquisition: DateTime(2024, 1, 15),
      dateMiseService: DateTime(2024, 1, 20),
      etat: 'Bon état',
      localisation: 'Bureau IT - Étage 2',
      typeNom: 'Matériel informatique',
      affectations: [
        Affectation(
          id: 1,
          immobilisationId: 1,
          employeId: 101,
          employeNom: 'Koffi Jean',
          dateAffectation: DateTime(2024, 1, 25),
          statut: 'En cours',
        ),
      ],
    ),
    Immobilisation(
      id: 2,
      nom: 'Imprimante HP LaserJet Pro',
      description: 'Imprimante laser couleur',
      numeroSerie: 'HP-LJ-2024-042',
      valeurAcquisition: 450000,
      dateAcquisition: DateTime(2024, 2, 10),
      dateMiseService: DateTime(2024, 2, 12),
      etat: 'Bon état',
      localisation: 'Bureau Comptabilité',
      typeNom: 'Matériel de bureau',
      affectations: [],
    ),
    Immobilisation(
      id: 3,
      nom: 'iPhone 15 Pro',
      description: 'Smartphone professionnel',
      numeroSerie: 'IPH15-2024-087',
      valeurAcquisition: 800000,
      dateAcquisition: DateTime(2024, 3, 5),
      dateMiseService: DateTime(2024, 3, 6),
      etat: 'Excellent',
      localisation: 'Direction',
      typeNom: 'Matériel informatique',
      affectations: [
        Affectation(
          id: 2,
          immobilisationId: 3,
          employeId: 102,
          employeNom: 'Amavi Marie',
          dateAffectation: DateTime(2024, 3, 10),
          statut: 'En cours',
        ),
      ],
    ),
    Immobilisation(
      id: 4,
      nom: 'Climatiseur LG 18000 BTU',
      description: 'Climatiseur split système',
      numeroSerie: 'LG-AC-2024-012',
      valeurAcquisition: 650000,
      dateAcquisition: DateTime(2023, 12, 20),
      dateMiseService: DateTime(2023, 12, 22),
      etat: 'Bon état',
      localisation: 'Salle de réunion A',
      typeNom: 'Équipement',
      affectations: [],
    ),
    Immobilisation(
      id: 5,
      nom: 'Bureau ergonomique',
      description: 'Bureau réglable en hauteur',
      numeroSerie: 'DESK-2024-055',
      valeurAcquisition: 350000,
      dateAcquisition: DateTime(2024, 1, 8),
      dateMiseService: DateTime(2024, 1, 10),
      etat: 'Très bon état',
      localisation: 'Open space - Poste 12',
      typeNom: 'Mobilier',
      affectations: [],
    ),
  ];

  List<Immobilisation> get filteredImmobilisations {
    return immobilisations.where((immo) {
      final matchesSearch = _searchQuery.isEmpty ||
          immo.nom.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (immo.numeroSerie?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);

      final matchesEtat = _filterEtat == 'Tous' || immo.etat == _filterEtat;

      final matchesAffectation = _filterAffectation == 'Tous' ||
          (_filterAffectation == 'Affectés' && immo.isAffecte) ||
          (_filterAffectation == 'Disponibles' && !immo.isAffecte);

      return matchesSearch && matchesEtat && matchesAffectation;
    }).toList();
  }

  void _addImmobilisation(BuildContext context) {
    // Controllers
    final TextEditingController _nomController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _numeroSerieController = TextEditingController();
    final TextEditingController _valeurAcquisitionController = TextEditingController();
    final TextEditingController _dateAcquisitionController = TextEditingController();
    final TextEditingController _dateMiseServiceController = TextEditingController();
    final TextEditingController _localisationController = TextEditingController();

    // Variables d'état
    String? _selectedTypeId;
    DateTime? _selectedDateAcquisition;
    DateTime? _selectedDateMiseService;
    String? _selectedEtat;

    // Listes de données
    final List<Map<String, dynamic>> _types = [
      {'id': '1', 'nom': 'Matériel informatique'},
      {'id': '2', 'nom': 'Matériel de bureau'},
      {'id': '3', 'nom': 'Mobilier'},
      {'id': '4', 'nom': 'Véhicule'},
      {'id': '5', 'nom': 'Équipement'},
    ];

    final List<String> _etats = [
      'Neuf',
      'Excellent',
      'Très bon état',
      'Bon état',
      'État moyen',
      'Usagé',
      'Hors service',
    ];

    void _clearForm() {
      _nomController.clear();
      _descriptionController.clear();
      _numeroSerieController.clear();
      _valeurAcquisitionController.clear();
      _dateAcquisitionController.clear();
      _dateMiseServiceController.clear();
      _localisationController.clear();
    }

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
                            'Nouvelle immobilisation',
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
                        // Type d'immobilisation
                        const Text(
                          'Type d\'immobilisation *',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.inputLabel,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedTypeId,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.inputText,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Sélectionnez un type',
                            filled: true,
                            fillColor: Colors.white,
                            labelStyle: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputText,
                              fontWeight: FontWeight.w600,
                            ),
                            hintStyle: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputLabel,
                              fontWeight: FontWeight.w600,
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
                          items: _types.map((type) {
                            return DropdownMenuItem<String>(
                              value: type['id'],
                              child: Text(
                                type['nom'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.inputText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setModalState(() {
                              _selectedTypeId = value;
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        // Nom
                        const Text(
                          'Nom de l\'immobilisation *',
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
                            hintText: 'Ex: MacBook Pro 16"',
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputLabel,
                              fontWeight: FontWeight.w600,
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
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.inputText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Description
                        const Text(
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
                          maxLines: 3,
                          maxLength: 1000,
                          decoration: InputDecoration(
                            hintText: 'Décrivez l\'immobilisation...',
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputLabel,
                              fontWeight: FontWeight.w600,
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
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.inputText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Numéro de série
                        const Text(
                          'Numéro de série',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.inputLabel,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _numeroSerieController,
                          decoration: InputDecoration(
                            hintText: 'Ex: MBP2024-001',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.qr_code_2, color: AppTheme.inputLabel),
                            hintStyle: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputLabel,
                              fontWeight: FontWeight.w600,
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
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.inputText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Valeur d'acquisition
                        const Text(
                          'Valeur d\'acquisition (FCFA) *',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.inputLabel,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _valeurAcquisitionController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Ex: 2500000',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.attach_money, color: AppTheme.inputLabel),
                            hintStyle: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputLabel,
                              fontWeight: FontWeight.w600,
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
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.inputText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Dates en ligne
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Date d\'acquisition *',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.inputLabel,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () async {
                                      final DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: _selectedDateAcquisition ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null) {
                                        setModalState(() {
                                          _selectedDateAcquisition = pickedDate;
                                          _dateAcquisitionController.text =
                                              DateFormat('yyyy-MM-dd').format(pickedDate);
                                        });
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: TextField(
                                        controller: _dateAcquisitionController,
                                        decoration: InputDecoration(
                                          hintText: 'JJ/MM/AAAA',
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintStyle: const TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.inputLabel,
                                            fontWeight: FontWeight.w600,
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
                                          suffixIcon: const Icon(Icons.calendar_today, size: 20),
                                        ),
                                        readOnly: true,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.inputText,
                                          fontWeight: FontWeight.w600,
                                        ),
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
                                    'Mise en service',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.inputLabel,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () async {
                                      final DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: _selectedDateMiseService ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (pickedDate != null) {
                                        setModalState(() {
                                          _selectedDateMiseService = pickedDate;
                                          _dateMiseServiceController.text =
                                              DateFormat('yyyy-MM-dd').format(pickedDate);
                                        });
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: TextField(
                                        controller: _dateMiseServiceController,
                                        decoration: InputDecoration(
                                          hintText: 'JJ/MM/AAAA',
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintStyle: const TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.inputLabel,
                                            fontWeight: FontWeight.w600,
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
                                          suffixIcon: const Icon(Icons.calendar_today, size: 20),
                                        ),
                                        readOnly: true,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.inputText,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // État
                        const Text(
                          'État',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.inputLabel,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedEtat,
                          decoration: InputDecoration(
                            hintText: 'Sélectionnez un état',
                            filled: true,
                            fillColor: Colors.white,
                            labelStyle: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputText,
                              fontWeight: FontWeight.w600,
                            ),
                            hintStyle: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputLabel,
                              fontWeight: FontWeight.w600,
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
                          items: _etats.map((etat) {
                            return DropdownMenuItem<String>(
                              value: etat,
                              child: Text(
                                etat,
                                style:  TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.inputText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setModalState(() {
                              _selectedEtat = value;
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        // Localisation
                        const Text(
                          'Localisation',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.inputLabel,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _localisationController,
                          decoration: InputDecoration(
                            hintText: 'Ex: Bureau IT - Étage 2',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.location_on, color: AppTheme.inputLabel),
                            hintStyle: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.inputLabel,
                              fontWeight: FontWeight.w600,
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
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.inputText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

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
                          onPressed: () {
                            // Validation
                            if (_selectedTypeId == null ||
                                _nomController.text.isEmpty ||
                                _valeurAcquisitionController.text.isEmpty ||
                                _dateAcquisitionController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Veuillez remplir tous les champs obligatoires'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // TODO: Envoyer les données au backend
                            final Map<String, dynamic> immobilisationData = {
                              'type_id': _selectedTypeId,
                              'nom': _nomController.text,
                              'description': _descriptionController.text.isNotEmpty
                                  ? _descriptionController.text
                                  : null,
                              'numero_serie': _numeroSerieController.text.isNotEmpty
                                  ? _numeroSerieController.text
                                  : null,
                              'valeur_acquisition': double.parse(_valeurAcquisitionController.text),
                              'date_acquisition': _dateAcquisitionController.text,
                              'date_mise_service': _dateMiseServiceController.text.isNotEmpty
                                  ? _dateMiseServiceController.text
                                  : null,
                              'etat': _selectedEtat,
                              'localisation': _localisationController.text.isNotEmpty
                                  ? _localisationController.text
                                  : null,
                            };

                            print('Données à envoyer: $immobilisationData');

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.white),
                                    SizedBox(width: 12),
                                    Text('Immobilisation ajoutée avec succès'),
                                  ],
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            _clearForm();
                            Navigator.pop(context);
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final filtered = filteredImmobilisations;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text('Immobilisations',   style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche et statistiques
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher une immobilisation...',
                    prefixIcon: const Icon(Icons.search),
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
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total',
                        immobilisations.length.toString(),
                        Colors.blue,
                        Icons.inventory_2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Affectés',
                        immobilisations.where((i) => i.isAffecte).length.toString(),
                        Colors.orange,
                        Icons.person,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Disponibles',
                        immobilisations.where((i) => !i.isAffecte).length.toString(),
                        Colors.green,
                        Icons.check_circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
               const Divider(
            height: 0,
            thickness: 0.5, // plus fin
            color: Color(0xFFDDDDDD),
          ),
          // Liste des immobilisations
          Expanded(
            child: filtered.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune immobilisation trouvée',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return _buildImmobilisationCard(filtered[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addImmobilisation(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImmobilisationCard(Immobilisation immo) {
    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'immobilisation-detail',
            extra: immo,
          );

        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.inventory_2, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          immo.nom,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          immo.typeNom,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: immo.isAffecte
                          ? Colors.orange.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: immo.isAffecte
                            ? Colors.orange.withOpacity(0.5)
                            : Colors.green.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      immo.isAffecte ? 'Affecté' : 'Disponible',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: immo.isAffecte ? Colors.orange[800] : Colors.green[800],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(
                height: 1,
                thickness: 0.5, // plus fin
                color: Color(0xFFDDDDDD),
              ),

              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      Icons.attach_money,
                      currencyFormat.format(immo.valeurAcquisition),
                    ),
                  ),
                  Expanded(
                    child: _buildInfoRow(
                      Icons.calendar_today,
                      DateFormat('dd/MM/yyyy').format(immo.dateAcquisition),
                    ),
                  ),
                ],
              ),
              if (immo.numeroSerie != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow(Icons.qr_code, immo.numeroSerie!),
              ],
              if (immo.localisation != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow(Icons.location_on, immo.localisation!),
              ],
              if (immo.isAffecte) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 18, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Affecté à ${immo.affectations.first.employeNom}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(immo.affectations.first.dateAffectation),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtres'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('État', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Tous', 'Bon état', 'Très bon état', 'Excellent']
                  .map((etat) => FilterChip(
                label: Text(etat),
                selected: _filterEtat == etat,
                onSelected: (selected) {
                  setState(() {
                    _filterEtat = etat;
                  });
                  Navigator.pop(context);
                },
              ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text('Affectation', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Tous', 'Affectés', 'Disponibles']
                  .map((statut) => FilterChip(
                label: Text(statut),
                selected: _filterAffectation == statut,
                onSelected: (selected) {
                  setState(() {
                    _filterAffectation = statut;
                  });
                  Navigator.pop(context);
                },
              ))
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _filterEtat = 'Tous';
                _filterAffectation = 'Tous';
              });
              Navigator.pop(context);
            },
            child: const Text('Réinitialiser'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

