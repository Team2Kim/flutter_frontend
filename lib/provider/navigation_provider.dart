import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  static const int facilityIndex = 0;
  static const int videoSearchIndex = 1;
  static const int homeIndex = 2;
  static const int diaryIndex = 3;
  static const int bookmarkIndex = 4;

  final PageController pageController = PageController(initialPage: homeIndex);
  int _currentIndex = homeIndex;

  int get currentIndex => _currentIndex;

  Future<void> goTo(int index) async {
    final target = index.clamp(facilityIndex, bookmarkIndex);
    if (target == _currentIndex) return;
    _currentIndex = target;
    notifyListeners();

    if (!pageController.hasClients) return;
    await pageController.animateToPage(
      target,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void handlePageChanged(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> goToExerciseSearch() => goTo(videoSearchIndex);
  Future<void> goToHome() => goTo(homeIndex);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}


