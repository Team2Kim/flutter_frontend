import '../model/muscle_model.dart';

class MuscleData {
  static final List<MuscleModel> allMuscles = [
    // head (머리)
    MuscleModel(
      name: '머리가장긴근',
      upperLowerBody: '상체',
      bodyPart: 'head',
      description: '머리와 목을 지지하는 긴 근육',
    ),
    MuscleModel(
      name: '머리널판근',
      upperLowerBody: '상체',
      bodyPart: 'head',
      description: '머리와 목을 지지하는 넓은 근육',
    ),
    MuscleModel(
      name: '머리반가시근',
      upperLowerBody: '상체',
      bodyPart: 'head',
      description: '머리와 목을 지지하는 반가시근',
    ),

    // neck (목)
    MuscleModel(
      name: '목빗근',
      upperLowerBody: '상체',
      bodyPart: 'neck',
      description: '목의 빗근',
    ),
    MuscleModel(
      name: '긴목근',
      upperLowerBody: '상체',
      bodyPart: 'neck',
      description: '목을 지지하는 긴 근육',
    ),
    MuscleModel(
      name: '목/머리널판근',
      upperLowerBody: '상체',
      bodyPart: 'neck',
      description: '목과 머리를 연결하는 넓은 근육',
    ),

    // shoulder (어깨)
    MuscleModel(
      name: '어깨세모근',
      upperLowerBody: '상체',
      bodyPart: 'leftShoulder',
      description: '어깨의 세모근',
    ),
    MuscleModel(
      name: '어깨세모근',
      upperLowerBody: '상체',
      bodyPart: 'rightShoulder',
      description: '어깨의 세모근',
    ),
    MuscleModel(
      name: '중간어깨세모근',
      upperLowerBody: '상체',
      bodyPart: 'leftShoulder',
      description: '어깨의 중간 세모근',
    ),
    MuscleModel(
      name: '중간어깨세모근',
      upperLowerBody: '상체',
      bodyPart: 'rightShoulder',
      description: '어깨의 중간 세모근',
    ),
    MuscleModel(
      name: '어깨올림근',
      upperLowerBody: '상체',
      bodyPart: 'leftShoulder',
      description: '어깨를 들어올리는 근육',
    ),
    MuscleModel(
      name: '어깨올림근',
      upperLowerBody: '상체',
      bodyPart: 'rightShoulder',
      description: '어깨를 들어올리는 근육',
    ),
    MuscleModel(
      name: '어깨밑근',
      upperLowerBody: '상체',
      bodyPart: 'leftShoulder',
      description: '어깨 아래쪽 근육',
    ),
    MuscleModel(
      name: '어깨밑근',
      upperLowerBody: '상체',
      bodyPart: 'rightShoulder',
      description: '어깨 아래쪽 근육',
    ),
    MuscleModel(
      name: '돌림근',
      upperLowerBody: '상체',
      bodyPart: 'leftShoulder',
      description: '어깨를 회전시키는 근육',
    ),
    MuscleModel(
      name: '돌림근',
      upperLowerBody: '상체',
      bodyPart: 'rightShoulder',
      description: '어깨를 회전시키는 근육',
    ),
    MuscleModel(
      name: '작은원근',
      upperLowerBody: '상체',
      bodyPart: 'leftShoulder',
      description: '작은 원근',
    ),
    MuscleModel(
      name: '작은원근',
      upperLowerBody: '상체',
      bodyPart: 'rightShoulder',
      description: '작은 원근',
    ),
    MuscleModel(
      name: '큰원근',
      upperLowerBody: '상체',
      bodyPart: 'leftShoulder',
      description: '큰 원근',
    ),
    MuscleModel(
      name: '큰원근',
      upperLowerBody: '상체',
      bodyPart: 'rightShoulder',
      description: '큰 원근',
    ),

    // upperArm (상완)
    MuscleModel(
      name: '위팔세갈래근',
      upperLowerBody: '상체',
      bodyPart: 'leftUpperArm',
      description: '팔 뒤쪽의 세갈래 근육',
    ),
    MuscleModel(
      name: '위팔세갈래근',
      upperLowerBody: '상체',
      bodyPart: 'rightUpperArm',
      description: '팔 뒤쪽의 세갈래 근육',
    ),
    MuscleModel(
      name: '위팔두갈래근',
      upperLowerBody: '상체',
      bodyPart: 'leftUpperArm',
      description: '팔 앞쪽의 두갈래 근육',
    ),
    MuscleModel(
      name: '위팔두갈래근',
      upperLowerBody: '상체',
      bodyPart: 'rightUpperArm',
      description: '팔 앞쪽의 두갈래 근육',
    ),
    MuscleModel(
      name: '위팔근',
      upperLowerBody: '상체',
      bodyPart: 'leftUpperArm',
      description: '위팔의 주요 근육',
    ),
    MuscleModel(
      name: '위팔근',
      upperLowerBody: '상체',
      bodyPart: 'rightUpperArm',
      description: '위팔의 주요 근육',
    ),
    MuscleModel(
      name: '위팔노근',
      upperLowerBody: '상체',
      bodyPart: 'leftUpperArm',
      description: '위팔의 노근',
    ),
    MuscleModel(
      name: '위팔노근',
      upperLowerBody: '상체',
      bodyPart: 'rightUpperArm',
      description: '위팔의 노근',
    ),

    // lowerArm (하완)
    MuscleModel(
      name: '손목굽힘근',
      upperLowerBody: '상체',
      bodyPart: 'leftLowerArm',
      description: '손목을 구부리는 근육',
    ),
    MuscleModel(
      name: '손목굽힘근',
      upperLowerBody: '상체',
      bodyPart: 'rightLowerArm',
      description: '손목을 구부리는 근육',
    ),
    MuscleModel(
      name: '손목폄근',
      upperLowerBody: '상체',
      bodyPart: 'leftLowerArm',
      description: '손목을 펴는 근육',
    ),
    MuscleModel(
      name: '손목폄근',
      upperLowerBody: '상체',
      bodyPart: 'rightLowerArm',
      description: '손목을 펴는 근육',
    ),
    MuscleModel(
      name: '노쪽손목굽힘근',
      upperLowerBody: '상체',
      bodyPart: 'leftLowerArm',
      description: '노쪽 손목 굽힘근',
    ),
    MuscleModel(
      name: '노쪽손목굽힘근',
      upperLowerBody: '상체',
      bodyPart: 'rightLowerArm',
      description: '노쪽 손목 굽힘근',
    ),
    MuscleModel(
      name: '노쪽 손목 폄근',
      upperLowerBody: '상체',
      bodyPart: 'leftLowerArm',
      description: '노쪽 손목 폄근',
    ),
    MuscleModel(
      name: '노쪽 손목 폄근',
      upperLowerBody: '상체',
      bodyPart: 'rightLowerArm',
      description: '노쪽 손목 폄근',
    ),

    // upperBody (상체)
    MuscleModel(
      name: '큰가슴근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '가슴의 큰 근육',
    ),
    MuscleModel(
      name: '작은가슴근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '가슴의 작은 근육',
    ),
    MuscleModel(
      name: '넓은등근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '등의 넓은 근육',
    ),
    MuscleModel(
      name: '등세모근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '등의 세모근',
    ),
    MuscleModel(
      name: '마름모근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '마름모 모양의 근육',
    ),
    MuscleModel(
      name: '뒤세모근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '뒤쪽의 세모근',
    ),
    MuscleModel(
      name: '앞세모근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '앞쪽의 세모근',
    ),
    MuscleModel(
      name: '앞톱니근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '앞쪽의 톱니 모양 근육',
    ),
    MuscleModel(
      name: '등가시근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '등의 가시근',
    ),
    MuscleModel(
      name: '가시아래근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '가시 아래쪽 근육',
    ),
    MuscleModel(
      name: '가시윗근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '가시 위쪽 근육',
    ),
    MuscleModel(
      name: '가시사이근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '가시 사이의 근육',
    ),
    MuscleModel(
      name: '가로돌기사이근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '가로돌기 사이의 근육',
    ),
    MuscleModel(
      name: '바깥갈비사이근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '바깥쪽 갈비사이근',
    ),
    MuscleModel(
      name: '안쪽갈비사이근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '안쪽 갈비사이근',
    ),
    MuscleModel(
      name: '뭇갈래근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '여러 갈래로 나뉜 근육',
    ),

    // abdomen (복부)
    MuscleModel(
      name: '배곧은근',
      upperLowerBody: '상체',
      bodyPart: 'abdomen',
      description: '배의 곧은 근육',
    ),
    MuscleModel(
      name: '배바깥빗근',
      upperLowerBody: '상체',
      bodyPart: 'abdomen',
      description: '배의 바깥쪽 빗근',
    ),
    MuscleModel(
      name: '배속빗근',
      upperLowerBody: '상체',
      bodyPart: 'abdomen',
      description: '배의 속쪽 빗근',
    ),
    MuscleModel(
      name: '배가로근',
      upperLowerBody: '상체',
      bodyPart: 'abdomen',
      description: '배의 가로 근육',
    ),
    MuscleModel(
      name: '배빗근',
      upperLowerBody: '상체',
      bodyPart: 'abdomen',
      description: '배의 빗근',
    ),

    // lowerBody (하체)
    MuscleModel(
      name: '큰볼기근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '볼기의 큰 근육',
    ),
    MuscleModel(
      name: '작은볼기근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '볼기의 작은 근육',
    ),
    MuscleModel(
      name: '중간볼기근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '볼기의 중간 근육',
    ),
    MuscleModel(
      name: '볼기근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '볼기 근육',
    ),
    MuscleModel(
      name: '엉덩관절굽힘근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '엉덩관절을 굽히는 근육',
    ),
    MuscleModel(
      name: '엉덩허리근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '엉덩이와 허리를 연결하는 근육',
    ),
    MuscleModel(
      name: '엉덩근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '엉덩이 근육',
    ),
    MuscleModel(
      name: '궁둥구멍근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '궁둥구멍 근육',
    ),

    // upperLeg (대퇴)
    MuscleModel(
      name: '넙다리네갈래근',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '넙다리의 네갈래 근육',
    ),
    MuscleModel(
      name: '넙다리네갈래근',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '넙다리의 네갈래 근육',
    ),
    MuscleModel(
      name: '넙다리두갈래근',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '넙다리의 두갈래 근육',
    ),
    MuscleModel(
      name: '넙다리두갈래근',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '넙다리의 두갈래 근육',
    ),
    MuscleModel(
      name: '넙다리근막긴장근',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '넙다리 근막을 긴장시키는 근육',
    ),
    MuscleModel(
      name: '넙다리근막긴장근',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '넙다리 근막을 긴장시키는 근육',
    ),
    MuscleModel(
      name: '넙다리빗근',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '넙다리의 빗근',
    ),
    MuscleModel(
      name: '넙다리빗근',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '넙다리의 빗근',
    ),
    MuscleModel(
      name: '넙다리곧은근',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '넙다리의 곧은 근육',
    ),
    MuscleModel(
      name: '넙다리곧은근',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '넙다리의 곧은 근육',
    ),
    MuscleModel(
      name: '뒤넙다리근',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '넙다리 뒤쪽 근육',
    ),
    MuscleModel(
      name: '뒤넙다리근',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '넙다리 뒤쪽 근육',
    ),
    MuscleModel(
      name: '가쪽넓은근',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '가쪽의 넓은 근육',
    ),
    MuscleModel(
      name: '가쪽넓은근',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '가쪽의 넓은 근육',
    ),
    MuscleModel(
      name: '안쪽넓은근',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '안쪽의 넓은 근육',
    ),
    MuscleModel(
      name: '안쪽넓은근',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '안쪽의 넓은 근육',
    ),

    // lowerLeg (하퇴)
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
    MuscleModel(
      name: '뒤정강근',
      upperLowerBody: '하체',
      bodyPart: 'leftLowerLeg',
      description: '정강이 뒤쪽 근육',
    ),
    MuscleModel(
      name: '뒤정강근',
      upperLowerBody: '하체',
      bodyPart: 'rightLowerLeg',
      description: '정강이 뒤쪽 근육',
    ),
    MuscleModel(
      name: '두덩정강근',
      upperLowerBody: '하체',
      bodyPart: 'leftLowerLeg',
      description: '두덩 정강근',
    ),
    MuscleModel(
      name: '두덩정강근',
      upperLowerBody: '하체',
      bodyPart: 'rightLowerLeg',
      description: '두덩 정강근',
    ),
    MuscleModel(
      name: '가자미근',
      upperLowerBody: '하체',
      bodyPart: 'leftLowerLeg',
      description: '가자미 모양의 근육',
    ),
    MuscleModel(
      name: '가자미근',
      upperLowerBody: '하체',
      bodyPart: 'rightLowerLeg',
      description: '가자미 모양의 근육',
    ),
    MuscleModel(
      name: '장딴지근',
      upperLowerBody: '하체',
      bodyPart: 'leftLowerLeg',
      description: '장딴지 근육',
    ),
    MuscleModel(
      name: '장딴지근',
      upperLowerBody: '하체',
      bodyPart: 'rightLowerLeg',
      description: '장딴지 근육',
    ),
    MuscleModel(
      name: '장딴지세갈래근',
      upperLowerBody: '하체',
      bodyPart: 'leftLowerLeg',
      description: '장딴지의 세갈래 근육',
    ),
    MuscleModel(
      name: '장딴지세갈래근',
      upperLowerBody: '하체',
      bodyPart: 'rightLowerLeg',
      description: '장딴지의 세갈래 근육',
    ),

    // foot (발)
    MuscleModel(
      name: '긴발가락폄근',
      upperLowerBody: '하체',
      bodyPart: 'leftFoot',
      description: '긴 발가락을 펴는 근육',
    ),
    MuscleModel(
      name: '긴발가락폄근',
      upperLowerBody: '하체',
      bodyPart: 'rightFoot',
      description: '긴 발가락을 펴는 근육',
    ),
    MuscleModel(
      name: '긴엄지발가락폄근',
      upperLowerBody: '하체',
      bodyPart: 'leftFoot',
      description: '긴 엄지발가락을 펴는 근육',
    ),
    MuscleModel(
      name: '긴엄지발가락폄근',
      upperLowerBody: '하체',
      bodyPart: 'rightFoot',
      description: '긴 엄지발가락을 펴는 근육',
    ),

    // spine (척추)
    MuscleModel(
      name: '척추세움근',
      upperLowerBody: '상체',
      bodyPart: 'spine',
      description: '척추를 세우는 근육',
    ),
    MuscleModel(
      name: '허리근',
      upperLowerBody: '상체',
      bodyPart: 'spine',
      description: '허리 근육',
    ),
    MuscleModel(
      name: '허리네모근',
      upperLowerBody: '상체',
      bodyPart: 'spine',
      description: '허리의 네모근',
    ),
    MuscleModel(
      name: '허리엉덩갈비근',
      upperLowerBody: '상체',
      bodyPart: 'spine',
      description: '허리와 엉덩이, 갈비를 연결하는 근육',
    ),
    MuscleModel(
      name: '큰허리근',
      upperLowerBody: '상체',
      bodyPart: 'spine',
      description: '허리의 큰 근육',
    ),
    MuscleModel(
      name: '반막모양근',
      upperLowerBody: '상체',
      bodyPart: 'spine',
      description: '반막 모양의 근육',
    ),
    MuscleModel(
      name: '반힘줄모양근',
      upperLowerBody: '상체',
      bodyPart: 'spine',
      description: '반힘줄 모양의 근육',
    ),

    // pelvic floor (골반저)
    MuscleModel(
      name: '모음근',
      upperLowerBody: '하체',
      bodyPart: 'pelvicFloor',
      description: '골반저의 모음근',
    ),
    MuscleModel(
      name: '긴모음근',
      upperLowerBody: '하체',
      bodyPart: 'pelvicFloor',
      description: '골반저의 긴 모음근',
    ),
    MuscleModel(
      name: '짧은 모음근',
      upperLowerBody: '하체',
      bodyPart: 'pelvicFloor',
      description: '골반저의 짧은 모음근',
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

  // 근육명을 그대로 반환 (이미 정확한 서버 형식으로 설정됨)
  static String getServerMuscleName(String muscleName) {
    return muscleName;
  }
}