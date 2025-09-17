import 'package:flutter/material.dart';
import 'package:gukminexdiary/model/geocoding_model.dart';
import 'package:gukminexdiary/services/facility_service.dart';
import 'package:gukminexdiary/model/facility_model.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class FacilityProvider extends ChangeNotifier {
  // 현재 시설 검색 상태
  final FacilityService _facilityService = FacilityService();
  bool _isSearching = false;
  List<FacilityModelResponse> _locations = [];
  int _focusLocationIndex = 0;

  NLatLng _focusLocation = NLatLng(37.6304351, 127.0378089);
  GeocodingModelResponse _geoCoding = GeocodingModelResponse(meta: Meta(totalCount: 0, page: 0, count: 0), status: '', addresses: []);

  // Getters
  bool get isSearching => _isSearching;
  List<FacilityModelResponse> get locations => _locations;
  NLatLng get focusLocation => _focusLocation;
  GeocodingModelResponse get geoCoding => _geoCoding;
  int get focusLocationIndex => _focusLocationIndex;

  // Setters
  void setIsSearching(bool isSearching) {
    _isSearching = isSearching;
    notifyListeners();
  }

  void setFocusLocation(double la, double lo) {
    _focusLocation = NLatLng(la, lo);
    notifyListeners();
  }

  void setFocusLocationIndex(int index) {
    _focusLocationIndex = index;
    notifyListeners();
  }


  void setGeoCoding(FacilityModelResponse facility) async {
    _geoCoding = await _facilityService.getGeoCoding(facility);
    notifyListeners();
  }

  void getLocations() async {
    var fetchedLocations = await _facilityService.getFacilities_example();
    _locations = fetchedLocations;
    print('locations: $_locations');
    if (_locations.isNotEmpty) {
        _focusLocation = NLatLng(_locations.first.latitude!, _locations.first.longitude!);
      }
    notifyListeners();
  }
}