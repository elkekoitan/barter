import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class CategoriesTab extends StatelessWidget {
  const CategoriesTab({super.key});

  final List<CategoryItem> categories = const [
    CategoryItem(
      id: '1',
      name: 'Elektronik',
      icon: Icons.smartphone,
      color: AppColors.primary,
      subcategories: ['Telefon', 'Bilgisayar', 'Tablet', 'Aksesuar'],
    ),
    CategoryItem(
      id: '2',
      name: 'Moda',
      icon: Icons.checkroom,
      color: AppColors.barterPrimary,
      subcategories: ['Giyim', 'Ayakkabı', 'Çanta', 'Aksesuar'],
    ),
    CategoryItem(
      id: '3',
      name: 'Ev & Bahçe',
      icon: Icons.home,
      color: AppColors.success,
      subcategories: ['Mobilya', 'Dekorasyon', 'Bahçe', 'Mutfak'],
    ),
    CategoryItem(
      id: '4',
      name: 'Araçlar',
      icon: Icons.directions_car,
      color: AppColors.warning,
      subcategories: ['Otomobil', 'Motosiklet', 'Bisiklet', 'Aksesuar'],
    ),
    CategoryItem(
      id: '5',
      name: 'Hizmetler',
      icon: Icons.build,
      color: AppColors.info,
      subcategories: ['Tamir', 'Temizlik', 'Taşıma', 'Diğer'],
    ),
    CategoryItem(
      id: '6',
      name: 'Diğer',
      icon: Icons.category,
      color: AppColors.textSecondary,
      subcategories: ['Kitap', 'Spor', 'Müzik', 'Koleksiyon'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'categories'.tr(),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(AppDimensions.paddingM),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppDimensions.marginM,
          mainAxisSpacing: AppDimensions.marginM,
          childAspectRatio: 0.85,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryCard(category: category);
        },
      ),
    );
  }
}

class CategoryItem {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<String> subcategories;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.subcategories,
  });
}

class CategoryCard extends StatelessWidget {
  final CategoryItem category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        border: Border.all(color: AppColors.border, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        child: InkWell(
          onTap: () => _onCategoryTap(context),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category.icon,
                    size: 30.w,
                    color: category.color,
                  ),
                ),

                SizedBox(height: AppDimensions.marginM),

                // Category Name
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppDimensions.marginS),

                // Subcategories
                Text(
                  '${category.subcategories.length} ${'subcategories'.tr()}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onCategoryTap(BuildContext context) {
    // TODO: Navigate to category listings
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${category.name} kategorisi seçildi'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
