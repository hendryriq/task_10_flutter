
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:task_10/home_page.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nisn = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();
  File? imageFile;

  final ImagePicker _picker = ImagePicker();

  Future pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future _simpan() async {
    var uri = Uri.parse('http://192.168.0.158/task_10/create.php');
    var request = http.MultipartRequest('POST', uri)
      ..fields['nisn'] = nisn.text
      ..fields['nama'] = nama.text
      ..fields['alamat'] = alamat.text;

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('gambar', imageFile!.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      // Success
      return true;
    } else {
      // Error
      return false;
    }
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
                // Tombol untuk memilih gambar
                ElevatedButton(
                  onPressed: pickImage,
                  child: Text("Pilih Gambar"),
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
