import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart'; 

void main() {
  runApp(MyApp());
}

class Universitas {
  String nama; // atribut
  String website; // atribut

  Universitas({required this.nama, required this.website}); // constructor
}

class DaftarUniversitas {
  List<Universitas> universitas = [];

  // mengambil data dari json
  DaftarUniversitas.fromJson(List<dynamic> json) { 
    universitas = json.map((uni) { 
      return Universitas(
        nama: uni['name'], // mengambil nama universitas
        website: uni['web_pages'][0], // mengambil situs web pertama dari daftar
      );
    }).toList();
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  late Future<DaftarUniversitas> futureUniversitas; // menampung hasil

  // api yang sesuai dengan modul
  String url = "http://universities.hipolabs.com/search?country=Indonesia";

  Future<DaftarUniversitas> fetchData() async { // fetch data
    final response = await http.get(Uri.parse(url)); // mengambil data dari url

    if (response.statusCode == 200) {
      // jika server mengembalikan 200 OK (berhasil), parse json
      return DaftarUniversitas.fromJson(jsonDecode(response.body));
    } else {
      // jika gagal (bukan  200 OK), lempar exception
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureUniversitas = fetchData(); // fetch data
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Universitas',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Universitas'),
        ),
        body: Center(
          child: FutureBuilder<DaftarUniversitas>(
            future: futureUniversitas,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.universitas.length, // berisikan jumlah data
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        if (await canLaunch(snapshot.data!.universitas[index].website)) { // mengecek apakah bisa membuka situs web
                          await launch(snapshot.data!.universitas[index].website); // membuka situs web
                        } else {
                          throw 'Tidak bisa membuka ${snapshot.data!.universitas[index].website}'; // jika tidak bisa membuka situs web
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.universitas[index].nama,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              snapshot.data!.universitas[index].website, // menampilkan situs web
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // menampilkan loading spinner by default
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
