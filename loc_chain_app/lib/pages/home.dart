import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:loc_chain_app/util/bluetooth.dart';
import 'package:loc_chain_app/util/transaction_manager.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<String> _id = FlutterUdid.consistentUdid;
  Connect connector = Connect();
  Map<String, Transaction> transactionMap = Map();
  // String getId() =>
  //     SharedPreferences.getInstance().then((s) => s.getString('id') ?? '0');

  void refreshTransactions() {
    setState(() {
      transactionMap = Connect.transactionMap;
      Connect.context = context;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<String>(
          future: _id, // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            String content = "Loading id...";
            if (snapshot.hasData) {
              content = "ID: ${snapshot.data!}";
            }
            List<Card> transactions = List.generate(
              transactionMap.length,
              (index) {
                Transaction t = transactionMap.values.elementAt(index);
                return Card(
                  child: Row(
                    children: [Text(t.hash), Text(t.pubKey)],
                  ),
                );
              },
            );
            return ListView(
              children: <Widget>[
                    Container(
                      child: Text(content),
                    ),
                  ] +
                  transactions,
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          refreshTransactions();
          try {
            Connect.stop();
            Connect.start();
          } catch (e) {
            print(e);
          }
        },
        child: Icon(Icons.refresh_sharp),
      ),
    );
  }

  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }
}
