import 'package:flutter/material.dart';

class AppTextStyles {
  static const double _smallSizeText = 14.0;
  static const double _mediumSizeText = 16.0;
  static const double _medBigSizeText = 18.0;

  static TextStyle textHiddenSmall(BuildContext context) {
    return TextStyle(
        fontSize: _smallSizeText,
        color: Theme.of(context).colorScheme.outline,
        fontFamily: "Gilroy",
        fontWeight: FontWeight.w400);
  }

  static TextStyle textHiddenMedium(BuildContext context) {
    return TextStyle(
        fontSize: _medBigSizeText,
        color: Theme.of(context).colorScheme.outline,
        fontFamily: "Gilroy",
        fontWeight: FontWeight.w400);
  }

  static TextStyle tabActive = const TextStyle(
      fontSize: _medBigSizeText,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w600);

  static TextStyle tabInActive = const TextStyle(
      fontSize: _medBigSizeText,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w400);

  static TextStyle infoItemValue = const TextStyle(
      fontSize: _mediumSizeText,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w600);

  static TextStyle infoItemTitle = const TextStyle(
      fontSize: _mediumSizeText,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w400);

  static TextStyle priceValue = const TextStyle(
      fontSize: 32, fontFamily: "Gilroy", fontWeight: FontWeight.w600);

  static TextStyle categoryStyle = const TextStyle(
      fontSize: 22, fontFamily: "Gilroy", fontWeight: FontWeight.w700);

  static TextStyle walletHash = const TextStyle(
      fontSize: _mediumSizeText,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w600);

  static TextStyle walletBalance = const TextStyle(
      fontSize: _mediumSizeText,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w600);

  static TextStyle titleMessage = const TextStyle(
      fontSize: _medBigSizeText,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w600);

  static TextStyle subTitleMessage = const TextStyle(
      fontSize: _mediumSizeText,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w400);

  static TextStyle dialogTitle = const TextStyle(
      fontSize: 20, fontFamily: "Gilroy", fontWeight: FontWeight.w600);

  static TextStyle itemMedium = const TextStyle(
      fontSize: _medBigSizeText,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w400);

  static TextStyle balance = const TextStyle(
      fontSize: 34,
      color: Colors.white,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w700);

  static TextStyle gvtBalance = const TextStyle(
      fontSize: 36,
      color: Colors.white,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w700);

  static TextStyle nosoName = const TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w500);

  static TextStyle textField = const TextStyle(
      fontSize: _mediumSizeText,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w700);

  static TextStyle textFieldHiddenStyle = const TextStyle(
      fontSize: _mediumSizeText,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w700);

  static TextStyle snackBarMessage = const TextStyle(
      fontSize: _mediumSizeText,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w600);

  static TextStyle buttonText = const TextStyle(
      fontSize: 18,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w600,
      color: Colors.white);

  static TextStyle buttonTextDefault(BuildContext context) {
    return TextStyle(
        fontSize: 16,
        color: Theme.of(context).colorScheme.onPrimary,
        fontFamily: "Gilroy",
        fontWeight: FontWeight.w600);
  }

  static TextStyle statusSeed = const TextStyle(
      fontSize: _mediumSizeText,
      fontFamily: "Gilroy",
      fontWeight: FontWeight.w700);
}
