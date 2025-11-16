import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // body가 뒤에 비쳐 보이도록 위쪽은 투명, 아래쪽은 거의 불투명
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(241, 248, 255, 0.0),
            Color.fromRGBO(241, 248, 255, 0.8),
            Color.fromRGBO(241, 248, 255, 1.0),
          ],
        ),
      ),
      child: Container(
        height: 80,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: Row(
          children: [
            _buildNavButton(
              context: context,
              index: 0,
              isFirst: true,
              icon: Image.asset('assets/icons/gym.png', width: 20, height: 20),
              label: '시설 검색',
            ),
            _buildNavButton(
              context: context,
              index: 1,
              icon: const Icon(Icons.video_library),
              label: '운동 검색',
            ),
            _buildNavButton(
              context: context,
              index: 2,
              icon: const Icon(Icons.home),
              label: '홈',
            ),
            _buildNavButton(
              context: context,
              index: 3,
              icon: Image.asset('assets/icons/diary.png', width: 20, height: 20),
              label: 'AI 일지',
            ),
            _buildNavButton(
              context: context,
              index: 4,
              isLast: true,
              icon: const Icon(Icons.bookmark),
              label: '즐겨찾기',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required int index,
    required Widget icon,
    required String label,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: Container (
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSelected ? [const Color.fromARGB(255, 217, 222, 250), const Color.fromARGB(255, 255, 255, 255)] : [const Color.fromARGB(255, 255, 255, 255), const Color.fromARGB(255, 255, 255, 255)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: isSelected ? const Color.fromARGB(255, 191, 198, 233) : const Color.fromARGB(255, 255, 255, 255)),
            boxShadow: isSelected ? [BoxShadow(color: const Color.fromARGB(255, 255, 255, 255), blurRadius: 5, offset: Offset(0, 10))] : [BoxShadow(color: const Color.fromARGB(255, 180, 180, 180), blurRadius: 2, offset: Offset(0, 2))],
            // color: isSelected ? const Color.fromARGB(255, 191, 198, 233) : const Color.fromARGB(255, 255, 255, 255),
            borderRadius: isFirst ? const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)) : isLast ? const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)) : BorderRadius.circular(0),
        ),
        child: InkWell(
          onTap: () => onItemSelected(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
