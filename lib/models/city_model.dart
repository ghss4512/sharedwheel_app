class CityModel {
  final int id;
  final String cityName;
  final String province;
  final double? latitude;
  final double? longitude;
  final bool isActive;

  CityModel({
    required this.id,
    required this.cityName,
    required this.province,
    this.latitude,
    this.longitude,
    required this.isActive,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      cityName: json['city_name'] ?? '',
      province: json['province'] ?? '',
      latitude: json['latitude'] == null
          ? null
          : double.tryParse(json['latitude'].toString()),
      longitude: json['longitude'] == null
          ? null
          : double.tryParse(json['longitude'].toString()),
      isActive: json['is_active'].toString() == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city_name': cityName,
      'province': province,
      'latitude': latitude,
      'longitude': longitude,
      'is_active': isActive ? 1 : 0,
    };
  }

  @override
  String toString() => cityName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
