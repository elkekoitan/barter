import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../widgets/custom_button.dart';
import '../help/help_search_page.dart';
import '../help/help_category_page.dart';
import '../help/help_faq_page.dart';
import '../help/help_article_detail_page.dart';
import '../help/help_bookmarks_page.dart';
import '../../../domain/entities/help.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<HelpCategory> _categories = [
    HelpCategory(
      id: 'getting-started',
      name: 'Başlarken',
      description: 'Hesap oluşturma, profil ayarları ve temel kullanım',
      iconName: 'rocket_launch',
      color: '#10B981',
      articleCount: 15,
      createdAt: DateTime.now(),
    ),
    HelpCategory(
      id: 'listing-management',
      name: 'İlan Yönetimi',
      description: 'İlan oluşturma, düzenleme ve yönetme',
      iconName: 'inventory_2',
      color: '#3B82F6',
      articleCount: 25,
      createdAt: DateTime.now(),
    ),
    HelpCategory(
      id: 'barter-system',
      name: 'Takas Sistemi',
      description: 'Takas teklifleri, emanet sistemi ve işlemler',
      iconName: 'swap_horiz',
      color: '#8B5CF6',
      articleCount: 20,
      createdAt: DateTime.now(),
    ),
    HelpCategory(
      id: 'payment-security',
      name: 'Ödeme ve Güvenlik',
      description: 'Ödeme yöntemleri, güvenlik ve hesap koruması',
      iconName: 'security',
      color: '#F59E0B',
      articleCount: 18,
      createdAt: DateTime.now(),
    ),
    HelpCategory(
      id: 'account-settings',
      name: 'Hesap Ayarları',
      description: 'Profil, bildirimler ve hesap yönetimi',
      iconName: 'settings',
      color: '#EF4444',
      articleCount: 12,
      createdAt: DateTime.now(),
    ),
    HelpCategory(
      id: 'troubleshooting',
      name: 'Sorun Giderme',
      description: 'Yaygın sorunlar ve çözümleri',
      iconName: 'build',
      color: '#6B7280',
      articleCount: 30,
      createdAt: DateTime.now(),
    ),
  ];

  final List<HelpArticle> _popularArticles = [
    HelpArticle(
      id: '1',
      title: 'İlk İlanınızı Nasıl Oluşturursunuz?',
      content: 'Adım adım ilan oluşturma rehberi...',
      categoryId: 'listing-management',
      type: ArticleType.tutorial,
      priority: ArticlePriority.high,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      authorId: 'admin',
      viewCount: 1250,
      helpfulCount: 98,
      notHelpfulCount: 5,
    ),
    HelpArticle(
      id: '2',
      title: 'Takas Sistemi Nasıl Çalışır?',
      content: 'Takas teklifleri ve emanet sistemi açıklaması...',
      categoryId: 'barter-system',
      type: ArticleType.guide,
      priority: ArticlePriority.high,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      authorId: 'admin',
      viewCount: 890,
      helpfulCount: 76,
      notHelpfulCount: 3,
    ),
    HelpArticle(
      id: '3',
      title: 'Güvenlik İpuçları',
      content: 'Hesabınızı ve işlemlerinizi koruma rehberi...',
      categoryId: 'payment-security',
      type: ArticleType.tip,
      priority: ArticlePriority.urgent,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      authorId: 'admin',
      viewCount: 2100,
      helpfulCount: 189,
      notHelpfulCount: 8,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yardım Merkezi'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showSearch,
            icon: Icon(Icons.search, color: AppColors.textSecondary),
          ),
          IconButton(
            onPressed: _showBookmarks,
            icon: Icon(Icons.bookmark_border, color: AppColors.textSecondary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            _buildHeroSection(),

            // Quick Actions
            _buildQuickActions(),

            // Categories
            _buildCategoriesSection(),

            // Popular Articles
            _buildPopularArticlesSection(),

            // FAQ Preview
            _buildFAQPreview(),

            // Contact Support
            _buildContactSupport(),

            SizedBox(height: AppDimensions.marginXXL),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                size: 32.w,
                color: AppColors.white,
              ),
              SizedBox(width: AppDimensions.marginM),
              Text(
                'Yardım Merkezine Hoş Geldiniz',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.marginM),
          Text(
            'Sorularınızın cevaplarını bulun veya yeni bir soru sorun',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: AppDimensions.marginL),
          CustomButton(
            text: 'Arama Yap',
            onPressed: _showSearch,
            type: ButtonType.outline,
            icon: Icons.search,
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.white, width: 1.w),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hızlı İşlemler',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.marginM),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.article,
                  title: 'Makaleler',
                  subtitle: 'Detaylı rehberler',
                  onTap: _showArticles,
                ),
              ),
              SizedBox(width: AppDimensions.marginM),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.question_answer,
                  title: 'SSS',
                  subtitle: 'Sık sorulan sorular',
                  onTap: _showFAQ,
                ),
              ),
              SizedBox(width: AppDimensions.marginM),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.contact_support,
                  title: 'Destek',
                  subtitle: 'Bize ulaşın',
                  onTap: _showContactSupport,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32.w,
                color: AppColors.primary,
              ),
              SizedBox(height: AppDimensions.marginS),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
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
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategoriler',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.marginM),
          AnimationLimiter(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppDimensions.marginM,
                mainAxisSpacing: AppDimensions.marginM,
                childAspectRatio: 1.2,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: 2,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: _buildCategoryCard(category),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(HelpCategory category) {
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
        child: InkWell(
          onTap: () => _openCategory(category),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: _parseColor(category.color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
                      ),
                      child: Icon(
                        _getCategoryIcon(category.iconName),
                        size: 20.w,
                        color: _parseColor(category.color),
                      ),
                    ),
                    SizedBox(width: AppDimensions.marginS),
                    Expanded(
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.marginS),
                Text(
                  category.description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppDimensions.marginS),
                Text(
                  '${category.articleCount} makale',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _parseColor(String color) {
    if (color.startsWith('#')) {
      return Color(int.parse(color.substring(1), radix: 16) | 0xFF000000);
    }
    return AppColors.primary;
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'rocket_launch':
        return Icons.rocket_launch;
      case 'inventory_2':
        return Icons.inventory_2;
      case 'swap_horiz':
        return Icons.swap_horiz;
      case 'security':
        return Icons.security;
      case 'settings':
        return Icons.settings;
      case 'build':
        return Icons.build;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildPopularArticlesSection() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popüler Makaleler',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.marginM),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _popularArticles.length,
            itemBuilder: (context, index) {
              final article = _popularArticles[index];
              return _buildArticleCard(article);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(HelpArticle article) {
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
          onTap: () => _openArticle(article),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
                  ),
                  child: Icon(
                    _getArticleIcon(article.type),
                    size: 24.w,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: AppDimensions.marginM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        article.excerpt,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 12.w,
                            color: AppColors.textMuted,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${article.viewCount}',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textMuted,
                            ),
                          ),
                          SizedBox(width: AppDimensions.marginM),
                          Icon(
                            Icons.thumb_up,
                            size: 12.w,
                            color: AppColors.success,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${article.helpfulCount}',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.w,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getArticleIcon(ArticleType type) {
    switch (type) {
      case ArticleType.tutorial:
        return Icons.school;
      case ArticleType.faq:
        return Icons.question_answer;
      case ArticleType.troubleshooting:
        return Icons.build;
      case ArticleType.guide:
        return Icons.menu_book;
      case ArticleType.tip:
        return Icons.lightbulb;
      case ArticleType.announcement:
        return Icons.announcement;
      case ArticleType.changelog:
        return Icons.history;
      default:
        return Icons.article;
    }
  }

  Widget _buildFAQPreview() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sık Sorulan Sorular',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: _showFAQ,
                child: Text(
                  'Tümü',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.info,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.marginM),
          Text(
            'En sık sorulan soruları burada bulabilirsiniz.',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDimensions.marginL),
          CustomButton(
            text: 'SSS\'ye Gözat',
            onPressed: _showFAQ,
            type: ButtonType.outline,
            icon: Icons.question_answer,
            buttonStyle: ElevatedButton.styleFrom(
              foregroundColor: AppColors.info,
              side: BorderSide(color: AppColors.info, width: 1.w),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSupport() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Destek',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.marginM),
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingL),
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
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.support,
                      size: 32.w,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: AppDimensions.marginM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Yardım mı ihtiyacınız var?',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Destek ekibimiz size yardımcı olmaya hazır',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.marginL),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'E-posta Gönder',
                        onPressed: _sendEmailSupport,
                        type: ButtonType.outline,
                        icon: Icons.email,
                        buttonStyle: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary, width: 1.w),
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimensions.marginM),
                    Expanded(
                      child: CustomButton(
                        text: 'WhatsApp',
                        onPressed: _contactWhatsApp,
                        icon: Icons.message,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HelpSearchPage(),
      ),
    );
  }

  void _showBookmarks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HelpBookmarksPage(),
      ),
    );
  }

  void _showArticles() {
    // Navigate to articles list
    debugPrint('Show articles');
  }

  void _showFAQ() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HelpFAQPage(),
      ),
    );
  }

  void _showContactSupport() {
    // Show contact support bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Nasıl Yardım Alabilirsiniz?',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppDimensions.marginL),
            ListTile(
              leading: Icon(Icons.email, color: AppColors.primary),
              title: Text('E-posta Destek'),
              subtitle: Text('support@bogazicibarter.com'),
              onTap: _sendEmailSupport,
            ),
            ListTile(
              leading: Icon(Icons.phone, color: AppColors.success),
              title: Text('Telefon Destek'),
              subtitle: Text('+90 850 123 45 67'),
              onTap: _callSupport,
            ),
            ListTile(
              leading: Icon(Icons.message, color: AppColors.info),
              title: Text('WhatsApp Destek'),
              subtitle: Text('7/24 aktif'),
              onTap: _contactWhatsApp,
            ),
          ],
        ),
      ),
    );
  }

  void _openCategory(HelpCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelpCategoryPage(category: category),
      ),
    );
  }

  void _openArticle(HelpArticle article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelpArticleDetailPage(article: article),
      ),
    );
  }

  void _sendEmailSupport() {
    // Launch email app
    debugPrint('Send email support');
  }

  void _contactWhatsApp() {
    // Launch WhatsApp
    debugPrint('Contact WhatsApp support');
  }

  void _callSupport() {
    // Launch phone dialer
    debugPrint('Call support');
  }
}
