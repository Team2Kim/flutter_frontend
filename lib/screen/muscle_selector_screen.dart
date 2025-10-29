import 'package:flutter/material.dart';
import '../widget/body_part_selector_widget.dart';
import '../model/muscle_model.dart';
import '../data/muscle_data.dart';
import '../widget/custom_appbar.dart';

class MuscleSelectorScreen extends StatefulWidget {
  const MuscleSelectorScreen({super.key});

  @override
  State<MuscleSelectorScreen> createState() => _MuscleSelectorScreenState();
}

class _MuscleSelectorScreenState extends State<MuscleSelectorScreen> { 
  List<String> selectedBodyParts = [];
  List<MuscleModel> selectedMuscles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: '근육 검색',
        automaticallyImplyLeading: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.red.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BodyPartSelectorWidget(
        onBodyPartsSelected: (bodyParts) {
          print('bodyParts: $bodyParts');
          setState(() {
            selectedBodyParts = bodyParts;
            // selectedMuscles.clear();
          });
        },
        onMusclesSelected: (muscles) {
          setState(() {
            selectedMuscles = muscles;
          });
        },
      ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 60, top: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedBodyParts.clear();
                      selectedMuscles.clear();
                    });
                  },
                  child: const Text('초기화'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: selectedMuscles.isNotEmpty
                      ? () {
                          _showSelectedMuscles();
                        }
                      : null,
                  child: Text(
                    '검색 (${selectedMuscles.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSelectedMuscles() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('선택된 근육'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('선택된 근육:'),
              const SizedBox(height: 8),
              ...selectedMuscles.map((muscle) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ${muscle.name}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        muscle.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // 여기에 실제 검색 로직을 추가할 수 있습니다
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${selectedMuscles.length}개 근육으로 검색합니다'),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            },
            child: const Text('검색'),
          ),
        ],
      ),
    );
  }

  String _getKoreanBodyPartName(String englishBodyPart) {
    return MuscleData.getKoreanBodyPartName(englishBodyPart);
  }
}
