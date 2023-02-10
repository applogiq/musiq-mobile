String detailedDuration(String duration) {
  List durationList = duration.split(":");

  if (durationList.length == 3) {
    return durationList[0].toString().trim() == "00"
        ? "${durationList[1]} mins ${durationList[2]} sec"
        : "${durationList[0]} hours ${durationList[1]} mins ${durationList[2]} sec";
  } else if (durationList.length == 2) {
    return "${durationList[0]} mins ${durationList[1]} secs ";
  } else {
    return "";
  }
}

int totalDuration(String time) {
  List durationList = time.split(":");
  List sec = [];
  if (durationList.length == 3) {
    sec = durationList[2].toString().split('.');
    Duration duration = Duration(
      hours: int.parse(durationList[0]),
      minutes: int.parse(durationList[1]),
      seconds: durationList.length == 3 ? int.parse(sec[0]) : 0,
    );
    int milliseconds = duration.inMilliseconds;
    return milliseconds;
  }
  return 0;
}

String formatDuration(Duration? d) {
  if (d == null) return "--:--";
  int minute = d.inMinutes;
  int second = (d.inSeconds >= 60) ? (d.inSeconds % 60) : d.inSeconds;
  String format =
      "${(minute < 10) ? "0$minute" : "$minute"}:${(second < 10) ? "0$second" : "$second"}";
  return format;
}
