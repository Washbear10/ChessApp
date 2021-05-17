import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

final String ring_path = "ringtone.mp3";
final AudioPlayer ringPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
final AudioCache ringCache = AudioCache(fixedPlayer: ringPlayer);
Future<void> playRing() async {
  await ringCache.load(ring_path);
  await ringCache.play(
    ring_path,
    volume: 1,
    mode: PlayerMode.LOW_LATENCY
  );
}


final String click_path = "click.mp3";
final AudioPlayer clickPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
final AudioCache clickCache = AudioCache(fixedPlayer: clickPlayer);
Future<void> playClick() async {
  await clickCache.load(click_path);
  await clickCache.play(
      click_path,
      volume: 1,
      mode: PlayerMode.LOW_LATENCY
  );
}