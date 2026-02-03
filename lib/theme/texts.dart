import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  // HEADLINE TEXTS
  // H6/Medium - Color: #262626 (surfaceInvertPrimary)
  static get H6MediumPrimary => GoogleFonts.inter(
    color: AppColors.surfaceInvertPrimary, // #262626
    fontSize: 18.0, // 18px
    fontWeight: FontWeight.w500,
    height: 21.0 / 18.0, // line-height: 21px
    letterSpacing: -0.4,
  );

  static get H6MediumPrimarySMB => H6MediumPrimary.copyWith(
    fontWeight: FontWeight.w600,
  );
  // H5/Medium - Color: #262626 (surfaceInvertPrimary)
  static get H5MediumPrimary => GoogleFonts.inter(
    color: AppColors.dark, // #262626
    fontSize: 20.0, // 18px
    fontWeight: FontWeight.w500,
    height: 24.0 / 18.0, // line-height: 21px
    letterSpacing: -0.4,
  );

  // H3/SemiBold - Color: #262626 (surfaceInvertPrimary)
  static get H4SemiBoldPrimary => GoogleFonts.inter(
    color: AppColors.surfaceInvertPrimary, // #262626
    fontSize: 23.0, // 23px
    fontWeight: FontWeight.w600,
    height: 27.0 / 23.0, // line-height: 27px
    letterSpacing: -0.4,
  );

  // H3/Medium - Color: #262626 (surfaceInvertPrimary)
  static get H3MediumPrimary => GoogleFonts.inter(
    color: AppColors.surfaceInvertPrimary, // #262626
    fontSize: 26.0, // 26px
    fontWeight: FontWeight.w500,
    height: 31.0 / 26.0, // line-height: 31px
    letterSpacing: -0.4,
  );

  // H2/Medium - Color: #262626 (surfaceInvertPrimary)
  static get H2MediumPrimary => GoogleFonts.inter(
    color: AppColors.surfaceInvertPrimary, // #262626
    fontSize: 29.0, // 26px
    fontWeight: FontWeight.w500,
    height: 31.0 / 26.0, // line-height: 31px
    letterSpacing: -0.4,
  );


  // BODY TEXTS
  // Body/sm/Regular - Color: #262626 (primary800)
  static get BodySmPrimary => GoogleFonts.inter(
      color: AppColors.surfaceInvertPrimary, // #262626
      fontSize: 14.0, // 14px
      fontWeight: FontWeight.w400,
      height: 21.0 / 14.0, // line-height: 21px
      letterSpacing: -0.4,
  );

  // Body/sm/Regular - Color: #7D7E80 surfaceInvertTertiary
  static get BodySmTertiary => BodySmPrimary.copyWith(
    color: AppColors.surfaceInvertTertiary, // #454545
    fontSize: 14.0, // 14px
  );
  // Body/sm/Regular - Color: #454545 (primary800)
  static get BodySmSecondary => BodySmPrimary.copyWith(
    color: AppColors.primary800, // #454545
    fontSize: 14.0, // 14px
  );

  // Body/sm/Medium - Color: #262626 (surfaceInvertPrimary)
  static get BodySmMediumPrimary => BodySmPrimary.copyWith(
    color: AppColors.surfaceInvertPrimary, // #262626
    fontWeight: FontWeight.w600,
  );

  // Body/md/Regular - Color: #262626 (surfaceInvertPrimary)
  static get BodyMdPrimary => GoogleFonts.inter(
    color: AppColors.surfaceInvertPrimary, // #262626
    fontSize: 16.0, // 16px
    fontWeight: FontWeight.w400,
    height: 24.0 / 16.0, // line-height: 24px
    letterSpacing: -0.4,
  );

  // LABEL TEXTS
  // Label/md/Regular - Color: #262626 (surfaceInvertPrimary)
  static get LabelMdPrimary => GoogleFonts.inter(
    color: AppColors.surfaceInvertPrimary, // #262626
    fontSize: 16.0, // 16px
    fontWeight: FontWeight.w400,
    height: 19.0 / 16.0, // line-height: 19px
    letterSpacing: -0.4,
  );

  // Label/md/Medium - Color: #262626 (surfaceInvertPrimary)
  static get LabelMdMediumPrimary => LabelMdPrimary.copyWith(
    color: AppColors.surfaceInvertPrimary, // #262626
    fontWeight: FontWeight.w600,
  );

  // Label/sm/Regular - Color: #444446 (surfaceInvertSecondary)
  static get LabelSmSecondary => GoogleFonts.inter(
    color: AppColors.surfaceInvertSecondary, // #444446
    fontSize: 14.0, // 14px
    fontWeight: FontWeight.w400,
    height: 16.0 / 14.0, // line-height: 16px
    letterSpacing: -0.4,
  );

  static get LabelSmNeutral => LabelSmSecondary.copyWith(
    color: AppColors.neutral500
  );

  // Label/sm/Regular - Color: #7D7E80 (surfaceInvertTertiary)
  static get LabelSmTertiary => GoogleFonts.inter(
    color: AppColors.surfaceInvertTertiary, // #7D7E80
    fontSize: 14.0, // 14px
    fontWeight: FontWeight.w400,
    height: 16.0 / 14.0, // line-height: 16px
    letterSpacing: -0.4,
  );
  static get LabelSmRegular => LabelSmTertiary.copyWith(
    color: AppColors.surfaceInvertPrimary
  );

  // Label/sm/Regular - Color: #7D7E80 (negative300)
  static get LabelSmNegative300 => LabelSmSecondary.copyWith(
    color: AppColors.negative300
  );

  // Label/sm/Medium - Color: #262626 (surfaceInvertPrimary)
  static get LabelSmMediumPrimary => LabelSmNegative300.copyWith(
    color: AppColors.surfaceInvertPrimary, // #262626
    fontWeight: FontWeight.w600,
  );

  // CAPTION TEXTS
  static get Caption => GoogleFonts.inter(
    color: AppColors.neutral300, // #7D7E80
    fontSize: 12.0, // 12px
    fontWeight: FontWeight.w400,
    height: 14.0 / 12.0, // line-height: 14px
    letterSpacing: -0.4,
  );

  static get CaptionMd => GoogleFonts.inter(
    color: AppColors.surfaceInvertTertiary, // #7D7E80
    fontSize: 12.0, // 12px
    fontWeight: FontWeight.w500,
    height: 14.0 / 12.0, // line-height: 14px
    letterSpacing: -0.4,
  );

  // Caption/Medium - Color: #FFF (light)
  static get CaptionMdLight => CaptionMd.copyWith(
    color: AppColors.light
  );
}
