import 'package:noso_rest_api/enum/time_range.dart';

class SetPriceRequest {
  final TimeRange _range;
  final int _interval;

  SetPriceRequest(this._range, this._interval);

  get interval => _interval;

  get range => stringFromTimeRange();

  TimeRange timeUnitFromString(String value) {
    return TimeRange.values
        .firstWhere((e) => e.toString().split('.').last == value.toLowerCase());
  }

  String stringFromTimeRange() {
    return _range.toString().split('.').last;
  }
}
