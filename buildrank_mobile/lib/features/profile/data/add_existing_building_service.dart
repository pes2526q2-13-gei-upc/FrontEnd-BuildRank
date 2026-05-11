class AddExistingBuildingService {
  Future<List<ExistingBuildingItem>> searchBuildings(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final allBuildings = <ExistingBuildingItem>[
      const ExistingBuildingItem(
        id: 1,
        name: 'Edifici Aragó 120',
        address: 'Carrer d\'Aragó, 120',
        city: 'Barcelona',
        acceptsNewRequests: true,
        isBlock: true,
      ),
      const ExistingBuildingItem(
        id: 2,
        name: 'Edifici Balmes 44',
        address: 'Carrer de Balmes, 44',
        city: 'Barcelona',
        acceptsNewRequests: true,
        isBlock: true,
      ),
      const ExistingBuildingItem(
        id: 3,
        name: 'Casa Mallorca 210',
        address: 'Carrer de Mallorca, 210',
        city: 'Barcelona',
        acceptsNewRequests: false,
        isBlock: false,
      ),
    ];

    final normalized = query.trim().toLowerCase();

    return allBuildings.where((building) {
      return building.name.toLowerCase().contains(normalized) ||
          building.address.toLowerCase().contains(normalized) ||
          (building.city?.toLowerCase().contains(normalized) ?? false);
    }).toList();
  }

  Future<void> createJoinRequest({
    required ExistingBuildingItem building,
    required String userRole,
    required Map<String, dynamic> habitatgePayload,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock temporal: aquí més endavant hi haurà la crida real al backend.
  }
}

class ExistingBuildingItem {
  final int id;
  final String name;
  final String address;
  final String? city;
  final bool acceptsNewRequests;
  final bool isBlock;

  const ExistingBuildingItem({
    required this.id,
    required this.name,
    required this.address,
    this.city,
    this.acceptsNewRequests = true,
    this.isBlock = true,
  });
}
