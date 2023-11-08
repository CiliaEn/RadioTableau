class Episode {
  final String title;
  final String? subtitle;
  final String description;
  final String startTimeCET;
  final String endTimeCET;
  final String? programName;
  final String imageUrl;

  Episode({
    required this.title,
    this.subtitle,
    required this.description,
    required this.startTimeCET,
    required this.endTimeCET,
    this.programName,
    required this.imageUrl,
  });
}
