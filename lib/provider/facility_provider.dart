import 'package:flutter/material.dart';
import 'package:gukminexdiary/model/geocoding_model.dart';
import 'package:gukminexdiary/services/facility_service.dart';
import 'package:gukminexdiary/model/facility_model.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class FacilityProvider extends ChangeNotifier {
  // 현재 시설 검색 상태
  final FacilityService _facilityService = FacilityService();
  bool _isSearching = false;
  List<FacilityModelResponse> _locations = [];
  int _focusLocationIndex = 0;
  bool _hasMoreData = true;
  int _currentPage = 0;
  final int _pageSize = 20;
  Position? _currentPosition;
  bool _isLoadingMore = false;
  int _type = 0; //검색 방식 0: 이름 검색, 1: 조건 검색
  String? _keyword;
  NLatLng _focusLocation = NLatLng(37.6304351, 127.0378089);
  GeocodingModelResponse _geoCoding = GeocodingModelResponse(meta: Meta(totalCount: 0, page: 0, count: 0), status: '', addresses: []);
  List<String> _keywords = [];
  TextEditingController _keywordController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  // Getters
  bool get isSearching => _isSearching;
  List<FacilityModelResponse> get locations => _locations;
  NLatLng get focusLocation => _focusLocation;
  GeocodingModelResponse get geoCoding => _geoCoding;
  int get focusLocationIndex => _focusLocationIndex;
  bool get hasMoreData => _hasMoreData;
  bool get isLoadingMore => _isLoadingMore;
  Position? get currentPosition => _currentPosition;
  String? get keyword => _keyword;
  int get pageSize => _pageSize;
  int get currentPage => _currentPage;
  int get type => _type;
  List<String> get keywords => _keywords;
  TextEditingController get keywordController => _keywordController;
  TextEditingController get searchController => _searchController;


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

  void toggleType() {
    _type = _type == 0 ? 1 : 0;
    notifyListeners();
  }

  void resetKeyword() {
    _keyword = '';
    notifyListeners();
  }
  
  void addKeyword(String keyword) {
    if (keyword.isEmpty) return;
    _keywords.add(keyword);
    notifyListeners();
  }

  void removeKeyword(String keyword) {
    _keywords.remove(keyword);
    notifyListeners();
  }

  void setGeoCoding(FacilityModelResponse facility) async {
    _geoCoding = await _facilityService.getGeoCoding(facility);
    notifyListeners();
  }

  void getLocations() async {
    var fetchedLocations = await _facilityService.getFacilities_example();
    _locations = fetchedLocations;
    // print('locations: $_locations');
    if (_locations.isNotEmpty) {
        _focusLocation = NLatLng(_locations.first.latitude!, _locations.first.longitude!);
      }
    notifyListeners();
  }

  // 위치 권한 요청
  Future<bool> _requestLocationPermission() async {
    final status = await Permission.location.request();
    return status == PermissionStatus.granted;
  }

  // 현재 위치 가져오기
  Future<Position?> getCurrentLocation() async {
    try {
      // 위치 권한 확인
      if (!await _requestLocationPermission()) {
        print('위치 권한이 거부되었습니다.');
        return null;
      }

      // 위치 서비스 활성화 확인
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('위치 서비스가 비활성화되어 있습니다.');
        return null;
      }

      // 현재 위치 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      _currentPosition = position;
      return position;
    } catch (e) {
      print('위치 가져오기 실패: $e');
      return null;
    }
  }

  // 거리 계산 (km)
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  // 위치 기반 시설 검색 (초기 로드)
  Future<void> searchNearbyFacilities() async {
    try {
      _isSearching = true;
      _currentPage = 0;
      _hasMoreData = true;
      _locations.clear();
      notifyListeners();

      // 현재 위치 가져오기
      Position? position = await getCurrentLocation();
      if (position == null) {
        print('위치를 가져올 수 없습니다.');
        _isSearching = false;
        notifyListeners();
        return;
      }

      // 3km 이내 시설 검색 (10개씩)
      List<FacilityModelResponse> facilities = await _facilityService.getFacilities_page(
        position.latitude,
        position.longitude,
        _pageSize,
        _currentPage,
      );

      // 3km 이내 시설만 필터링 (API에서 제공하는 distance 사용, 미터 단위)
      List<FacilityModelResponse> nearbyFacilities = facilities.where((facility) {
        return facility.distance != null && facility.distance! <= 3000;
      }).toList();

      _locations = nearbyFacilities;
      _currentPage = 0;
      _hasMoreData = nearbyFacilities.length >= 10; // 10개 미만이면 더 이상 데이터 없음

      if (_locations.isNotEmpty) {
        _focusLocation = NLatLng(_locations.first.latitude!, _locations.first.longitude!);
      }

      _isSearching = false;
      notifyListeners();
    } catch (e) {
      print('근처 시설 검색 실패: $e');
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> searchFacilities(String? keyword) async {
    _isSearching = true;
    _currentPage = 0;
    _hasMoreData = true;
    _locations.clear();
    _keyword = keyword;
    notifyListeners();
    
    List<FacilityModelResponse> facilities = [];

    if (_type == 0) {
      facilities = await _facilityService.getFacilities_search(
        _focusLocation.latitude,
        _focusLocation.longitude,
        _keyword!,
        _pageSize,
        _currentPage,
      );
    } else {
      facilities = await _facilityService.getFacilities_search_by_keywords(
        _focusLocation.latitude,
        _focusLocation.longitude,
        _keywords,
        _pageSize,
        _currentPage,
      );
    }
        // 3km 이내 시설만 필터링 (API에서 제공하는 distance 사용, 미터 단위)
    List<FacilityModelResponse> nearbyFacilities = facilities.where((facility) {
      return facility.distance != null && facility.distance! <= 3000;
    }).toList();

    _locations = nearbyFacilities;
    _currentPage = 0;
    _hasMoreData = nearbyFacilities.length >= 10; // 10개 미만이면 더 이상 데이터 없음

    if (_locations.isNotEmpty) {
      _focusLocation = NLatLng(_locations.first.latitude!, _locations.first.longitude!);
    }

    _isSearching = false;
    notifyListeners();
  }

  // 더 많은 시설 로드 (무한 스크롤)
  Future<void> loadMoreFacilities() async {
    if (_isLoadingMore || !_hasMoreData || _currentPosition == null) return;

    try {
      _isLoadingMore = true;
      List<FacilityModelResponse> facilities = [];
      notifyListeners();

      _currentPage++;
      // print('currentPage: $_currentPage');
      if ((_keyword != null || _keyword != '') && _type == 0) {
        print("이름 검색 실행");
        facilities = await _facilityService.getFacilities_search(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          _keyword!,
          _pageSize,
          _currentPage,
        );
      } else if (_keywords.isNotEmpty && _type == 1) {
        print("조건 검색 실행");
        facilities = await _facilityService.getFacilities_search_by_keywords(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          _keywords, 
          _pageSize, 
          _currentPage
        );
      } else {  
        print("기본 검색 실행");
        facilities = await _facilityService.getFacilities_page(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          _pageSize,
          _currentPage,
        );
      }

      // print('nearbyFacilities: $facilities');

      // 3km 이내 시설만 필터링 (API에서 제공하는 distance 사용, 미터 단위)
      List<FacilityModelResponse> nearbyFacilities = facilities.where((facility) {
        return facility.distance != null && facility.distance! <= 3000;
      }).toList();

      // print('nearbyFacilities: $nearbyFacilities');

      if (nearbyFacilities.isEmpty) {
        _hasMoreData = false;
      } else {
        _locations.addAll(nearbyFacilities);
        _hasMoreData = nearbyFacilities.length >= 10; // 10개 미만이면 더 이상 데이터 없음
      }


      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      print('더 많은 시설 로드 실패: $e');
      _isLoadingMore = false;
      _hasMoreData = false;
      notifyListeners();
    }
  }

  void resetFacilities() {
    _locations.clear();
    _currentPage = 0;
    _hasMoreData = true;
    notifyListeners();
  }

  // 지도 중심 위치 기반 시설 검색 (map_search_screen용)
  Future<void> searchFacilitiesByMapCenter(double lat, double lon) async {
    try {
      _isSearching = true;
      _currentPage = 0;
      _hasMoreData = true;
      _locations.clear();
      notifyListeners();

      // 3km 이내 시설 검색 (10개씩)
      List<FacilityModelResponse> facilities = await _facilityService.getFacilities_page(
        lat,
        lon,
        _pageSize,
        _currentPage,
      );

      // 3km 이내 시설만 필터링 (API에서 제공하는 distance 사용, 미터 단위)
      List<FacilityModelResponse> nearbyFacilities = facilities.where((facility) {
        return facility.distance != null && facility.distance! <= 3000;
      }).toList();

      _locations = nearbyFacilities;
      _currentPage = 0;
      _hasMoreData = nearbyFacilities.length >= 10;

      if (_locations.isNotEmpty) {
        _focusLocation = NLatLng(_locations.first.latitude!, _locations.first.longitude!);
      }

      _isSearching = false;
      notifyListeners();
    } catch (e) {
      print('지도 중심 시설 검색 실패: $e');
      _isSearching = false;
      notifyListeners();
    }
  }
}