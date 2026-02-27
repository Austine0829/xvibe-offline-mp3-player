class SongDurationFormater {
  static String format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, "");
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, "0");

    return "$minutes:$seconds";
  }
}