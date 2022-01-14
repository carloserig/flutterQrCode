
import 'package:contato/database/contato_helper.dart';
import 'package:flutter/cupertino.dart';

class Teste extends StatefulWidget {
  const Teste({Key? key}) : super(key: key);

  @override
  _TesteState createState() => _TesteState();
}

class _TesteState extends State<Teste> {

  ContatoHelper helper = ContatoHelper();

  // Teste BD
  @override
  void initState() {
    super.initState();
    /*Contato contato = Contato();
    contato.nome = "Carlos Erig";
    contato.email = "carlos.erig@gmail.com";
    contato.phone = "4599706001";
    contato.img = "";

    helper.salvarContato(contato);*/

    helper.getAllContacts().then((list) {
      print(list);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
