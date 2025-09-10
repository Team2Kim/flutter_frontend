import 'package:flutter/material.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:table_calendar/table_calendar.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week; // 주간 뷰로 설정
  ScrollController _scrollController = ScrollController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _setsController = TextEditingController();
  TextEditingController _repsController = TextEditingController();
  TextEditingController _minuteController = TextEditingController();
  TextEditingController _secondController = TextEditingController();

  Map<String, dynamic> _exercises = {
    '2025-09-09T09:00:00': {
      'name': '푸시업',
      'sets': 3,
      'reps': 10,
      'time': '30:00',
    },
    '2025-09-09T10:00:00': {
      'name': '데드리프트',
      'sets': 3,
      'reps': 10,
      'time': '30:00',
    },
    '2025-09-09T11:00:00': {
      'name': '스쿼트',
      'sets': 3,
      'reps': 10,
      'time': '30:00',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: '운동 일지',
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const Text(
              '운동일지',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // 주간 달력
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TableCalendar(
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),
                focusedDay: _focusedDate,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDate, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                    _focusedDate = focusedDay;
                  });
                  print('선택된 날짜: $selectedDay');
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDate = focusedDay;
                },
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(
                    color: Colors.red.shade400,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  formatButtonTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(
                    color: Colors.red.shade400,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 선택된 날짜 정보
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, color: Colors.blue.shade700),
                  const SizedBox(width: 10),
                  Text(
                    '${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _exercises.length,
                itemBuilder: (context, index) {
                  final exercise = _exercises.values.toList()[index];
                  return _buildExerciseCard(exercise, _exercises.keys.toList()[index]);
                },
              ),
            ),         
            // 일지 작성 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final key  = DateTime.now().toString().split(' ')[0] + 'T' + DateTime.now().toString().split(' ')[1];
                  // print(key);
                  _exercises[key] = {
                    'name': '운동 이름',
                    'sets': 0,
                    'reps': 0,
                    'time': '00:00',
                  };
                  setState(() {});
                  // TODO: 일지 작성 화면으로 이동
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${_selectedDate.month}월 ${_selectedDate.day}일 운동 추가'),
                    ),
                  );
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent,
                    );
                  });
                },
                icon: const Icon(Icons.edit),
                label: const Text('운동 추가하기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTimeString(String recordTime, String time) {
    final parsedRecordTime = DateTime.parse(recordTime);
    final splittedTime = time.split(':');
    print(splittedTime);
    final timeInt = int.parse(splittedTime[0]) * 60 + int.parse(splittedTime[1]);
    final startTime = recordTime.split('T')[1];
    print(startTime);
    final startTimeStringSplitted = startTime.split(':');
    print(startTimeStringSplitted);
    final endTime = parsedRecordTime.add(Duration(seconds: timeInt));
    final endTimeString = endTime.toString().split(' ')[1];
    final endTimeStringSplitted = endTimeString.split(':');

    return '${startTimeStringSplitted[0]}:${startTimeStringSplitted[1]} ~ ${endTimeStringSplitted[0]}:${endTimeStringSplitted[1]} (${splittedTime[0]}분)';
  }

  Widget _buildExerciseEditPopup(Map<String, dynamic> exercise, String key) {
    _nameController.text = exercise['name'];
    _setsController.text = exercise['sets'].toString();
    _repsController.text = exercise['reps'].toString();
    _minuteController.text = exercise['time'].split(':')[0];
    _secondController.text = exercise['time'].split(':')[1];
    return AlertDialog(
      title: Text('운동 수정'),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '운동 이름',
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _setsController,
                    decoration: InputDecoration(
                      labelText: '세트',
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                  controller: _repsController,
                  decoration: InputDecoration(
                    labelText: '횟수',
                  ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _minuteController,
                    decoration: InputDecoration(
                      labelText: '분',
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _secondController,
                    decoration: InputDecoration(
                      labelText: '초',
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ),
      actions: [
        TextButton(onPressed: () {
          Navigator.pop(context);
        }, child: Text('취소')),
        TextButton(onPressed: () {
          exercise['name'] = _nameController.text;
          exercise['sets'] = int.parse(_setsController.text);
          exercise['reps'] = int.parse(_repsController.text);
          exercise['time'] = '${_minuteController.text}:${_secondController.text}';
          setState(() {});
          Navigator.pop(context);
        }, child: Text('저장')),
      ],
    );
  }

  Widget _buildExerciseCard(Map<String, dynamic> exercise, String key) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(padding: const EdgeInsets.all(10), child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise['name']),
                Text('${exercise['sets']} sets x ${exercise['reps']} reps'),
                Text('${getTimeString(key, exercise['time'])}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _exercises.remove(key);
                    });
                  },
                  icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                ),
                IconButton( 
                  onPressed: () {
                    setState(() {
                      showDialog(context: context, builder: (context) => _buildExerciseEditPopup(exercise, key));
                    });
                  },
                  icon: const Icon(Icons.edit, size: 16, color: Colors.blue),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}
