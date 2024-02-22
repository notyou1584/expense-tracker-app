class Expense {
  String userId;
  double amount;
  String description;
  String category;
  DateTime date;
  String id;
  int? groupId;

  Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
    this.groupId, String? mobile,
  });
}
