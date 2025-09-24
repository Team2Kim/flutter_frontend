import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gukminexdiary/model/facility_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gukminexdiary/model/geocoding_model.dart';
import 'package:gukminexdiary/config/api_config.dart';


class FacilityService {
  final String baseUrl = ApiConfig.baseUrl;
  final String facilityEndpoint = ApiConfig.facilityEndpoint;

  Future<List<FacilityModelResponse>> getFacilities(double lat, double lon, int rad) async {
    final response = await http.get(Uri.parse('${facilityEndpoint}/map?lat=${lat}&lon=${lon}&rad=${rad}'));
    print('response: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> items = jsonDecode(response.body);
      final List<FacilityModelResponse> facilities = items.map((item) => FacilityModelResponse.fromJson(item)).toList();
      return facilities;
    } else {
      throw Exception('Failed to load facilities');
    }
  }

  Future<List<FacilityModelResponse>> getFacilities_page(double lat, double lon, int size, int page) async {
    final response = await http.get(Uri.parse('${facilityEndpoint}/list?lat=${lat}&lon=${lon}&size=${size}&page=${page}'));
    print('response: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> items = data['content'];
      final List<FacilityModelResponse> facilities = items.map((item) => FacilityModelResponse.fromJson(item)).toList();
      return facilities;
    } else {
      throw Exception('Failed to load facilities');
    }
  }

  Future<List<FacilityModelResponse>> getFacilities_example() async {
    return [
      FacilityModelResponse(
        facilityId: 1, 
        name: '수원체력인증센터', 
        groupName: '체육센터',
        typeName: '체력인증센터',
        categoryName: '체력인증센터',
        status: '운영',
        postalCode: '12345',
        roadAddress: '경기 수원시 영통구 광교산로 154-42 경기대학교 성신관2강의동 지하2003호',
        latitude: 37.2996813,
        longitude: 127.0335522,
        phoneNumber: '0507-1324-8052',
        isNation: 'Y',
        lastUpdateDate: '2024-01-01T00:00:00',
        distance: 0.5,
      ),
      FacilityModelResponse(
        facilityId: 2, 
        name: '안산체력인증센터', 
        groupName: '체육센터',
        typeName: '체력인증센터',
        categoryName: '체력인증센터',
        status: '운영',
        postalCode: '12345',
        roadAddress: '경기 안산시 상록구 한양대학로 55 체육관',
        latitude: 37.2967403,
        longitude: 126.8352371,
        phoneNumber: '0507-1359-1485',
        isNation: 'Y',
        lastUpdateDate: '2024-01-01T00:00:00',
        distance: 1.2,
      ),
      FacilityModelResponse(
        facilityId: 3, 
        name: '화성체력인증센터', 
        groupName: '체육센터',
        typeName: '체력인증센터',
        categoryName: '체력인증센터',
        status: '운영',
        postalCode: '12345',
        roadAddress: '경기도 화성시 봉담읍 동화리 18 406-1) 화성국민체육센터 B1',
        latitude: 37.2208397,
        longitude: 126.9517371,
        phoneNumber: '031-278-7548',
        isNation: 'Y',
        lastUpdateDate: '2024-01-01T00:00:00',
        distance: 2.1,
      ),
    ];
  }
    
  Future<GeocodingModelResponse> getGeoCoding(FacilityModelResponse facility) async {
    try {
      print('지오코딩 요청 주소: ${facility.roadAddress}');
      // print(dotenv.env['NAVER_MAP_CLIENT_ID']);
      // print(dotenv.env['NAVER_MAP_CLIENT_SECRET']);
      final response = await http.get(
        headers: {
          'X-NCP-APIGW-API-KEY-ID': dotenv.env['NAVER_MAP_CLIENT_ID'] ?? '',
          'X-NCP-APIGW-API-KEY': dotenv.env['NAVER_MAP_CLIENT_SECRET'] ?? '',
          'Accept': 'application/json',
        },
        Uri.parse('https://maps.apigw.ntruss.com/map-geocode/v2/geocode?query=${Uri.encodeComponent(facility.roadAddress!)}'),
      );
      
      // print('응답 상태 코드: ${response.statusCode}');
      // print('응답 본문: ${response.body}');
      
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('빈 응답을 받았습니다');
        }
        return GeocodingModelResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('API 호출 실패: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('지오코딩 API 오류: $e');
      rethrow;
    }
  }
}