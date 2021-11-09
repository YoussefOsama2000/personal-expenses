import 'package:flutter/material.dart';
import 'transaction.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool noItems = true;
  String newItemTitle = '';
  double newItemPrice = 0;
  int year = int.parse(DateTime.now().year.toString());
  int month = int.parse(DateTime.now().month.toString());
  int day = int.parse(DateTime.now().day.toString());
  List<Transaction> transaction = [];
  List<BarChartGroupData> initBars() {
    List<BarChartGroupData> barsData = [];
    for (int i = 0; i < 7; i++) {
      double total = 0;
      for (int j = 0; j < transaction.length; j++) {
        if (transaction[j].date.weekday == i + 1)
          total = total + transaction[j].price;
      }
      barsData.add(BarChartGroupData(x: i + 1, barRods: [
        BarChartRodData(
          y: total,
        )
      ]));
    }

    return barsData;
  }

  String week(double x) {
    List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekDays[(x - 1).toInt()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: BarChart(
                        BarChartData(
                            maxY: 1000,
                            minY: 0,
                            titlesData: FlTitlesData(
                              rightTitles: SideTitles(
                                showTitles: false,
                              ),
                              topTitles: SideTitles(
                                showTitles: false,
                              ),
                              bottomTitles: SideTitles(
                                getTitles: week,
                                showTitles: true,
                              ),
                            ),
                            barGroups: initBars()),
                      ),
                    ),
                    TextField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration:
                          InputDecoration(hintText: 'Enter new category title'),
                      onChanged: (txt) {
                        newItemTitle = txt;
                      },
                    ),
                    TextField(
                      decoration:
                          InputDecoration(hintText: 'Enter piece price in USD'),
                      keyboardType: TextInputType.number,
                      onChanged: (num) {
                        newItemPrice = double.parse(num);
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: DateTime.now().year.toString()),
                            onChanged: (txt) {
                              print(txt);
                              year = txt == ''
                                  ? int.parse(DateTime.now().year.toString())
                                  : int.parse(txt);
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: DateTime.now().month.toString()),
                            onChanged: (txt) {
                              month = txt == ''
                                  ? int.parse(DateTime.now().month.toString())
                                  : int.parse(txt);
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: DateTime.now().day.toString()),
                            onChanged: (txt) {
                              day = txt == ''
                                  ? int.parse(DateTime.now().day.toString())
                                  : int.parse(txt);
                            },
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        if (newItemTitle != '' && newItemPrice != 0)
                          setState(() {
                            noItems = false;
                            transaction.add(Transaction(newItemTitle,
                                newItemPrice, DateTime(year, month, day)));
                          });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.black,
                            )),
                        child: Text(
                          'add item',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  height: 200,
                  child: SingleChildScrollView(
                    child: Column(
                        children: noItems
                            ? [
                                SizedBox(
                                  width: double.infinity,
                                )
                              ]
                            : transaction.map((tx) {
                                return Card(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: SizedBox(
                                          width: 110,
                                          child: Center(
                                            child: Text(
                                              '\$ ${tx.price.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1, color: Colors.blue)),
                                        padding: EdgeInsets.all(5),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tx.title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            '${tx.date.year.toString()}-${tx.date.month.toString()}-${tx.date.day.toString()}',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                transaction.insert(
                                                    transaction.indexOf(tx, 0) +
                                                        1,
                                                    Transaction(
                                                      tx.title,
                                                      tx.price,
                                                      tx.date,
                                                    ));
                                              });
                                            },
                                            child: Icon(
                                              Icons.add_to_photos,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                for (int i = 0;
                                                    i < transaction.length;
                                                    i++)
                                                  if (transaction[i] == tx) {
                                                    transaction.remove(tx);
                                                    return;
                                                  }
                                              });
                                            },
                                            child: Icon(
                                              Icons.delete,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(growable: true)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
