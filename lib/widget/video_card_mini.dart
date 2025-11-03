import 'package:flutter/material.dart';
import 'package:gukminexdiary/model/exercise_model.dart';
import 'package:gukminexdiary/screen/video_detail_screen.dart';
import 'package:gukminexdiary/widget/add_dialog_widget.dart';

class VideoCardMini extends StatefulWidget {
  const VideoCardMini({super.key, required this.exercise});
  final ExerciseModelResponse exercise;

  @override
  State<VideoCardMini> createState() => _VideoCardMiniState();
}

class _VideoCardMiniState extends State<VideoCardMini> {
  bool _istouched = false;
  @override
  Widget build(BuildContext context) {
    return Container (
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                setState(() {
                  _istouched = !_istouched;
                });
              },
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 237, 255, 255),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.exercise.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
                              const SizedBox(width: 8),
                              // 근육명 영역
                              Text(widget.exercise.muscleName ?? '', style: TextStyle(fontSize: 14, color: Colors.grey.shade700,),),
                            ],
                          ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeInOut,
                      child: _istouched
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        AddExerciseDialog.show(context, widget.exercise);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        backgroundColor: const Color.fromARGB(255, 131, 193, 255),
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("운동 기록하기"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => VideoDetailScreen(exercise: widget.exercise),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 176, 255, 179),
                                        foregroundColor: const Color.fromARGB(255, 44, 44, 44),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("영상 보러가기"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(height: 0),
                    )
                  ],
                )                   
              ),
            ),
          ),
        );
  }

}
