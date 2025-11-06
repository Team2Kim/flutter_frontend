import 'package:flutter/material.dart';
import 'package:gukminexdiary/model/exercise_model.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
import 'package:gukminexdiary/widget/add_dialog_widget.dart';
import 'package:gukminexdiary/widget/muscle_description_dialog.dart';
import 'package:video_player/video_player.dart';

class VideoDetailScreen extends StatefulWidget {
  final ExerciseModelResponse exercise;

  const VideoDetailScreen({super.key, required this.exercise});

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  VideoPlayerController? _controller;
  bool _isVideoInitialized = false;
  bool _isFullScreen = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    if (widget.exercise.videoUrl != null && widget.exercise.videoUrl!.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.exercise.videoUrl!));
      await _controller!.initialize();
      
      // 비디오 상태 변화를 감지하는 리스너 추가
      _controller!.addListener(_videoListener);
      
      setState(() {
        _isVideoInitialized = true;
      });
    }
  }

  void _videoListener() {
    if (_controller != null) {
      setState(() {
        // 비디오 상태가 변경될 때마다 UI 업데이트
      });
    }
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  void _setVolume(double volume) {
    setState(() {
      if (volume == 0.0) {
        _controller!.setVolume(0.0);
        _isMuted = true;
      } else {
        _controller!.setVolume(volume);
        _isMuted = false;
      }
    });
  }

  Widget _buildFullScreenVideo() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: _isVideoInitialized && _controller != null
          ? Stack(
              children: [
                // 전체화면 영상
                Center(
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                ),
                // 전체화면 컨트롤 오버레이
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_controller!.value.isPlaying) {
                          _controller!.pause();
                        } else {
                          _controller!.play();
                        }
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          // 하단 컨트롤 바
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // 진행바
                                  VideoProgressIndicator(
                                    _controller!,
                                    allowScrubbing: true,
                                    colors: VideoProgressColors(
                                      playedColor: Colors.red,
                                      bufferedColor: Colors.grey[300]!,
                                      backgroundColor: Colors.grey[600]!,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // 컨트롤 버튼들
                                  Row(
                                    children: [
                                      // 재생/일시정지
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (_controller!.value.isPlaying) {
                                              _controller!.pause();
                                            } else {
                                              _controller!.play();
                                            }
                                          });
                                        },
                                        icon: Icon(
                                          _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // 시간 표시
                                      Text(
                                        '${_formatDuration(_controller!.value.position)} / ${_formatDuration(_controller!.value.duration)}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const Spacer(),
                                      // 볼륨
                                      SizedBox(
                                        width: 100, 
                                        child: SliderTheme(
                                          data: SliderThemeData(
                                          trackShape: RectangularSliderTrackShape(),
                                          trackHeight: 4,
                                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                                          thumbColor: Colors.white,
                                          overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
                                          overlayColor: Colors.white.withOpacity(0.2),
                                        ), 
                                        child: Slider(
                                          onChanged: (value) {
                                            _setVolume(value);
                                          },
                                          value: _controller!.value.volume, 
                                          min: 0.0, 
                                          max: 1.0, 
                                          divisions: 100,),
                                        ),
                                      ),
                                      // PopupMenuButton<double>(
                                      //   icon: Icon(
                                      //     _isMuted ? Icons.volume_off : Icons.volume_up,
                                      //     color: Colors.white,
                                      //     size: 24,
                                      //   ),
                                      //   onSelected: _setVolume,
                                      //   itemBuilder: (context) => [
                                      //     PopupMenuItem(
                                      //       value: 0.0,
                                      //       child: Row(
                                      //         children: [
                                      //           Icon(_isMuted ? Icons.volume_off : Icons.volume_mute),
                                      //           const SizedBox(width: 8),
                                      //           const Text('음소거'),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     PopupMenuItem(
                                      //       value: 0.25,
                                      //       child: Row(
                                      //         children: [
                                      //           const Icon(Icons.volume_down),
                                      //           const SizedBox(width: 8),
                                      //           const Text('25%'),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     PopupMenuItem(
                                      //       value: 0.5,
                                      //       child: Row(
                                      //         children: [
                                      //           const Icon(Icons.volume_down),
                                      //           const SizedBox(width: 8),
                                      //           const Text('50%'),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     PopupMenuItem(
                                      //       value: 0.75,
                                      //       child: Row(
                                      //         children: [
                                      //           const Icon(Icons.volume_up),
                                      //           const SizedBox(width: 8),
                                      //           const Text('75%'),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     PopupMenuItem(
                                      //       value: 1.0,
                                      //       child: Row(
                                      //         children: [
                                      //           const Icon(Icons.volume_up),
                                      //           const SizedBox(width: 8),
                                      //           const Text('100%'),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      const SizedBox(width: 8),
                                      // 전체화면 종료
                                      IconButton(
                                        onPressed: _toggleFullScreen,
                                        icon: const Icon(
                                          Icons.fullscreen_exit,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
    );
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  String _formatVideoLength(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullScreen ? null : CustomAppbar(
        title: '운동 영상',
        automaticallyImplyLeading: true,
      ),
      body: _isFullScreen 
          ? _buildFullScreenVideo()
          : SingleChildScrollView(
              child: 
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.green.shade100],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
             // 영상 섹션 (일반 모드)
             Container(
              alignment: Alignment.center,
               width: double.infinity,
               height: MediaQuery.of(context).size.height * 0.3,
               padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
               margin: const EdgeInsets.symmetric(horizontal: 10),
               decoration: BoxDecoration(
                 color: Colors.grey[600],
                 borderRadius: BorderRadius.circular(12),
               ),
               child: _isVideoInitialized && _controller != null
                   ? Stack(
                       children: [
                         ClipRRect(
                           child: AspectRatio(
                             aspectRatio: _controller!.value.aspectRatio,
                             child: VideoPlayer(_controller!),
                           ),
                         ),
                         // 유튜브 스타일 컨트롤 오버레이
                         Positioned.fill(
                           child: GestureDetector(
                             onTap: () {
                               setState(() {
                                 if (_controller!.value.isPlaying) {
                                   _controller!.pause();
                                 } else {
                                   _controller!.play();
                                 }
                               });
                             },
                             child: Container(
                               color: Colors.transparent,
                               child: Stack(
                                 children: [
                                   // 하단 컨트롤 바
                                   Positioned(
                                     bottom: 0,
                                     left: 0,
                                     right: 0,
                                     child: Container(
                                       decoration: BoxDecoration(
                                         gradient: LinearGradient(
                                           begin: Alignment.topCenter,
                                           end: Alignment.bottomCenter,
                                           colors: [
                                             Colors.transparent,
                                             Colors.black.withOpacity(0.7),
                                           ],
                                         ),
                                       ),
                                       padding: const EdgeInsets.all(16),
                                       child: Column(
                                         mainAxisSize: MainAxisSize.min,
                                         children: [
                                           // 진행바
                                           VideoProgressIndicator(
                                             _controller!,
                                             allowScrubbing: true,
                                             colors: VideoProgressColors(
                                               playedColor: Colors.red,
                                               bufferedColor: Colors.grey[300]!,
                                               backgroundColor: Colors.grey[600]!,
                                             ),
                                           ),
                                           const SizedBox(height: 12),
                                           // 컨트롤 버튼들
                                           Row(
                                             children: [
                                               // 재생/일시정지
                                               IconButton(
                                                 onPressed: () {
                                                   setState(() {
                                                     if (_controller!.value.isPlaying) {
                                                       _controller!.pause();
                                                     } else {
                                                       _controller!.play();
                                                     }
                                                   });
                                                 },
                                                 icon: Icon(
                                                   _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                                   color: Colors.white,
                                                   size: 32,
                                                 ),
                                               ),
                                               const SizedBox(width: 8),
                                               // 시간 표시
                                               Text(
                                                 '${_formatDuration(_controller!.value.position)} / ${_formatDuration(_controller!.value.duration)}',
                                                 style: const TextStyle(
                                                   color: Colors.white,
                                                   fontSize: 14,
                                                 ),
                                               ),
                                               const Spacer(),
                                               // 볼륨
                                               SizedBox(
                                                  width: 100, 
                                                  child: SliderTheme(
                                                    data: SliderThemeData(
                                                    trackShape: RectangularSliderTrackShape(),
                                                    trackHeight: 4,
                                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                                                    thumbColor: Colors.white,
                                                    overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
                                                    overlayColor: Colors.white.withOpacity(0.2),
                                                  ), 
                                                  child: Slider(
                                                    activeColor: Colors.blue,
                                                    inactiveColor: Colors.grey[600]!,
                                                    onChanged: (value) {
                                                      _setVolume(value);
                                                    },
                                                    value: _controller!.value.volume, 
                                                    min: 0.0, 
                                                    max: 1.0, 
                                                    divisions: 100,),
                                                  ),
                                                ),
                                               const SizedBox(width: 8),
                                               // 전체화면
                                               IconButton(
                                                 onPressed: _toggleFullScreen,
                                                 icon: const Icon(
                                                   Icons.fullscreen,
                                                   color: Colors.white,
                                                   size: 24,
                                                 ),
                                               ),
                                             ],
                                           ),
                                         ],
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ),
                       ],
                     )
                   : Center(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(
                             Icons.play_circle_outline,
                             size: 64,
                             color: Colors.grey[600],
                           ),
                           const SizedBox(height: 8),
                           Text(
                             '영상을 불러오는 중...',
                             style: TextStyle(
                               color: Colors.grey[600],
                               fontSize: 16,
                             ),
                           ),
                         ],
                       ),
                     ),
             ),
            
            const SizedBox(height: 10),
            
            if (!_isFullScreen) ...[
              
              // 운동 정보 섹션
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child:Text(
                          widget.exercise.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),)
                      ),
                      const Spacer(),
                      // 운동 기록 추가 버튼
                      SizedBox(
                        width: 100,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            AddExerciseDialog.show(context, widget.exercise);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('일지 추가'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],),
                    const SizedBox(height: 16),
                    _buildInfoRow('카테고리', widget.exercise.fitnessFactorName ?? '', Color.fromARGB(255, 255, 202, 176), Color.fromARGB(255, 255, 238, 229), false),
                    _buildInfoRow('운동 부위', widget.exercise.muscleName ?? '', Color.fromARGB(255, 217, 255, 171), Color.fromARGB(255, 245, 255, 233), true),
                    _buildInfoRow('대상 그룹', widget.exercise.targetGroup ?? '', Color.fromARGB(255, 179, 217, 255), Color.fromARGB(255, 229, 242, 255), false),
                    _buildInfoRow('영상 길이', _formatVideoLength(widget.exercise.videoLengthSeconds ?? 0), Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255), false ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        widget.exercise.description ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
          ),
          ),
        ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color color, Color color2, bool isMuscle) {
    final valueList = value.split(',');
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            alignment: Alignment.centerLeft,
            width: 80,
            child: Text(
              textAlign: TextAlign.left,
              '$label:',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.withOpacity(0.5), Colors.grey.withOpacity(0.2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3, 0.7],
              ),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            width: MediaQuery.of(context).size.width * 0.6,
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: valueList.length,
              itemBuilder: (context, index) {
                return 
                InkWell(
                onTap: () {
                  if (isMuscle) {
                    MuscleDescriptionDialog.show(context, valueList[index]);
                  } else {
                    // TODO: 운동 기록 추가 버튼 클릭 시 운동 기록 추가 화면으로 이동
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.3, 0.7]
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(5),  
                  alignment: Alignment.center,
                  child: Text(valueList[index])
                )
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
