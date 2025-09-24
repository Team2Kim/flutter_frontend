import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';
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
  Position? _currentLocation;

  void setMapController(NaverMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  NaverMap? get map => _map;
  bool get isMapReady => _isMapReady;

  Future<void> initMap(NCameraPosition initialCameraPosition, FacilityProvider facilityProvider) async {
    _map = NaverMap(
      options: NaverMapViewOptions(
        contentPadding: safeAreaPadding,
        initialCameraPosition: initialCameraPosition,
      ),
      onMapReady: (controller) {
        _mapController = controller;
        setCurrentLocation();
        setFocusLocation(facilityProvider.focusLocation, facilityProvider);
      },
      onCameraIdle: () async {
        setFocusLocation(facilityProvider.focusLocation, facilityProvider);
      },
    );
    _isMapReady = true;
    notifyListeners();
  }

  Future<void> setCurrentLocation() async {
    _currentLocation = await Geolocator.getCurrentPosition();
    _myLocationMarker = NMarker(
      iconTintColor: const Color.fromARGB(255, 0, 0, 0),
      size: NSize(30, 40),
      id: 'myLocationMarker',
      position: NLatLng(_currentLocation!.latitude, _currentLocation!.longitude),
      caption: NOverlayCaption(text: '내 위치'),
    );
    _mapController!.addOverlay(_myLocationMarker!);
  }

  void setFocusLocation(NLatLng location, FacilityProvider facilityProvider) {
    final cameraPosition = _mapController!.nowCameraPosition;
    facilityProvider.setFocusLocation(location.latitude, location.longitude);
    print('cameraPosition: ${cameraPosition}');
    _mapController!.deleteOverlay(NOverlayInfo(type: NOverlayType.marker, id: 'focusedMarker'));
    _focusedMarker = NMarker(
      iconTintColor: const Color.fromARGB(255, 17, 0, 255),
      size: NSize(30, 40),
      id: 'focusedMarker',
      position: NLatLng(cameraPosition.target.latitude, cameraPosition.target.longitude),
      // caption: NOverlayCaption(text: '선택된 위치'),
    );
    _mapController!.addOverlay(_focusedMarker!);
    notifyListeners();
  }

  Future<void> updateFacilityMarkers(BuildContext context, FacilityProvider facilityProvider, ScrollController scrollController) async {
    print('facilityProvider.locations.length: ${facilityProvider.locations.length}');
    for (int i = 0; i < facilityProvider.locations.length; i++) {
      final location = facilityProvider.locations[i];
      final marker = NMarker(
        size: NSize(20, 30),
        iconTintColor: const Color.fromARGB(255, 139, 139, 139),
        //icon: NOverlayImage.fromAssetImage('assets/images/sub_logo.png'),
        id: location.facilityId.toString(),
        position: NLatLng(location.latitude!, location.longitude!),
        caption: NOverlayCaption(text: location.name),
      );
      
      // 마커 클릭 이벤트 추가
      marker.setOnTapListener((overlay) async {
        facilityProvider.setFocusLocation(location.latitude!, location.longitude!);
        facilityProvider.setFocusLocationIndex(i);
        
        // ListView를 선택된 시설로 스크롤
        scrollController.animateTo(
          MediaQuery.of(context).size.width * 0.8 * i,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        
        // 지도 카메라 업데이트
        await _mapController!.updateCamera(
          NCameraUpdate.withParams(
            target: NLatLng(location.latitude!, location.longitude!),
            zoom: 16,
          ),
        );
      });
      
      _mapController!.addOverlay(marker);
    }
  }
}