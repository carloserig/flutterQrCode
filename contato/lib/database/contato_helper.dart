import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String idColumn = "idColumn";
final String nomeColumn = "nomeColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class ContatoHelper {
  static final dbname = "contatos.db";
  static final dbversion = 1;
  static final tblContato = "contato";

  ContatoHelper();
  ContatoHelper._privateConstructor();
  static final ContatoHelper instance = ContatoHelper._privateConstructor();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initiateDatabase();
    return _database;
  }

  initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbname);
    return await openDatabase(path, version: dbversion, onCreate: onCreate);
  }

  Future onCreate(Database db, int dbversion) async {
    return await db.execute('''
         CREATE TABLE $tblContato (
           $idColumn INTEGER PRIMARY KEY,
           $nomeColumn TEXT,
           $emailColumn TEXT,
           $phoneColumn TEXT,
           $imgColumn TEXT
         )         
      ''');

  }

  Future<Contato> salvarContato(Contato contato) async {
    Database? dbContato = await database;
    contato.id = await dbContato!.insert(tblContato, contato.toMap());
    return contato;
  }

  Future<Contato?> getContact(int id) async {
    Database? dbContact = await database;
    List<Map> maps = await dbContact!.query(tblContato,
        columns: [idColumn, nomeColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if(maps.length > 0){
      return Contato.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletarContato(int id) async {
    Database? dbContact = await database;
    return await dbContact!.delete(tblContato, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContato(Contato contato) async {
    Database? dbContact = await database;
    return await dbContact!.update(tblContato,
        contato.toMap(),
        where: "$idColumn = ?",
        whereArgs: [contato.id]);
  }

  Future<List> getAllContacts() async {
    Database? dbContact = await database;
    List listMap = await dbContact!.rawQuery("SELECT * FROM $tblContato");
    List<Contato> listContact = [];
    for(Map m in listMap){
      listContact.add(Contato.fromMap(m));
    }
    return listContact;
  }

  Future<int?> getNumber() async {
    Database? dbContact = await database;
    return Sqflite.firstIntValue(await dbContact!.rawQuery("SELECT COUNT(*) FROM $tblContato"));
  }

  Future close() async {
    Database? dbContact = await database;
    dbContact!.close();
  }

}

class Contato {
  int? id;
  String? nome;
  String? email;
  String? phone;
  String? img;

  Contato();

  Contato.fromMap(Map map) {
    id = map[idColumn];
    nome = map[nomeColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nomeColumn: nome,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if(id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contato(id: $id, nome: $nome, email: $email, phone: $phone, img: $img)";
  }
}

