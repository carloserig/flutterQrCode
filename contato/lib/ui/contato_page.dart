import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contato/database/contato_helper.dart';
import 'package:image_picker/image_picker.dart';

class ContatoPage extends StatefulWidget {

  final Contato? contato;
  ContatoPage({this.contato});

  @override
  _ContatoPageState createState() => _ContatoPageState();
}


class _ContatoPageState extends State<ContatoPage> {

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nomeFocus = FocusNode();

  bool _usuarioEditado = false;
  late Contato _contatoEditado;

  @override
  void initState() {
    super.initState();
    if(widget.contato == null) {
      _contatoEditado = Contato();
    } else {
      _contatoEditado = Contato.fromMap(widget.contato!.toMap());

      _nomeController.text = _contatoEditado.nome!;
      _emailController.text = _contatoEditado.email!;
      _phoneController.text = _contatoEditado.phone!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_contatoEditado.nome ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_contatoEditado.nome!.isNotEmpty && _contatoEditado.nome != null) {
              Navigator.pop(context, _contatoEditado);
            } else {
              FocusScope.of(context).requestFocus(_nomeFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding:  EdgeInsets.all(10.0),
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: _contatoEditado.img != null ?
                      FileImage(File(_contatoEditado.img!)) as ImageProvider :
                      AssetImage("images/person.png")
                    ),
                  ),
                ),
                onTap: () {
                  ImagePicker().pickImage(source: ImageSource.camera).then((file) {
                    if (file == null) return;
                    else {
                      setState(() {
                        _contatoEditado.img = file.path;
                      });
                    }
                  });
                },
              ),
              TextField(
                controller: _nomeController,
                focusNode: _nomeFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _usuarioEditado = true;
                  setState(() {
                    _contatoEditado.nome = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "E-mail"),
                onChanged: (text) {
                  _usuarioEditado = true;
                  _contatoEditado.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                onChanged: (text) {
                  _usuarioEditado = true;
                  _contatoEditado.phone = text;
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> _requestPop() {
    if (_usuarioEditado) {
      showDialog(context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações:"),
              content: Text("Ao sair as alterações serão perdidas!"),
              actions: [
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
