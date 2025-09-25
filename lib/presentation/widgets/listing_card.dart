import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../domain/entities/listing.dart';

class ListingCard extends StatelessWidget {
  final ListingEntity listing;
  final VoidCallback? onTap;
  final Function(bool)? onFavoriteToggle;

  const ListingCard({
    super.key,
    required this.listing,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            _buildImageSection(),

            // Content Section
            Padding(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Favorite Button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              listing.title,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            SizedBox(height: AppDimensions.marginXS),

                            // Category and Condition
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppDimensions.paddingS,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadiusXS,
                                    ),
                                  ),
                                  child: Text(
                                    listing.category.name,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: AppDimensions.marginS),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppDimensions.paddingS,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getConditionColor(listing.condition).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadiusXS,
                                    ),
                                  ),
                                  child: Text(
                                    listing.condition.displayName,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: _getConditionColor(listing.condition),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Favorite Button
                      IconButton(
                        onPressed: () {
                          if (onFavoriteToggle != null) {
                            onFavoriteToggle!(listing.stats.favoriteCount > 0);
                          }
                        },
                        icon: Icon(
                          listing.stats.favoriteCount > 0
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 20.w,
                          color: listing.stats.favoriteCount > 0
                              ? AppColors.error
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppDimensions.marginM),

                  // Description
                  Text(
                    listing.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: AppDimensions.marginM),

                  // Pricing and Barter Info
                  _buildPricingSection(),

                  SizedBox(height: AppDimensions.marginM),

                  // Location and Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16.w,
                            color: AppColors.textMuted,
                          ),
                          SizedBox(width: AppDimensions.marginXS),
                          Text(
                            '${listing.location.city}, ${listing.location.district}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      // Stats
                      Row(
                        children: [
                          // Views
                          Icon(
                            Icons.visibility_outlined,
                            size: 14.w,
                            color: AppColors.textMuted,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            listing.stats.viewCount.toString(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textMuted,
                            ),
                          ),
                          SizedBox(width: AppDimensions.marginM),

                          // Delivery Method
                          _buildDeliveryIcon(),
                        ],
                      ),
                    ],
                  ),

                  // Boost indicators
                  if (listing.isFeatured || listing.isUrgent) ...[
                    SizedBox(height: AppDimensions.marginS),
                    _buildBoostIndicators(),
                  ],

                  // Moderation status
                  if (listing.moderation.status != ModerationStatus.approved) ...[
                    SizedBox(height: AppDimensions.marginS),
                    _buildModerationStatus(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.borderRadiusL),
        ),
        color: AppColors.inputBackground,
      ),
      child: Stack(
        children: [
          // Main Image
          if (listing.media.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimensions.borderRadiusL),
              ),
              child: CachedNetworkImage(
                imageUrl: listing.media.first.url,
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.inputBackground,
                  child: Icon(
                    Icons.image_outlined,
                    size: 40.w,
                    color: AppColors.textMuted,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.inputBackground,
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 40.w,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            )
          else
            Container(
              color: AppColors.inputBackground,
              child: Icon(
                Icons.image_outlined,
                size: 40.w,
                color: AppColors.textMuted,
              ),
            ),

          // Multiple images indicator
          if (listing.media.length > 1)
            Positioned(
              top: AppDimensions.paddingM,
              right: AppDimensions.paddingM,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingS,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusS,
                  ),
                ),
                child: Text(
                  '${listing.media.length}+',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // Boost indicators
          if (listing.isFeatured)
            Positioned(
              top: AppDimensions.paddingM,
              left: AppDimensions.paddingM,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingS,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.barterPrimary,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusS,
                  ),
                ),
                child: Text(
                  'featured'.tr().toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          if (listing.isUrgent)
            Positioned(
              bottom: AppDimensions.paddingM,
              left: AppDimensions.paddingM,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingS,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusS,
                  ),
                ),
                child: Text(
                  'urgent'.tr().toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return Row(
      children: [
        // Cash Price
        if (listing.pricing.hasCashPrice) ...[
          Text(
            '${listing.pricing.cashPrice} ${listing.pricing.currency}',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: AppDimensions.marginM),
        ],

        // Barter Badge
        if (listing.pricing.acceptsBarter)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingS,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.barterPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusXS,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.swap_horiz,
                  size: 14.w,
                  color: AppColors.barterPrimary,
                ),
                SizedBox(width: 4.w),
                Text(
                  'barter_available'.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.barterPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

        const Spacer(),

        // Negotiable badge
        if (listing.pricing.isNegotiable)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingS,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusXS,
              ),
            ),
            child: Text(
              'negotiable'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDeliveryIcon() {
    if (listing.delivery.hasInPerson) {
      return Row(
        children: [
          Icon(
            Icons.person_outline,
            size: 14.w,
            color: AppColors.textMuted,
          ),
          SizedBox(width: 4.w),
          Text(
            'in_person'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textMuted,
            ),
          ),
        ],
      );
    } else if (listing.delivery.hasShipping) {
      return Row(
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 14.w,
            color: AppColors.textMuted,
          ),
          SizedBox(width: 4.w),
          Text(
            'shipping'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textMuted,
            ),
          ),
        ],
      );
    } else if (listing.delivery.hasPickup) {
      return Row(
        children: [
          Icon(
            Icons.storefront_outlined,
            size: 14.w,
            color: AppColors.textMuted,
          ),
          SizedBox(width: 4.w),
          Text(
            'pickup'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textMuted,
            ),
          ),
        ],
      );
    }
    return Container();
  }

  Widget _buildBoostIndicators() {
    return Wrap(
      spacing: AppDimensions.marginXS,
      children: [
        if (listing.isFeatured)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingS,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.barterPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusXS,
              ),
            ),
            child: Text(
              'featured'.tr(),
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.barterPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (listing.isUrgent)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingS,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusXS,
              ),
            ),
            child: Text(
              'urgent'.tr(),
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildModerationStatus() {
    Color statusColor;
    String statusText;

    switch (listing.moderation.status) {
      case ModerationStatus.pending:
        statusColor = AppColors.warning;
        statusText = 'pending_review'.tr();
        break;
      case ModerationStatus.approved:
        return Container(); // Don't show anything for approved
      case ModerationStatus.rejected:
        statusColor = AppColors.error;
        statusText = 'rejected'.tr();
        break;
      case ModerationStatus.needsReview:
        statusColor = AppColors.info;
        statusText = 'needs_review'.tr();
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          AppDimensions.borderRadiusXS,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 10.sp,
          color: statusColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getConditionColor(ListingCondition condition) {
    switch (condition) {
      case ListingCondition.brandNew:
        return AppColors.success;
      case ListingCondition.likeNew:
        return AppColors.success;
      case ListingCondition.veryGood:
        return AppColors.info;
      case ListingCondition.good:
        return AppColors.warning;
      case ListingCondition.acceptable:
        return AppColors.warning;
      case ListingCondition.defective:
        return AppColors.error;
    }
  }
}
