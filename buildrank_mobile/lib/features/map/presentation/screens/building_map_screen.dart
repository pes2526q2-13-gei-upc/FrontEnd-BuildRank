import 'package:buildrank_mobile/features/map/data/building_map_feature_model.dart';
import 'package:buildrank_mobile/features/map/data/building_map_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BuildingMapScreen extends StatefulWidget {
  const BuildingMapScreen({super.key});

  @override
  State<BuildingMapScreen> createState() => _BuildingMapScreenState();
}

class _BuildingMapScreenState extends State<BuildingMapScreen> {
  static const LatLng _barcelonaCenter = LatLng(41.3851, 2.1734);

  final _service = const BuildingMapService();
  final _mapController = MapController();
  final _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorText;
  BuildingMapResponse? _response;
  BuildingMapFeature? _selectedFeature;
  double? _scoreMin;

  List<BuildingMapFeature> get _features => _response?.features ?? [];

  @override
  void initState() {
    super.initState();
    _loadMapData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMapData() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final response = await _service.getBuildingsForMap(
        search: _searchController.text,
        scoreMin: _scoreMin,
        limit: 500,
      );

      if (!mounted) return;

      setState(() {
        _response = response;
        _selectedFeature = response.features.isNotEmpty
            ? response.features.first
            : null;
      });

      if (response.features.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _mapController.move(response.features.first.point, 13);
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorText = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _selectFeature(BuildingMapFeature feature) {
    setState(() {
      _selectedFeature = feature;
    });

    _mapController.move(feature.point, 16);
  }

  LatLng _initialCenter() {
    if (_features.isNotEmpty) return _features.first.point;
    return _barcelonaCenter;
  }

  Color _scoreColor(BuildingMapFeature feature) {
    final score = feature.roundedScore;

    if (score >= 80) return Colors.green;
    if (score >= 65) return Colors.blue;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }

  String _scoreGrade(BuildingMapFeature feature) {
    if (!feature.hasScore) return '—';

    final score = feature.roundedScore;

    if (score >= 80) return 'A';
    if (score >= 65) return 'B';
    if (score >= 50) return 'C';
    return 'D';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa d’edificis'),
        actions: [
          IconButton(
            tooltip: 'Refrescar',
            onPressed: _isLoading ? null : _loadMapData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorText != null
                ? _buildErrorState()
                : _buildMap(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _loadMapData(),
            decoration: InputDecoration(
              hintText: 'Cerca per carrer, barri o codi postal',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: 'Cercar',
                onPressed: _loadMapData,
                icon: const Icon(Icons.arrow_forward),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.tune, size: 18, color: Colors.black54),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildScoreChip('Tots', null),
                      _buildScoreChip('≥ 50', 50),
                      _buildScoreChip('≥ 65', 65),
                      _buildScoreChip('≥ 80', 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreChip(String label, double? value) {
    final selected = _scoreMin == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: selected,
        label: Text(label),
        onSelected: (_) {
          setState(() {
            _scoreMin = value;
          });
          _loadMapData();
        },
      ),
    );
  }

  Widget _buildMap() {
    final features = _features;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _initialCenter(),
            initialZoom: features.isEmpty ? 12 : 13,
            minZoom: 5,
            maxZoom: 18,
            onTap: (_, _) {
              setState(() {
                _selectedFeature = null;
              });
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'edu.upc.buildrank',
            ),
            MarkerLayer(
              markers: [for (final feature in features) _buildMarker(feature)],
            ),
          ],
        ),
        Positioned(top: 12, left: 12, right: 12, child: _buildMapSummary()),
        if (features.isEmpty)
          Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 16,
                    offset: Offset(0, 6),
                    color: Color.fromRGBO(0, 0, 0, 0.12),
                  ),
                ],
              ),
              child: const Text(
                'No hi ha edificis amb coordenades vàlides per mostrar.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        Positioned(
          right: 8,
          bottom: _selectedFeature == null ? 8 : 218,
          child: _buildAttribution(),
        ),
        if (_selectedFeature != null)
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: _BuildingMapDetailCard(
              feature: _selectedFeature!,
              color: _scoreColor(_selectedFeature!),
              grade: _scoreGrade(_selectedFeature!),
            ),
          ),
      ],
    );
  }

  Marker _buildMarker(BuildingMapFeature feature) {
    final color = _scoreColor(feature);
    final selected = _selectedFeature?.idEdifici == feature.idEdifici;

    return Marker(
      point: feature.point,
      width: 58,
      height: 76,
      child: GestureDetector(
        onTap: () => _selectFeature(feature),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: selected ? 46 : 40,
              height: selected ? 46 : 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 12,
                    offset: Offset(0, 4),
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _scoreGrade(feature),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: color, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSummary() {
    final count = _response?.count ?? _features.length;
    final shown = _features.length;
    final truncated = _response?.truncated == true;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            offset: Offset(0, 5),
            color: Color.fromRGBO(0, 0, 0, 0.12),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.map_outlined, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              truncated
                  ? '$shown de $count edificis mostrats'
                  : '$shown edificis al mapa',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const Text(
            'GeoJSON',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildAttribution() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        '© OpenStreetMap contributors',
        style: TextStyle(fontSize: 10, color: Colors.black54),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, size: 46, color: Colors.black45),
            const SizedBox(height: 12),
            Text(
              _errorText ?? 'No s’ha pogut carregar el mapa.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadMapData,
              icon: const Icon(Icons.refresh),
              label: const Text('Torna-ho a provar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildingMapDetailCard extends StatelessWidget {
  final BuildingMapFeature feature;
  final Color color;
  final String grade;

  const _BuildingMapDetailCard({
    required this.feature,
    required this.color,
    required this.grade,
  });

  List<Widget> _buildStats() {
    final stats = <Widget>[
      _MiniStat(icon: Icons.speed_outlined, text: feature.scoreText),
      _MiniStat(
        icon: Icons.energy_savings_leaf_outlined,
        text: 'Classe ${feature.energyClassText}',
      ),
      _MiniStat(icon: Icons.dataset_outlined, text: feature.sourceText),
    ];

    final heatRisk = feature.heatRiskText;
    if (heatRisk != null && heatRisk.isNotEmpty) {
      stats.add(_MiniStat(icon: Icons.thermostat_outlined, text: heatRisk));
    }

    return stats;
  }

  @override
  Widget build(BuildContext context) {
    final visibleBadges = feature.visibleBadges;

    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color,
              child: Text(
                grade,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, runSpacing: 6, children: _buildStats()),
                  if (visibleBadges.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final badge in visibleBadges)
                          _MapBadgeChip(label: badge.label),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapBadgeChip extends StatelessWidget {
  final String label;

  const _MapBadgeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.emoji_events_outlined,
            size: 13,
            color: Colors.brown,
          ),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.brown,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MiniStat({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.black54),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 11, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
