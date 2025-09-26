import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';

class HelpArticleDetailPage extends StatefulWidget {
  final String articleId;

  const HelpArticleDetailPage({
    super.key,
    required this.articleId,
  });

  @override
  State<HelpArticleDetailPage> createState() => _HelpArticleDetailPageState();
}

class _HelpArticleDetailPageState extends State<HelpArticleDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yardım Makalesi'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Text('Makale ID: ${widget.articleId}'),
      ),
    );
  }
}
