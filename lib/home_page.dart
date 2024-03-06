import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_10/add_page.dart';
import 'package:task_10/api/api.dart';
import 'package:task_10/auth/login_page.dart';
import 'package:task_10/edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _listdata = [];
  bool _isloading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('loggedIn') ?? false;

    if (!isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      _getdata();
    }
  }

  Future<void> _getdata() async {
    try {
      final response =
      await http.get(Uri.parse('http://192.168.0.158/task_10/read.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
          _isloading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _deleteData(String nisn) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.158/task_10/delete.php'),
        body: {
          'nisn': nisn,
        },
      );

      if (response.statusCode == 200) {
        // Jika berhasil, tampilkan pesan sukses dan perbarui UI atau kembali ke halaman sebelumnya
        Navigator.pop(context); // Tutup dialog
        _getdata(); // Refresh data

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Data berhasil dihapus")),
        );
      } else {
        // Jika gagal, tampilkan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menghapus data")),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan saat menghapus data")),
      );
    }
  }


  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Siswa"),
        actions: [
          GestureDetector(
            onTap: () => logout(),
            child: Icon(Icons.logout),
          ),
        ],
      ),
      body: _isloading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _listdata.length,
        itemBuilder: ((context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPage(
                      ListData: {
                        "id": _listdata[index]['id'],
                        "nisn": _listdata[index]['nisn'],
                        "nama": _listdata[index]['nama'],
                        "alamat": _listdata[index]['alamat'],
                        "gambar": _listdata[index]['gambar'],
                      },
                    ),
                  ),
                );
              },
              child: ListTile(
                title: Text(_listdata[index]['nama']),
                subtitle: Text(_listdata[index]['alamat']),
                leading: Image.network(
                  "${Api.imageUrl}${_listdata[index]['gambar']}", // Replace with actual field name
                  width: 50, // Adjust size as needed
                  height: 50,
                ),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          content: Text("Anda yakin ingin menghapus data?"),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                _deleteData(_listdata[index]['nisn'].toString());
                              },
                              child: Text("Hapus"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Batal"),
                            ),
                          ],
                        );
                      }),
                    );
                  },
                  icon: Icon(Icons.delete),
                ),
              ),
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
