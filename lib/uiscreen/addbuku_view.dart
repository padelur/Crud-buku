import 'package:buku_sqflite/helper/db_helper.dart';
import 'package:buku_sqflite/model/model_buku.dart';
import 'package:flutter/material.dart';

class AddbukuView extends StatefulWidget {
  const AddbukuView({super.key});

  @override
  State<AddbukuView> createState() => _AddbukuViewState();
}

class _AddbukuViewState extends State<AddbukuView> {

  var _namaBukuController = TextEditingController();
  var _judulBukuController = TextEditingController();

  bool _validateNama = false;
  bool _validateJudul = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add data buku'),

      ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('add new buku',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.teal,

                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: _namaBukuController,
                decoration: InputDecoration(border: OutlineInputBorder(),
                    hintText: 'masukkan nama buku',
                    labelText: 'nama buku',
                    errorText: _validateNama ? 'nama tidak boleh kosong': null
                ),
              ),

              SizedBox(height: 20,),
              TextField(
                controller: _judulBukuController,
                decoration: InputDecoration(border: OutlineInputBorder(),
                    hintText: 'masukkan judul buku',
                    labelText: 'judul buku',
                    errorText: _validateJudul ? 'judul tidak boleh kosong': null
                ),
              ),

              SizedBox(height: 20,),
              Row(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.teal,
                          textStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)
                      ),
                      onPressed: () async{
                        setState(() {
                          _namaBukuController.text.isEmpty
                              ? _validateNama = true
                              : _validateNama = false;
                          _judulBukuController.text.isEmpty
                              ? _validateJudul = true
                              : _validateJudul = false;
                        });

                        //ketika data sudah diisi
                        if(_validateNama == false && _validateJudul == false )
                        {
                          // print ("good data can save");
                          var _buku = ModelBuku(namaBuku: _namaBukuController.text, judulBuku: _judulBukuController.text);

                          var result = await DatabaseHelper.instance.insertBuku(_buku);
                          Navigator.pop(context,result);
                        }


                      },child: Text('Save ')),

                  SizedBox(width: 10,),
                  Row(
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                              textStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)
                          ),
                          onPressed: (){
                            _namaBukuController.text = '';
                            _judulBukuController.text = '';
                          },child: Text('Clear ')),

                    ],
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
