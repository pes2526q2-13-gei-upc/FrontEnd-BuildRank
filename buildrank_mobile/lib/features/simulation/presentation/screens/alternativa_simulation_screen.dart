import 'package:flutter/material.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';

class AlternativaSimulationScreen extends StatefulWidget {
  final String userRole;
  final String buildingName;
  final int currentPoints;
  final void Function(List<SimulationImprovement> selectedImprovements)?
  onPresentToVote;

  const AlternativaSimulationScreen({
    super.key,
    required this.userRole,
    this.buildingName = 'Edifici A-240',
    this.currentPoints = 42,
    this.onPresentToVote,
  });

  @override
  State<AlternativaSimulationScreen> createState() =>
      _AlternativaSimulationScreenState();
}

class _AlternativaSimulationScreenState
    extends State<AlternativaSimulationScreen> {
  final List<SimulationImprovement> _improvements = [
    const SimulationImprovement(
      id: 'solar_panels',
      title: 'solar_panels',
      subtitle: 'solar_roof_10kw',
      impactPoints: 15,
      estimatedCost: 12500,
      annualSavings: 1200,
      carbonReduction: 1.8,
      intensityReduction: 2.4,
      icon: Icons.wb_sunny_outlined,
    ),
    const SimulationImprovement(
      id: 'triple_glazing',
      title: 'triple_glazing',
      subtitle: 'high_performance',
      impactPoints: 8,
      estimatedCost: 8000,
      annualSavings: 700,
      carbonReduction: 0.9,
      intensityReduction: 1.8,
      icon: Icons.air_outlined,
    ),
    const SimulationImprovement(
      id: 'wall_insulation',
      title: 'Aïllament de paret',
      subtitle: 'external_mineral',
      impactPoints: 12,
      estimatedCost: 15000,
      annualSavings: 1100,
      carbonReduction: 1.5,
      intensityReduction: 2.6,
      icon: Icons.layers_outlined,
    ),
    const SimulationImprovement(
      id: 'heat_pump',
      title: 'heat_pump',
      subtitle: 'efficient_air_water',
      impactPoints: 20,
      estimatedCost: 11000,
      annualSavings: 1400,
      carbonReduction: 2.1,
      intensityReduction: 3.5,
      icon: Icons.thermostat_outlined,
    ),
  ];

  final Set<String> _selectedIds = {};

  static const double _currentAnnualEnergyCost = 4800;
  static const double _currentCarbonFootprint = 12.4;
  static const double _currentEnergyIntensity = 24.5;

  bool get _canPresentToVote => widget.userRole == 'admin';

  List<SimulationImprovement> get _selectedImprovements =>
      _improvements.where((i) => _selectedIds.contains(i.id)).toList();

  int get _simulatedPoints {
    final extraPoints = _selectedImprovements.fold<int>(
      0,
      (sum, item) => sum + item.impactPoints,
    );
    final total = widget.currentPoints + extraPoints;
    return total > 100 ? 100 : total;
  }

  double get _totalInvestment => _selectedImprovements.fold<double>(
    0,
    (sum, item) => sum + item.estimatedCost,
  );

  double get _annualSavings => _selectedImprovements.fold<double>(
    0,
    (sum, item) => sum + item.annualSavings,
  );

  double get _simulatedAnnualEnergyCost {
    final result = _currentAnnualEnergyCost - _annualSavings;
    return result < 0 ? 0 : result;
  }

  double get _simulatedCarbonFootprint {
    final reduction = _selectedImprovements.fold<double>(
      0,
      (sum, item) => sum + item.carbonReduction,
    );
    final result = _currentCarbonFootprint - reduction;
    return result < 0 ? 0 : result;
  }

  double get _simulatedEnergyIntensity {
    final reduction = _selectedImprovements.fold<double>(
      0,
      (sum, item) => sum + item.intensityReduction,
    );
    final result = _currentEnergyIntensity - reduction;
    return result < 0 ? 0 : result;
  }

  String get _paybackPeriod {
    if (_annualSavings <= 0) return '-';
    final years = _totalInvestment / _annualSavings;
    return AppLocalizations.of(
      context,
    ).altSimulationYears(years.toStringAsFixed(1));
  }

  void _toggleImprovement(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _presentToVote() {
    if (!_canPresentToVote || _selectedImprovements.isEmpty) return;

    if (widget.onPresentToVote != null) {
      widget.onPresentToVote!(_selectedImprovements);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(
            context,
          ).altSimulationPreparedSnack(_selectedImprovements.length),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = _selectedImprovements.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PredictionCard(
                currentPoints: widget.currentPoints,
                simulatedPoints: _simulatedPoints,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).altSimulationSelectUpdates,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFF22C55E)),
                      color: const Color(0xFFEAF8EE),
                    ),
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).simulationSelectedCount(selectedCount),
                      style: const TextStyle(
                        color: Color(0xFF16A34A),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // PANEL HORITZONTAL SCROLL
              SizedBox(
                height: 285,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _improvements.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final item = _improvements[index];
                    final isSelected = _selectedIds.contains(item.id);

                    return SizedBox(
                      width: 250,
                      child: _ImprovementCard(
                        improvement: item,
                        selected: isSelected,
                        onTap: () => _toggleImprovement(item.id),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),
              Text(
                AppLocalizations.of(context).altSimulationDetailedImpact,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              _OperationalPreviewCard(
                currentAnnualCost: _currentAnnualEnergyCost,
                simulatedAnnualCost: _simulatedAnnualEnergyCost,
                currentCarbon: _currentCarbonFootprint,
                simulatedCarbon: _simulatedCarbonFootprint,
                currentIntensity: _currentEnergyIntensity,
                simulatedIntensity: _simulatedEnergyIntensity,
              ),
              const SizedBox(height: 20),
              _InvestmentSummaryCard(
                totalInvestment: _totalInvestment,
                annualSavings: _annualSavings,
                paybackPeriod: _paybackPeriod,
              ),

              // NOMÉS ES MOSTRA SI ÉS ADMIN
              if (_canPresentToVote) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _selectedImprovements.isNotEmpty
                        ? _presentToVote
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      disabledBackgroundColor: const Color(0xFFBFC7C2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context).altSimulationPresentVote,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SimulationImprovement {
  final String id;
  final String title;
  final String subtitle;
  final int impactPoints;
  final double estimatedCost;
  final double annualSavings;
  final double carbonReduction;
  final double intensityReduction;
  final IconData icon;

  const SimulationImprovement({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.impactPoints,
    required this.estimatedCost,
    required this.annualSavings,
    required this.carbonReduction,
    required this.intensityReduction,
    required this.icon,
  });
}

class _PredictionCard extends StatelessWidget {
  final int currentPoints;
  final int simulatedPoints;

  const _PredictionCard({
    required this.currentPoints,
    required this.simulatedPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8EE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context).altSimulationLive,
            style: TextStyle(
              color: Color(0xFF22C55E),
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).altSimulationExpectedPerformance,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MiniScoreBubble(
                  label: AppLocalizations.of(context).simulationCurrent,
                  points: '$currentPoints pts',
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Color(0xFF22C55E),
                ),
              ),
              Expanded(
                child: _MiniScoreBubble(
                  label: AppLocalizations.of(context).simulationSimulated,
                  points: '$simulatedPoints pts',
                  highlight: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniScoreBubble extends StatelessWidget {
  final String label;
  final String points;
  final bool highlight;

  const _MiniScoreBubble({
    required this.label,
    required this.points,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'C',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: highlight
                  ? const Color(0xFF22C55E)
                  : Colors.grey.withValues(alpha: 0.5),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          points,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: highlight ? const Color(0xFF16A34A) : Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _ImprovementCard extends StatelessWidget {
  final SimulationImprovement improvement;
  final bool selected;
  final VoidCallback onTap;

  const _ImprovementCard({
    required this.improvement,
    required this.selected,
    required this.onTap,
  });

  String _title(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (improvement.id) {
      case 'solar_panels':
        return l10n.altSimulationSolarTitle;
      case 'triple_glazing':
        return l10n.altSimulationGlazingTitle;
      case 'wall_insulation':
        return l10n.altSimulationInsulationTitle;
      case 'heat_pump':
        return l10n.altSimulationHeatPumpTitle;
      default:
        return improvement.title;
    }
  }

  String _subtitle(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (improvement.id) {
      case 'solar_panels':
        return l10n.altSimulationSolarSubtitle;
      case 'triple_glazing':
        return l10n.altSimulationGlazingSubtitle;
      case 'wall_insulation':
        return l10n.altSimulationInsulationSubtitle;
      case 'heat_pump':
        return l10n.altSimulationHeatPumpSubtitle;
      default:
        return improvement.subtitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFEAF8EE) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(improvement.icon, color: Colors.black54),
                      ),
                      const Spacer(),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected
                              ? const Color(0xFF22C55E)
                              : Colors.transparent,
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFE5E7EB),
                          ),
                        ),
                        child: selected
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _title(context),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _subtitle(context),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _MiniMetric(
                          label: AppLocalizations.of(
                            context,
                          ).altSimulationImpact,
                          value: '+${improvement.impactPoints} pts',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _MiniMetric(
                          label: AppLocalizations.of(
                            context,
                          ).altSimulationEstimatedCost,
                          value: _formatCurrency(improvement.estimatedCost),
                          alignEnd: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _MiniMetric({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black45,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
        ),
      ],
    );
  }
}

class _OperationalPreviewCard extends StatelessWidget {
  final double currentAnnualCost;
  final double simulatedAnnualCost;
  final double currentCarbon;
  final double simulatedCarbon;
  final double currentIntensity;
  final double simulatedIntensity;

  const _OperationalPreviewCard({
    required this.currentAnnualCost,
    required this.simulatedAnnualCost,
    required this.currentCarbon,
    required this.simulatedCarbon,
    required this.currentIntensity,
    required this.simulatedIntensity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Text(
              AppLocalizations.of(context).altSimulationOperationalForecast,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
          _DetailRow(
            icon: Icons.attach_money,
            title: 'Cost energètic anual',
            oldValue: _formatCurrency(currentAnnualCost),
            newValue: _formatCurrency(simulatedAnnualCost),
          ),
          _DetailRow(
            icon: Icons.eco_outlined,
            title: AppLocalizations.of(context).altSimulationCarbonFootprint,
            oldValue: currentCarbon.toStringAsFixed(1),
            newValue: simulatedCarbon.toStringAsFixed(1),
          ),
          _DetailRow(
            icon: Icons.bolt_outlined,
            title: 'Intensitat energètica',
            oldValue: currentIntensity.toStringAsFixed(2),
            newValue: simulatedIntensity.toStringAsFixed(2),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String oldValue;
  final String newValue;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.oldValue,
    required this.newValue,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          if (oldValue != newValue) ...[
            Text(
              oldValue,
              style: const TextStyle(
                color: Colors.black45,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            newValue,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class _InvestmentSummaryCard extends StatelessWidget {
  final double totalInvestment;
  final double annualSavings;
  final String paybackPeriod;

  const _InvestmentSummaryCard({
    required this.totalInvestment,
    required this.annualSavings,
    required this.paybackPeriod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF6B7280),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).altSimulationTotalInvestment,
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _formatCurrency(totalInvestment),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _SummaryMiniCard(
                  title: AppLocalizations.of(
                    context,
                  ).altSimulationAnnualSavings,
                  value: _formatCurrency(annualSavings),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryMiniCard(
                  title: AppLocalizations.of(
                    context,
                  ).altSimulationPaybackPeriod,
                  value: paybackPeriod,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMiniCard extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryMiniCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatCurrency(double value) {
  final rounded = value.round();
  final text = rounded.toString();
  final buffer = StringBuffer();

  for (int i = 0; i < text.length; i++) {
    final positionFromEnd = text.length - i;
    buffer.write(text[i]);
    if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
      buffer.write('.');
    }
  }

  return '${buffer.toString()}€';
}
