import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../blocs/listing/listing_bloc.dart';
import '../../../blocs/listing/listing_event.dart';
import '../../../blocs/listing/listing_state.dart';
import '../../../../domain/repositories/listing_repository.dart';
import '../../../../domain/entities/listing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// TODO: implement steps and widgets, temporary placeholders below
// import 'steps/category_step.dart';
// import 'steps/details_step.dart';
// import 'steps/media_step.dart';
// import 'steps/pricing_step.dart';
// import 'steps/delivery_step.dart';
// import 'steps/review_step.dart';
// import '../../widgets/step_progress_indicator.dart';
// import '../../widgets/custom_button.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/step_progress_indicator.dart';

class CreateListingPage extends StatefulWidget {
  const CreateListingPage({super.key});

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  late PageController _pageController;
  int _currentStep = 1;
  final int _totalSteps = 6;

  // Form data
  String? _selectedCategoryId;
  Map<String, dynamic> _listingData = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListingBloc, ListingState>(
      listener: (context, state) {
        if (state is ListingCreated) {
          _showSuccessDialog();
        } else if (state is ListingError) {
          _showErrorDialog(state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          leading: IconButton(
            onPressed: _currentStep > 1 ? _goToPreviousStep : null,
            icon: Icon(
              Icons.arrow_back,
              size: 24.w,
              color: _currentStep > 1 ? AppColors.textPrimary : AppColors.textMuted,
            ),
          ),
          title: Text(
            'create_listing'.tr(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          actions: [
            if (_currentStep > 1)
              TextButton(
                onPressed: _saveAsDraft,
                child: Text(
                  'save_draft'.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.h),
            child: StepProgressIndicator(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              onStepTap: _canGoToStep(_currentStep) ? _goToStep : null,
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Center(child: Text('Kategori adımı (placeholder)')),
            Center(child: Text('Detaylar adımı (placeholder)')),
            Center(child: Text('Medya adımı (placeholder)')),
            Center(child: Text('Fiyatlandırma adımı (placeholder)')),
            Center(child: Text('Teslimat adımı (placeholder)')),
            Center(child: Text('Gözden geçir adımı (placeholder)')),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigation(),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    if (_currentStep == _totalSteps) {
      // Final step - show submit button
      return Container(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BlocBuilder<ListingBloc, ListingState>(
          builder: (context, state) {
            return CustomButton(
              text: 'publish_listing'.tr(),
              onPressed: state is ListingLoading ? null : _submitListing,
              isLoading: state is ListingLoading,
              width: double.infinity,
              size: ButtonSize.large,
            );
          },
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 1) ...[
            Expanded(
              child: CustomButton(
                text: 'previous'.tr(),
                onPressed: _goToPreviousStep,
                type: ButtonType.outline,
              ),
            ),
            SizedBox(width: AppDimensions.marginM),
          ],
          Expanded(
            child: CustomButton(
              text: _currentStep == _totalSteps - 1 ? 'review'.tr() : 'next'.tr(),
              onPressed: _canGoToNextStep() ? _goToNextStep : null,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }

  void _goToNextStep() {
    if (_currentStep < _totalSteps && _canGoToNextStep()) {
      setState(() {
        _currentStep++;
        _pageController.animateToPage(
          _currentStep - 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
        _pageController.animateToPage(
          _currentStep - 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _goToStep(int step) {
    if (_canGoToStep(step)) {
      setState(() {
        _currentStep = step;
        _pageController.animateToPage(
          step - 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  bool _canGoToNextStep() {
    switch (_currentStep) {
      case 1:
        return _selectedCategoryId != null && _selectedCategoryId!.isNotEmpty;
      case 2:
        return _listingData['title'] != null && _listingData['description'] != null;
      case 3:
        return _listingData['mediaUrls'] != null && (_listingData['mediaUrls'] as List).isNotEmpty;
      case 4:
        return _listingData['pricing'] != null;
      case 5:
        return _listingData['delivery'] != null;
      default:
        return true;
    }
  }

  bool _canGoToStep(int step) {
    if (step <= _currentStep) return true;
    return _canGoToNextStep();
  }

  void _saveAsDraft() {
    // TODO: Implement save as draft functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('draft_saved'.tr()),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _submitListing() {
    // Validate all required data
    if (!_validateListingData()) {
      _showErrorDialog('please_complete_all_required_fields'.tr());
      return;
    }

    // Submit the listing
    context.read<ListingBloc>().add(
      CreateListingRequested(
        CreateListingRequest(
          userId: 'current_user_id', // TODO: Get from auth state
          title: _listingData['title'],
          description: _listingData['description'],
          categoryId: _selectedCategoryId!,
          condition: _listingData['condition'] ?? ListingCondition.good,
          brand: _listingData['brand'],
          model: _listingData['model'],
          year: _listingData['year'],
          mediaUrls: _listingData['mediaUrls'] ?? [],
          pricing: _listingData['pricing'],
          delivery: _listingData['delivery'],
          location: _listingData['location'],
          saveAsDraft: false,
        ),
      ),
    );
  }

  bool _validateListingData() {
    return _selectedCategoryId != null &&
           _listingData['title'] != null &&
           _listingData['description'] != null &&
           _listingData['mediaUrls'] != null &&
           (_listingData['mediaUrls'] as List).isNotEmpty &&
           _listingData['pricing'] != null &&
           _listingData['delivery'] != null;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('success'.tr()),
        content: Text('listing_created_successfully'.tr()),
        actions: [
          CustomButton(
            text: 'view_listing'.tr(),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to listings
              // TODO: Navigate to listing detail page
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
            },
            child: Text('back_to_home'.tr()),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('error'.tr()),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ok'.tr()),
          ),
        ],
      ),
    );
  }
}
