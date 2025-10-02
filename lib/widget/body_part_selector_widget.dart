import 'package:flutter/material.dart';
import 'package:body_part_selector/body_part_selector.dart';
import '../model/muscle_model.dart';
import '../data/muscle_data.dart';

class BodyPartSelectorWidget extends StatefulWidget {
  final Function(List<String> selectedBodyParts)? onBodyPartsSelected;
  final Function(List<MuscleModel> selectedMuscles)? onMusclesSelected;

  const BodyPartSelectorWidget({
    super.key,
    this.onBodyPartsSelected,
    this.onMusclesSelected,
  });

  @override
  State<BodyPartSelectorWidget> createState() => _BodyPartSelectorWidgetState();
}

class _BodyPartSelectorWidgetState extends State<BodyPartSelectorWidget> {
  BodyParts selectedBodyParts = BodyParts();
  List<MuscleModel> selectedMuscles = [];
  List<BodySide> selectedBodySides = [
    BodySide.front,
    BodySide.left,
    BodySide.right,
    BodySide.back,
  ];

  int selectedBodySideIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 신체 부위 선택 섹션
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '신체 부위 선택',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(),
              const SizedBox(height: 16),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Row(
                  children: [
                    // 왼쪽: BodyPartSelector
                    Expanded(
                      flex: 1,
                      child: BodyPartSelector(
                        bodyParts: selectedBodyParts,
                        selectedColor: Colors.blue,
                        unselectedColor: Colors.grey,
                        side: selectedBodySides[selectedBodySideIndex],
                        onSelectionUpdated: (bodyParts) {
                          setState(() {
                            selectedBodyParts = bodyParts;
                            selectedMuscles.clear();
                          });
                          
                          // BodyParts 객체에서 선택된 부위들을 문자열 리스트로 변환 (true가 선택된 것)
                          List<String> selectedParts = [];
                          final bodyPartsMap = bodyParts.toMap();
                          for (var part in bodyPartsMap.keys) {
                            if (bodyPartsMap[part] == true) {
                              selectedParts.add(part);
                            }
                          }
                          
                          widget.onBodyPartsSelected?.call(selectedParts);
                        },
                      ),
                    ),
                    VerticalDivider(),
                    // 오른쪽: 근육 선택 섹션
                    // if (_getSelectedBodyParts().isNotEmpty)
                    Expanded(
                      flex: 1,
                      child: _MuscleSelectorWidget(
                        selectedBodyParts: _getSelectedBodyParts(), 
                        onMusclesSelected: (muscles) {
                          setState(() {
                            selectedMuscles = muscles;
                          });
                          widget.onMusclesSelected?.call(muscles);
                        },
                      ),
                    ),
                  ],
                ),
              ),
               // 신체 방향 선택 버튼들
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedBodySideIndex = (selectedBodySideIndex - 1 + selectedBodySides.length) % selectedBodySides.length;
                          });
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getBodySideName(selectedBodySides[selectedBodySideIndex]),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedBodySideIndex = (selectedBodySideIndex + 1) % selectedBodySides.length;
                          });
                        },
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                  SizedBox()
                ],
              ),
              )
            ],
          ),
        ),
        
        
      ],
    );
  }

  List<String> _getSelectedBodyParts() {
    List<String> selectedParts = [];
    final bodyParts = selectedBodyParts.toMap().keys.toList();
    for (var part in bodyParts) {
      if (selectedBodyParts.toMap()[part] == true) {
        selectedParts.add(part);
      }
    }
    print('selectedParts: $selectedParts');
    return selectedParts;
  }

  String _getBodySideName(BodySide side) {
    switch (side) {
      case BodySide.front:
        return '전면';
      case BodySide.left:
        return '좌측면';
      case BodySide.right:
        return '우측면';
      case BodySide.back:
        return '후면';
    }
  }
}

class _MuscleSelectorWidget extends StatefulWidget {
  final List<String> selectedBodyParts;
  final Function(List<MuscleModel>) onMusclesSelected;

  const _MuscleSelectorWidget({
    required this.selectedBodyParts,
    required this.onMusclesSelected,
  });

  @override
  State<_MuscleSelectorWidget> createState() => _MuscleSelectorWidgetState();
}

class _MuscleSelectorWidgetState extends State<_MuscleSelectorWidget> {
  List<MuscleModel> selectedMuscles = [];
  List<MuscleModel> muscles = [];

  @override
  void initState() {
    super.initState();
    _loadMuscles();
  }

  @override
  void didUpdateWidget(_MuscleSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedBodyParts != widget.selectedBodyParts) {
      _loadMuscles();
    }
  }

  void _loadMuscles() {
    muscles.clear();
    
    // 선택된 모든 부위에 해당하는 근육들을 수집
    for (String bodyPart in widget.selectedBodyParts) {
      List<MuscleModel> partMuscles = MuscleData.getMusclesByBodyPart(bodyPart);
      muscles.addAll(partMuscles);
    }
    
    // 중복 제거
    muscles = muscles.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '근육 선택',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${muscles.length}개의 근육이 있습니다',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: muscles.isEmpty
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '해당 부위의 근육 정보가 없습니다',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                    itemCount: muscles.length,
                    itemBuilder: (context, index) {
                      final muscle = muscles[index];
                      final isSelected = selectedMuscles.contains(muscle);
                      
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          // borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 24,
                                child: Checkbox(
                                  value: isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedMuscles.add(muscle);
                                      } else {
                                        selectedMuscles.remove(muscle);
                                      }
                                    });
                                    widget.onMusclesSelected(selectedMuscles);
                                  },
                                ),
                              ),
                              Text(
                                muscle.name,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Theme.of(context).primaryColor : null,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            muscle.description,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              MuscleData.getKoreanBodyPartName(muscle.bodyPart),
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],),
                        // ListTile(
                        //   title: Text(
                        //     muscle.name,
                        //     style: TextStyle(
                        //       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        //       color: isSelected ? Theme.of(context).primaryColor : null,
                        //     ),
                        //   ),
                        //   subtitle: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         muscle.description,
                        //         style: Theme.of(context).textTheme.bodySmall,
                        //       ),
                        //       const SizedBox(height: 4),
                        //       Container(
                        //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        //         decoration: BoxDecoration(
                        //           color: Theme.of(context).primaryColor.withOpacity(0.1),
                        //           borderRadius: BorderRadius.circular(12),
                        //         ),
                        //         child: Text(
                        //           MuscleData.getKoreanBodyPartName(muscle.bodyPart),
                        //           style: TextStyle(
                        //             fontSize: 12,
                        //             color: Theme.of(context).primaryColor,
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing: Checkbox(
                        //     value: isSelected,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         if (value == true) {
                        //           selectedMuscles.add(muscle);
                        //         } else {
                        //           selectedMuscles.remove(muscle);
                        //         }
                        //       });
                        //       widget.onMusclesSelected(selectedMuscles);
                        //     },
                        //   ),
                        //   onTap: () {
                        //     setState(() {
                        //       if (selectedMuscles.contains(muscle)) {
                        //         selectedMuscles.remove(muscle);
                        //       } else {
                        //         selectedMuscles.add(muscle);
                        //       }
                        //     });
                        //     widget.onMusclesSelected(selectedMuscles);
                        //   },
                        // ),
                      );
                    },
                  ),
                ),
          ),
          
          // 선택된 근육 요약
          if (selectedMuscles.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '선택된 근육 (${selectedMuscles.length}개)',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: selectedMuscles.map((muscle) {
                      return Chip(
                        label: Text(
                          muscle.name,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                        deleteIcon: Icon(
                          Icons.close,
                          size: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                        onDeleted: () {
                          setState(() {
                            selectedMuscles.remove(muscle);
                          });
                          widget.onMusclesSelected(selectedMuscles);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}