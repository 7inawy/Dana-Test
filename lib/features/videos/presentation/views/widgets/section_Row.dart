import 'package:flutter/material.dart';
import '../../../data/model/video_Model.dart';
import '../screens/view_all_screen.dart';
import 'section_header.dart';
import 'video_horizontal_list.dart';

class SectionRow extends StatelessWidget {
  final VideoSection section;

  const SectionRow({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: section.title,
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewAllScreen(
                  videos: section.videos,
                  sectionTitle: section.title,
                ),
              ),
            );
          },
        ),
        VideoHorizontalList(videos: section.videos),
      ],
    );
  }
}
