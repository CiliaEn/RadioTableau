class ScheduleEpisode {
  final String title;
  final String description;
  final String startTimeUtc;
  final String endTimeUtc;
  final String? programId;
  final String? programName;
  final String? channelId;
  final String? channelName;
  final String imageUrl;

  ScheduleEpisode({
    required this.title,
    required this.description,
    required this.startTimeUtc,
    required this.endTimeUtc,
    required this.programId,
    required this.programName,
    required this.channelId,
    required this.channelName,
    required this.imageUrl,
  });
}
