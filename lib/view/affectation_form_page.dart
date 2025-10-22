import 'package:flutter/material.dart';
import 'package:gesah_inventaire_app/view/immobilisation_screen.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
class AffectationFormPage extends StatefulWidget {
  final Immobilisation immobilisation;

  const AffectationFormPage({Key? key, required this.immobilisation}) : super(key: key);

  @override
  State<AffectationFormPage> createState() => _AffectationFormPageState();
}

class _AffectationFormPageState extends State<AffectationFormPage> {
  final _formKey = GlobalKey<FormState>();
  Employe? _selectedEmploye;
  DateTime _dateAffectation = DateTime.now();
  String _statut = 'En cours';

  // Liste d'employés de test
  final List<Employe> employes = [
    Employe(id: 101, nom: 'Koffi', prenom: 'Jean', service: 'IT'),
    Employe(id: 102, nom: 'Amavi', prenom: 'Marie', service: 'Comptabilité'),
    Employe(id: 103, nom: 'Mensah', prenom: 'Paul', service: 'Direction'),
    Employe(id: 104, nom: 'Adebayor', prenom: 'Sophie', service: 'RH'),
    Employe(id: 105, nom: 'Akakpo', prenom: 'David', service: 'Commercial'),
    Employe(id: 106, nom: 'Togbé', prenom: 'Élise', service: 'Marketing'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text('Nouvelle Affectation',style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        )),
        scrolledUnderElevation: 0,
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Immobilisation à affecter',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
                          child: const Icon(Icons.inventory_2, color: Colors
                              .blue, size: 32),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.immobilisation.nom,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.immobilisation.typeNom,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (widget.immobilisation.numeroSerie !=
                                  null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'N° ${widget.immobilisation.numeroSerie}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sélection de l'employé
            const Text(
              'Employé *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  if (_selectedEmploye == null)
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        child: const Icon(
                            Icons.person_search, color: Colors.grey),
                      ),
                      title: const Text('Sélectionner un employé',    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),),
                      subtitle: const Text('Appuyez pour choisir'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: _showEmployeSelection,
                    )
                  else
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.withOpacity(0.2),
                        child: Text(
                          _selectedEmploye!.prenom[0] +
                              _selectedEmploye!.nom[0],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      title: Text(
                        _selectedEmploye!.nomComplet,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          _selectedEmploye!.service ?? 'Aucun service'),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _selectedEmploye = null;
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Date d'affectation
            const Text(
              'Date d\'affectation *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.blue),
                title: Text(
                  DateFormat('EEEE dd MMMM yyyy', 'fr_FR').format(
                      _dateAffectation),
                    style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                ),
                trailing: const Icon(Icons.edit, size: 20),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dateAffectation,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    locale: const Locale('fr', 'FR'),
                  );
                  if (date != null) {
                    setState(() {
                      _dateAffectation = date;
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 24),

            // Statut
            const Text(
              'Statut *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: DropdownButtonFormField<String>(
                  value: _statut,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.info_outline),
                  ),
                  items: ['En cours', 'En attente', 'Terminé']
                      .map((statut) =>
                      DropdownMenuItem(
                        value: statut,
                        child: Text(statut),
                      ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _statut = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Boutons d'action
            Row(
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
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _selectedEmploye == null
                        ? null
                        : _submitAffectation,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Confirmer l\'affectation',style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEmployeSelection() {
    // Liste filtrée et contrôleur de recherche
    List<Employe> _filteredEmployes = List.from(employes);
    TextEditingController _searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    // ✅ Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Sélectionner un employé',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),

                    // ✅ Barre de recherche
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Rechercher par nom ou service...',
                          prefixIcon: const Icon(Icons.search),
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
                        onChanged: (value) {
                          setStateModal(() {
                            _filteredEmployes = employes
                                .where((e) =>
                            e.nomComplet.toLowerCase().contains(value.toLowerCase()) ||
                                (e.service ?? '').toLowerCase().contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                    ),

                    // ✅ Liste filtrée
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: _filteredEmployes.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final employe = _filteredEmployes[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue.withOpacity(0.2),
                                child: Text(
                                  employe.prenom[0] + employe.nom[0],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              title: Text(
                                employe.nomComplet,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(employe.service ?? 'Aucun service'),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                setState(() {
                                  _selectedEmploye = employe;
                                });
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }


  void _submitAffectation() {
    if (_formKey.currentState!.validate() && _selectedEmploye != null) {
      // TODO: Envoyer les données au backend
      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Affectation réussie à ${_selectedEmploye!.nomComplet}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Retourner à la page précédente
      Navigator.pop(context);
    }
  }
}