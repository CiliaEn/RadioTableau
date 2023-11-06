import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'package:radiotableau/models/episode.dart';
import 'package:radiotableau/provider/episode_list_provider.dart';
import 'package:radiotableau/services/api_service.dart';
import 'package:radiotableau/widgets/episode_list_item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final apiService = ApiService();
  bool showAllTodaysEpisodes = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    await Provider.of<EpisodeListProvider>(context, listen: false)
        .fetchYesterdaysEpisodes();
    await Provider.of<EpisodeListProvider>(context, listen: false)
        .fetchTodaysEpisodes();

    await Provider.of<EpisodeListProvider>(context, listen: false)
        .fetchTomorrowsEpisodes();
  }

  @override
  Widget build(BuildContext context) {
    final episodeListProvider = Provider.of<EpisodeListProvider>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/Background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Tablå för P1',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TabBar(
                    tabs: <Widget>[
                      Tab(text: 'Yesterday'),
                      Tab(text: 'Today'),
                      Tab(text: 'Tomorrow'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        _buildScheduleListForDay(
                            episodeListProvider.yesterdaysEpisodes),
                        _buildScheduleListForDay(
                            episodeListProvider.filteredTodayEpisodes),
                        _buildScheduleListForDay(
                            episodeListProvider.tomorrowsEpisodes),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleListForDay(List<Episode> episodes) {
    return ListView.builder(
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        return EpisodeListItem(
          episode: episodes[index],
        );
      },
    );
  }
}
