import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart';

//first comment
//Cilia Ence 31 october 2023

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

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

class _MyHomePageState extends State<MyHomePage> {
  List<ScheduleEpisode> _scheduleEpisodes = [];

  final dio = Dio();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  String _firstProgramName = 'no sé';

  void _fetchData() async {
    const channelID = '132';

    Response response = await dio
        .get('https://api.sr.se/v2/scheduledepisodes?channelid=$channelID');

    final document = XmlDocument.parse(response.data);

    final scheduleElements = document.findAllElements('scheduledepisode');

    List<ScheduleEpisode> scheduleEpisodes = scheduleElements.map((element) {
      final title = element.findElements('title').single.text;
      final description = element.findElements('description').single.text;
      final startTimeUtc = element.findElements('starttimeutc').single.text;
      final endTimeUtc = element.findElements('endtimeutc').single.text;
      final programId =
          element.findElements('program').first.getAttribute('id');
      final programName =
          element.findElements('program').first.getAttribute('name');
      final channelId =
          element.findElements('channel').first.getAttribute('id');
      final channelName =
          element.findElements('channel').first.getAttribute('name');
      final imageUrl = element.findElements('imageurl').single.text;

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

    setState(() {
      _scheduleEpisodes = scheduleEpisodes;
    });

    if (_scheduleEpisodes.isNotEmpty) {
      setState(() {
        _firstProgramName = _scheduleEpisodes[0].title;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Tablå för P1",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _scheduleEpisodes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_scheduleEpisodes[index].title),
                    subtitle: Text(_scheduleEpisodes[index].description),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
