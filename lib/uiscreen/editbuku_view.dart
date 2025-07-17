import 'package:flutter/material.dart';
import 'package:buku_sqflite/helper/db_helper.dart';
import 'package:buku_sqflite/model/model_buku.dart';


class EditbukuView extends StatefulWidget {
  final ModelBuku buku;

  const EditbukuView({super.key, required this.buku});

  @override
  State<EditbukuView> createState() => _EditbukuViewState();
}

class _EditbukuViewState extends State<EditbukuView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulBukuController;
  late TextEditingController _namaBukuController;

  @override
  void initState() {
    super.initState();
    _judulBukuController = TextEditingController(text: widget.buku.judulBuku);
    _namaBukuController = TextEditingController(text: widget.buku.namaBuku);
  }

  Future<void> _updateBuku() async {
    if (_formKey.currentState!.validate()) {
      final updatedBuku = ModelBuku(
        id: widget.buku.id,
        judulBuku: _judulBukuController.text,
        namaBuku: _namaBukuController.text,
      );

      await DatabaseHelper.instance.updateBuku(updatedBuku);
      Navigator.pop(context); // kembali ke halaman list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Buku berhasil diperbarui")),
      );
    }
  }

  @override
  void dispose() {
    _judulBukuController.dispose();
    _namaBukuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Buku")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _judulBukuController,
                decoration: const InputDecoration(labelText: "Judul Buku"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Judul tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaBukuController,
                decoration: const InputDecoration(labelText: "Nama Buku"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.teal,
                          textStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)
                      ),
                      onPressed: (){
                        _updateBuku();
                      }, child: Text('Update Details')),
                  SizedBox(width: 10,),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          textStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold )
                      ),
                      onPressed: (){}, child: Text('Clear Details')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}