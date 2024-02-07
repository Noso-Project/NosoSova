import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static TextStyle textHiddenSmall(BuildContext context) {
    return TextStyle(
        fontSize: 12.sp,
        color: Theme.of(context).colorScheme.outline,
        fontFamily: "Gilroy",
        fontWeight: FontWeight.w400);
  }

  static TextStyle textHiddenMedium(BuildContext context) {
    return TextStyle(
        fontSize: 16.sp,
        color: Theme.of(context).colorScheme.outline,
        fontFamily: "Gilroy",
        fontWeight: FontWeight.w400);
  }

  static TextStyle tabActive = TextStyle(
      fontSize: 18.sp, fontFamily: "Gilroy", fontWeight: FontWeight.w600);

  static TextStyle tabInActive = TextStyle(
      fontSize: 18.sp, fontFamily: "Gilroy", fontWeight: FontWeight.w400);

  static TextStyle infoItemValue = TextStyle(
      fontSize: 14.sp, fontFamily: "Gilroy", fontWeight: FontWeight.w600);

  static TextStyle infoItemTitle = TextStyle(
      fontSize: 14.sp, fontFamily: "Gilroy", fontWeight: FontWeight.w400);

  static TextStyle priceValue = TextStyle(
      fontSize: 32.sp, fontFamily: "Gilroy", fontWeight: FontWeight.w600);

  static TextStyle categoryStyle = TextStyle(
      fontSize: 20.sp, fontFamily: "Gilroy", fontWeight: FontWeight.w700);

  static TextStyle walletHash = TextStyle(
      fontSize: 14.sp, fontFamily: "Gilroy", fontWeight: FontWeight.w600);

  static TextStyle walletBalance = TextStyle(
      fontSize: 14.sp, fontFamily: "Gilroy", fontWeight: FontWeight.w600);

  static TextStyle titleMessage = TextStyle(
      fontSize: 16.sp, fontFamily: "Gilroy", fontWeight: FontWeight.w600);

  static TextStyle subTitleMessage = TextStyle(
      fontSize: 14.sp, fontFamily: "Gilroy", fontWeight: FontWeight.w400);

  static TextStyle dialogTitle = TextStyle(
      fontSize: 18.sp, fontFamily: "Gilroy", fontWeight: FontWeight.w600);

  static TextStyle itemMedium = TextStyle(
      fontSize: 16.sp, fontFamily: "Gilroy", fontWeight: FontWeight.w400);

  static TextStyle balance = TextStyle(
      fontSize: 34.sp,
      color: Colors.white,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w700);

  static TextStyle nosoName = TextStyle(
      fontSize: 18.sp,
      color: Colors.white,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w500);

  static TextStyle textField = TextStyle(
      fontSize: 14.sp, fontFamily: "Gilroy", fontWeight: FontWeight.w700);

  static TextStyle textFieldHiddenStyle = TextStyle(
      fontSize: 14.sp, fontFamily: "Gilroy", fontWeight: FontWeight.w700);

  static TextStyle snackBarMessage = TextStyle(
      fontSize: 14.sp, fontFamily: "Gilroy", fontWeight: FontWeight.w600);

  static TextStyle buttonText = TextStyle(
      fontSize: 15.sp,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w600,
      color: Colors.white);
}
