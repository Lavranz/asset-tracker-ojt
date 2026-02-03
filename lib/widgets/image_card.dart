import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:apollo_tracker_mobile/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';


class ImageCardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  ImageCardWidget({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: AppColors.strokePrimary, // Border color
          width: 1, // Border width
        ),
      ),
      child: SingleChildScrollView(  // Add scrolling to handle overflow
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: CustomImageView(
                imagePath: imageUrl,
                height: 95, 
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Title and Subtitle
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,  // Prevent overflow by truncating the text
                    style: AppTextTheme.LabelSmMediumPrimary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,  // Prevent overflow by truncating the text
                    style: AppTextTheme.CaptionMd,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
