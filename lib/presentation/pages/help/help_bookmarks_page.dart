import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';

class HelpBookmarksPage extends StatefulWidget {
  const HelpBookmarksPage({super.key});

  @override
  State<HelpBookmarksPage> createState() => _HelpBookmarksPageState();
}

class _HelpBookmarksPageState extends State<HelpBookmarksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yer İşaretleri'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Yer İşaretleri Sayfası'),
      ),
    );
  }
}
