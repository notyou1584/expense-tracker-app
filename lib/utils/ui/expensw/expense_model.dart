class Expense {
  String id;
  String userId;
  double amount;
  String currency;
  String description;
  String category;
  DateTime date;

  Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.description,
    required this.category,
    required this.date,
  });
}
