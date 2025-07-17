import 'package:buku_sqflite/helper/db_helper.dart';
import 'package:buku_sqflite/model/model_buku.dart';
import 'package:buku_sqflite/uiscreen/addbuku_view.dart';
import 'package:buku_sqflite/uiscreen/editbuku_view.dart';
import 'package:flutter/material.dart';

class ListViewBuku extends StatefulWidget {
  const ListViewBuku({super.key});

  @override
  State<ListViewBuku> createState() => _ListViewBukuState();
}

class _ListViewBukuState extends State<ListViewBuku> {
  List<ModelBuku> _buku = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAndFetch();
  }

  Future<void> _initializeAndFetch() async {
    await DatabaseHelper.instance.initializeDataBuku();
    _fetchDataBuku();
  }

  Future<void> _fetchDataBuku() async {
    setState(() {
      _isLoading = true;
    });

    final bukuMaps = await DatabaseHelper.instance.queryAllBuku();
    setState(() {
      _buku = bukuMaps.map((bukuMaps) => ModelBuku.fromMap(bukuMaps)).toList();
      _isLoading = false;
    });
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _deleteFormDialog(BuildContext context, int id) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah Anda yakin ingin menghapus buku ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseHelper.instance.deleteUser(id);
                Navigator.pop(context); // tutup dialog
                _showSuccessSnackbar("Buku berhasil dihapus");
                _fetchDataBuku(); // refresh data
              },
              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data Buku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchDataBuku,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buku.isEmpty
          ? const Center(child: Text("Belum ada data buku."))
          : ListView.builder(
        itemCount: _buku.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_buku[index].judulBuku),
            subtitle: Text(_buku[index].namaBuku),
            onTap: () async {
              // navigasi ke halaman edit dan refresh data setelah kembali
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditbukuView(buku: _buku[index]),
                ),
              );
              _fetchDataBuku();
            },
            onLongPress: () {
              _deleteFormDialog(context, _buku[index].id!);
            },
          );

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddbukuView()),
          );
          _fetchDataBuku(); // refresh data
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
