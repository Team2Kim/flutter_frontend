import 'package:flutter/material.dart';
import 'package:gukminexdiary/model/user_profile_model.dart';
import 'package:gukminexdiary/services/user_service.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/widget/custom_drawer.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _userService = UserService();

  // 연령대 옵션
  static const List<String> _targetGroupOptions = [
    '유아기',
    '유소년',
    '청소년',
    '성인',
    '노인',
  ];

  // 운동 수준 옵션
  static const List<String> _fitnessLevelOptions = [
    '초급',
    '중급',
    '고급',
  ];

  static const List<String> _fitnessFactorOptions = [
    '근력/근지구력',
    '근력',
    '심폐지구력',
    '유연성',
    '순발력',
    '민첩성',
    '협응력',
    '전신지구력',
    '유산소',
    '평형성',
    '협응성',
    '체력인증',
    '체력측정',
    '근지구력',
    '재활',
    '기타',
  ];

  String? _selectedTargetGroup;
  String? _selectedFitnessLevel;
  String? _selectedFitnessFactor;

  UserProfile? _profile;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final profile = await _userService.fetchProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _selectedTargetGroup = _normalizeSelection(profile.targetGroup, _targetGroupOptions);
        _selectedFitnessLevel = _normalizeSelection(profile.fitnessLevelName, _fitnessLevelOptions);
        _selectedFitnessFactor = _normalizeSelection(profile.fitnessFactorName, _fitnessFactorOptions);
        _isLoading = false;
        _isSaving = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _handleSave() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _userService.updateProfile(
        targetGroup: _selectedTargetGroup,
        fitnessLevelName: _selectedFitnessLevel,
        fitnessFactorName: _selectedFitnessFactor,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필 정보가 저장되었습니다.')),
      );

      await _loadProfile();
      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: '설정',
        automaticallyImplyLeading: false,
      ),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.white, const Color.fromRGBO(241, 248, 255, 1)],
              radius: 0.7,
              stops: [0.3, 0.7],
            ),
          ),
          child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? _buildErrorState()
                : RefreshIndicator(
                    onRefresh: _loadProfile,
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        _buildProfileSummary(),
                        const SizedBox(height: 24),
                        _buildPreferenceForm(),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _isSaving ? null : _handleSave,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.save),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(_isSaving ? '저장 중...' : '선호도 저장'),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
      )
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? '오류가 발생했습니다.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadProfile,
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSummary() {
    final profile = _profile;
    if (profile == null) {
      return const SizedBox.shrink();
    }

    String formatDate(DateTime? date) {
      if (date == null) return '-';
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '회원 정보',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow('닉네임', profile.nickname ?? '-'),
          _buildSummaryRow('이메일', profile.email ?? '-'),
          _buildSummaryRow('아이디', profile.loginId ?? '-'),
          _buildSummaryRow('가입일', formatDate(profile.createdAt)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '운동 선호도 설정',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: '연령대',
            value: _selectedTargetGroup,
            items: _targetGroupOptions,
            onChanged: (String? value) {
              setState(() {
                _selectedTargetGroup = value;
              });
            },
          ),
          const SizedBox(height: 12),
          _buildDropdown(
            label: '운동 수준',
            value: _selectedFitnessLevel,
            items: _fitnessLevelOptions,
            onChanged: (String? value) {
              setState(() {
                _selectedFitnessLevel = value;
              });
            },
          ),
          const SizedBox(height: 12),
          _buildDropdown(
            label: '운동 목적',
            value: _selectedFitnessFactor,
            items: _fitnessFactorOptions,
            onChanged: (String? value) {
              setState(() {
                _selectedFitnessFactor = value;
              });
            },
          ),
          const SizedBox(height: 8),
          const Text(
            '선택 안 함을 고르면 해당 항목은 변경되지 않습니다.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String? _normalizeSelection(String? value, List<String> options) {
    if (value == null || value.isEmpty) return null;
    return options.contains(value) ? value : null;
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String?>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      isExpanded: true,
      items: [
        const DropdownMenuItem<String?>(
          value: null,
          child: Text('선택 안 함'),
        ),
        ...items.map<DropdownMenuItem<String?>>(
          (item) => DropdownMenuItem<String?>(
            value: item,
            child: Text(item),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }

}
