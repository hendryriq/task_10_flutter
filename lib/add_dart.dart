import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_10/home_page.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({super.key});

  @override
  State<AddDataPage> createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nisn = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();

  Future _simpan() async{
    final response = await http.post(
      Uri.parse('http://192.168.0.158/task_10/create.php'),
      body: {
        "nisn" : nisn.text,
        "nama" : nama.text,
        "alamat" : alamat.text,
      }
    );
    if(response.statusCode == 200){
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Container(
            child: Column(
              children: [
                TextFormField(
                  controller: nisn,
                  decoration: InputDecoration(
                    hintText: "NISN",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                    )
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "NISN tidak boleh kosong";
                    }
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: nama,
                  decoration: InputDecoration(
                      hintText: "Nama",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Nama tidak boleh kosong";
                    }
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: alamat,
                  decoration: InputDecoration(
                      hintText: "Alamat",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Alamat tidak boleh kosong";
                    }
                  },
                ),
                SizedBox(height: 15),
                MaterialButton(
                  minWidth: double.infinity,
                    color: Colors.blue,
                    onPressed: (){
                    if(formKey.currentState!.validate()){
                      _simpan().then((value){
                        if(value){
                          final snackBar= SnackBar(content: const Text("Data berhasil disimpan"),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }else{
                          final snackBar = SnackBar(content: const Text("Data berhasil disimpan"),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: ((context) => HomePage())),(route) => false);
                    }
                    },child: Text("Simpan"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
