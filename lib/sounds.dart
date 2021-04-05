import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

final String path = "ringtone.mp3";
final AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
final AudioCache audioCache = AudioCache(fixedPlayer: audioPlayer);
Future<void> playSound() async {
  await audioCache.load(path);
  await audioCache.play(
    path,
    volume: 1,
    mode: PlayerMode.LOW_LATENCY
  );
}