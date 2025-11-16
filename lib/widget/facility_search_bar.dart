import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gukminexdiary/provider/facility_provider.dart';

class FacilitySearchBar extends StatelessWidget {
  final VoidCallback onSearch;

  const FacilitySearchBar({
    super.key,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FacilityProvider>(
      builder: (context, facilityProvider, child) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, const Color.fromARGB(0, 245, 245, 245)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.7, 0.9],
                ),
                border: Border.all(color: const Color.fromARGB(255, 186, 225, 255), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: facilityProvider.type == 0
                        ? TextFormField(
                            controller: facilityProvider.searchController,
                            decoration: const InputDecoration(
                              hintText: '검색어를 입력해주세요.',
                              border: InputBorder.none,
                            ),
                          )
                        : TextFormField(
                            controller: facilityProvider.keywordController,
                            onChanged: (value) {
                              if (value.endsWith(' ')) {
                                facilityProvider.addKeyword(value.trim());
                                facilityProvider.keywordController.clear();
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: '입력 후 띄어쓰기를 하면 조건이 추가됩니다.',
                              border: InputBorder.none,
                            ),
                          ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: facilityProvider.type == 0 ? Colors.grey[800] : Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      facilityProvider.toggleType();
                    },
                    child: facilityProvider.type == 0
                        ? const Text('이름', style: TextStyle(color: Colors.white))
                        : const Text('조건', style: TextStyle(color: Colors.white)),
                  ),
                  IconButton(
                    onPressed: onSearch,
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ),
            facilityProvider.type == 1
                ? Container(
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        for (var keyword in facilityProvider.keywords)
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                            ),
                            onPressed: () {
                              facilityProvider.removeKeyword(keyword);
                            },
                            child: Text('${keyword} X'),
                          ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
