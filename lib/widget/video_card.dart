import 'package:flutter/material.dart';
import 'package:gukminexdiary/model/exercise_model.dart';
import 'package:gukminexdiary/screen/video_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gukminexdiary/provider/bookmark_provider.dart';
import 'package:gukminexdiary/widget/add_dialog_widget.dart';

class VideoCard extends StatefulWidget {
  const VideoCard({super.key, required this.exercise});
  final ExerciseModelResponse exercise;

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
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
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 237, 255, 255),
                          ),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: "${widget.exercise.imageUrl}/${widget.exercise.imageFileName}", 
                                  imageBuilder: (context, imageProvider) => Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey[300],
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey[300],
                                    ),
                                    child: const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(_formatVideoLength(widget.exercise.videoLengthSeconds ?? 0), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,), textAlign: TextAlign.start,),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 150,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          widget.exercise.title, 
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,), 
                                          textAlign: TextAlign.end,),
                                      ),
                                    ),
                                    Consumer<BookmarkProvider>(
                                      builder: (context, bookmarkProvider, child) {
                                        final isBookmarked = bookmarkProvider.isBookmarked(widget.exercise);
                                        return IconButton(
                                          onPressed: () async {
                                            bookmarkProvider.toggleBookmark(widget.exercise);
                                          },
                                          icon: Icon(
                                            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                            color: isBookmarked ? Colors.blue : Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  // Text(_formatVideoLength(exercise.videoLengthSeconds ?? 0), style: TextStyle(fontSize: 14,),),
                                  Text("${widget.exercise.targetGroup ?? ''} 대상 ${widget.exercise.fitnessFactorName ?? ''} 운동", style: TextStyle(fontSize: 14,),),
                                ],),
                              ],
                            )
                          ]
                        ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [    
                        Text("운동 부위", style: TextStyle(fontSize: 14,),),
                        Text(widget.exercise.muscleName?.length != null && widget.exercise.muscleName!.length > 20 ? widget.exercise.muscleName!.substring(0, 20) + "..." : widget.exercise.muscleName ?? '', style: TextStyle(fontSize: 14,),),
                      ],
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
                                          Icon(Icons.fitness_center, size: 18),
                                          SizedBox(width: 4),
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
                                          Icon(Icons.video_library, size: 18),
                                          SizedBox(width: 4),
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

  String _formatVideoLength(int videoLength) {
    return (videoLength~/60).toString() + "분 " + (videoLength%60).toString() + "초";
  }

  String _formatTitleLength(String title) {
    if (title.length > 12) {
      return title.substring(0, 12) + "...";
    }
    return title;
  }
}
