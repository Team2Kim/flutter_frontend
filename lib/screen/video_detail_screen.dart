import 'package:flutter/material.dart';
import 'package:gukminexdiary/model/exercise_model.dart';
import 'package:gukminexdiary/widget/custom_appbar.dart';
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
  double _volume = 1.0;
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

  void _seekTo(Duration position) {
    if (_controller != null) {
      _controller!.seekTo(position);
    }
  }

  void _toggleMute() {
    setState(() {
      if (_isMuted) {
        _controller!.setVolume(_volume);
        _isMuted = false;
      } else {
        _controller!.setVolume(0.0);
        _isMuted = true;
      }
    });
  }

  void _setVolume(double volume) {
    setState(() {
      _volume = volume;
      if (!_isMuted) {
        _controller!.setVolume(volume);
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
                                      PopupMenuButton<double>(
                                        icon: Icon(
                                          _isMuted ? Icons.volume_off : Icons.volume_up,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        onSelected: _setVolume,
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 0.0,
                                            child: Row(
                                              children: [
                                                Icon(_isMuted ? Icons.volume_off : Icons.volume_mute),
                                                const SizedBox(width: 8),
                                                const Text('음소거'),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 0.25,
                                            child: Row(
                                              children: [
                                                const Icon(Icons.volume_down),
                                                const SizedBox(width: 8),
                                                const Text('25%'),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 0.5,
                                            child: Row(
                                              children: [
                                                const Icon(Icons.volume_down),
                                                const SizedBox(width: 8),
                                                const Text('50%'),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 0.75,
                                            child: Row(
                                              children: [
                                                const Icon(Icons.volume_up),
                                                const SizedBox(width: 8),
                                                const Text('75%'),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 1.0,
                                            child: Row(
                                              children: [
                                                const Icon(Icons.volume_up),
                                                const SizedBox(width: 8),
                                                const Text('100%'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
             // 영상 섹션 (일반 모드)
             Container(
               width: double.infinity,
               height: 250,
               decoration: BoxDecoration(
                 color: Colors.grey[300],
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
                                               PopupMenuButton<double>(
                                                 icon: Icon(
                                                   _isMuted ? Icons.volume_off : Icons.volume_up,
                                                   color: Colors.white,
                                                   size: 24,
                                                 ),
                                                 onSelected: _setVolume,
                                                 itemBuilder: (context) => [
                                                   PopupMenuItem(
                                                     value: 0.0,
                                                     child: Row(
                                                       children: [
                                                         Icon(_isMuted ? Icons.volume_off : Icons.volume_mute),
                                                         const SizedBox(width: 8),
                                                         const Text('음소거'),
                                                       ],
                                                     ),
                                                   ),
                                                   PopupMenuItem(
                                                     value: 0.25,
                                                     child: Row(
                                                       children: [
                                                         const Icon(Icons.volume_down),
                                                         const SizedBox(width: 8),
                                                         const Text('25%'),
                                                       ],
                                                     ),
                                                   ),
                                                   PopupMenuItem(
                                                     value: 0.5,
                                                     child: Row(
                                                       children: [
                                                         const Icon(Icons.volume_down),
                                                         const SizedBox(width: 8),
                                                         const Text('50%'),
                                                       ],
                                                     ),
                                                   ),
                                                   PopupMenuItem(
                                                     value: 0.75,
                                                     child: Row(
                                                       children: [
                                                         const Icon(Icons.volume_up),
                                                         const SizedBox(width: 8),
                                                         const Text('75%'),
                                                       ],
                                                     ),
                                                   ),
                                                   PopupMenuItem(
                                                     value: 1.0,
                                                     child: Row(
                                                       children: [
                                                         const Icon(Icons.volume_up),
                                                         const SizedBox(width: 8),
                                                         const Text('100%'),
                                                       ],
                                                     ),
                                                   ),
                                                 ],
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
            
            const SizedBox(height: 20),
            
            if (!_isFullScreen) ...[
              const SizedBox(height: 20),
              
              // 운동 정보 섹션
              Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.exercise.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildInfoRow('카테고리', widget.exercise.category),
                    _buildInfoRow('운동 부위', widget.exercise.bodyPart),
                    _buildInfoRow('대상 그룹', widget.exercise.targetGroup),
                    _buildInfoRow('영상 길이', _formatVideoLength(widget.exercise.videoLength ?? 0)),
                    // _buildInfoRow('언어', widget.exercise.language),
                    _buildInfoRow('게시일자', widget.exercise.createdAt?.toString() ?? ''),
                    // _buildInfoRow('운영기관', widget.exercise.operatingOrganization),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 운동 설명 섹션
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '운동 설명',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.exercise.videoDescription ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 기술적 정보 섹션
            // Card(
            //   child: Padding(
            //     padding: const EdgeInsets.all(20),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Text(
            //           '기술적 정보',
            //           style: TextStyle(
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         const SizedBox(height: 12),
            //         _buildInfoRow('파일 크기', '${(widget.exercise.fileSize ?? 0) ~/ (1024 * 1024)} MB'),
            //         _buildInfoRow('해상도', widget.exercise.resolution),
            //         _buildInfoRow('프레임률', '${widget.exercise.frameRate} fps'),
            //         _buildInfoRow('파일 형식', widget.exercise.fileType),
            //       ],
            //     ),
            //   ),
            // ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
