import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:radiotableau/models/episode.dart';
import 'package:radiotableau/services/api_service.dart';
import 'package:intl/intl.dart';

class EpisodeListProvider extends ChangeNotifier {
  List<Episode> yesterdaysEpisodes = [];
  List<Episode> todaysEpisodes = [];
  List<Episode> filteredTodayEpisodes = [];
  List<Episode> tomorrowsEpisodes = [];
  final apiService = ApiService();
  DateTime currentDate = DateTime.now();
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> fetchYesterdaysEpisodes() async {
    DateTime yesterday = currentDate.subtract(const Duration(days: 1));
    String formattedDate = dateFormat.format(yesterday);
    yesterdaysEpisodes.addAll(await apiService.fetchData(formattedDate));
    notifyListeners();
  }

  Future<void> fetchTodaysEpisodes() async {
    todaysEpisodes.addAll(await apiService.fetchData(''));
    filterTodaysEpisodes();
    notifyListeners();
  }

  Future<void> fetchTomorrowsEpisodes() async {
    DateTime tomorrow = currentDate.add(const Duration(days: 1));
    String formattedDate = dateFormat.format(tomorrow);
    tomorrowsEpisodes.addAll(await apiService.fetchData(formattedDate));
    notifyListeners();
  }

  void filterTodaysEpisodes() {
    final now = DateTime.now();
    filteredTodayEpisodes = todaysEpisodes.where((episode) {
      DateTime episodeStartTime = DateTime.parse(episode.startTimeCET);
      DateTime episodeEndTime = DateTime.parse(episode.endTimeCET);
      return episodeStartTime.isAfter(currentDate) ||
          (episodeStartTime.isBefore(now) && episodeEndTime.isAfter(now));
    }).toList();
  }
}
