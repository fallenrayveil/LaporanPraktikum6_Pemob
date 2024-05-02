import 'dart:convert';
void main() {
  // json untuk transkrip mahasiswa
  String jsonString = 
  '''{
    "mahasiswa": { "nama": "Finn Rayveil", "npm": "2108201000", "semester": 2 },
    "matakuliah": 
    [
      { "kode": "UV21001", "nama": "Agama Islam", "sks": 2, "nilai": "A" },
      { "kode": "UV21010", "nama": "Bahasa Inggris", "sks": 3, "nilai": "A" },
      { "kode": "SI211107", "nama": "Basis Data", "sks": 3, "nilai": "A" },
      { "kode": "SI211109", "nama": "Matematika Komputasi", "sks": 3, "nilai": "B+"},
      { "kode": "SI211112", "nama": "Sistem Informasi Manajemen", "sks": 3, "nilai": "B+" },
      { "kode": "SI211108", "nama": "Analisis Proses Bisnis", "sks": 3, "nilai": "A" },
      { "kode": "SI211106", "nama": "Bahasa Pemrograman 2", "sks": 3, "nilai": "A-" },
      { "kode": "UV21008", "nama": "Kewarganegaraan", "sks": 2, "nilai": "A-" }
    ]
  }''';

  // mendecode json ke dalam map
  Map transkrip = jsonDecode(jsonString);

  // menghitung total sks dan total nilai transkrip
  double totalSks = 0;
  double totalNilai = 0;

  // mengiterasi setiap mata kuliah
  for (Map<String, dynamic> matkul in transkrip['matakuliah']) {
    // get sks dan nilai
    double sks = matkul['sks'];
    double nilai = getNilai(matkul['nilai']);
    // menghitung total sks dan total nilai
    totalSks += sks;
    totalNilai += sks * nilai;
  }

  // menghitung ipk mahasiswa
  double ipk = totalNilai / totalSks;

  // mencetak hasil
  print("Nama: ${transkrip['mahasiswa']['nama']}");
  print("NPM: ${transkrip['mahasiswa']['npm']}");
  print("Semester: ${transkrip['mahasiswa']['semester']}");
  print("IPK: ${ipk.toStringAsFixed(2)}"); // membulatkan 2 angka di belakang koma
}

// sebagai fungsi untuk mendapatkan nilai angka dari nilai huruf
double getNilai(String nilaiHuruf) {
  switch (nilaiHuruf) {
    case "A":
      return 4.0;
    case "A-":
      return 3.75;
    case "B+":
      return 3.25;
    case "B":
      return 3.0;
    case "B-":
      return 2.75;
    case "C+":
      return 2.25;
    case "C":
      return 2.0;
    case "D+":
      return 1.75;
    case "D":
      return 1.5;
    case "E":
      return 0.0;
    default:
      return 0.0;
  }
}
