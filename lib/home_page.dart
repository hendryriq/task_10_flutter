import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_10/add_dart.dart';
import 'package:task_10/edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  List _listdata =[];
  bool _isloading = true;

  Future _getdata() async{
    try{
      final response = await http.get(Uri.parse('http://192.168.0.158/task_10/read.php'));
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
          _isloading= false;
        });
      }
    }catch(e){
      print(e);
    }
  }

  Future _hapus(String id) async{
    try{
      final response = await http.post(Uri.parse('http://192.168.0.158/task_10/delete.php'),
      body: {
        "nisn":id,
      });
      if(response.statusCode == 200){
        return true;
      }return false;
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _getdata();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Siswa"),
      ),
      body: _isloading ? Center(
        child: CircularProgressIndicator(),
      ): ListView.builder(
          itemCount: _listdata.length,
          itemBuilder: ((context, index){
            return Card(
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(
                    ListData: {
                      "id" : _listdata[index]['id'],
                      "nisn" : _listdata[index]['nisn'],
                      "nama" : _listdata[index]['nama'],
                      "alamat" : _listdata[index]['alamat'],
                    },
                  )));
                },
                child: ListTile(
                  title: Text(_listdata[index]['nama']),
                  subtitle: Text(_listdata[index]['alamat']),
                  trailing: 
                  IconButton(
                    onPressed: (){
                      showDialog(context: context,
                          builder: ((context){
                            return AlertDialog(
                              content: Text("Ada yakin ingin menghapus data?"),
                              actions: [
                                ElevatedButton(onPressed: (){
                                  _hapus(_listdata[index]['nisn'])
                                  .then((value) {
                                    if(value){
                                      final snackBar= SnackBar(content: const Text("Data berhasil dihapus"),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }else{
                                      final snackBar = SnackBar(content: const Text("Data gagal dihapus"),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                          builder: ((context) => HomePage())),(route) => false);
                                    }
                                  });
                                }, child: Text("Hapus")),
                                ElevatedButton(onPressed: (){
                                  Navigator.pop(context);
                                }, child: Text("Batal"))
                              ],
                            );
                          }));
                    }, icon: Icon(Icons.delete),
                  ),
                ),
              ),
            );
          })),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddDataPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
