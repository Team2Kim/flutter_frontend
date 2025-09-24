class FacilityModelResponse {
  final int facilityId;
  final String name;
  final String? groupName;
  final String? typeName;
  final String? categoryName;
  final String? status;
  final String? postalCode;
  final String? roadAddress;
  final double? latitude;
  final double? longitude;
  final String? phoneNumber;
  final String? lastUpdateDate;
  final String? isNation;
  final double? distance;


  FacilityModelResponse(
    {
      required this.facilityId, 
      required this.name, 
      this.groupName, 
      this.typeName,
      this.categoryName, 
      this.status, 
      this.postalCode, 
      this.roadAddress, 
      this.latitude, 
      this.longitude, 
      this.phoneNumber, 
      this.isNation, 
      this.lastUpdateDate,
      this.distance,
    }
  );

  factory FacilityModelResponse.fromJson(Map<String, dynamic> json) {
    return FacilityModelResponse(
      facilityId: json['facilityId'],
      name: json['name'],
      groupName: json['groupName'],
      typeName: json['typeName'],
      categoryName: json['categoryName'],
      status: json['status'],
      postalCode: json['postalCode'],
      roadAddress: json['roadAddress'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      phoneNumber: json['phoneNumber'],
      isNation: json['isNation'],
      lastUpdateDate: json['lastUpdateDate'],
      distance: json['distance']?.toDouble(),
    );
  }
}