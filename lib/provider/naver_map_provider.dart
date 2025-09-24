import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gukminexdiary/provider/facility_provider.dart';
import 'package:geolocator/geolocator.dart';

class NaverMapProvider extends ChangeNotifier {
  bool _isMapReady = false;
  NaverMapController? _mapController;
  NaverMap? _map;
  NaverMapController? get mapController => _mapController;
  final safeAreaPadding = EdgeInsets.zero;
  NMarker? _focusedMarker;
  NMarker? _myLocationMarker;
  NCameraPosition? _focusedCameraPosition;
  NCameraPosition? get focusedCameraPosition => _focusedCameraPosition;
  Position? _currentLocation;

  void setMapController(NaverMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  NaverMap? get map => _map;
  bool get isMapReady => _isMapReady;

  Future<void> initMap(NCameraPosition initialCameraPosition) async {
    _map = NaverMap(
      options: NaverMapViewOptions(
        contentPadding: safeAreaPadding,
        initialCameraPosition: initialCameraPosition,
      ),
      onMapReady: (controller) async {
        _mapController = controller;
        await setCurrentLocation();
        notifyListeners();
      },
      onCameraIdle: () {
        // 카메라 이동이 끝났을 때의 처리
        if (_mapController != null) {
          final cameraPosition = _mapController!.nowCameraPosition;
          _focusedCameraPosition = cameraPosition;
          notifyListeners();
        }
      },
    );
    _isMapReady = true;
    notifyListeners();
  }

  Future<void> setCurrentLocation() async {
    try {
      _currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      if (_mapController != null) {
        _myLocationMarker = NMarker(
          iconTintColor: const Color.fromARGB(255, 0, 0, 0),
          size: NSize(30, 40),
          id: 'myLocationMarker',
          position: NLatLng(_currentLocation!.latitude, _currentLocation!.longitude),
          caption: NOverlayCaption(text: '내 위치'),
        );
        _mapController!.addOverlay(_myLocationMarker!);
      }
    } catch (e) {
      print('현재 위치 가져오기 실패: $e');
    }
  }

  void setFocusLocation(NLatLng location, FacilityProvider facilityProvider) {
    if (_mapController == null) return;
    
    facilityProvider.setFocusLocation(location.latitude, location.longitude);
    
    // 기존 포커스 마커 제거
    _mapController!.deleteOverlay(NOverlayInfo(type: NOverlayType.marker, id: 'focusedMarker'));
    
    // 새로운 포커스 마커 추가
    _focusedMarker = NMarker(
      iconTintColor: const Color.fromARGB(255, 17, 0, 255),
      size: NSize(30, 40),
      id: 'focusedMarker',
      position: NLatLng(location.latitude, location.longitude),
      caption: NOverlayCaption(text: '선택된 위치'),
    );
    _mapController!.addOverlay(_focusedMarker!);
    
    // 지도 카메라 업데이트
    _mapController!.updateCamera(
      NCameraUpdate.withParams(
        target: NLatLng(location.latitude, location.longitude),
        zoom: 16,
      ),
    );
    notifyListeners();
  }

  Future<void> resetFacilityMarkers(FacilityProvider facilityProvider) async {
    if (_mapController == null) return;
    print('facilityProvider.locations.length: ${facilityProvider.locations.length}');
    for (int i = 0; i < facilityProvider.locations.length; i++) {
      final location = facilityProvider.locations[i];
      _mapController!.deleteOverlay(NOverlayInfo(type: NOverlayType.marker, id: location.facilityId.toString()));
    }
    notifyListeners();
  }

  Future<void> updateFacilityMarkers(BuildContext context, FacilityProvider facilityProvider, ScrollController scrollController) async {
    if (_mapController == null || !context.mounted) return;
    
    print('facilityProvider.locations.length: ${facilityProvider.locations.length}');
    
    for (int i = 0; i < facilityProvider.locations.length; i++) {
      final location = facilityProvider.locations[i];
      
      if (location.latitude == null || location.longitude == null) continue;
      
      final marker = NMarker(
        size: NSize(20, 30),
        iconTintColor: const Color.fromARGB(255, 139, 139, 139),
        id: location.facilityId.toString(),
        position: NLatLng(location.latitude!, location.longitude!),
        caption: NOverlayCaption(text: location.name),
      );
      
      // 마커 클릭 이벤트 추가
      marker.setOnTapListener((overlay) async {
        facilityProvider.setFocusLocation(location.latitude!, location.longitude!);
        facilityProvider.setFocusLocationIndex(i);
        
        // ListView를 선택된 시설로 스크롤
        if (scrollController.hasClients) {
          scrollController.animateTo(
            MediaQuery.of(context).size.width * 0.8 * i,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        
        setFocusLocation(NLatLng(location.latitude!, location.longitude!), facilityProvider);
      });
      
      _mapController!.addOverlay(marker);
    }
  }
}