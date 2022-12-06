import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutterapi/list.dart';
import 'dart:async';
import 'dart:convert';
import 'qrcode.dart';
import 'package:localstorage/localstorage.dart';

final String URL = "https://slmm.com.br/CTC/";
final LocalStorage storage = LocalStorage('localstorage_app');

Future<String> postData(String nome, String date) async {
  Map data = {"nome":"${nome}", "data": "${date}"};
  String body = json.encode(data);
  var response = await http.post(Uri.parse("${URL}insere.php"),
      headers: {"Content-Type": "application/json"}, body: body);
  if (response.statusCode == 200) {
    String ret = json.encode(response.body);
    return ret;
  } else {
    throw Exception('Erro POST.');
  }
}


Future<List<Lista>> fetchAll() async {
  final response = await http.get(Uri.parse(URL+"getLista.php"));
  if (response.statusCode == 200) {
    final List result = json.decode(response.body);
    return result.map((e) => Lista.fromJson(e)).toList();
  } else {
    throw Exception('Erro GET ALL.');
  }
}

Future<String> delete(String id) async {
  final response = await http.delete(Uri.parse(URL + "delete.php?id=" + id),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return response.body;
  } else {
    throw Exception('Erro DELETE.');
  }
}


class Crud extends StatefulWidget {
  const Crud({Key? key}) : super(key: key);

  @override
  _CrudState createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  final nomeController = TextEditingController();
  final dataController = TextEditingController();
  final idController = TextEditingController();
  Future<List<Lista>>? _dadosF;

  @override
  void dispose() {
    nomeController.dispose();
    dataController.dispose();
    super.dispose();
  }

  FutureBuilder<List<Lista>> buildFutureBuilder() {
    return FutureBuilder(
        future: fetchAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].nome.toString()),
                  subtitle: Text(snapshot.data![index].data.toString()),
                );
              }));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }

  ElevatedButton botao() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            _dadosF = null;
          });
        },
        child: const Text("enviar dados"));
  }

  @override
  Widget build(BuildContext context) {

     setState(() {
            _dadosF = fetchAll();
          });

    return Scaffold(
      appBar: AppBar(title: const Text("Lista de dados")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(6),
        child: 
          Column(
          children: [
            TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.person),
                    hintText: 'Insira o nome')),
            TextField(
                controller: dataController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.date_range),
                    hintText: 'Insira a data')),
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.delete_forever),
                    hintText: 'Insira um ID para deletar'
              ),
            ),
            Container(
                margin: const EdgeInsets.all(3),
                child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    (nomeController.text.isNotEmpty && dataController.text.isNotEmpty) 
                    ? postData(nomeController.text, dataController.text) :
                      delete(idController.text);
                  });
                },
                child: const Text("Enviar/Deletar")),
                ),
                Container(
                  margin: const EdgeInsets.all(6),
                  child:  ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Qrcode(),
                      ));
                },
                child: const Text("Habilitar QR Code")),
                ),
                SizedBox(
                  child: FutureBuilder<List<Lista>>(future: fetchAll(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        separatorBuilder:(context, index) {
                          return const SizedBox(height: 12);
                        },
                        itemBuilder:(context, index) {
                          return ListTile(
                            title: Text(snapshot.data![index].nome.toString()),
                            subtitle: Text(snapshot.data![index].data.toString()),
                          );
                        },
                        );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  },),
                )
          ]),
      ),
    );
  }
}
