import 'package:flutter/material.dart';
import 'package:gukminexdiary/model/exercise_model.dart';
import 'package:gukminexdiary/screen/video_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gukminexdiary/provider/bookmark_provider.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.exercise});
  final ExerciseModelResponse exercise;

  @override
  Widget build(BuildContext context) {
    return _buildVideoCard(context, exercise);
  }

  Widget _buildVideoCard(BuildContext context, ExerciseModelResponse exercise) {
    return Container (
          decoration: BoxDecoration(
            color: Colors.white,
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
            padding: const EdgeInsets.all(15),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoDetailScreen(exercise: exercise),
                  ),
                );
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
                            CachedNetworkImage(
                              imageUrl: "${exercise.imageUrl}/${exercise.imageFileName}", 
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(exercise.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,), textAlign: TextAlign.start,),
                                Consumer<BookmarkProvider>(
                                  builder: (context, bookmarkProvider, child) {
                                    final isBookmarked = bookmarkProvider.isBookmarked(exercise);
                                    return IconButton(
                                      onPressed: () async {
                                        if (isBookmarked) {
                                          bookmarkProvider.removeBookmark(exercise);
                                        } else {
                                          bookmarkProvider.addBookmark(exercise);
                                        }
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
                          ]
                        ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(children: [
                          Text("영상 길이", style: TextStyle(fontSize: 14,),),
                          Text(_formatVideoLength(exercise.videoLengthSeconds ?? 0), style: TextStyle(fontSize: 14,),),
                        ],),
                        Column(children: [  
                          Text("체력 항목", style: TextStyle(fontSize: 14,),),
                          Text(exercise.fitnessFactorName ?? '', style: TextStyle(fontSize: 14,),),
                        ],),
                        Column(children: [
                          Text("운동 대상", style: TextStyle(fontSize: 14,),),
                          Text(exercise.targetGroup ?? '', style: TextStyle(fontSize: 14,),),
                        ],),
                        Column(children: [
                          Text("운동 부위", style: TextStyle(fontSize: 14,),),
                          Text(exercise.bodyPart ?? '', style: TextStyle(fontSize: 14,),),
                        ],),
                      ],
                    ),  
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
}
