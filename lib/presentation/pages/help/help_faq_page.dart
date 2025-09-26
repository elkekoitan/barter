import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';

class HelpFAQPage extends StatefulWidget {
  const HelpFAQPage({super.key});

  @override
  State<HelpFAQPage> createState() => _HelpFAQPageState();
}

class _HelpFAQPageState extends State<HelpFAQPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sık Sorulan Sorular'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('SSS Sayfası'),
      ),
    );
  }
}
