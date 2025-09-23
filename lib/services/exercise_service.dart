import 'package:gukminexdiary/model/exercise_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gukminexdiary/config/api_config.dart';

class ExerciseService {
  final String baseUrl = ApiConfig.baseUrl;
  final String exerciseEndpoint = ApiConfig.exerciseEndpoint;
  final String example_data = '''
{
  "response": {
    "header": {
      "resultCode": "00",
      "resultMsg": "NORMAL SERVICE"
    },
    "body": {
      "pageNo": 1,
      "totalCount": 15045,
      "items": {
        "item": [
          {
            "file_url": "http://openapi.kspo.or.kr/web/video/",
            "snap_tm": 17.45,
            "vdo_desc": "유소년 근력/근지구력을 위한 팔/어깨운동 중, 팔굽혀펴기운동을 설명한 운동처방 가이드 동영상",
            "file_sz": 15145209,
            "file_type_nm": "mp4",
            "oper_nm": "운동처방가이드",
            "fps_cnt": 29.96,
            "row_num": 1,
            "file_nm": "0AUDLJ08S_00351.mp4",
            "resolution": "1920*1080",
            "aggrp_nm": "유소년",
            "frme_no": 523,
            "img_file_nm": "0AUDLJ08S_00351_SC_00005.jpeg",
            "img_file_url": "http://openapi.kspo.or.kr/web/image/0AUDLJ08S_00351/",
            "img_file_sn": 3,
            "fbctn_yr": "2019",
            "data_type": "동영상",
            "vdo_len": "91",
            "lang": "한국어",
            "trng_nm": "팔 굽혀 펴기(매트)",
            "job_ymd": "20221010",
            "vdo_ttl_nm": "팔굽혀펴기"
          }
        ]
      },
      "numOfRows": 1
    }
  }
}
''';
  List<ExerciseModelResponse> getExercises() {
    final json = jsonDecode(example_data);
    final items = json['response']['body']['items']['item'] as List;
    print(items.map((item) => ExerciseModelResponse.fromJson_temp(item)).toList());
    return items.map<ExerciseModelResponse>((item) => ExerciseModelResponse.fromJson_temp(item)).toList();
  }
  
  List<ExerciseModelResponse> getExercisesByBookmark() {
    final json = jsonDecode(example_data);
    final items = json['response']['body']['items']['item'] as List;
    return items.map<ExerciseModelResponse>((item) => ExerciseModelResponse.fromJson(item)).toList();
  }


  Future<List<ExerciseModelResponse>> getExercisesData(int page, int size) async {
    final response = await http.get(
      Uri.parse('$exerciseEndpoint?size=$size&page=$page'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final json = data['content'];
      print(json);
      
      // API 응답이 List인지 Map인지 확인
      if (json is List) {
        return json.map<ExerciseModelResponse>((item) => ExerciseModelResponse.fromJson(item)).toList();
      } else if (json is Map<String, dynamic>) {
        // 만약 응답이 Map이고 data 필드에 List가 있다면
        if (json.containsKey('data') && json['data'] is List) {
          final dataList = json['data'] as List;
          return dataList.map<ExerciseModelResponse>((item) => ExerciseModelResponse.fromJson(item)).toList();
        }
        // 만약 응답이 Map이고 exercises 필드에 List가 있다면
        else if (json.containsKey('exercises') && json['exercises'] is List) {
          final exercisesList = json['exercises'] as List;
          return exercisesList.map<ExerciseModelResponse>((item) => ExerciseModelResponse.fromJson(item)).toList();
        }
        // 만약 응답이 Map이고 items 필드에 List가 있다면
        else if (json.containsKey('items') && json['items'] is List) {
          final itemsList = json['items'] as List;
          return itemsList.map<ExerciseModelResponse>((item) => ExerciseModelResponse.fromJson(item)).toList();
        }
        // 단일 객체인 경우
        else {
          return [ExerciseModelResponse.fromJson(json)];
        }
      }
      
      throw Exception('Unexpected response format');
    } else {
      throw Exception('Failed to load exercises: ${response.statusCode}');
    }
  }
}
