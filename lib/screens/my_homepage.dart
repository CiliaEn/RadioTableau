import 'package:flutter/material.dart';
import 'package:radiotableau/models/schedule_episode.dart';
import 'package:radiotableau/services/api_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ScheduleEpisode> _scheduleEpisodes = [];
  final apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    List<ScheduleEpisode> episodes = await apiService.fetchData();

    setState(() {
      _scheduleEpisodes = episodes;
    });
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
