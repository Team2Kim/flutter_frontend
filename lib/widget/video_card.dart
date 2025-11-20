import 'package:flutter/material.dart';
import 'package:gukminexdiary/model/exercise_model.dart';
import 'package:gukminexdiary/screen/video_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gukminexdiary/provider/bookmark_provider.dart';
import 'package:gukminexdiary/widget/add_dialog_widget.dart';
import 'package:gukminexdiary/widget/muscle_description_dialog.dart';

class VideoCard extends StatefulWidget {
  VideoCard({super.key, required this.exercise, this.selectedMuscleNames = const []});
  final ExerciseModelResponse exercise;
  final List<String> selectedMuscleNames;

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  bool _istouched = false;
  
  @override
  void initState() {
    super.initState();
    print(widget.exercise.videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return
           Container(
            margin: const EdgeInsets.only(top:5, bottom: 5, left: 10, right: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
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
                            gradient: LinearGradient(
                              colors: [
                                const Color.fromARGB(0, 231, 242, 250),
                                const Color.fromARGB(0, 231, 242, 250)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(children: [
                                  CachedNetworkImage(
                                    imageUrl: "${widget.exercise.imageUrl}/${widget.exercise.imageFileName}", 
                                    imageBuilder: (context, imageProvider) => Container(
                                      width: 80,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) => Container(
                                      width: 80,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[300],
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      width: 80,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[300],
                                      ),
                                      child: const Icon(
                                        Icons.image_not_supported_outlined,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 4,
                                    left: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _formatVideoLength(widget.exercise.videoLengthSeconds ?? 0), 
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white), 
                                        textAlign: TextAlign.start,),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        return SizedBox(width: 30, height: 20, child: IconButton(
                                          onPressed: () async {
                                            bookmarkProvider.toggleBookmark(widget.exercise);
                                          },
                                          icon: Icon(
                                            size: 20,
                                            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                            color: isBookmarked ? Colors.blue : Colors.grey,
                                          ),
                                        ));
                                      },
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 150,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      widget.exercise.standardTitle ?? '', 
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,), 
                                      textAlign: TextAlign.end,),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  // Text(_formatVideoLength(exercise.videoLengthSeconds ?? 0), style: TextStyle(fontSize: 14,),),
                                  Text("${widget.exercise.targetGroup ?? ''} 대상 ${widget.exercise.fitnessFactorName ?? ''} 운동", style: TextStyle(fontSize: 14,),),
                                ],),
                              ],
                            ))
                          ]
                        ),
                    ),
                    SizedBox(
                      height: 30,
                      child: widget.exercise.muscleName?.split(',').length != null && widget.exercise.muscleName!.split(',').length > 0 ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.exercise.muscleName?.split(',').length ?? 0,
                        itemBuilder: (context, index) {
                          final muscleName = widget.exercise.muscleName?.split(',');
                          final currentMuscleName = muscleName![index].trim();
                          // print(muscleName![index]);
                          return InkWell(
                            onTap: () {
                              MuscleDescriptionDialog.show(context, currentMuscleName);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: !widget.selectedMuscleNames.contains(currentMuscleName) ? Colors.blue.withOpacity(0.2) : const Color.fromARGB(255, 200, 255, 202).withOpacity(0.2),
                                  width: 1,
                                ),
                                // color: Colors.white,
                                gradient: !widget.selectedMuscleNames.contains(currentMuscleName) ? LinearGradient(
                                  colors: [Colors.blue.shade50, Colors.white],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    stops: [0.05, 0.2],
                                  ) :  LinearGradient(
                                  colors: [
                                    const Color.fromARGB(255, 200, 255, 202).withOpacity(0.2),
                                      Colors.white,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: [0.05, 0.2],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),  
                              child: Text(currentMuscleName, 
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 80, 80, 80)),)
                            ),
                          );
                        },
                      ) : const Text('등록된 운동 부위가 없습니다.', 
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
                        textAlign: TextAlign.left,),
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
                                    child: InkWell(
                                      onTap: () {
                                        AddExerciseDialog.show(context, widget.exercise);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Color.fromARGB(255, 214, 232, 249), Colors.white],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            stops: [0.01, 0.1],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          border: Border.all(color: Colors.blue.withOpacity(0.2), width: 1,),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.fitness_center, size: 18),
                                            SizedBox(width: 4),
                                            Text("운동 기록", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),),
                                          ],
                                        ),
                                      ),
                                    )
                                    // child: ElevatedButton(
                                    //   onPressed: () {
                                    //     AddExerciseDialog.show(context, widget.exercise);
                                    //   },
                                    //   style: ElevatedButton.styleFrom(
                                    //     shape: RoundedRectangleBorder(
                                    //       borderRadius: BorderRadius.circular(6),
                                    //     ),
                                    //     backgroundColor: const Color.fromARGB(255, 131, 193, 255),
                                    //     foregroundColor: Colors.white,
                                    //   ),
                                    //   child: const Row(
                                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    //     children: [
                                    //       Icon(Icons.fitness_center, size: 18),
                                    //       SizedBox(width: 4),
                                    //       Text("운동 기록"),
                                    //     ],
                                    //   ),
                                    // ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => VideoDetailScreen(exercise: widget.exercise),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Color.fromARGB(255, 221, 254, 222), Colors.white],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            stops: [0.01, 0.1],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          border: Border.all(color: Color.fromARGB(255, 205, 255, 207), width: 1,),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.video_library, size: 18),
                                            SizedBox(width: 4),
                                            Text("영상 보기", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // child: ElevatedButton(
                                    //   onPressed: () {
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) => VideoDetailScreen(exercise: widget.exercise),
                                    //       ),
                                    //     );
                                    //   },
                                    //   style: ElevatedButton.styleFrom(
                                    //     backgroundColor: const Color.fromARGB(255, 176, 255, 179),
                                    //     foregroundColor: const Color.fromARGB(255, 44, 44, 44),
                                    //     shape: RoundedRectangleBorder(
                                    //       borderRadius: BorderRadius.circular(6),
                                    //     ),
                                    //   ),
                                    //   child: const Row(
                                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    //     children: [
                                    //       Icon(Icons.video_library, size: 18),
                                    //       SizedBox(width: 4),
                                    //       Text("영상 보기"),
                                    //     ],
                                    //   ),
                                    // ),
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
          );
  }

  String _formatVideoLength(int videoLength) {
    return (videoLength~/60).toString().padLeft(2, '0') + ":" + (videoLength%60).toString().padLeft(2, '0');
  }
}
