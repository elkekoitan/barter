import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class ListingDetailPage extends StatefulWidget {
  final String listingId;

  const ListingDetailPage({
    super.key,
    required this.listingId,
  });

  @override
  State<ListingDetailPage> createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends State<ListingDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İlan Detayları'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Text('İlan ID: ${widget.listingId}'),
      ),
    );
  }
}
