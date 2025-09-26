import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/localization/string_extensions.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Function(int)? onStepTap;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.paddingM,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: 1.w,
          ),
        ),
      ),
      child: Column(
        children: [
          // Progress bar
          Container(
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
            ),
            child: Row(
              children: List.generate(totalSteps, (index) {
                final step = index + 1;
                final isCompleted = step < currentStep;
                final isCurrent = step == currentStep;
                final isClickable = onStepTap != null && step <= currentStep;

                return Expanded(
                  child: GestureDetector(
                    onTap: isClickable ? () => onStepTap!(step) : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 4.h,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 0 : 1.w,
                        right: index == totalSteps - 1 ? 0 : 1.w,
                      ),
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent
                            ? AppColors.primary
                            : AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          SizedBox(height: AppDimensions.marginM),

          // Step indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalSteps, (index) {
              final step = index + 1;
              final isCompleted = step < currentStep;
              final isCurrent = step == currentStep;
              final isClickable = onStepTap != null && step <= currentStep;

              return GestureDetector(
                onTap: isClickable ? () => onStepTap!(step) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppColors.primary
                        : isCurrent
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.inputBackground,
                    border: Border.all(
                      color: isCompleted || isCurrent
                          ? AppColors.primary
                          : AppColors.border,
                      width: isCurrent ? 2.w : 1.w,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? Icon(
                            Icons.check,
                            size: 16.w,
                            color: AppColors.white,
                          )
                        : Text(
                            step.toString(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isCurrent
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: AppDimensions.marginS),

          // Step titles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepTitle(1, 'category'.translate, currentStep >= 1),
              _buildStepTitle(2, 'details'.translate, currentStep >= 2),
              _buildStepTitle(3, 'media'.translate, currentStep >= 3),
              _buildStepTitle(4, 'pricing'.translate, currentStep >= 4),
              _buildStepTitle(5, 'delivery'.translate, currentStep >= 5),
              _buildStepTitle(6, 'review'.translate, currentStep >= 6),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepTitle(int step, String title, bool isActive) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: isActive ? AppColors.primary : AppColors.textMuted,
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
