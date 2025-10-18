class UserHealthProfile {
  String mood; // from Mood Journal
  List<String> symptoms; // from AI Chat
  List<String> medicines; // from OCR scan
  Map<String, dynamic> otherData; // e.g., blood pressure, allergies

  UserHealthProfile({
    this.mood = '',
    this.symptoms = const [],
    this.medicines = const [],
    this.otherData = const {},
  });
}
