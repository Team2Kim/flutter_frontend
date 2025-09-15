class FacilityModelResponse {
  final int facilityId;
  final String name;
  final String? groupName;
  final String? categoryName;
  final String? status;
  final String? postalCode;
  final String? roadAddress;
  final double? latitude;
  final double? longitude;
  final String? phoneNumber;
  final DateTime? lastUpdateDate;
  final String? isNation;


  FacilityModelResponse(
    {
      required this.facilityId, 
      required this.name, 
      this.groupName, 
      this.categoryName, 
      this.status, 
      this.postalCode, 
      this.roadAddress, 
      this.latitude, 
      this.longitude, 
      this.phoneNumber, 
      this.isNation, 
      this.lastUpdateDate,
    }
  );

  factory FacilityModelResponse.fromJson(Map<String, dynamic> json) {
    return FacilityModelResponse(
      facilityId: json['facilityId'],
      name: json['name'],
      groupName: json['groupName'],
      categoryName: json['categoryName'],
      status: json['status'],
      postalCode: json['postalCode'],
      roadAddress: json['roadAddress'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      phoneNumber: json['phoneNumber'],
      isNation: json['isNation'],
      lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
    );
  }
}