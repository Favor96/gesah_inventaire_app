import 'package:flutter/material.dart';
import 'package:gesah_inventaire_app/view/immobilisation_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ImmobilisationDetailPage extends StatefulWidget {
  final Immobilisation immobilisation;

  const ImmobilisationDetailPage({Key? key, required this.immobilisation}) : super(key: key);

  @override
  State<ImmobilisationDetailPage> createState() => _ImmobilisationDetailPageState();
}

class _ImmobilisationDetailPageState extends State<ImmobilisationDetailPage> {
  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text('Détails Immobilisation',style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Modifier l'immobilisation
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec statut
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blue.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: widget.immobilisation.isAffecte ? Colors.orange : Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.immobilisation.isAffecte ? 'AFFECTÉ' : 'DISPONIBLE',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.immobilisation.nom,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.immobilisation.typeNom,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Informations principales
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Informations générales'),
                  const SizedBox(height: 12),
                  _buildDetailCard([
                    _buildDetailRow('Valeur d\'acquisition', currencyFormat.format(widget.immobilisation.valeurAcquisition)),
                    _buildDetailRow('Date d\'acquisition', DateFormat('dd/MM/yyyy').format(widget.immobilisation.dateAcquisition)),
                    if (widget.immobilisation.dateMiseService != null)
                      _buildDetailRow('Mise en service', DateFormat('dd/MM/yyyy').format(widget.immobilisation.dateMiseService!)),
                    if (widget.immobilisation.numeroSerie != null)
                      _buildDetailRow('N° de série', widget.immobilisation.numeroSerie!),
                    if (widget.immobilisation.etat != null)
                      _buildDetailRow('État', widget.immobilisation.etat!),
                    if (widget.immobilisation.localisation != null)
                      _buildDetailRow('Localisation', widget.immobilisation.localisation!),
                  ]),

                  if (widget.immobilisation.description != null) ...[
                    const SizedBox(height: 24),
                    _buildSectionTitle('Description'),
                    const SizedBox(height: 12),
                    _buildDetailCard([
                      Text(
                        widget.immobilisation.description!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ]),
                  ],

                  const SizedBox(height: 24),
                  _buildSectionTitle('Historique des affectations'),
                  const SizedBox(height: 12),

                  if (widget.immobilisation.affectations.isEmpty)
                    _buildDetailCard([
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children: [
                              Icon(Icons.assignment, size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text(
                                'Aucune affectation',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ])
                  else
                    ...widget.immobilisation.affectations.map((affectation) =>
                        _buildAffectationCard(context, affectation)
                    ).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: !widget.immobilisation.isAffecte
          ? Container(
        padding: const EdgeInsets.all(16),
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
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: () {
              context.pushNamed(
                'immobilisation-affectation',
                extra: widget.immobilisation,
              );
            },
            icon: const Icon(Icons.person_add,color: Colors.white,),
            label: const Text('Affecter à un employé', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      )
          : null,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      )
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffectationCard(BuildContext context, Affectation affectation) {
    final isActive = affectation.statut == 'En cours';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isActive ? Colors.orange.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isActive ? Colors.orange.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    color: isActive ? Colors.orange : Colors.grey,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        affectation.employeNom,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.orange.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          affectation.statut,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.orange[800] : Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isActive)
                  IconButton(
                    icon: const Icon(Icons.assignment_return),
                    color: Colors.orange,
                    onPressed: () {
                      // TODO: Retourner l'immobilisation
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Affecté le ${DateFormat('dd/MM/yyyy').format(affectation.dateAffectation)}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
                if (affectation.dateRetour != null) ...[
                  const SizedBox(width: 16),
                  const Icon(Icons.assignment_return, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Retourné le ${DateFormat('dd/MM/yyyy').format(affectation.dateRetour!)}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
