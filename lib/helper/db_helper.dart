import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:buku_sqflite/model/model_buku.dart';

class DatabaseHelper{
  static final DatabaseHelper instance = DatabaseHelper._instance();

  static Database? _database;
  DatabaseHelper._instance();

  Future<Database> get db async{
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async{
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'db_buku');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE tb_buku (
      id INTEGER PRIMARY KEY,
      namaBuku TEXT,
      judulBuku TEXT
    )
    ''');
  }

  Future<int> insertBuku(ModelBuku buku) async{
    Database db = await instance.db;
    return await db.insert('tb_buku', buku.toMap());
  }

  //get all data
  Future<List<Map<String, dynamic>>> queryAllBuku() async{
    Database db = await instance.db;
    return await db.query('tb_buku');
  }

  Future<int> updateBuku(ModelBuku buku) async{
    Database db = await instance.db;
    return await db.update('tb_buku', buku.toMap(), where: 'id = ?', whereArgs: [buku.id]);
  }

  Future<int> deleteUser(int id) async{
    Database db = await instance.db;
    return await db.delete('tb_buku', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> initializeDataBuku() async{
    List<ModelBuku> dataBukuToAdd = [
      ModelBuku(namaBuku: 'komik', judulBuku: 'cihuyy'),
      ModelBuku(namaBuku: 'komik', judulBuku: 'mahal  kink'),
      ModelBuku(namaBuku: 'novel', judulBuku: 'kelaz kink'),
      ModelBuku(namaBuku: 'psikolog', judulBuku: 'laba-laba sunda'),
      ModelBuku(namaBuku: 'novel', judulBuku: 'owalah cik'),
    ];
    for (ModelBuku modelBuku in dataBukuToAdd){
      await insertBuku(modelBuku);
    }
  }

}