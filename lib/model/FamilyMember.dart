class FamilyMember {
  String name;
  bool isHome;
  DateTime date;
  String iconUrl;

  FamilyMember({this.name, this.isHome, this.date, this.iconUrl});

  String getLastTime() {
    DateTime dateNow = DateTime.now();
    Duration dur = dateNow.difference(date);
    if (dur.inMinutes < 60) return '${dur.inMinutes} min.';
    if (dur.inHours < 24) return '${dur.inMinutes} hod.';
    return '${dur.inDays} dni.';
  }

  void updateDate() {
    date = DateTime.now();
  }
}
