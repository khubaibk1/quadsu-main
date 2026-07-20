
String twoDigits(int n) {
  if (n >= 10) {
    return '$n';
  }
  return '0$n';
}

String formatDuration(int totalSeconds) {
  int hours = totalSeconds ~/ 3600;
  int minutes = (totalSeconds ~/ 60) % 60;
  int seconds = totalSeconds % 60;

  if (hours > 0) {
    return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
  } else {
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}