import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:radiotableau/models/episode.dart';
import 'package:radiotableau/utils/constants.dart';
import 'package:xml/xml.dart';

class ApiService {
  final dio = Dio();

  Future<List<Episode>> fetchData(String? channelID, String? date,
      {int page = 1}) async {
    final inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ssZ');
    final outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS');

    try {
      final response = await dio.get(
        'https://api.sr.se/v2/scheduledepisodes?channelid=$channelID&date=$date&page=$page',
      );

      final document = XmlDocument.parse(response.data);

      final scheduleElements = document.findAllElements('scheduledepisode');

      final episodes = scheduleElements.map((element) {
        final title = element.findElements('title').isNotEmpty
            ? element.findElements('title').single.innerText
            : '';
        final subtitle = element.findElements('subtitle').isNotEmpty
            ? element.findElements('subtitle').single.innerText
            : null;
        final description = element.findElements('description').isNotEmpty
            ? element.findElements('description').single.innerText
            : '';
        final startTimeUtc = element.findElements('starttimeutc').isNotEmpty
            ? element.findElements('starttimeutc').single.innerText
            : '';
        final endTimeUtc = element.findElements('endtimeutc').isNotEmpty
            ? element.findElements('endtimeutc').single.innerText
            : '';

        final startTime = inputFormat.parse(startTimeUtc);
        final startTimeCET =
            outputFormat.format(startTime.add(const Duration(hours: 1)));

        final endTime = inputFormat.parse(endTimeUtc);
        final endTimeCET =
            outputFormat.format(endTime.add(const Duration(hours: 1)));

        final programName = element.findElements('program').isNotEmpty
            ? element.findElements('program').first.getAttribute('name')
            : '';
        final imageUrl = element.findElements('imageurl').isNotEmpty
            ? element.findElements('imageurl').single.innerText
            : '';

        return Episode(
          title: title,
          subtitle: subtitle,
          description: description,
          startTimeCET: startTimeCET,
          endTimeCET: endTimeCET,
          programName: programName,
          imageUrl: imageUrl,
        );
      }).toList();

      final totalPagesElement = document.findAllElements('totalpages').first;
      final totalPages = int.parse(totalPagesElement.text);

      if (page < totalPages) {
        final nextPage = page + 1;
        episodes.addAll(await fetchData(channelID, date, page: nextPage));
      }

      return episodes;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
}
