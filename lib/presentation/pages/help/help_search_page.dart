import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../../domain/entities/help.dart';

class HelpSearchPage extends StatefulWidget {
  const HelpSearchPage({super.key});

  @override
  State<HelpSearchPage> createState() => _HelpSearchPageState();
}

class _HelpSearchPageState extends State<HelpSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = [
    'İlan oluşturma',
    'Takas sistemi',
    'Ödeme yöntemleri',
    'Güvenlik ayarları',
    'Hesap doğrulama',
  ];
  final List<String> _popularSearches = [
    'İlk ilan nasıl oluşturulur?',
    'Takas teklifleri nasıl çalışır?',
    'Emanet sistemi nedir?',
    'Ödeme güvenliği',
    'Profil bilgileri güncelleme',
    'İlan düzenleme',
    'Bildirim ayarları',
    'Hesap silme',
  ];

  bool _isLoading = false;
  List<HelpSearchResult> _searchResults = [];
  String _selectedCategory = 'all';
  String _selectedType = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arama'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          if (_isLoading)
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              child: SizedBox(
                width: 20.w,
                height: 20.w,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              onPressed: _clearSearch,
              icon: Icon(Icons.clear, color: AppColors.textSecondary),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(),

          // Filters
          _buildFilters(),

          // Search Results or Suggestions
          Expanded(
            child: _searchResults.isEmpty
                ? _buildSearchSuggestions()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1.w),
        ),
      ),
      child: Column(
        children: [
          CustomTextField(
            controller: _searchController,
            label: 'Ne arıyorsunuz?',
            prefixIcon: Icons.search,
            suffixIcon: _searchController.text.isNotEmpty
                ? Icons.clear
                : null,
            onChanged: _onSearchChanged,
            onSubmitted: _performSearch,
          ),
          SizedBox(height: AppDimensions.marginM),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Ara',
                  onPressed: () => _performSearch(_searchController.text),
                  size: ButtonSize.small,
                ),
              ),
              SizedBox(width: AppDimensions.marginM),
              Expanded(
                child: CustomButton(
                  text: 'Gelişmiş',
                  onPressed: _showAdvancedSearch,
                  type: ButtonType.outline,
                  size: ButtonSize.small,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.paddingS,
      ),
      color: AppColors.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              label: 'Tümü',
              value: 'all',
              selectedValue: _selectedCategory,
              onSelected: (value) => setState(() => _selectedCategory = value),
            ),
            SizedBox(width: AppDimensions.marginS),
            _buildFilterChip(
              label: 'Makaleler',
              value: 'articles',
              selectedValue: _selectedCategory,
              onSelected: (value) => setState(() => _selectedCategory = value),
            ),
            SizedBox(width: AppDimensions.marginS),
            _buildFilterChip(
              label: 'SSS',
              value: 'faqs',
              selectedValue: _selectedCategory,
              onSelected: (value) => setState(() => _selectedCategory = value),
            ),
            SizedBox(width: AppDimensions.marginS),
            _buildFilterChip(
              label: 'Rehberler',
              value: 'guides',
              selectedValue: _selectedCategory,
              onSelected: (value) => setState(() => _selectedCategory = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String value,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    final isSelected = selectedValue == value;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => onSelected(value),
      backgroundColor: AppColors.white,
      selectedColor: AppColors.primary.withOpacity(0.1),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontSize: 12.sp,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: 4.h,
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            Text(
              'Son Aramalar',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppDimensions.marginM),
            Wrap(
              spacing: AppDimensions.marginS,
              runSpacing: AppDimensions.marginS,
              children: _recentSearches.map((search) {
                return _buildSuggestionChip(search, onTap: () => _performSearch(search));
              }).toList(),
            ),
            SizedBox(height: AppDimensions.marginL),
          ],

          Text(
            'Popüler Aramalar',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.marginM),
          Wrap(
            spacing: AppDimensions.marginS,
            runSpacing: AppDimensions.marginS,
            children: _popularSearches.map((search) {
              return _buildSuggestionChip(search, onTap: () => _performSearch(search));
            }).toList(),
          ),

          SizedBox(height: AppDimensions.marginL),
          Text(
            'Kategoriye Göre Ara',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.marginM),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppDimensions.marginM,
              mainAxisSpacing: AppDimensions.marginM,
              childAspectRatio: 2.5,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              final categories = [
                ('Başlarken', Icons.rocket_launch),
                ('İlan Yönetimi', Icons.inventory_2),
                ('Takas Sistemi', Icons.swap_horiz),
                ('Ödeme', Icons.payment),
                ('Güvenlik', Icons.security),
                ('Hesap', Icons.person),
              ];

              final category = categories[index];
              return _buildCategoryCard(category.$1, category.$2);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text, {required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        border: Border.all(color: AppColors.border, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        border: Border.all(color: AppColors.border, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: () => _performSearch(title),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20.w,
                  color: AppColors.primary,
                ),
                SizedBox(width: AppDimensions.marginS),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return _buildSearchResultCard(result);
      },
    );
  }

  Widget _buildSearchResultCard(HelpSearchResult result) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.marginM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        border: Border.all(color: AppColors.border, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: () => _openSearchResult(result),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        result.title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingS,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
                      ),
                      child: Text(
                        result.type,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.marginS),
                Text(
                  result.excerpt,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppDimensions.marginM),
                Row(
                  children: [
                    Icon(
                      Icons.category,
                      size: 14.w,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      result.categoryName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textMuted,
                      ),
                    ),
                    SizedBox(width: AppDimensions.marginM),
                    Icon(
                      Icons.access_time,
                      size: 14.w,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      _formatDate(result.createdAt),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(result.relevanceScore * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSearchChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        _searchResults = [];
      });
    }
  }

  void _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Mock search results
      await Future.delayed(const Duration(seconds: 1));

      _searchResults = [
        HelpSearchResult(
          id: '1',
          title: 'İlan Oluşturma Rehberi',
          excerpt: 'Adım adım ilan oluşturma süreci hakkında detaylı bilgiler...',
          type: 'Makale',
          categoryName: 'İlan Yönetimi',
          relevanceScore: 0.95,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        HelpSearchResult(
          id: '2',
          title: 'Takas Sistemi SSS',
          excerpt: 'Takas teklifleri, emanet sistemi ve işlem süreci hakkında sık sorulan sorular...',
          type: 'SSS',
          categoryName: 'Takas Sistemi',
          relevanceScore: 0.87,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        HelpSearchResult(
          id: '3',
          title: 'Güvenlik İpuçları',
          excerpt: 'Hesabınızı ve işlemlerinizi koruma konusunda önemli tavsiyeler...',
          type: 'Rehber',
          categoryName: 'Güvenlik',
          relevanceScore: 0.78,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Search error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
    });
  }

  void _showAdvancedSearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gelişmiş Arama',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppDimensions.marginL),
            Expanded(
              child: ListView(
                children: [
                  _buildAdvancedFilter('İçerik Türü', [
                    'Tümü',
                    'Makale',
                    'Rehber',
                    'SSS',
                    'Video',
                  ]),
                  SizedBox(height: AppDimensions.marginM),
                  _buildAdvancedFilter('Kategori', [
                    'Tümü',
                    'Başlarken',
                    'İlan Yönetimi',
                    'Takas Sistemi',
                    'Ödeme',
                    'Güvenlik',
                    'Hesap',
                  ]),
                  SizedBox(height: AppDimensions.marginM),
                  _buildAdvancedFilter('Öncelik', [
                    'Tümü',
                    'Düşük',
                    'Orta',
                    'Yüksek',
                    'Acil',
                  ]),
                  SizedBox(height: AppDimensions.marginM),
                  SwitchListTile(
                    title: Text('Sadece yayınlanan'),
                    value: true,
                    onChanged: (value) {},
                    activeColor: AppColors.primary,
                  ),
                  SwitchListTile(
                    title: Text('Sadece video içeren'),
                    value: false,
                    onChanged: (value) {},
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Sıfırla',
                    onPressed: () {},
                    type: ButtonType.outline,
                  ),
                ),
                SizedBox(width: AppDimensions.marginM),
                Expanded(
                  child: CustomButton(
                    text: 'Uygula',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedFilter(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppDimensions.marginS),
        Wrap(
          spacing: AppDimensions.marginS,
          runSpacing: AppDimensions.marginS,
          children: options.map((option) {
            return _buildSuggestionChip(option, onTap: () {});
          }).toList(),
        ),
      ],
    );
  }

  void _openSearchResult(HelpSearchResult result) {
    // Navigate to article detail page
    debugPrint('Open search result: ${result.title}');
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Bugün';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return DateFormat('dd MMM yyyy').format(date);
    }
  }
}
