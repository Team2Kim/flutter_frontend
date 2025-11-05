import '../model/muscle_model.dart';

class MuscleData {
  static final List<MuscleModel> allMuscles = [
    // head (머리)
    MuscleModel(
      name: '머리가장긴근',
      upperLowerBody: '상체',
      bodyPart: 'head',
      description: '머리와 목을 지지하는 긴 근육',
      detail: '목 뒤쪽의 척추 가시돌기에서 시작하여 두개골 후두부에 붙는 긴 근육입니다. 머리를 뒤로 젖히고 옆으로 돌리는 동작에 관여하며, 목의 안정성을 유지하는 데 중요한 역할을 합니다.',
    ),
    MuscleModel(
      name: '머리널판근',
      upperLowerBody: '상체',
      bodyPart: 'head',
      description: '머리와 목을 지지하는 넓은 근육',
      detail: '목의 깊은 층에 위치한 넓은 근육으로, 상부 척추와 두개골을 연결합니다. 머리의 신전과 측면 굴곡에 관여하며, 목의 자세 유지와 안정성에 기여합니다.',
    ),
    MuscleModel(
      name: '머리반가시근',
      upperLowerBody: '상체',
      bodyPart: 'head',
      description: '머리와 목을 지지하는 반가시근',
      detail: '목의 깊은 근육층에 위치한 반가시근으로, 척추의 가시돌기 사이에 위치합니다. 머리와 목의 신전 및 회전 운동을 담당하며, 목의 정렬과 안정성 유지에 중요한 역할을 합니다.',
    ),

    // neck (목)
    MuscleModel(
      name: '목빗근',
      upperLowerBody: '상체',
      bodyPart: 'neck',
      description: '목의 빗근',
      detail: '목의 앞쪽과 옆쪽에 위치한 얇고 넓은 근육으로, 목의 측면을 덮고 있습니다. 목의 측면 굴곡과 회전에 관여하며, 머리와 목의 자세를 유지하는 데 도움을 줍니다.',
    ),
    MuscleModel(
      name: '긴목근',
      upperLowerBody: '상체',
      bodyPart: 'neck',
      description: '목을 지지하는 긴 근육',
      detail: '목의 앞쪽에 위치한 긴 근육으로, 경추의 앞면을 따라 위치합니다. 머리를 앞으로 굽히고 목을 굽히는 동작에 주로 관여하며, 목의 안정성과 자세 유지에 중요한 역할을 합니다.',
    ),
    MuscleModel(
      name: '목/머리널판근',
      upperLowerBody: '상체',
      bodyPart: 'neck',
      description: '목과 머리를 연결하는 넓은 근육',
      detail: '목과 머리 뒤쪽을 덮는 넓은 근육으로, 상부 척추에서 시작하여 두개골과 목의 척추에 붙습니다. 머리를 뒤로 젖히고 목을 신전시키는 동작에 관여하며, 목의 자세 유지에 기여합니다.',
    ),

    // shoulder (어깨)
    MuscleModel(
      name: '어깨세모근',
      upperLowerBody: '상체',
      bodyPart: 'leftShoulder',
      description: '어깨의 세모근',
      detail: '어깨의 가장 큰 근육으로 삼각형 모양을 하고 있습니다. 상부, 중부, 하부 세 부분으로 나뉘며 팔을 들어올리고, 외전시키며, 회전시키는 동작에 관여합니다. 어깨 관절의 안정성과 움직임에 핵심적인 역할을 합니다.',
    ),
    MuscleModel(
      name: '어깨세모근',
      upperLowerBody: '상체',
      bodyPart: 'rightShoulder',
      description: '어깨의 세모근',
      detail: '어깨의 가장 큰 근육으로 삼각형 모양을 하고 있습니다. 상부, 중부, 하부 세 부분으로 나뉘며 팔을 들어올리고, 외전시키며, 회전시키는 동작에 관여합니다. 어깨 관절의 안정성과 움직임에 핵심적인 역할을 합니다.',
    ),
    MuscleModel(
      name: '중간어깨세모근',
      upperLowerBody: '상체',
      bodyPart: 'leftShoulder',
      description: '어깨의 중간 세모근',
      detail: '어깨세모근의 중간 부분으로, 어깨뼈의 가운데 가장자리에서 시작하여 위팔뼈에 붙습니다. 팔을 옆으로 들어올리는 동작(외전)과 어깨 관절의 안정화에 주요 역할을 합니다.',
    ),
    MuscleModel(
      name: '중간어깨세모근',
      upperLowerBody: '상체',
      bodyPart: 'rightShoulder',
      description: '어깨의 중간 세모근',
      detail: '어깨세모근의 중간 부분으로, 어깨뼈의 가운데 가장자리에서 시작하여 위팔뼈에 붙습니다. 팔을 옆으로 들어올리는 동작(외전)과 어깨 관절의 안정화에 주요 역할을 합니다.',
    ),
    MuscleModel(
      name: '어깨올림근',
      upperLowerBody: '상체',
      bodyPart: 'leftShoulder',
      description: '어깨를 들어올리는 근육',
      detail: '목과 어깨 사이에 위치한 근육으로, 어깨뼈를 위로 들어올리는 역할을 합니다. 어깨를 으쓱하는 동작과 어깨뼈의 상승을 담당하며, 목의 측면 굴곡에도 관여합니다.',
    ),
    MuscleModel(
      name: '어깨올림근',
      upperLowerBody: '상체',
      bodyPart: 'rightShoulder',
      description: '어깨를 들어올리는 근육',
      detail: '목과 어깨 사이에 위치한 근육으로, 어깨뼈를 위로 들어올리는 역할을 합니다. 어깨를 으쓱하는 동작과 어깨뼈의 상승을 담당하며, 목의 측면 굴곡에도 관여합니다.',
    ),
    MuscleModel(
      name: '어깨밑근',
      upperLowerBody: '상체',
      bodyPart: 'leftShoulder',
      description: '어깨 아래쪽 근육',
      detail: '어깨뼈의 앞면에 위치한 깊은 근육으로, 어깨뼈를 안정시키고 아래로 내리는 역할을 합니다. 팔을 들어올릴 때 어깨뼈가 제대로 움직이도록 도와주며, 어깨 관절의 안정성에 기여합니다.',
    ),
    MuscleModel(
      name: '어깨밑근',
      upperLowerBody: '상체',
      bodyPart: 'rightShoulder',
      description: '어깨 아래쪽 근육',
      detail: '어깨뼈의 앞면에 위치한 깊은 근육으로, 어깨뼈를 안정시키고 아래로 내리는 역할을 합니다. 팔을 들어올릴 때 어깨뼈가 제대로 움직이도록 도와주며, 어깨 관절의 안정성에 기여합니다.',
    ),
    MuscleModel(
      name: '돌림근',
      upperLowerBody: '상체',
      bodyPart: 'leftShoulder',
      description: '어깨를 회전시키는 근육',
      detail: '어깨 관절의 회전근개(rotator cuff)를 구성하는 근육 중 하나로, 어깨뼈의 앞면에서 시작하여 위팔뼈의 작은 결절에 붙습니다. 팔을 안쪽으로 돌리는 동작(내회전)과 어깨 관절의 안정화에 중요한 역할을 합니다.',
    ),
    MuscleModel(
      name: '돌림근',
      upperLowerBody: '상체',
      bodyPart: 'rightShoulder',
      description: '어깨를 회전시키는 근육',
      detail: '어깨 관절의 회전근개(rotator cuff)를 구성하는 근육 중 하나로, 어깨뼈의 앞면에서 시작하여 위팔뼈의 작은 결절에 붙습니다. 팔을 안쪽으로 돌리는 동작(내회전)과 어깨 관절의 안정화에 중요한 역할을 합니다.',
    ),
    MuscleModel(
      name: '작은원근',
      upperLowerBody: '상체',
      bodyPart: 'leftShoulder',
      description: '작은 원근',
      detail: '어깨 관절의 회전근개를 구성하는 작은 근육으로, 어깨뼈의 뒤면에서 시작하여 위팔뼈의 큰 결절에 붙습니다. 팔을 바깥쪽으로 돌리는 동작(외회전)과 어깨 관절의 안정화에 관여합니다.',
    ),
    MuscleModel(
      name: '작은원근',
      upperLowerBody: '상체',
      bodyPart: 'rightShoulder',
      description: '작은 원근',
      detail: '어깨 관절의 회전근개를 구성하는 작은 근육으로, 어깨뼈의 뒤면에서 시작하여 위팔뼈의 큰 결절에 붙습니다. 팔을 바깥쪽으로 돌리는 동작(외회전)과 어깨 관절의 안정화에 관여합니다.',
    ),
    MuscleModel(
      name: '큰원근',
      upperLowerBody: '상체',
      bodyPart: 'leftShoulder',
      description: '큰 원근',
      detail: '어깨뼈의 아래쪽 가장자리에서 시작하여 위팔뼈의 작은 결절에 붙는 큰 근육입니다. 팔을 안쪽으로 돌리고, 내리고, 어깨뼈 쪽으로 당기는 동작에 관여하며, 팔의 내회전과 내전에 중요한 역할을 합니다.',
    ),
    MuscleModel(
      name: '큰원근',
      upperLowerBody: '상체',
      bodyPart: 'rightShoulder',
      description: '큰 원근',
      detail: '어깨뼈의 아래쪽 가장자리에서 시작하여 위팔뼈의 작은 결절에 붙는 큰 근육입니다. 팔을 안쪽으로 돌리고, 내리고, 어깨뼈 쪽으로 당기는 동작에 관여하며, 팔의 내회전과 내전에 중요한 역할을 합니다.',
    ),

    // upperArm (상완)
    MuscleModel(
      name: '위팔세갈래근',
      upperLowerBody: '상체',
      bodyPart: 'leftUpperArm',
      description: '팔 뒤쪽의 세갈래 근육',
      detail: '팔 뒤쪽에 위치한 삼두근으로, 긴갈래, 가쪽갈래, 안쪽갈래 세 부분으로 구성됩니다. 팔꿈치를 펴는 동작(신전)과 어깨 관절의 신전을 담당하며, 팔의 뒤쪽 근육량을 구성하는 주요 근육입니다.',
    ),
    MuscleModel(
      name: '위팔세갈래근',
      upperLowerBody: '상체',
      bodyPart: 'rightUpperArm',
      description: '팔 뒤쪽의 세갈래 근육',
      detail: '팔 뒤쪽에 위치한 삼두근으로, 긴갈래, 가쪽갈래, 안쪽갈래 세 부분으로 구성됩니다. 팔꿈치를 펴는 동작(신전)과 어깨 관절의 신전을 담당하며, 팔의 뒤쪽 근육량을 구성하는 주요 근육입니다.',
    ),
    MuscleModel(
      name: '위팔두갈래근',
      upperLowerBody: '상체',
      bodyPart: 'leftUpperArm',
      description: '팔 앞쪽의 두갈래 근육',
      detail: '팔 앞쪽에 위치한 이두근으로, 긴갈래와 짧은갈래 두 부분으로 구성됩니다. 팔꿈치를 구부리는 동작(굴곡)과 손바닥을 위로 돌리는 동작(선회)을 담당하며, 팔의 앞쪽 근육량을 구성하는 대표적인 근육입니다.',
    ),
    MuscleModel(
      name: '위팔두갈래근',
      upperLowerBody: '상체',
      bodyPart: 'rightUpperArm',
      description: '팔 앞쪽의 두갈래 근육',
      detail: '팔 앞쪽에 위치한 이두근으로, 긴갈래와 짧은갈래 두 부분으로 구성됩니다. 팔꿈치를 구부리는 동작(굴곡)과 손바닥을 위로 돌리는 동작(선회)을 담당하며, 팔의 앞쪽 근육량을 구성하는 대표적인 근육입니다.',
    ),
    MuscleModel(
      name: '위팔근',
      upperLowerBody: '상체',
      bodyPart: 'leftUpperArm',
      description: '위팔의 주요 근육',
      detail: '위팔의 앞쪽에 위치한 깊은 근육으로, 위팔뼈의 앞면을 덮고 있습니다. 팔꿈치를 구부리는 보조 역할을 하며, 팔꿈치 관절의 안정성 유지에 기여합니다.',
    ),
    MuscleModel(
      name: '위팔근',
      upperLowerBody: '상체',
      bodyPart: 'rightUpperArm',
      description: '위팔의 주요 근육',
      detail: '위팔의 앞쪽에 위치한 깊은 근육으로, 위팔뼈의 앞면을 덮고 있습니다. 팔꿈치를 구부리는 보조 역할을 하며, 팔꿈치 관절의 안정성 유지에 기여합니다.',
    ),
    MuscleModel(
      name: '위팔노근',
      upperLowerBody: '상체',
      bodyPart: 'leftUpperArm',
      description: '위팔의 노근',
      detail: '위팔의 앞쪽 바깥면에 위치한 근육으로, 노뼈의 위쪽에 붙습니다. 팔꿈치를 구부리는 동작에 보조적으로 관여하며, 팔꿈치 관절의 안정성과 움직임에 기여합니다.',
    ),
    MuscleModel(
      name: '위팔노근',
      upperLowerBody: '상체',
      bodyPart: 'rightUpperArm',
      description: '위팔의 노근',
      detail: '위팔의 앞쪽 바깥면에 위치한 근육으로, 노뼈의 위쪽에 붙습니다. 팔꿈치를 구부리는 동작에 보조적으로 관여하며, 팔꿈치 관절의 안정성과 움직임에 기여합니다.',
    ),

    // lowerArm (하완)
    MuscleModel(
      name: '손목굽힘근',
      upperLowerBody: '상체',
      bodyPart: 'leftLowerArm',
      description: '손목을 구부리는 근육',
      detail: '팔꿈치 안쪽에서 시작하여 손목의 손바닥 쪽에 붙는 근육으로, 손목을 손바닥 쪽으로 구부리는 동작(굴곡)을 담당합니다. 손목의 안정성과 정밀한 손 움직임에 중요한 역할을 합니다.',
    ),
    MuscleModel(
      name: '손목굽힘근',
      upperLowerBody: '상체',
      bodyPart: 'rightLowerArm',
      description: '손목을 구부리는 근육',
      detail: '팔꿈치 안쪽에서 시작하여 손목의 손바닥 쪽에 붙는 근육으로, 손목을 손바닥 쪽으로 구부리는 동작(굴곡)을 담당합니다. 손목의 안정성과 정밀한 손 움직임에 중요한 역할을 합니다.',
    ),
    MuscleModel(
      name: '손목폄근',
      upperLowerBody: '상체',
      bodyPart: 'leftLowerArm',
      description: '손목을 펴는 근육',
      detail: '팔꿈치 바깥쪽에서 시작하여 손목의 손등 쪽에 붙는 근육으로, 손목을 손등 쪽으로 펴는 동작(신전)을 담당합니다. 손목의 신전과 안정성 유지에 중요한 역할을 합니다.',
    ),
    MuscleModel(
      name: '손목폄근',
      upperLowerBody: '상체',
      bodyPart: 'rightLowerArm',
      description: '손목을 펴는 근육',
      detail: '팔꿈치 바깥쪽에서 시작하여 손목의 손등 쪽에 붙는 근육으로, 손목을 손등 쪽으로 펴는 동작(신전)을 담당합니다. 손목의 신전과 안정성 유지에 중요한 역할을 합니다.',
    ),
    MuscleModel(
      name: '노쪽손목굽힘근',
      upperLowerBody: '상체',
      bodyPart: 'leftLowerArm',
      description: '노쪽 손목 굽힘근',
      detail: '팔꿈치 안쪽에서 시작하여 손목의 노쪽(엄지 쪽)에 붙는 근육으로, 손목을 손바닥 쪽으로 구부리고 노쪽으로 기울이는 동작을 담당합니다. 손목의 굴곡과 노쪽 편향에 관여합니다.',
    ),
    MuscleModel(
      name: '노쪽손목굽힘근',
      upperLowerBody: '상체',
      bodyPart: 'rightLowerArm',
      description: '노쪽 손목 굽힘근',
      detail: '팔꿈치 안쪽에서 시작하여 손목의 노쪽(엄지 쪽)에 붙는 근육으로, 손목을 손바닥 쪽으로 구부리고 노쪽으로 기울이는 동작을 담당합니다. 손목의 굴곡과 노쪽 편향에 관여합니다.',
    ),
    MuscleModel(
      name: '노쪽 손목 폄근',
      upperLowerBody: '상체',
      bodyPart: 'leftLowerArm',
      description: '노쪽 손목 폄근',
      detail: '팔꿈치 바깥쪽에서 시작하여 손목의 노쪽(엄지 쪽)에 붙는 근육으로, 손목을 손등 쪽으로 펴고 노쪽으로 기울이는 동작을 담당합니다. 손목의 신전과 노쪽 편향에 관여합니다.',
    ),
    MuscleModel(
      name: '노쪽 손목 폄근',
      upperLowerBody: '상체',
      bodyPart: 'rightLowerArm',
      description: '노쪽 손목 폄근',
      detail: '팔꿈치 바깥쪽에서 시작하여 손목의 노쪽(엄지 쪽)에 붙는 근육으로, 손목을 손등 쪽으로 펴고 노쪽으로 기울이는 동작을 담당합니다. 손목의 신전과 노쪽 편향에 관여합니다.',
    ),

    // upperBody (상체)
    MuscleModel(
      name: '큰가슴근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '가슴의 큰 근육',
      detail: '가슴의 가장 큰 표면 근육으로, 가슴뼈, 쇄골, 갈비뼈에서 시작하여 위팔뼈에 붙습니다. 팔을 앞으로 모으고, 안쪽으로 돌리며, 숨을 내쉴 때 보조적으로 작용합니다. 푸시업, 벤치프레스 등 가슴 운동의 주동근입니다.',
    ),
    MuscleModel(
      name: '작은가슴근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '가슴의 작은 근육',
      detail: '큰가슴근 아래에 위치한 작은 근육으로, 갈비뼈에서 시작하여 어깨뼈에 붙습니다. 어깨뼈를 앞으로 기울이고 아래로 내리는 역할을 하며, 호흡 시 갈비뼈를 들어올리는 보조 역할을 합니다.',
    ),
    MuscleModel(
      name: '넓은등근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '등의 넓은 근육',
      detail: '등의 가장 넓은 근육으로, 척추, 골반, 갈비뼈에서 시작하여 위팔뼈에 붙습니다. 팔을 뒤로 당기고, 안쪽으로 돌리며, 몸을 앞으로 당기는 동작에 관여합니다. 등 근육량의 대부분을 차지하는 주요 근육입니다.',
    ),
    MuscleModel(
      name: '등세모근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '등의 세모근',
      detail: '등의 위쪽에 위치한 큰 근육으로, 어깨뼈를 안정시키고 위로 올리는 역할을 합니다. 어깨뼈를 모으고, 위로 올리며, 아래로 내리는 동작에 관여하며, 어깨의 자세와 안정성에 중요한 역할을 합니다.',
    ),
    MuscleModel(
      name: '마름모근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '마름모 모양의 근육',
      detail: '등의 깊은 층에 위치한 마름모 모양의 근육으로, 큰마름모근과 작은마름모근으로 구성됩니다. 어깨뼈를 모으고 안정시키는 역할을 하며, 어깨뼈의 회전과 안정성 유지에 중요한 역할을 합니다.',
    ),
    MuscleModel(
      name: '뒤세모근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '뒤쪽의 세모근',
      detail: '등의 깊은 층에 위치한 근육으로, 척추의 가시돌기에서 시작하여 어깨뼈에 붙습니다. 어깨뼈를 모으고 위로 올리는 동작에 관여하며, 등과 어깨의 자세 유지에 기여합니다.',
    ),
    MuscleModel(
      name: '앞세모근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '앞쪽의 세모근',
      detail: '목과 가슴 사이의 앞쪽에 위치한 근육으로, 목뼈에서 시작하여 갈비뼈와 어깨뼈에 붙습니다. 어깨뼈를 앞으로 기울이고, 호흡을 보조하며, 목의 안정성 유지에 기여합니다.',
    ),
    MuscleModel(
      name: '앞톱니근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '앞쪽의 톱니 모양 근육',
      detail: '가슴 옆면에 위치한 톱니 모양의 근육으로, 갈비뼈에서 시작하여 어깨뼈의 앞면에 붙습니다. 어깨뼈를 앞으로 당기고 안정시키며, 팔을 들어올릴 때 어깨뼈의 움직임을 도와줍니다.',
    ),
    MuscleModel(
      name: '등가시근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '등의 가시근',
      detail: '등의 깊은 층에 위치한 근육으로, 척추의 가시돌기에서 시작하여 갈비뼈와 척추에 붙습니다. 척추를 신전시키고, 측면 굴곡과 회전에 관여하며, 등과 척추의 자세 유지에 중요한 역할을 합니다.',
    ),
    MuscleModel(
      name: '가시아래근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '가시 아래쪽 근육',
      detail: '등의 깊은 층에 위치한 근육으로, 척추의 가시돌기 아래쪽에서 시작하여 척추의 가로돌기에 붙습니다. 척추의 신전과 안정화에 관여하며, 등과 척추의 자세 유지에 기여합니다.',
    ),
    MuscleModel(
      name: '가시윗근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '가시 위쪽 근육',
      detail: '등의 깊은 층에 위치한 근육으로, 척추의 가시돌기 위쪽에서 시작하여 위쪽 척추에 붙습니다. 척추의 신전과 안정화에 관여하며, 목과 등 상부의 자세 유지에 기여합니다.',
    ),
    MuscleModel(
      name: '가시사이근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '가시 사이의 근육',
      detail: '등의 깊은 층에 위치한 작은 근육으로, 인접한 척추의 가시돌기 사이에 위치합니다. 척추의 신전과 안정화에 관여하며, 척추 세그먼트 간의 미세한 움직임을 조절합니다.',
    ),
    MuscleModel(
      name: '가로돌기사이근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '가로돌기 사이의 근육',
      detail: '등의 깊은 층에 위치한 근육으로, 척추의 가로돌기 사이에 위치합니다. 척추의 측면 굴곡과 회전에 관여하며, 척추 세그먼트 간의 안정성과 움직임을 조절합니다.',
    ),
    MuscleModel(
      name: '바깥갈비사이근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '바깥쪽 갈비사이근',
      detail: '갈비뼈 사이의 바깥쪽에 위치한 근육으로, 호흡 시 갈비뼈를 들어올려 흉강을 넓히는 역할을 합니다. 흡기(숨을 들이쉬는) 동작에 주로 관여하며, 호흡의 주요 근육 중 하나입니다.',
    ),
    MuscleModel(
      name: '안쪽갈비사이근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '안쪽 갈비사이근',
      detail: '갈비뼈 사이의 안쪽에 위치한 근육으로, 호흡 시 갈비뼈를 내려 흉강을 줄이는 역할을 합니다. 호기(숨을 내쉬는) 동작에 주로 관여하며, 호흡의 보조 근육으로 작용합니다.',
    ),
    MuscleModel(
      name: '뭇갈래근',
      upperLowerBody: '상체',
      bodyPart: 'upperBody',
      description: '여러 갈래로 나뉜 근육',
      detail: '등의 깊은 층에 위치한 여러 갈래로 나뉜 근육으로, 척추와 갈비뼈를 연결합니다. 척추의 신전, 측면 굴곡, 회전에 관여하며, 척추의 안정성과 자세 유지에 중요한 역할을 합니다.',
    ),

    // abdomen (복부)
    MuscleModel(
      name: '배곧은근',
      upperLowerBody: '상체',
      bodyPart: 'abdomen',
      description: '배의 곧은 근육',
      detail: '복부의 앞면 중앙에 위치한 세로로 긴 근육으로, 가슴뼈 아래에서 시작하여 골반까지 이어집니다. 몸을 앞으로 굽히고, 골반을 앞으로 기울이며, 복압을 유지하는 역할을 합니다. 복근 운동의 주요 타겟 근육입니다.',
    ),
    MuscleModel(
      name: '배바깥빗근',
      upperLowerBody: '상체',
      bodyPart: 'abdomen',
      description: '배의 바깥쪽 빗근',
      detail: '복부의 측면에 위치한 가장 바깥쪽 근육으로, 갈비뼈에서 시작하여 골반과 배곧은근에 붙습니다. 몸을 옆으로 굽히고, 몸통을 회전시키며, 복압을 유지하는 역할을 합니다. 옆구리와 복부 측면의 근육량을 구성합니다.',
    ),
    MuscleModel(
      name: '배속빗근',
      upperLowerBody: '상체',
      bodyPart: 'abdomen',
      description: '배의 속쪽 빗근',
      detail: '복부의 중간 층에 위치한 근육으로, 배바깥빗근 아래에 있습니다. 몸을 옆으로 굽히고, 몸통을 회전시키며, 복압을 유지하는 보조 역할을 합니다. 복부의 안정성과 자세 유지에 기여합니다.',
    ),
    MuscleModel(
      name: '배가로근',
      upperLowerBody: '상체',
      bodyPart: 'abdomen',
      description: '배의 가로 근육',
      detail: '복부의 가장 깊은 층에 위치한 가로로 배열된 근육으로, 척추와 갈비뼈에서 시작하여 배곧은근에 붙습니다. 복압을 유지하고, 내장을 지지하며, 호흡 시 보조 역할을 합니다. 코어 안정성에 가장 중요한 근육 중 하나입니다.',
    ),
    MuscleModel(
      name: '배빗근',
      upperLowerBody: '상체',
      bodyPart: 'abdomen',
      description: '배의 빗근',
      detail: '복부의 깊은 층에 위치한 근육으로, 골반에서 시작하여 갈비뼈에 붙습니다. 복압을 유지하고, 몸통의 안정성에 기여하며, 호흡 시 보조 역할을 합니다. 복부의 깊은 안정성과 자세 유지에 중요한 역할을 합니다.',
    ),

    // lowerBody (하체)
    MuscleModel(
      name: '큰볼기근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '볼기의 큰 근육',
      detail: '볼기의 가장 큰 표면 근육으로, 골반의 뒤쪽과 엉치뼈에서 시작하여 넓적다리뼈에 붙습니다. 엉덩관절을 펴고, 다리를 뒤로 움직이며, 몸통을 곧게 세우는 역할을 합니다. 보행, 달리기, 앉았다 일어나기 등에 핵심적인 근육입니다.',
    ),
    MuscleModel(
      name: '작은볼기근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '볼기의 작은 근육',
      detail: '볼기의 가장 깊은 층에 위치한 작은 근육으로, 골반의 측면에서 시작하여 넓적다리뼈의 큰돌기에 붙습니다. 엉덩관절을 펴고, 다리를 바깥쪽으로 돌리는 동작에 관여하며, 엉덩관절의 안정성에 기여합니다.',
    ),
    MuscleModel(
      name: '중간볼기근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '볼기의 중간 근육',
      detail: '볼기의 중간 층에 위치한 근육으로, 골반의 측면에서 시작하여 넓적다리뼈에 붙습니다. 다리를 옆으로 들어올리고, 엉덩관절을 안정시키며, 보행 시 골반의 안정성을 유지하는 역할을 합니다. 서있을 때 골반을 지지하는 중요한 근육입니다.',
    ),
    MuscleModel(
      name: '볼기근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '볼기 근육',
      detail: '볼기를 구성하는 근육군의 총칭으로, 큰볼기근, 중간볼기근, 작은볼기근을 포함합니다. 엉덩관절의 신전, 외전, 회전에 관여하며, 보행, 달리기, 점프 등 하체 운동의 핵심 역할을 합니다.',
    ),
    MuscleModel(
      name: '엉덩관절굽힘근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '엉덩관절을 굽히는 근육',
      detail: '엉덩관절을 굽히는 역할을 하는 근육으로, 골반의 앞면에서 시작하여 넓적다리뼈에 붙습니다. 다리를 앞으로 올리고, 엉덩관절을 굽히며, 보행 시 다리를 앞으로 움직이는 동작에 관여합니다.',
    ),
    MuscleModel(
      name: '엉덩허리근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '엉덩이와 허리를 연결하는 근육',
      detail: '허리와 엉덩이를 연결하는 근육으로, 척추의 요추부에서 시작하여 골반에 붙습니다. 골반을 앞으로 기울이고, 허리를 펴는 역할을 하며, 골반과 척추의 연결과 안정성에 중요한 역할을 합니다.',
    ),
    MuscleModel(
      name: '엉덩근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '엉덩이 근육',
      detail: '엉덩이 부위의 근육을 총칭하는 용어로, 볼기근과 함께 엉덩관절의 움직임과 안정성을 담당합니다. 보행, 달리기, 점프 등 하체 운동의 기초가 되는 근육입니다.',
    ),
    MuscleModel(
      name: '궁둥구멍근',
      upperLowerBody: '하체',
      bodyPart: 'lowerBody',
      description: '궁둥구멍 근육',
      detail: '골반의 깊은 곳에 위치한 작은 근육으로, 엉치뼈와 꼬리뼈에서 시작하여 골반의 다른 부위에 붙습니다. 골반저를 지지하고, 엉덩관절의 안정성에 기여하며, 골반저 근육의 일부로 작용합니다.',
    ),

    // upperLeg (대퇴)
    MuscleModel(
      name: '넙다리네갈래근',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '넙다리의 네갈래 근육',
      detail: '넙다리 앞쪽에 위치한 대퇴사두근으로, 넙다리곧은근, 가쪽넓은근, 안쪽넓은근, 중간넓은근 네 부분으로 구성됩니다. 무릎을 펴는 동작(신전)과 무릎 관절의 안정성을 담당하며, 보행, 달리기, 점프 등에 핵심적인 역할을 합니다.',
    ),
    MuscleModel(
      name: '넙다리네갈래근',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '넙다리의 네갈래 근육',
      detail: '넙다리 앞쪽에 위치한 대퇴사두근으로, 넙다리곧은근, 가쪽넓은근, 안쪽넓은근, 중간넓은근 네 부분으로 구성됩니다. 무릎을 펴는 동작(신전)과 무릎 관절의 안정성을 담당하며, 보행, 달리기, 점프 등에 핵심적인 역할을 합니다.',
    ),
    MuscleModel(
      name: '넙다리두갈래근',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '넙다리의 두갈래 근육',
      detail: '넙다리 뒤쪽에 위치한 대퇴이두근으로, 긴갈래와 짧은갈래 두 부분으로 구성됩니다. 무릎을 구부리고, 엉덩관절을 펴며, 다리를 바깥쪽으로 돌리는 동작에 관여합니다. 하체 뒤쪽 근육량의 주요 구성 요소입니다.',
    ),
    MuscleModel(
      name: '넙다리두갈래근',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '넙다리의 두갈래 근육',
      detail: '넙다리 뒤쪽에 위치한 대퇴이두근으로, 긴갈래와 짧은갈래 두 부분으로 구성됩니다. 무릎을 구부리고, 엉덩관절을 펴며, 다리를 바깥쪽으로 돌리는 동작에 관여합니다. 하체 뒤쪽 근육량의 주요 구성 요소입니다.',
    ),
    MuscleModel(
      name: '넙다리근막긴장근',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '넙다리 근막을 긴장시키는 근육',
      detail: '넙다리의 앞쪽 바깥면에 위치한 근육으로, 골반에서 시작하여 무릎 부위의 근막에 붙습니다. 넙다리 근막을 긴장시켜 무릎의 안정성을 유지하고, 무릎을 펴는 동작을 보조합니다.',
    ),
    MuscleModel(
      name: '넙다리근막긴장근',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '넙다리 근막을 긴장시키는 근육',
      detail: '넙다리의 앞쪽 바깥면에 위치한 근육으로, 골반에서 시작하여 무릎 부위의 근막에 붙습니다. 넙다리 근막을 긴장시켜 무릎의 안정성을 유지하고, 무릎을 펴는 동작을 보조합니다.',
    ),
    MuscleModel(
      name: '넙다리빗근',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '넙다리의 빗근',
      detail: '넙다리의 안쪽 앞면에 위치한 근육으로, 골반의 빗장에서 시작하여 넙다리뼈의 안쪽에 붙습니다. 다리를 안쪽으로 모으고, 무릎을 구부리는 동작에 관여하며, 하체의 안정성에 기여합니다.',
    ),
    MuscleModel(
      name: '넙다리빗근',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '넙다리의 빗근',
      detail: '넙다리의 안쪽 앞면에 위치한 근육으로, 골반의 빗장에서 시작하여 넙다리뼈의 안쪽에 붙습니다. 다리를 안쪽으로 모으고, 무릎을 구부리는 동작에 관여하며, 하체의 안정성에 기여합니다.',
    ),
    MuscleModel(
      name: '넙다리곧은근',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '넙다리의 곧은 근육',
      detail: '넙다리 네갈래근의 중간 부분으로, 골반 앞면에서 시작하여 무릎뼈에 붙습니다. 무릎을 펴는 동작에 주로 관여하며, 엉덩관절을 구부리는 동작에도 참여합니다. 대퇴사두근의 가시적인 부분을 구성합니다.',
    ),
    MuscleModel(
      name: '넙다리곧은근',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '넙다리의 곧은 근육',
      detail: '넙다리 네갈래근의 중간 부분으로, 골반 앞면에서 시작하여 무릎뼈에 붙습니다. 무릎을 펴는 동작에 주로 관여하며, 엉덩관절을 구부리는 동작에도 참여합니다. 대퇴사두근의 가시적인 부분을 구성합니다.',
    ),
    MuscleModel(
      name: '뒤넙다리근',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '넙다리 뒤쪽 근육',
      detail: '넙다리 뒤쪽에 위치한 근육군으로, 대퇴이두근, 반막근, 반힘줄근을 포함합니다. 무릎을 구부리고, 엉덩관절을 펴는 동작에 관여하며, 보행과 달리기 시 하체의 추진력을 제공합니다.',
    ),
    MuscleModel(
      name: '뒤넙다리근',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '넙다리 뒤쪽 근육',
      detail: '넙다리 뒤쪽에 위치한 근육군으로, 대퇴이두근, 반막근, 반힘줄근을 포함합니다. 무릎을 구부리고, 엉덩관절을 펴는 동작에 관여하며, 보행과 달리기 시 하체의 추진력을 제공합니다.',
    ),
    MuscleModel(
      name: '가쪽넓은근',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '가쪽의 넓은 근육',
      detail: '넙다리 네갈래근의 바깥쪽 부분으로, 넙다리뼈의 바깥면에서 시작하여 무릎뼈에 붙습니다. 무릎을 펴는 동작에 관여하며, 넙다리의 바깥쪽 근육량을 구성하는 주요 부분입니다.',
    ),
    MuscleModel(
      name: '가쪽넓은근',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '가쪽의 넓은 근육',
      detail: '넙다리 네갈래근의 바깥쪽 부분으로, 넙다리뼈의 바깥면에서 시작하여 무릎뼈에 붙습니다. 무릎을 펴는 동작에 관여하며, 넙다리의 바깥쪽 근육량을 구성하는 주요 부분입니다.',
    ),
    MuscleModel(
      name: '안쪽넓은근',
      upperLowerBody: '하체',
      bodyPart: 'leftUpperLeg',
      description: '안쪽의 넓은 근육',
      detail: '넙다리 네갈래근의 안쪽 부분으로, 넙다리뼈의 안쪽면에서 시작하여 무릎뼈에 붙습니다. 무릎을 펴는 동작에 관여하며, 무릎의 안정성과 정렬에 중요한 역할을 합니다.',
    ),
    MuscleModel(
      name: '안쪽넓은근',
      upperLowerBody: '하체',
      bodyPart: 'rightUpperLeg',
      description: '안쪽의 넓은 근육',
      detail: '넙다리 네갈래근의 안쪽 부분으로, 넙다리뼈의 안쪽면에서 시작하여 무릎뼈에 붙습니다. 무릎을 펴는 동작에 관여하며, 무릎의 안정성과 정렬에 중요한 역할을 합니다.',
    ),

    // lowerLeg (하퇴)
    MuscleModel(
      name: '앞정강근',
      upperLowerBody: '하체',
      bodyPart: 'leftLowerLeg',
      description: '정강이 앞쪽 근육',
      detail: '정강이 앞쪽에 위치한 근육으로, 정강뼈의 바깥쪽에서 시작하여 발목과 발에 붙습니다. 발목을 위로 올리고(배굴), 발을 안쪽으로 돌리며, 발목의 안정성을 유지하는 역할을 합니다. 보행 시 발을 들어올리는 동작에 핵심적인 근육입니다.',
    ),
    MuscleModel(
      name: '앞정강근',
      upperLowerBody: '하체',
      bodyPart: 'rightLowerLeg',
      description: '정강이 앞쪽 근육',
      detail: '정강이 앞쪽에 위치한 근육으로, 정강뼈의 바깥쪽에서 시작하여 발목과 발에 붙습니다. 발목을 위로 올리고(배굴), 발을 안쪽으로 돌리며, 발목의 안정성을 유지하는 역할을 합니다. 보행 시 발을 들어올리는 동작에 핵심적인 근육입니다.',
    ),
    MuscleModel(
      name: '뒤정강근',
      upperLowerBody: '하체',
      bodyPart: 'leftLowerLeg',
      description: '정강이 뒤쪽 근육',
      detail: '정강이 뒤쪽의 깊은 층에 위치한 근육으로, 정강뼈와 비골에서 시작하여 발목과 발에 붙습니다. 발목을 아래로 내리고(저측굴), 발을 안쪽으로 돌리며, 발목의 안정성과 균형 유지에 기여합니다.',
    ),
    MuscleModel(
      name: '뒤정강근',
      upperLowerBody: '하체',
      bodyPart: 'rightLowerLeg',
      description: '정강이 뒤쪽 근육',
      detail: '정강이 뒤쪽의 깊은 층에 위치한 근육으로, 정강뼈와 비골에서 시작하여 발목과 발에 붙습니다. 발목을 아래로 내리고(저측굴), 발을 안쪽으로 돌리며, 발목의 안정성과 균형 유지에 기여합니다.',
    ),
    MuscleModel(
      name: '두덩정강근',
      upperLowerBody: '하체',
      bodyPart: 'leftLowerLeg',
      description: '두덩 정강근',
      detail: '정강이 앞쪽에 위치한 작은 근육으로, 정강뼈의 바깥쪽에서 시작하여 발목과 발에 붙습니다. 발목을 위로 올리고(배굴), 발을 안쪽으로 돌리는 동작에 보조적으로 관여합니다.',
    ),
    MuscleModel(
      name: '두덩정강근',
      upperLowerBody: '하체',
      bodyPart: 'rightLowerLeg',
      description: '두덩 정강근',
      detail: '정강이 앞쪽에 위치한 작은 근육으로, 정강뼈의 바깥쪽에서 시작하여 발목과 발에 붙습니다. 발목을 위로 올리고(배굴), 발을 안쪽으로 돌리는 동작에 보조적으로 관여합니다.',
    ),
    MuscleModel(
      name: '가자미근',
      upperLowerBody: '하체',
      bodyPart: 'leftLowerLeg',
      description: '가자미 모양의 근육',
      detail: '정강이 뒤쪽의 깊은 층에 위치한 가자미 모양의 평평한 근육으로, 정강뼈에서 시작하여 발목을 통과하여 발에 붙습니다. 발목을 아래로 내리고(저측굴), 발을 안쪽으로 돌리며, 발목의 안정성에 기여합니다.',
    ),
    MuscleModel(
      name: '가자미근',
      upperLowerBody: '하체',
      bodyPart: 'rightLowerLeg',
      description: '가자미 모양의 근육',
      detail: '정강이 뒤쪽의 깊은 층에 위치한 가자미 모양의 평평한 근육으로, 정강뼈에서 시작하여 발목을 통과하여 발에 붙습니다. 발목을 아래로 내리고(저측굴), 발을 안쪽으로 돌리며, 발목의 안정성에 기여합니다.',
    ),
    MuscleModel(
      name: '장딴지근',
      upperLowerBody: '하체',
      bodyPart: 'leftLowerLeg',
      description: '장딴지 근육',
      detail: '정강이 뒤쪽의 표면에 위치한 큰 근육으로, 넙다리뼈의 뒤쪽에서 시작하여 아킬레스건을 통해 발꿈치뼈에 붙습니다. 발목을 아래로 내리고(저측굴), 발가락을 구부리며, 서있을 때와 보행 시 발목의 안정성을 유지합니다.',
    ),
    MuscleModel(
      name: '장딴지근',
      upperLowerBody: '하체',
      bodyPart: 'rightLowerLeg',
      description: '장딴지 근육',
      detail: '정강이 뒤쪽의 표면에 위치한 큰 근육으로, 넙다리뼈의 뒤쪽에서 시작하여 아킬레스건을 통해 발꿈치뼈에 붙습니다. 발목을 아래로 내리고(저측굴), 발가락을 구부리며, 서있을 때와 보행 시 발목의 안정성을 유지합니다.',
    ),
    MuscleModel(
      name: '장딴지세갈래근',
      upperLowerBody: '하체',
      bodyPart: 'leftLowerLeg',
      description: '장딴지의 세갈래 근육',
      detail: '정강이 뒤쪽의 표면에 위치한 근육으로, 장딴지근과 가자미근의 세 부분(장딴지근의 두 갈래와 가자미근)으로 구성됩니다. 발목을 아래로 내리고(저측굴), 서있을 때와 보행, 달리기, 점프 시 발목의 추진력과 안정성을 제공합니다.',
    ),
    MuscleModel(
      name: '장딴지세갈래근',
      upperLowerBody: '하체',
      bodyPart: 'rightLowerLeg',
      description: '장딴지의 세갈래 근육',
      detail: '정강이 뒤쪽의 표면에 위치한 근육으로, 장딴지근과 가자미근의 세 부분(장딴지근의 두 갈래와 가자미근)으로 구성됩니다. 발목을 아래로 내리고(저측굴), 서있을 때와 보행, 달리기, 점프 시 발목의 추진력과 안정성을 제공합니다.',
    ),

    // foot (발)
    MuscleModel(
      name: '긴발가락폄근',
      upperLowerBody: '하체',
      bodyPart: 'leftFoot',
      description: '긴 발가락을 펴는 근육',
      detail: '정강이 앞쪽에서 시작하여 발목을 통과하여 발가락(2-5번)에 붙는 근육으로, 발가락을 펴고(신전), 발목을 위로 올리는(배굴) 동작에 관여합니다. 보행 시 발가락을 들어올리고 발목의 안정성을 유지하는 데 중요한 역할을 합니다.',
    ),
    MuscleModel(
      name: '긴발가락폄근',
      upperLowerBody: '하체',
      bodyPart: 'rightFoot',
      description: '긴 발가락을 펴는 근육',
      detail: '정강이 앞쪽에서 시작하여 발목을 통과하여 발가락(2-5번)에 붙는 근육으로, 발가락을 펴고(신전), 발목을 위로 올리는(배굴) 동작에 관여합니다. 보행 시 발가락을 들어올리고 발목의 안정성을 유지하는 데 중요한 역할을 합니다.',
    ),
    MuscleModel(
      name: '긴엄지발가락폄근',
      upperLowerBody: '하체',
      bodyPart: 'leftFoot',
      description: '긴 엄지발가락을 펴는 근육',
      detail: '정강이 앞쪽에서 시작하여 발목을 통과하여 엄지발가락에 붙는 근육으로, 엄지발가락을 펴고(신전), 발목을 위로 올리는(배굴) 동작에 관여합니다. 보행 시 엄지발가락을 들어올리고 발의 추진력 생성에 중요한 역할을 합니다.',
    ),
    MuscleModel(
      name: '긴엄지발가락폄근',
      upperLowerBody: '하체',
      bodyPart: 'rightFoot',
      description: '긴 엄지발가락을 펴는 근육',
      detail: '정강이 앞쪽에서 시작하여 발목을 통과하여 엄지발가락에 붙는 근육으로, 엄지발가락을 펴고(신전), 발목을 위로 올리는(배굴) 동작에 관여합니다. 보행 시 엄지발가락을 들어올리고 발의 추진력 생성에 중요한 역할을 합니다.',
    ),

    // spine (척추)
    MuscleModel(
      name: '척추세움근',
      upperLowerBody: '상체',
      bodyPart: 'spine',
      description: '척추를 세우는 근육',
      detail: '척추 양쪽에 위치한 긴 근육군으로, 골반에서 시작하여 척추 전체를 따라 목까지 이어집니다. 척추를 펴고(신전), 몸을 뒤로 젖히며, 척추의 안정성과 자세 유지를 담당합니다. 서있을 때와 보행 시 몸을 곧게 세우는 핵심 근육입니다.',
    ),
    MuscleModel(
      name: '허리근',
      upperLowerBody: '상체',
      bodyPart: 'spine',
      description: '허리 근육',
      detail: '허리 부위의 척추를 지지하고 안정시키는 근육군으로, 척추의 신전, 측면 굴곡, 회전에 관여합니다. 허리의 안정성과 자세 유지에 중요한 역할을 하며, 허리 통증과 관련이 깊은 근육입니다.',
    ),
    MuscleModel(
      name: '허리네모근',
      upperLowerBody: '상체',
      bodyPart: 'spine',
      description: '허리의 네모근',
      detail: '허리 부위의 깊은 층에 위치한 네모 모양의 근육으로, 척추의 가로돌기에서 시작하여 척추의 가시돌기에 붙습니다. 척추의 신전과 측면 굴곡에 관여하며, 허리 부위의 안정성과 자세 유지에 기여합니다.',
    ),
    MuscleModel(
      name: '허리엉덩갈비근',
      upperLowerBody: '상체',
      bodyPart: 'spine',
      description: '허리와 엉덩이, 갈비를 연결하는 근육',
      detail: '허리, 엉덩이, 갈비뼈를 연결하는 근육으로, 척추의 요추부와 갈비뼈에서 시작하여 골반에 붙습니다. 척추를 펴고, 골반을 기울이며, 호흡을 보조하는 역할을 합니다. 허리와 골반의 연결과 안정성에 중요한 근육입니다.',
    ),
    MuscleModel(
      name: '큰허리근',
      upperLowerBody: '상체',
      bodyPart: 'spine',
      description: '허리의 큰 근육',
      detail: '허리 부위의 가장 큰 근육으로, 척추의 요추부와 갈비뼈에서 시작하여 골반에 붙습니다. 척추를 펴고, 몸을 뒤로 젖히며, 골반을 앞으로 기울이는 동작에 관여합니다. 허리의 근육량과 힘의 주요 구성 요소입니다.',
    ),
    MuscleModel(
      name: '반막모양근',
      upperLowerBody: '상체',
      bodyPart: 'spine',
      description: '반막 모양의 근육',
      detail: '넙다리 뒤쪽에 위치한 근육으로, 골반에서 시작하여 정강뼈의 안쪽에 붙습니다. 무릎을 구부리고, 엉덩관절을 펴며, 다리를 안쪽으로 돌리는 동작에 관여합니다. 하체 뒤쪽 근육군의 일부로 보행과 달리기에 기여합니다.',
    ),
    MuscleModel(
      name: '반힘줄모양근',
      upperLowerBody: '상체',
      bodyPart: 'spine',
      description: '반힘줄 모양의 근육',
      detail: '넙다리 뒤쪽에 위치한 근육으로, 골반에서 시작하여 정강뼈의 안쪽에 붙습니다. 무릎을 구부리고, 엉덩관절을 펴며, 다리를 안쪽으로 돌리는 동작에 관여합니다. 하체 뒤쪽 근육군의 일부로 보행과 달리기에 기여합니다.',
    ),

    // pelvic floor (골반저)
    MuscleModel(
      name: '모음근',
      upperLowerBody: '하체',
      bodyPart: 'pelvicFloor',
      description: '골반저의 모음근',
      detail: '골반저에 위치한 근육으로, 골반의 아래쪽을 지지하고 내장을 지탱하는 역할을 합니다. 골반저의 안정성과 내장의 지지를 담당하며, 배뇨와 배변의 조절에도 관여합니다. 코어 안정성과 골반 건강에 중요한 근육입니다.',
    ),
    MuscleModel(
      name: '긴모음근',
      upperLowerBody: '하체',
      bodyPart: 'pelvicFloor',
      description: '골반저의 긴 모음근',
      detail: '골반저에 위치한 긴 근육으로, 골반의 앞쪽에서 뒤쪽으로 이어집니다. 골반저를 지지하고 내장을 지탱하며, 골반의 안정성과 배뇨, 배변의 조절에 관여합니다. 골반저 근육군의 주요 구성 요소입니다.',
    ),
    MuscleModel(
      name: '짧은 모음근',
      upperLowerBody: '하체',
      bodyPart: 'pelvicFloor',
      description: '골반저의 짧은 모음근',
      detail: '골반저에 위치한 짧은 근육으로, 골반의 앞쪽 부위에 위치합니다. 골반저의 안정성과 내장 지지에 기여하며, 배뇨와 배변의 조절에 보조적으로 관여합니다. 골반저 근육군의 일부로 골반 건강에 중요한 역할을 합니다.',
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

  // 근육 이름으로 MuscleModel 찾기
  static MuscleModel? getMuscleByName(String muscleName) {
    try {
      return allMuscles.firstWhere(
        (muscle) => muscle.name == muscleName.trim(),
      );
    } catch (e) {
      return null;
    }
  }
}