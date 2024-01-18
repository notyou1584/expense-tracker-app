class addexpense {
  String id;
  double amount;
  String currency;
  String description;
  String category;
  DateTime date;

  addexpense({
    required this.id,
    required this.amount,
    required this.currency,
    required this.description,
    required this.category,
    required this.date,
  });
}