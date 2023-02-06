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

  Duration duration = Duration(
    hours: int.parse(durationList[0]),
    minutes: int.parse(durationList[1]),
    seconds: int.parse(durationList[2]),
  );
  int milliseconds = duration.inMilliseconds;
  return milliseconds;
}
