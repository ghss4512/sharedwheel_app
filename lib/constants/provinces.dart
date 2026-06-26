class Provinces {
  Provinces._();

  static const String all = 'All Provinces';

  static const String punjab = 'Punjab';
  static const String sindh = 'Sindh';
  static const String kpk = 'Khyber Pakhtunkhwa';
  static const String balochistan = 'Balochistan';
  static const String ict = 'Islamabad Capital Territory';
  static const String ajk = 'Azad Jammu & Kashmir';
  static const String gb = 'Gilgit Baltistan';

  static const List<String> list = [
    all,
    punjab,
    sindh,
    kpk,
    balochistan,
    ict,
    ajk,
    gb,
  ];

  static const List<String> withoutAll = [
    punjab,
    sindh,
    kpk,
    balochistan,
    ict,
    ajk,
    gb,
  ];
}
