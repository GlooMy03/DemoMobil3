import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

class NotificationController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;
  var isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Mengatur listener untuk durasi dan posisi
    _audioPlayer.onDurationChanged.listen((d) {
      duration.value = d;
    });

    _audioPlayer.onPositionChanged.listen((p) {
      position.value = p;
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
    });
  }

  Future<void> playAudio(String url, {bool isLocal = false}) async {
    await _audioPlayer.play(UrlSource(url));
  }

  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
  }

  Future<void> resumeAudio() async {
    await _audioPlayer.resume();
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
  }

  void seekAudio(Duration position) {
    _audioPlayer.seek(position);
  }
}
