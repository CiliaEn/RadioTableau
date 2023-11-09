import 'package:flutter/material.dart';
import 'package:radiotableau/models/episode.dart';
import 'package:intl/intl.dart';

class EpisodeListItem extends StatelessWidget {
  const EpisodeListItem({super.key, required this.episode});

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    final formattedTime =
        DateFormat.Hm().format(DateTime.parse(episode.startTimeCET));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              if (episode.imageUrl.isNotEmpty)
                Image.network(
                  episode.imageUrl,
                  height: 50,
                  width: 50,
                )
              else
                Image.asset(
                  'lib/assets/noImage.png',
                  height: 50,
                  width: 50,
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  episode.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (episode.subtitle != null)
                  Text(
                    episode.subtitle!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Text(
                  episode.description,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
