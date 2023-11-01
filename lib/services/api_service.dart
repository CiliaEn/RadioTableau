import 'package:dio/dio.dart';
import 'package:radiotableau/models/schedule_episode.dart';
import 'package:radiotableau/utils/constants.dart';
import 'package:xml/xml.dart';
import 'package:intl/intl.dart';

class ApiService {
  final dio = Dio();

  Future<List<ScheduleEpisode>> fetchData() async {
    const String channelID = Constants.channelID;

    try {
      Response response = await dio
          .get('https://api.sr.se/v2/scheduledepisodes?channelid=$channelID');

      final document = XmlDocument.parse(response.data);

      final scheduleElements = document.findAllElements('scheduledepisode');

      List<ScheduleEpisode> scheduleEpisodes = scheduleElements.map((element) {
        final title = element.findElements('title').isNotEmpty
            ? element.findElements('title').single.innerText
            : '';
        final description = element.findElements('description').isNotEmpty
            ? element.findElements('description').single.innerText
            : '';
        final startTimeUtc = element.findElements('starttimeutc').isNotEmpty
            ? element.findElements('starttimeutc').single.innerText
            : '';
        final endTimeUtc = element.findElements('endtimeutc').isNotEmpty
            ? element.findElements('endtimeutc').single.innerText
            : '';
        final programId = element.findElements('program').isNotEmpty
            ? element.findElements('program').first.getAttribute('id')
            : '';
        final programName = element.findElements('program').isNotEmpty
            ? element.findElements('program').first.getAttribute('name')
            : '';
        final channelId = element.findElements('channel').isNotEmpty
            ? element.findElements('channel').first.getAttribute('id')
            : '';
        final channelName = element.findElements('channel').isNotEmpty
            ? element.findElements('channel').first.getAttribute('name')
            : '';
        final imageUrl = element.findElements('imageurl').isNotEmpty
            ? element.findElements('imageurl').single.innerText
            : '';

        return ScheduleEpisode(
          title: title,
          description: description,
          startTimeUtc: startTimeUtc,
          endTimeUtc: endTimeUtc,
          programId: programId,
          programName: programName,
          channelId: channelId,
          channelName: channelName,
          imageUrl: imageUrl,
        );
      }).toList();

      return scheduleEpisodes;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
}
