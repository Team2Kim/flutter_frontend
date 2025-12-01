import 'package:flutter/material.dart';

class PrivacyConsentScreen extends StatefulWidget {
  final Function(Map<String, bool>)? onConsentSubmitted;

  const PrivacyConsentScreen({
    super.key,
    this.onConsentSubmitted,
  });

  @override
  State<PrivacyConsentScreen> createState() => _PrivacyConsentScreenState();
}

class _PrivacyConsentScreenState extends State<PrivacyConsentScreen> {
  // 필수 동의
  bool _requiredConsent = false;

  bool get _allRequiredConsent => _requiredConsent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '개인정보 수집·이용 동의',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 섹션 1: 개인정보 수집·이용 동의 (필수)
            _buildRequiredConsentSection(),
            const SizedBox(height: 40),

            // 동의/거부 버튼
            _buildActionButtons(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 섹션 1: 개인정보 수집·이용 동의 (필수)
  Widget _buildRequiredConsentSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '개인정보 수집·이용 동의',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "사용자는 '오늘운동' 서비스 회원 가입 및 고지사항 전달을 위해 다음과 같이 개인정보를 수집·이용합니다.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          
          // 테이블
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(color: Colors.grey[300]!),
                verticalInside: BorderSide(color: Colors.grey[300]!),
              ),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1.5),
              },
              children: [
                // 헤더
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                  ),
                  children: [
                    _buildTableCell('수집 목적', isHeader: true),
                    _buildTableCell('수집 항목', isHeader: true),
                    _buildTableCell('수집 근거', isHeader: true),
                  ],
                ),
                // 회원 식별 및 회원제 서비스 제공
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        '회원 식별 및\n서비스 제공',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        '아이디, 비밀번호, 이메일',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        '개인정보 보호법\n제15조 제1항',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                // 서비스 변경사항 및 고지사항 전달
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        '서비스 변경사항 및\n고지사항 전달',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        '이메일',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        '개인정보 보호법\n제15조 제1항',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '* 귀하는 오늘운동의 서비스 이용에 필요한 최소한의 개인정보 수집·이용에 동의하지 않을 수 있으나, 동의를 거부할 경우 서비스 이용이 불가합니다.',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: _requiredConsent,
                  onChanged: (bool? value) {
                    setState(() {
                      _requiredConsent = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    '위 개인정보 수집·이용에 동의합니다.(필수)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 13 : 12,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey[400]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '취소',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _allRequiredConsent
                ? () {
                    final consentData = {
                      'required': _requiredConsent,
                    };

                    if (widget.onConsentSubmitted != null) {
                      widget.onConsentSubmitted!(consentData);
                    }

                    Navigator.pop(context, consentData);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              disabledForegroundColor: Colors.grey[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '동의하고 계속하기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

