import 'package:flutter/material.dart';

import 'package:buildrank_mobile/features/simulation/data/implemented_improvement_model.dart';
import 'package:buildrank_mobile/features/simulation/data/improvement_model.dart';
import 'package:buildrank_mobile/features/simulation/data/saved_simulation_model.dart';
import 'package:buildrank_mobile/features/simulation/data/simulation_result_model.dart';
import 'package:buildrank_mobile/features/simulation/data/simulation_service.dart';

class SimulationScreen extends StatefulWidget {
  final int idEdifici;
  final String userRole;
  final String buildingName;
  final int currentPoints;

  const SimulationScreen({
    super.key,
    required this.idEdifici,
    required this.userRole,
    required this.buildingName,
    required this.currentPoints,
  });

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  final _simulationService = SimulationService();

  int _selectedTab = 0;

  bool _isLoadingCatalog = true;
  bool _isLoadingHistory = false;
  bool _isPreviewLoading = false;
  bool _isSaving = false;
  String? _errorText;

  List<ImprovementModel> _improvements = [];
  List<SavedSimulationModel> _savedSimulations = [];
  List<ImplementedImprovementModel> _implementedImprovements = [];

  final Set<int> _selectedIds = {};
  SimulationResultModel? _previewResult;

  bool get _canSaveSimulation => widget.userRole == 'admin';

  @override
  void initState() {
    super.initState();
    _loadCatalog();
    _loadHistory();
  }

  Future<void> _refreshAll() async {
    await Future.wait([_loadCatalog(), _loadHistory()]);
  }

  Future<void> _loadCatalog() async {
    setState(() {
      _isLoadingCatalog = true;
      _errorText = null;
    });

    try {
      final improvements = await _simulationService.getImprovements();

      if (!mounted) return;

      setState(() {
        _improvements = improvements;
      });
    } on SimulationApiException catch (e) {
      if (!mounted) return;

      setState(() {
        _errorText = e.message;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorText = 'No s’ha pogut carregar el catàleg de millores.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCatalog = false;
        });
      }
    }
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoadingHistory = true;
    });

    try {
      final saved = await _simulationService.getSavedSimulations(
        widget.idEdifici,
      );
      final implemented = await _simulationService.getImplementedImprovements(
        widget.idEdifici,
      );

      if (!mounted) return;

      setState(() {
        _savedSimulations = saved;
        _implementedImprovements = implemented;
      });
    } on SimulationApiException catch (e) {
      if (!mounted) return;

      setState(() {
        _errorText = e.message;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorText = 'No s’ha pogut carregar l’historial de simulacions.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingHistory = false;
        });
      }
    }
  }

  List<ImprovementModel> get _selectedImprovements {
    return _improvements
        .where((improvement) => _selectedIds.contains(improvement.idMillora))
        .toList();
  }

  List<Map<String, dynamic>> _buildSelectedPayload() {
    return _selectedImprovements
        .map(
          (improvement) => {
            'milloraId': improvement.idMillora,
            'coberturaPercent': 100,
          },
        )
        .toList();
  }

  void _toggleImprovement(int idMillora) {
    setState(() {
      if (_selectedIds.contains(idMillora)) {
        _selectedIds.remove(idMillora);
      } else {
        _selectedIds.add(idMillora);
      }

      _previewResult = null;
    });
  }

  Future<void> _previewSimulation() async {
    if (_selectedIds.isEmpty || _isPreviewLoading) return;

    setState(() {
      _isPreviewLoading = true;
      _errorText = null;
    });

    try {
      final result = await _simulationService.previewSimulation(
        idEdifici: widget.idEdifici,
        descripcio: 'Preview simulació ${widget.buildingName}',
        millores: _buildSelectedPayload(),
      );

      if (!mounted) return;

      setState(() {
        _previewResult = result;
      });
    } on SimulationApiException catch (e) {
      if (!mounted) return;

      setState(() {
        _errorText = e.message;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorText = 'No s’ha pogut calcular la simulació.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isPreviewLoading = false;
        });
      }
    }
  }

  Future<void> _saveSimulation() async {
    if (_selectedIds.isEmpty || _isSaving) return;

    setState(() {
      _isSaving = true;
      _errorText = null;
    });

    try {
      final result = await _simulationService.saveSimulation(
        idEdifici: widget.idEdifici,
        descripcio: 'Simulació ${widget.buildingName}',
        millores: _buildSelectedPayload(),
      );

      if (!mounted) return;

      setState(() {
        _previewResult = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Simulació guardada correctament.')),
      );

      await _loadHistory();

      if (!mounted) return;

      setState(() {
        _selectedTab = 1;
      });
    } on SimulationApiException catch (e) {
      if (!mounted) return;

      setState(() {
        _errorText = e.message;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorText = 'No s’ha pogut guardar la simulació.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  IconData _iconForImprovement(ImprovementModel improvement) {
    final slug = improvement.slug ?? '';

    if (slug.contains('solar') || improvement.categoria == 'renovables') {
      return Icons.wb_sunny_outlined;
    }

    if (slug.contains('finestr')) {
      return Icons.window_outlined;
    }

    if (slug.contains('aillament') || improvement.categoria == 'envolupant') {
      return Icons.layers_outlined;
    }

    if (slug.contains('aerotermia') ||
        improvement.categoria == 'instal_lacio_termica') {
      return Icons.thermostat_outlined;
    }

    if (improvement.categoria == 'electricitat') {
      return Icons.lightbulb_outline;
    }

    if (improvement.categoria == 'control_i_monitoratge') {
      return Icons.sensors_outlined;
    }

    return Icons.construction_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final isRefreshing = _isLoadingCatalog || _isLoadingHistory;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F2),
      body: RefreshIndicator(
        onRefresh: _refreshAll,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leadingWidth: 120,
              leading: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Torna"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  tooltip: 'Refrescar',
                  onPressed: isRefreshing ? null : _refreshAll,
                  icon: isRefreshing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage("https://i.pravatar.cc/100"),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),

                    const SizedBox(height: 16),

                    _buildSimulationTabs(),

                    const SizedBox(height: 16),

                    if (_errorText != null) ...[
                      _ErrorBanner(text: _errorText!, onRetry: _refreshAll),
                      const SizedBox(height: 16),
                    ],

                    if (_selectedTab == 0)
                      _buildSimulationTab()
                    else if (_selectedTab == 1)
                      _buildSavedSimulationsTab()
                    else
                      _buildImplementedImprovementsTab(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final preview = _previewResult;

    final currentScore = preview?.abans.score.round() ?? widget.currentPoints;
    final simulatedScore =
        preview?.despres.score.round() ?? widget.currentPoints;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4EC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Simulador de millores',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            widget.buildingName,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _ScoreBox(
                  label: 'Actual',
                  value: currentScore,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ScoreBox(
                  label: 'Simulat',
                  value: simulatedScore,
                  color: const Color(0xFF16A34A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Els resultats són estimacions orientatives. No substitueixen una auditoria energètica professional.',
            style: TextStyle(fontSize: 12, height: 1.35, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulationTabs() {
    return SegmentedButton<int>(
      segments: const [
        ButtonSegment(
          value: 0,
          label: Text('Simular'),
          icon: Icon(Icons.analytics_outlined),
        ),
        ButtonSegment(
          value: 1,
          label: Text('Guardades'),
          icon: Icon(Icons.save_outlined),
        ),
        ButtonSegment(
          value: 2,
          label: Text('Aplicades'),
          icon: Icon(Icons.verified_outlined),
        ),
      ],
      selected: {_selectedTab},
      onSelectionChanged: (value) {
        setState(() {
          _selectedTab = value.first;
        });
      },
    );
  }

  Widget _buildSimulationTab() {
    final selectedCount = _selectedIds.length;

    if (_isLoadingCatalog) {
      return const Padding(
        padding: EdgeInsets.only(top: 60),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Catàleg de millores',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFF22C55E)),
                color: const Color(0xFFEAF8EE),
              ),
              child: Text(
                '$selectedCount seleccionades',
                style: const TextStyle(
                  color: Color(0xFF16A34A),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        if (_improvements.isEmpty)
          const _EmptyCatalogCard()
        else
          ..._improvements.map((improvement) {
            final selected = _selectedIds.contains(improvement.idMillora);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ImprovementCard(
                improvement: improvement,
                icon: _iconForImprovement(improvement),
                selected: selected,
                onTap: () => _toggleImprovement(improvement.idMillora),
              ),
            );
          }),

        const SizedBox(height: 12),

        _buildActionButtons(),

        const SizedBox(height: 20),

        if (_previewResult != null)
          _SimulationResultCard(result: _previewResult!),
      ],
    );
  }

  Widget _buildSavedSimulationsTab() {
    if (_isLoadingHistory) {
      return const Padding(
        padding: EdgeInsets.only(top: 60),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_savedSimulations.isEmpty) {
      return const _InfoCard(
        text:
            'Encara no hi ha simulacions guardades per aquest edifici. Calcula un preview i prem “Guardar simulació”.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Simulacions guardades',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ..._savedSimulations.map(
          (simulation) => _SavedSimulationCard(simulation: simulation),
        ),
      ],
    );
  }

  Widget _buildImplementedImprovementsTab() {
    if (_isLoadingHistory) {
      return const Padding(
        padding: EdgeInsets.only(top: 60),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_implementedImprovements.isEmpty) {
      return const _InfoCard(
        text:
            'Encara no hi ha millores aplicades registrades. Les simulacions guardades són escenaris; les aplicades representen actuacions realment executades o en validació.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Millores aplicades',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ..._implementedImprovements.map(
          (improvement) =>
              _ImplementedImprovementCard(improvement: improvement),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final hasSelection = _selectedIds.isNotEmpty;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: hasSelection && !_isPreviewLoading
                ? _previewSimulation
                : null,
            icon: _isPreviewLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.analytics_outlined),
            label: Text(
              _isPreviewLoading ? 'Calculant preview...' : 'Calcular preview',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22C55E),
              disabledBackgroundColor: const Color(0xFFBFC7C2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
          ),
        ),
        if (_canSaveSimulation) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: hasSelection && !_isSaving ? _saveSimulation : null,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(
                _isSaving ? 'Guardant simulació...' : 'Guardar simulació',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF16A34A),
                side: const BorderSide(color: Color(0xFF22C55E)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ] else ...[
          const SizedBox(height: 10),
          const _InfoCard(
            text:
                'Aquest rol pot consultar el preview, però la gestió formal de simulacions queda reservada a l’administrador de finca.',
          ),
        ],
      ],
    );
  }
}

class _ScoreBox extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _ScoreBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 6),
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImprovementCard extends StatelessWidget {
  final ImprovementModel improvement;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ImprovementCard({
    required this.improvement,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFEAF8EE) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? const Color(0xFF22C55E)
                  : const Color(0xFFE5E7EB),
              width: selected ? 1.8 : 1.2,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.black54),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      improvement.nom,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      improvement.categoriaLabel,
                      style: const TextStyle(
                        color: Color(0xFF16A34A),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    if (improvement.descripcio.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        improvement.descripcio,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                          height: 1.25,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _MiniChip(
                          text:
                              '+${improvement.impactePunts.toStringAsFixed(1)} pts',
                        ),
                        _MiniChip(
                          text:
                              '${_formatCurrency(improvement.costEstimatBase)} ${improvement.unitatLabel}',
                        ),
                        _MiniChip(text: improvement.nivellConfianca),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                selected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: selected ? const Color(0xFF22C55E) : Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimulationResultCard extends StatelessWidget {
  final SimulationResultModel result;

  const _SimulationResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resultat de la simulació',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              _ResultRow(
                icon: Icons.bolt_outlined,
                title: 'Consum anual',
                oldValue:
                    '${result.abans.consumFinalKwhAny.toStringAsFixed(0)} kWh',
                newValue:
                    '${result.despres.consumFinalKwhAny.toStringAsFixed(0)} kWh',
                detail:
                    '-${result.delta.reduccioConsumPercent.toStringAsFixed(1)}%',
              ),
              _ResultRow(
                icon: Icons.eco_outlined,
                title: 'Emissions',
                oldValue:
                    '${result.abans.emissionsKgCO2Any.toStringAsFixed(0)} kg CO₂',
                newValue:
                    '${result.despres.emissionsKgCO2Any.toStringAsFixed(0)} kg CO₂',
                detail:
                    '-${result.delta.reduccioEmissionsPercent.toStringAsFixed(1)}%',
              ),
              _ResultRow(
                icon: Icons.euro_outlined,
                title: 'Cost anual estimat',
                oldValue: _formatCurrency(result.abans.costAnualEnergia),
                newValue: _formatCurrency(result.despres.costAnualEnergia),
                detail:
                    'Estalvi ${_formatCurrency(result.delta.estalviAnualEstimatiu)}',
              ),
              _ResultRow(
                icon: Icons.trending_up,
                title: 'Puntuació',
                oldValue: result.abans.score.toStringAsFixed(0),
                newValue: result.despres.score.toStringAsFixed(0),
                detail:
                    '+${result.delta.incrementScore.toStringAsFixed(1)} punts',
                isLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _InfoCard(
          text:
              'Cost total estimat: ${_formatCurrency(result.delta.costTotalEstimat)} · Motor ${result.versioMotor}',
        ),
      ],
    );
  }
}

class _SavedSimulationCard extends StatelessWidget {
  final SavedSimulationModel simulation;

  const _SavedSimulationCard({required this.simulation});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            simulation.descripcio,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Data: ${simulation.dataSimulacio} · Motor ${simulation.versioMotor}',
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MiniChip(
                text:
                    '-${simulation.reduccioConsumPrevista.toStringAsFixed(0)} kWh',
              ),
              _MiniChip(
                text:
                    '-${simulation.reduccioEmissionsPrevista.toStringAsFixed(0)} kg CO₂',
              ),
              _MiniChip(
                text: 'Cost ${_formatCurrency(simulation.costEstimat)}',
              ),
              _MiniChip(
                text: 'Estalvi ${_formatCurrency(simulation.estalviAnual)}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImplementedImprovementCard extends StatelessWidget {
  final ImplementedImprovementModel improvement;

  const _ImplementedImprovementCard({required this.improvement});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            improvement.nom,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Execució: ${improvement.dataExecucio}',
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MiniChip(text: improvement.estatValidacio),
              _MiniChip(
                text: 'Cost real ${_formatCurrency(improvement.costReal)}',
              ),
            ],
          ),
          if (improvement.observacionsAdmin.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              improvement.observacionsAdmin,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String oldValue;
  final String newValue;
  final String detail;
  final bool isLast;

  const _ResultRow({
    required this.icon,
    required this.title,
    required this.oldValue,
    required this.newValue,
    required this.detail,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF16A34A)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                oldValue,
                style: const TextStyle(
                  color: Colors.black45,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                newValue,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String text;

  const _MiniChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      visualDensity: VisualDensity.compact,
      backgroundColor: const Color(0xFFF3F4F6),
      side: BorderSide.none,
      labelStyle: const TextStyle(fontSize: 12),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String text;
  final VoidCallback? onRetry;

  const _ErrorBanner({required this.text, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade800),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.red.shade900, height: 1.35),
            ),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('Reintenta')),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String text;

  const _InfoCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.green.shade900,
          height: 1.35,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _EmptyCatalogCard extends StatelessWidget {
  const _EmptyCatalogCard();

  @override
  Widget build(BuildContext context) {
    return const _InfoCard(
      text:
          'Encara no hi ha millores actives al catàleg. Carrega el seed de millores al backend.',
    );
  }
}

String _formatCurrency(double value) {
  return '${value.toStringAsFixed(0)} €';
}
