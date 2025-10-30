import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../services/api_test_service.dart';
import '../provider/auth_provider.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final ApiTestService _apiService = ApiTestService();
  final TextEditingController _dateController = TextEditingController(text: '2025-10-08');
  
  Map<String, dynamic>? _response;
  bool _isLoading = false;
  String _selectedApi = 'journals'; // journals, recommendation, exercises

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _testJournalsApi() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final accessToken = authProvider.accessToken;

    if (accessToken == null || accessToken.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다. Access Token이 없습니다.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _response = null;
    });

    try {
      final response = await _apiService.getJournalsByDate(
        date: _dateController.text,
        accessToken: accessToken,
      );

      setState(() {
        _response = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _response = {
          'error': e.toString(),
        };
        _isLoading = false;
      });
    }
  }

  Future<void> _testRecommendationApi() async {
    setState(() {
      _isLoading = true;
      _response = null;
    });

    try {
      final response = await _apiService.getBasicRecommendation(
        userId: 'test_user',
        weeklyFrequency: 3,
        splitType: '전신 운동',
        mainGoal: '근육 증가',
        experienceLevel: '중급',
        sessionDuration: 60,
        preferredEquipment: '덤벨',
      );

      setState(() {
        _response = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _response = {
          'error': e.toString(),
        };
        _isLoading = false;
      });
    }
  }

  Future<void> _testExercisesApi() async {
    setState(() {
      _isLoading = true;
      _response = null;
    });

    try {
      final response = await _apiService.searchExercises(
        bodyPart: '가슴',
      );

      setState(() {
        _response = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _response = {
          'error': e.toString(),
        };
        _isLoading = false;
      });
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('클립보드에 복사되었습니다')),
    );
  }

  Widget _buildResponseView() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_response == null) {
      return const Center(
        child: Text('API를 테스트해보세요'),
      );
    }

    final statusCode = _response!['statusCode'];
    final success = _response!['success'] ?? false;
    final body = _response!['body'];

    // JSON 파싱 시도
    dynamic parsedBody;
    bool isJson = false;
    try {
      parsedBody = jsonDecode(body);
      isJson = true;
    } catch (e) {
      parsedBody = body;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Code
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: success ? Colors.green.shade100 : Colors.red.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  success ? Icons.check_circle : Icons.error,
                  color: success ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Status Code: $statusCode',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: success ? Colors.green.shade900 : Colors.red.shade900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Headers
          if (_response!['headers'] != null)
            ExpansionTile(
              title: const Text(
                'Response Headers',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.grey.shade100,
                  child: Text(
                    _response!['headers'].toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 16),

          // Response Body
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Response Body',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => _copyToClipboard(
                  isJson ? jsonEncode(parsedBody) : body,
                ),
                tooltip: '복사',
              ),
            ],
          ),
          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              isJson 
                  ? const JsonEncoder.withIndent('  ').convert(parsedBody)
                  : body,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API 테스트'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // API 선택 탭
          Container(
            color: Colors.grey.shade200,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedApi = 'journals'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      color: _selectedApi == 'journals' 
                          ? Theme.of(context).primaryColor 
                          : Colors.transparent,
                      child: Text(
                        '일지 조회',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _selectedApi == 'journals' 
                              ? Colors.white 
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedApi = 'recommendation'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      color: _selectedApi == 'recommendation' 
                          ? Theme.of(context).primaryColor 
                          : Colors.transparent,
                      child: Text(
                        'AI 추천',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _selectedApi == 'recommendation' 
                              ? Colors.white 
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedApi = 'exercises'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      color: _selectedApi == 'exercises' 
                          ? Theme.of(context).primaryColor 
                          : Colors.transparent,
                      child: Text(
                        '운동 검색',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _selectedApi == 'exercises' 
                              ? Colors.white 
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 입력 폼
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                if (_selectedApi == 'journals') ...[
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: authProvider.isAuthenticated 
                              ? Colors.green.shade50 
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: authProvider.isAuthenticated 
                                ? Colors.green 
                                : Colors.red,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              authProvider.isAuthenticated 
                                  ? Icons.check_circle 
                                  : Icons.error,
                              color: authProvider.isAuthenticated 
                                  ? Colors.green 
                                  : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                authProvider.isAuthenticated 
                                    ? '로그인됨 (Access Token 사용)' 
                                    : '로그인이 필요합니다',
                                style: TextStyle(
                                  color: authProvider.isAuthenticated 
                                      ? Colors.green.shade900 
                                      : Colors.red.shade900,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: '날짜 (YYYY-MM-DD)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                      hintText: '예: 2025-10-08',
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _testJournalsApi,
                      icon: const Icon(Icons.send),
                      label: const Text('일지 조회 API 테스트'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ] else if (_selectedApi == 'recommendation') ...[
                  const Text('AI 운동 추천 API를 테스트합니다.'),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _testRecommendationApi,
                      icon: const Icon(Icons.send),
                      label: const Text('AI 추천 API 테스트'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ] else if (_selectedApi == 'exercises') ...[
                  const Text('운동 검색 API를 테스트합니다.'),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _testExercisesApi,
                      icon: const Icon(Icons.send),
                      label: const Text('운동 검색 API 테스트'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Divider(height: 1),

          // 응답 결과
          Expanded(
            child: _buildResponseView(),
          ),
        ],
      ),
    );
  }
}

