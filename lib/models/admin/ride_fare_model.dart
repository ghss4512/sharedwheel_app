class RideFareModel {
  final int id;

  final int fromCityId;
  final String fromCity;

  final int toCityId;
  final String toCity;

  final double farePerSeat;

  final bool isActive;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  RideFareModel({
    required this.id,
    required this.fromCityId,
    required this.fromCity,
    required this.toCityId,
    required this.toCity,
    required this.farePerSeat,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory RideFareModel.fromJson(Map<String, dynamic> json) {
    return RideFareModel(
      id: int.tryParse(json['id'].toString()) ?? 0,

      fromCityId:
      int.tryParse(json['from_city_id'].toString()) ?? 0,

      fromCity: json['from_city'] ?? '',

      toCityId:
      int.tryParse(json['to_city_id'].toString()) ?? 0,

      toCity: json['to_city'] ?? '',

      farePerSeat:
      double.tryParse(json['fare_per_seat'].toString()) ?? 0,

      isActive: json['is_active'].toString() == '1',

      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(
        json['created_at'].toString(),
      ),

      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(
        json['updated_at'].toString(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_city_id': fromCityId,
      'from_city': fromCity,
      'to_city_id': toCityId,
      'to_city': toCity,
      'fare_per_seat': farePerSeat,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String get route => '$fromCity → $toCity';

  String get fareText =>
      'Rs. ${farePerSeat.toStringAsFixed(0)}';

  String get statusText =>
      isActive ? 'ACTIVE' : 'INACTIVE';
}