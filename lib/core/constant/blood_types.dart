class BloodTypes {
  static const Map<String, String> all = {
    'A+': 'A+',
    'A-': 'A-',
    'B+': 'B+',
    'B-': 'B-',
    'AB+': 'AB+',
    'AB-': 'AB-',
    'O+': 'O+',
    'O-': 'O-',
  };

  static List<String> get list => all.keys.toList();
}
