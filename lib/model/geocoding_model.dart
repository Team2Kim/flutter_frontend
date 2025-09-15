class Address {
  final String roadAddress;
  final String jibunAddress;
  final String englishAddress;
  final List<AddressElement> addressElements;
  final double? x;
  final double? y;
  final double? distance;
  Address({
    required this.roadAddress,
    required this.jibunAddress,
    required this.englishAddress,
    required this.addressElements,
    this.x,
    this.y,
    this.distance,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      roadAddress: json['roadAddress']?.toString() ?? '',
      jibunAddress: json['jibunAddress']?.toString() ?? '',
      englishAddress: json['englishAddress']?.toString() ?? '',
      addressElements: (json['addressElements'] as List?)
          ?.map((addressElement) => AddressElement.fromJson(addressElement))
          .toList() ?? [],
      x: json['x'] != null ? double.tryParse(json['x'].toString()) : null,
      y: json['y'] != null ? double.tryParse(json['y'].toString()) : null,
      distance: json['distance'] != null ? double.tryParse(json['distance'].toString()) : null,
    );
  }
}

class AddressElement {
  final List<dynamic> types;
  final String longName;
  final String shortName;
  final String code;

  AddressElement({
    required this.types,
    required this.longName,
    required this.shortName,
    required this.code,
  });

  factory AddressElement.fromJson(Map<String, dynamic> json) {
    return AddressElement(
      types: (json['types'] as List?) ?? [],
      longName: json['longName']?.toString() ?? '',
      shortName: json['shortName']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
    );
  }
}

class Meta {
  final int totalCount;
  final int page;
  final int count;
  Meta({
    required this.totalCount,
    required this.page,
    required this.count,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      totalCount: json['totalCount']?.toInt() ?? 0,
      page: json['page']?.toInt() ?? 1,
      count: json['count']?.toInt() ?? 0,
    );
  }
}

class GeocodingModelResponse {
  final Meta meta;
  final String status;
  final List<Address> addresses;
  final String? errorMessage;

  GeocodingModelResponse({
    required this.meta,
    required this.status,
    required this.addresses,
    this.errorMessage,
  });

  factory GeocodingModelResponse.fromJson(Map<String, dynamic> json) {
    return GeocodingModelResponse(
      meta: Meta.fromJson(json['meta']),
      status: json['status'].toString(),
      addresses: (json['addresses'] as List?)
          ?.map((address) => Address.fromJson(address))
          .toList() ?? [],
      errorMessage: json['errorMessage']?.toString(),
    );
  }
}