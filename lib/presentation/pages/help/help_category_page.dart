import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class HelpCategoryPage extends StatefulWidget {
  final String categoryId;

  const HelpCategoryPage({
    super.key,
    required this.categoryId,
  });

  @override
  State<HelpCategoryPage> createState() => _HelpCategoryPageState();
}

class _HelpCategoryPageState extends State<HelpCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yardım Kategorisi'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Text('Kategori ID: ${widget.categoryId}'),
      ),
    );
  }
}
