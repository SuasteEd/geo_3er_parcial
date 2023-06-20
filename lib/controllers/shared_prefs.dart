import '../main.dart';

class SharedPrefs {
  void clear() {
    sharedPreferences.clear();
  }

  double get latitude {
    return sharedPreferences.getDouble('latitude') ?? 0.0;
  }

  set latitude(double value) {
    sharedPreferences.setDouble('latitude', value);
  }

  double get longitude {
    return sharedPreferences.getDouble('longitude') ?? 0.0;
  }

  set longitude(double value) {
    sharedPreferences.setDouble('longitude', value);
  }
}
