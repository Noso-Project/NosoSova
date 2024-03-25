import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/address_tile_style.dart';

class AddressStyleNotifier with ChangeNotifier {
  final String _styleAddressTilePref = "addressTileStyle";
  int _styleAddressTile = 0;

  AddressTileStyle? get getStyleAddressTile =>
      _listStyleAddressTile[_styleAddressTile];

  final Map<int, AddressTileStyle> _listStyleAddressTile = {
    0: AddressTileStyle.sDefault,
    1: AddressTileStyle.sCustom,
  };

  AddressStyleNotifier() {
    _loadSettings();
  }

  void setStyleAddressTile(int value) {
    var styleInt = value > 1 ? 0 : value;
    _styleAddressTile = styleInt;
    notifyListeners();
    _saveTileAddressStyle(styleInt);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _styleAddressTile = prefs.getInt(_styleAddressTilePref) ?? 0;
    notifyListeners();
  }

  Future<void> _saveTileAddressStyle(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_styleAddressTilePref, value);
  }
}
