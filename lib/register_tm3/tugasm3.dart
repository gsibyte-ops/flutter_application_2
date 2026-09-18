import 'package:flutter/material.dart';

// Membuat struktur halaman menggunakan StatefulWidget.
// Pakai StatefulWidget (bukan StatelessWidget) karena halaman ini sifatnya dinamis.
// Tampilannya bisa berubah-ubah saat user berinteraksi, contohnya saat ngetik teks,
// milih opsi dropdown, atau menekan tombol tampilkan/sembunyikan password.
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

// Tempat kita menyimpan semua variabel dan logika.
class _RegistrationPageState extends State<RegistrationPage> {
  // Membuat kunci unik (GlobalKey) untuk membungkus form.
  // Kunci ini nanti dipakai buat mengecek apakah semua inputan sudah valid/terisi.
  final _formKey = GlobalKey<FormState>();
  
  // Variabel untuk mengontrol password. True sembunyi.
  bool _isPasswordHidden = true;
  
  // Variabel untuk menyimpan data pilihan gender dari dropdown.
  // (?) boleh kosong (null).
  String? _selectedGender;
  
  // Controller khusus untuk kolom Tanggal Lahir.
  // menangkap, membaca, dan mengubah teks di dalam kolom tersebut via kode.
  final TextEditingController _dobController = TextEditingController();

  // asynchronous untuk menampilkan kalender (Date Picker).
  // Dipanggil saat user mengklik kolom tanggal lahir.
  Future<void> _selectDate(BuildContext context) async {
    // Memunculkan dialog kalender bawaan Flutter dan menunggu user memilih tanggal.
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Tanggal default saat kalender dibuka (hari ini)
      firstDate: DateTime(1900), // Batas tahun paling mundur yang bisa dipilih
      lastDate: DateTime.now(),  // Batas tahun paling maju (tidak bisa pilih tanggal besok)
    );
    
    // Mengecek apakah user benar-benar memilih tanggal (tidak menekan tombol cancel).
    if (picked != null) {
      // setState memberitahu sistem untuk merender ulang tampilan karena ada data yang berubah.
      setState(() {
        // Mengubah isi teks di dalam _dobController menjadi format "tanggal/bulan/tahun".
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // Fungsi dispose dipanggil otomatis saat halaman ini ditutup/dihancurkan.
  @override
  void dispose() {
    // Kita wajib menghapus (dispose) controller yang udah ga dipakai
    // biar memori HP ga bocor (mencegah memory leak) dan aplikasi ga lemot.
    _dobController.dispose();
    super.dispose();
  }

  // Fungsi build adalah bagian yang merender elemen visual (UI) ke layar HP.
  @override
  Widget build(BuildContext context) {
    // Scaffold adalah kanvas putih dasar untuk membangun halaman.
    // Menyediakan struktur rapi seperti AppBar (header) dan Body (isi utama).
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi'), // Judul di bagian atas layar
      ),
      // Membungkus seluruh isi form dengan SingleChildScrollView.
      // Ini krusial biar layarnya bisa di-scroll ke bawah dan ga muncul error layar tertabrak keyboard (overflow).
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(16.0), // Memberi jarak tepi (margin dalam) 16 pixel di semua sisi.
        
        // Form membungkus semua inputan. Terhubung dengan _formKey yang dibuat di atas.
        child: Form(
          key: _formKey,
          // Column dipakai untuk menyusun elemen UI secara vertikal (berbaris dari atas ke bawah).
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Bikin semua tombol/inputan melebar mentok ke kanan-kiri.
            children: [
              
              // 1. Kolom Input Nama Lengkap
              // TextFormField adalah widget kotak teks standar.
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap', // Label kecil di atas kotak
                  hintText: 'Contoh: Gabriel Putra', // Teks contoh transparan di dalam kotak
                  border: OutlineInputBorder(), // Bikin gaya kotaknya ada garis pinggirnya yang tegas
                ),
              ),
              const SizedBox(height: 16), // SizedBox dipakai untuk memberi jarak (spasi) vertikal antar elemen.
              
              // 2. Kolom Input Username
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Contoh: gabriel_p',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Kolom Input Email
              TextFormField(
                keyboardType: TextInputType.emailAddress, // Memunculkan keyboard khusus email (ada tombol @-nya).
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Contoh: email@domain.com',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 4. Kolom Input Nomor HP
              TextFormField(
                keyboardType: TextInputType.phone, // Memunculkan keyboard khusus angka/nomor telepon.
                decoration: const InputDecoration(
                  labelText: 'No HP',
                  hintText: 'Contoh: 081234567890',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 5. Kolom Pilihan Gender (Dropdown)
              // Menggunakan DropdownButtonFormField agar terintegrasi dengan validasi Form.
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                // items bertugas memetakan list berisi 'Laki-laki' dan 'Perempuan' menjadi menu dropdown.
                items: ['Laki-laki', 'Perempuan'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                // onChanged dipanggil ketika user memilih opsi baru.
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue; // Menyimpan data pilihan ke dalam variabel _selectedGender.
                  });
                },
              ),
              const SizedBox(height: 16),

              // 6. Kolom Input Tanggal Lahir
              TextFormField(
                controller: _dobController, // Mengikat kolom ini ke controller tanggal lahir.
                readOnly: true, // Memblokir keyboard agar user tidak bisa mengetik manual, harus lewat kalender.
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir',
                  hintText: 'Pilih Tanggal',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_month), // Menambahkan ikon kalender di ujung kanan kolom.
                ),
                // onTap dipanggil saat kolom ini diklik, langsung memicu fungsi _selectDate memunculkan kalender.
                onTap: () => _selectDate(context), 
              ),
              const SizedBox(height: 16),

              // 7. Kolom Input Alamat
              TextFormField(
                maxLines: 3, // Bikin tinggi kotaknya bisa menampung 3 baris tulisan.
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  hintText: 'Contoh: Jl. Mastrip, Jember',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 8. Kolom Input Password
              TextFormField(
                obscureText: _isPasswordHidden, // Logika keamanan: Jika true, teks disensor.
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  // suffixIcon disini berisi IconButton (tombol ikon) yang bisa diklik.
                  suffixIcon: IconButton(
                    // Ikon akan berubah antara mata terbuka / tercoret tergantung status _isPasswordHidden.
                    icon: Icon(
                      _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      // setState mengubah status tersembunyi menjadi sebaliknya (toggle).
                      setState(() {
                        _isPasswordHidden = !_isPasswordHidden;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24), // Jarak yang lebih lebar sebelum tombol submit.

              // 9. Tombol Submit = ElevatedButton
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16), // Melebarkan ruang di dalam tombol biar lebih enak diklik.
                ),
                onPressed: () {
                  // Aksi yang dijalankan saat tombol diklik.
                  // ScaffoldMessenger bertugas memunculkan SnackBar (pop-up kecil) dari bagian bawah layar HP.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mantap! Data registrasi berhasil disubmit.'), // Teks pesan
                      backgroundColor: Colors.green, // Warna latar belakang pop-up
                      duration: Duration(seconds: 3), // Pop-up akan hilang otomatis setelah 3 detik
                    ),
                  );
                },
                child: const Text(
                  'Submit', // Tulisan di dalam tombol
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}