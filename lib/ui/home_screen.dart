import 'package:flutter/material.dart';
import 'package:flutter_banco_douro/models/account.dart';
import 'package:flutter_banco_douro/services/account_service.dart';
import 'package:flutter_banco_douro/ui/styles/colors.dart';
import 'package:flutter_banco_douro/ui/widgets/account_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.lightGrey,
        title: const Text("Sistema de Gestão de Contas"),
        actions: [
          IconButton(
              onPressed: () =>
                  {Navigator.pushReplacementNamed(context, "login")},
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: AccountService().getAll(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                {

                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Nenhuma conta recebida!"),
                    );
                  } else {
                    List<Account> listAccounts = snapshot.data!;
                    print("resultado!!");
                    print(listAccounts);
                    return ListView.builder(
                      itemCount: listAccounts.length,
                      itemBuilder: (context, index) {
                        Account account = listAccounts[index];
                        return AccountWidget(account: account);
                      },
                    );
                  }
                }
            }
          },
        ),
      ),
    );
  }
}
