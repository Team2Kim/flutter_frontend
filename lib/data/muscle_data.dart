import '../model/muscle_model.dart';

class MuscleData {
  static final List<MuscleModel> allMuscles = [
    // head (머리)
    MuscleModel(
      name: '얼굴근육군',
      upperLowerBody: '상체',
      bodyPart: 'head',
      description: '얼굴 표정을 만드는 근육들',
    ),

    // neck (목)
    MuscleModel(
      name: '흉쇄유돌근',
      upperLowerBody: '상체',
      bodyPart: 'neck',
      description: '머리 회전, 경부 근육',
    ),
    MuscleModel(
      name: '승모근상부',
      upperLowerBody: '상체',
      bodyPart: 'neck',
      description: '목과 어깨 연결 근육',
    ),

    // shoulder (어깨)
    MuscleModel(
      name: '어깨세모근',
      upperLowerBody: '상체',
      bodyPart: 'leftShoulder',
      description: '어깨 외측, 팔을 들어올림',
    ),
    MuscleModel(
      name: '어깨세모근',
      upperLowerBody: '상체',
      bodyPart: 'rightShoulder',
      description: '어깨 외측, 팔을 들어올림',
    ),
    MuscleModel(
      name: '상부승모근',
      upperLowerBody: '상체',
      bodyPart: 'leftShoulder',
      description: '어깨를 들어올리는 근육',
    ),
    MuscleModel(
      name: '상부승모근',
      upperLowerBody: '상체',
      bodyPart: 'rightShoulder',
      description: '어깨를 들어올리는 근육',
    ),
    MuscleModel(
      name: '회전근개',
      upperLowerBody: '상체',
      bodyPart: 'leftShoulder',
      description: '어깨 관절 안정화',
    ),
    MuscleModel(
      name: '회전근개',
      upperLowerBody: '상체',
      bodyPart: 'rightShoulder',
      description: '어깨 관절 안정화',
    ),

    // upperArm (상완)
    MuscleModel(
      name: '이두근',
      upperLowerBody: '상체',
      bodyPart: 'leftUpperArm',
      description: '팔 앞쪽 (이두근)',
    ),
    MuscleModel(
      name: '이두근',
      upperLowerBody: '상체',
      bodyPart: 'rightUpperArm',
      description: '팔 앞쪽 (이두근)',
    ),
    MuscleModel(
      name: '삼두근',
      upperLowerBody: '상체',
      bodyPart: 'leftUpperArm',
      description: '팔 뒤쪽 (삼두근)',
    ),
    MuscleModel(
      name: '삼두근',
      upperLowerBody: '상체',
      bodyPart: 'rightUpperArm',
      description: '팔 뒤쪽 (삼두근)',
    ),
    MuscleModel(
      name: '상완근',
      upperLowerBody: '상체',
      bodyPart: 'leftUpperArm',
      description: '팔꿈치 굴곡',
    ),
    MuscleModel(
      name: '상완근',
      upperLowerBody: '상체',
      bodyPart: 'rightUpperArm',
      description: '팔꿈치 굴곡',
    ),

    // elbow (팔꿈치)
    MuscleModel(
      name: '팔꿈치근',
      upperLowerBody: '상체',
      bodyPart: 'leftElbow',
      description: '팔꿈치 관절 안정화',
    ),
    MuscleModel(
      name: '팔꿈치근',
      upperLowerBody: '상체',
      bodyPart: 'rightElbow',
      description: '팔꿈치 관절 안정화',
    ),

    // lowerArm (하완)
    MuscleModel(
      name: '전완근군',
      upperLowerBody: '상체',
      bodyPart: 'leftLowerArm',
      description: '팔뚝 근육들',
    ),
    MuscleModel(
      name: '전완근군',
      upperLowerBody: '상체',
      bodyPart: 'rightLowerArm',
      description: '팔뚝 근육들',
    ),
    MuscleModel(
      name: '손목굴곡근',
      upperLowerBody: '상체',
      bodyPart: 'leftLowerArm',
      description: '손목을 구부리는 근육',
    ),
    MuscleModel(
      name: '손목굴곡근',
      upperLowerBody: '상체',
      bodyPart: 'rightLowerArm',
      description: '손목을 구부리는 근육',
    ),
    MuscleModel(
      name: '손목신전근',
      upperLowerBody: '상체',
      bodyPart: 'leftLowerArm',
      description: '손목을 펴는 근육',
    ),
    MuscleModel(
      name: '손목신전근',
      upperLowerBody: '상체',
      bodyPart: 'rightLowerArm',
      description: '손목을 펴는 근육',
    ),

    // hand (손)
    MuscleModel(
      name: '손가락굴곡근',
      upperLowerBody: '상체',
      bodyPart: 'leftHand',
      description: '손가락을 구부리는 근육',
    ),
    MuscleModel(
      name: '손가락굴곡근',
      upperLowerBody: '상체',
      bodyPart: 'rightHand',
      description: '손가락을 구부리는 근육',
    ),
    MuscleModel(
      name: '손가락신전근',
      upperLowerBody: '상체',
      bodyPart: 'leftHand',
      description: '손가락을 펴는 근육',
    ),
    MuscleModel(
      name: '손가락신전근',
      upperLowerBody: '상체',
      bodyPart: 'rightHand',
      description: '손가락을 펴는 근육',
    ),

    // upperBody (상체)
    MuscleModel(
      name: '큰가슴근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '흉부 전면의 주요 근육',
    ),
    MuscleModel(
      name: '넓은등근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '등 아래쪽, 팔을 뒤로 당김',
    ),
    MuscleModel(
      name: '전거근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '갈비뼈 측면의 근육',
    ),
    MuscleModel(
      name: '대원근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '팔을 내리는 근육',
    ),
    MuscleModel(
      name: '소원근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '팔을 회전시키는 근육',
    ),
    MuscleModel(
      name: '대마름근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '어깨뼈를 안정화하는 근육',
    ),
    MuscleModel(
      name: '소마름근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '어깨뼈를 들어올리는 근육',
    ),

    // abdomen (복부)
    MuscleModel(
      name: '배곧은근',
      upperLowerBody: '상체',
      bodyPart: 'abdomen',
      description: '복부 중앙, 윗몸일으키기 관여',
    ),
    MuscleModel(
      name: '외복사근',
      upperLowerBody: '상체',
      bodyPart: 'abdomen',
      description: '복부 측면, 옆구리 근육',
    ),
    MuscleModel(
      name: '내복사근',
      upperLowerBody: '상체',
      bodyPart: 'abdomen',
      description: '외복사근 아래 깊은 근육',
    ),
    MuscleModel(
      name: '횡복근',
      upperLowerBody: '상체',
      bodyPart: 'abdomen',
      description: '가장 깊은 복부 근육',
    ),

    // lowerBody (하체)
    MuscleModel(
      name: '큰볼기근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '둔근 중 가장 큰 근육',
    ),
    MuscleModel(
      name: '중간볼기근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '둔근, 다리 벌림',
    ),
    MuscleModel(
      name: '작은볼기근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '둔근, 엉덩이 외측',
    ),

    // upperLeg (대퇴)
    MuscleModel(
      name: '대퇴사두근',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '허벅지 앞쪽 (대퇴사두근)',
    ),
    MuscleModel(
      name: '대퇴사두근',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '허벅지 앞쪽 (대퇴사두근)',
    ),
    MuscleModel(
      name: '햄스트링',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '허벅지 뒤쪽 (햄스트링)',
    ),
    MuscleModel(
      name: '햄스트링',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '허벅지 뒤쪽 (햄스트링)',
    ),
    MuscleModel(
      name: '내전근군',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '허벅지 안쪽 근육',
    ),
    MuscleModel(
      name: '내전근군',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '허벅지 안쪽 근육',
    ),
    MuscleModel(
      name: '외전근군',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '허벅지 바깥쪽 근육',
    ),
    MuscleModel(
      name: '외전근군',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '허벅지 바깥쪽 근육',
    ),

    // knee (무릎)
    MuscleModel(
      name: '슬개골',
      upperLowerBody: '하체',
      bodyPart: 'leftKnee',
      description: '무릎 관절 안정화',
    ),
    MuscleModel(
      name: '슬개골',
      upperLowerBody: '하체',
      bodyPart: 'rightKnee',
      description: '무릎 관절 안정화',
    ),

    // lowerLeg (하퇴)
    MuscleModel(
      name: '장딴지근',
      upperLowerBody: '하체',
      bodyPart: 'leftLowerLeg',
      description: '종아리 뒤쪽 표면 근육',
    ),
    MuscleModel(
      name: '장딴지근',
      upperLowerBody: '하체',
      bodyPart: 'rightLowerLeg',
      description: '종아리 뒤쪽 표면 근육',
    ),
    MuscleModel(
      name: '가자미근',
      upperLowerBody: '하체',
      bodyPart: 'leftLowerLeg',
      description: '종아리 뒤쪽 깊은 근육',
    ),
    MuscleModel(
      name: '가자미근',
      upperLowerBody: '하체',
      bodyPart: 'rightLowerLeg',
      description: '종아리 뒤쪽 깊은 근육',
    ),
    MuscleModel(
      name: '앞정강근',
      upperLowerBody: '하체',
      bodyPart: 'leftLowerLeg',
      description: '정강이 앞쪽 근육',
    ),
    MuscleModel(
      name: '앞정강근',
      upperLowerBody: '하체',
      bodyPart: 'rightLowerLeg',
      description: '정강이 앞쪽 근육',
    ),

    // foot (발)
    MuscleModel(
      name: '족근굴곡근',
      upperLowerBody: '하체',
      bodyPart: 'leftFoot',
      description: '발목을 구부리는 근육',
    ),
    MuscleModel(
      name: '족근굴곡근',
      upperLowerBody: '하체',
      bodyPart: 'rightFoot',
      description: '발목을 구부리는 근육',
    ),
    MuscleModel(
      name: '족근신전근',
      upperLowerBody: '하체',
      bodyPart: 'leftFoot',
      description: '발목을 펴는 근육',
    ),
    MuscleModel(
      name: '족근신전근',
      upperLowerBody: '하체',
      bodyPart: 'rightFoot',
      description: '발목을 펴는 근육',
    ),
    MuscleModel(
      name: '족저근',
      upperLowerBody: '하체',
      bodyPart: 'leftFoot',
      description: '발바닥 근육',
    ),
    MuscleModel(
      name: '족저근',
      upperLowerBody: '하체',
      bodyPart: 'rightFoot',
      description: '발바닥 근육',
    ),
  ];

  static List<MuscleModel> getMusclesByBodyPart(String bodyPart) {
    return allMuscles.where((muscle) => muscle.bodyPart == bodyPart).toList();
  }

  static List<MuscleModel> getMusclesByUpperLowerBody(String upperLowerBody) {
    return allMuscles.where((muscle) => muscle.upperLowerBody == upperLowerBody).toList();
  }

  static List<String> getBodyParts(String upperLowerBody) {
    return allMuscles
        .where((muscle) => muscle.upperLowerBody == upperLowerBody)
        .map((muscle) => muscle.bodyPart)
        .toSet()
        .toList();
  }

  static List<String> getUpperLowerBodyList() {
    return ['상체', '하체'];
  }

  // 영어 부위명을 한국어로 매핑하는 함수
  static String getKoreanBodyPartName(String englishBodyPart) {
    switch (englishBodyPart) {
      case 'head':
        return '머리';
      case 'neck':
        return '목';
      case 'leftShoulder':
      case 'rightShoulder':
        return '어깨';
      case 'leftUpperArm':
      case 'rightUpperArm':
        return '상완';
      case 'leftElbow':
      case 'rightElbow':
        return '팔꿈치';
      case 'leftLowerArm':
      case 'rightLowerArm':
        return '하완';
      case 'leftHand':
      case 'rightHand':
        return '손';
      case 'upperBody':
        return '상체';
      case 'abdomen':
        return '복부';
      case 'lowerBody':
        return '하체';
      case 'leftUpperLeg':
      case 'rightUpperLeg':
        return '대퇴';
      case 'leftKnee':
      case 'rightKnee':
        return '무릎';
      case 'leftLowerLeg':
      case 'rightLowerLeg':
        return '하퇴';
      case 'leftFoot':
      case 'rightFoot':
        return '발';
      default:
        return englishBodyPart;
    }
  }
}