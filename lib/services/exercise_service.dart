import 'package:gukminexdiary/model/exercise_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ExerciseService {
  final String baseUrl = 'https://api.example.com';

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
  // Future<List<ExerciseModelResponse>> getExercises() async {
  //   final response = await http.get(Uri.parse('$baseUrl/exercises'));
  //   if (response.statusCode == 200) {
  //     return ExerciseModelResponse.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load exercises');
  //   }
  // }
}
