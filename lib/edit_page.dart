import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_10/home_page.dart';

class EditPage extends StatefulWidget {
  final Map ListData;
  EditPage({Key? key, required this.ListData}): super (key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController id = TextEditingController();
  TextEditingController nisn = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();

  Future _update() async{
    final response = await http.post(
        Uri.parse('http://192.168.0.158/task_10/edit.php'),
        body: {
          "id" : id.text,
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
  void initState() {
    super.initState();
    id.text = widget.ListData['id']?.toString() ?? "";
    nisn.text = widget.ListData['nisn']?.toString() ?? "";
    nama.text = widget.ListData['nama']?.toString() ?? "";
    alamat.text = widget.ListData['alamat']?.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Page"),
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
                      borderRadius: BorderRadius.circular(5),
                    ),
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
                      borderRadius: BorderRadius.circular(5),
                    ),
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
                      borderRadius: BorderRadius.circular(5),
                    ),
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
                      _update().then((value){
                        final snackBar = SnackBar(
                          content: Text(value
                              ? "Data berhasil diupdate"
                              : "Gagal mengupdate data"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        if (value) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                                (route) => false,
                          );
                        }
                      });
                    }
                  },
                  child: Text("Update"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
