class Transaction {
  static int currentId = 0;
  String title;
  double price;
  DateTime date;
  int id = 0;
  Transaction(this.title, this.price, this.date) {
    currentId++;
    id = currentId;
  }
}
