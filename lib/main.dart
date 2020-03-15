import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/UI/CreateReview.dart';

void main() => runApp(MyApp());

// final dummySnapshot = [
//   {"name": "Flutter", "votes": 15},
//   {"name": "Android", "votes": 14},
//   {"name": "iOS", "votes": 11},
//   {"name": "Xamerin", "votes": 10},
//   {"name": "React", "votes": 1}
// ];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apps',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Best app by votes')),
      body: _buildBody(context),
      bottomSheet: SizedBox(
        width: double.infinity,
        child:    RaisedButton(
        elevation: 5.0,
        onPressed: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new CreateForm()));
        },
        child: Text('Inbuilt Review App'),
        color: Colors.blue,
        colorBrightness: Brightness.dark,
      ),
      )
   
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.userName),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)),
        child: ListTile(
          title: Text(record.userName),
          trailing: Text(record.value),
          onTap: () {
            final snackBar = SnackBar(
                content:
                    Text("Selected App : " + record.userName));

            Scaffold.of(context).showSnackBar(snackBar);
          },
        ),
      ),
    );
  }
}

class Record {
  final String userName;
  final String value;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['userName'] != null),
        assert(map['value'] != null),
        userName = map['userName'],
        value = map['value'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$userName:$value>";
}
