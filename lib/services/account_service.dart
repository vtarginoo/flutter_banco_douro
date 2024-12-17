import 'dart:async';

import 'package:http/http.dart';
import 'dart:convert';

import '../models/account.dart';
import 'api_key.dart';

class AccountService {
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;

   String url = 
    "https://api.github.com/gists/f692e28182d11fabd7e12c9d4d479b5d";

   Future<List<Account>> getAll() async {
    Response response = await get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $apiKey"},
    );
    _streamController.add("${DateTime.now()} | Requisição de leitura.");

    Map<String, dynamic> mapResponse = json.decode(response.body);
    List<dynamic> listDynamic =
        json.decode(mapResponse["files"]["accounts.json"]["content"]);

    List<Account> listAccounts = [];

    for (dynamic dyn in listDynamic) {
      Map<String, dynamic> mapAccount = dyn as Map<String, dynamic>;
      Account account = Account.fromMap(mapAccount);
      listAccounts.add(account);
    }

  //print("print do list accounts"); 
  //print(listAccounts);


    return listAccounts;
  }

  addAccount(Account account) async {
    List<Account> listAccounts = await getAll();
    listAccounts.add(account);
    await save(listAccounts, accountName: account.name);
  }

  save(List<Account> listAccounts, {String accountName = ""}) async {
    List<Map<String, dynamic>> listContent = [];
    for (Account account in listAccounts) {
      listContent.add(account.toMap());
    }

    String content = json.encode(listContent);

    Response response = await post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $apiKey"},
      body: json.encode({
        "description": "account.json",
        "public": true,
        "files": {
          "accounts.json": {
            "content": content,
          }
        }
      }),
    );

    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
          "${DateTime.now()} | Requisição adição bem sucedida ($accountName).");
    } else {
      _streamController
          .add("${DateTime.now()} | Requisição falhou ($accountName).");
    }
  }
}
