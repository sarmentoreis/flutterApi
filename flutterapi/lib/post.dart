import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';

String URL = "http://slmm.com.br/CTC/";

Future<String> postData() async {
  DateTime dataAgora = DateTime.now();
  DateFormat teste = new DateFormat("yy/MM/dd HH:mm:ss");
  Map data = {'nome': 'Marcus', 'data': teste.format(dataAgora)};

  String body = json.encode(data);

  var response = await http.post(Uri.parse(URL + "insere.php"),
      headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('POST ERROR.');
  }
}

Future<String> fetchAll() async {
  final response = await http.get(Uri.parse(URL + "getLista.php"));
  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return response.body;
  } else {
    throw Exception('FETCH ALL ERROR.');
  }
}

Future<String> fetchOne(id) async {
  final response = await http.get(Uri.parse(URL + "getDetalhe.php?id=" + id));
  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return response.body;
  } else {
    throw Exception('FETCH ALL ERROR.');
  }
}

Future<String> delete(String id) async {
  final response = await http.delete(Uri.parse(URL + "delete.php?id=" + id),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return response.body;
  } else {
    throw Exception('DELETE ERROR.');
  }
}

class PostNot extends StatefulWidget {
  const PostNot({Key? key}) : super(key: key);

  @override
  _PostNotState createState() => _PostNotState();
}

class _PostNotState extends State<PostNot> {
  final raController = TextEditingController();
  Future<String>? _dadosF;

  @override
  void dispose() {
    raController.dispose();
    super.dispose();
  }

  FutureBuilder<String> buildFutureBuilder() {
    return FutureBuilder(
        future: _dadosF,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }

  ElevatedButton botaoPost() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            _dadosF = postData();
          });
        },
        child: Text("enviar dados"));
  }

  ElevatedButton botaoGet() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            _dadosF = fetchAll();
          });
        },
        child: Text("Receber dados"));
  }

  ElevatedButton botaoGetOne(String id) {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            _dadosF = fetchOne(id);
          });
        },
        child: Text("Receber dados"));
  }

  ElevatedButton botaoDelete(String id) {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            _dadosF = delete(id);
          });
        },
        child: Text("Receber dados"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("post dados")),
      body: Container(
        padding: EdgeInsets.all(6),
        child: Column(children: [
          TextField(
              controller: raController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.person),
                  hintText: 'Informe o RA')),
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(raController.text),
                      );
                    });
                setState(() {
                  _dadosF = null;
                });
              },
              child: Text("Enviar")),
          (_dadosF == null) ? botaoPost() : buildFutureBuilder(),
        ]),
      ),
    );
  }
}
