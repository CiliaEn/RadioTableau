import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radiotableau/utils/constants.dart';
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
  bool showAllTodayEpisodes = false;

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

  void toggleShowAllTodayEpisodes() {
    setState(() {
      showAllTodayEpisodes = !showAllTodayEpisodes;
    });
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
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Tablå för ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton<String>(
                          value: episodeListProvider.channelID,
                          items: const [
                            DropdownMenuItem(
                              value: Constants.p1ID,
                              child: Text(
                                'P1',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: Constants.p2ID,
                              child: Text(
                                'P2',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: Constants.p3ID,
                              child: Text(
                                'P3',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: Constants.p4ID,
                              child: Text(
                                'P4',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (newValue) {
                            setState(() {
                              episodeListProvider.channelID = newValue;
                              episodeListProvider.clearEpisodes();
                              showAllTodayEpisodes = false;
                              _fetchData();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TabBar(
                    labelColor: Colors.black,
                    onTap: (int index) {
                      if (index < 3) {
                        if (showAllTodayEpisodes) {
                          toggleShowAllTodayEpisodes();
                        }
                      }
                    },
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle: const TextStyle(color: Colors.grey),
                    tabs: const <Widget>[
                      Tab(text: 'Igår'),
                      Tab(text: 'Idag'),
                      Tab(text: 'Imorgon'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        _buildScheduleListForDay(
                            episodeListProvider.yesterdaysEpisodes),
                        showAllTodayEpisodes
                            ? _buildScheduleListForDay(
                                episodeListProvider.todaysEpisodes,
                                showAll: showAllTodayEpisodes)
                            : _buildScheduleListForDay(
                                episodeListProvider.filteredTodayEpisodes,
                                showAll: showAllTodayEpisodes),
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

  Widget _buildScheduleListForDay(List<Episode> episodes,
      {bool showAll = true}) {
    return Column(
      children: [
        if (!showAll)
          ElevatedButton(
            onPressed: toggleShowAllTodayEpisodes,
            style: ElevatedButton.styleFrom(
              backgroundColor: Constants.themeColor,
            ),
            child: const Text('Visa tidigare avsnitt'),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: episodes.length,
            itemBuilder: (context, index) {
              return EpisodeListItem(
                episode: episodes[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
