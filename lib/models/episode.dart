class Episode {
  final String title;
  final String description;
  final String startTimeCET;
  final String endTimeCET;
  final String? programName;
  final String imageUrl;

  Episode({
    required this.title,
    required this.description,
    required this.startTimeCET,
    required this.endTimeCET,
    required this.programName,
    required this.imageUrl,
  });
}
