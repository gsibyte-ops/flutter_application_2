import 'package:flutter/material.dart';

// Membuat struktur halaman menggunakan StatefulWidget.
// Pakai StatefulWidget (bukan StatelessWidget) karena halaman ini sifatnya dinamis.
// Tampilannya bisa berubah-ubah saat user berinteraksi, contohnya saat munculin teks error merah,
// milih opsi dropdown, atau menekan tombol tampilkan/sembunyikan password.
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

// Tempat kita menyimpan semua variabel dan logika.
class _RegistrationPageState extends State<RegistrationPage> {
  // Membuat kunci unik (GlobalKey) untuk membungkus form.
  // Kunci ibarat "mandor" yang nanti dipakai buat ngecek apakah semua inputan di dalam form sudah diisi (valid).
  final _formKey = GlobalKey<FormState>();
  
  // Variabel untuk mengontrol password. True = password disensor (titik-titik).
  bool _isPasswordHidden = true;
  
  // Variabel untuk menyimpan data pilihan gender dari dropdown.
  // Ada tanda (?) yang artinya nilai awalnya boleh kosong (null).
  String? _selectedGender;
  
  // Controller khusus untuk kolom Tanggal Lahir.
  // Fungsinya menangkap, membaca, dan mengubah teks di dalam kolom tersebut via kode.
  final TextEditingController _dobController = TextEditingController();

  // Fungsi asynchronous untuk menampilkan kalender (Date Picker).
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
        
        // Form membungkus semua inputan. Terhubung dengan _formKey (si mandor) yang dibuat di atas.
        child: Form(
          key: _formKey,
          // Column dipakai untuk menyusun elemen UI secara vertikal (berbaris dari atas ke bawah).
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Bikin semua tombol/inputan melebar mentok ke kanan-kiri.
            children: [
              
              // 1. Kolom Input Nama Lengkap
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Contoh: Gabriel Putra',
                  border: OutlineInputBorder(),
                ),
                // VALIDASI: Mengecek apakah kolom ini diisi. Jika kosong, return teks error merah.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null; // return null artinya aman (valid)
                },
              ),
              const SizedBox(height: 16),
              
              // 2. Kolom Input Username
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Contoh: gabriel_p',
                  border: OutlineInputBorder(),
                ),
                // VALIDASI USERNAME
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Kolom Input Email
              TextFormField(
                keyboardType: TextInputType.emailAddress, 
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Contoh: email@domain.com',
                  border: OutlineInputBorder(),
                ),
                // VALIDASI EMAIL (Bisa dikembangin lagi buat ngecek format ada @ nya)
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  } else if (!value.contains('@')) {
                    return 'Format email tidak valid (harus pakai @)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 4. Kolom Input Nomor HP
              TextFormField(
                keyboardType: TextInputType.phone, 
                decoration: const InputDecoration(
                  labelText: 'No HP',
                  hintText: 'Contoh: 081234567890',
                  border: OutlineInputBorder(),
                ),
                // VALIDASI NO HP
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor HP tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 5. Kolom Pilihan Gender (Dropdown)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: ['Laki-laki', 'Perempuan'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                // VALIDASI GENDER (ngecek apakah user udah milih dari opsi)
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih gender terlebih dahulu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 6. Kolom Input Tanggal Lahir
              TextFormField(
                controller: _dobController,
                readOnly: true, 
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir',
                  hintText: 'Pilih Tanggal',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_month), 
                ),
                onTap: () => _selectDate(context), 
                // VALIDASI TANGGAL LAHIR
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal lahir wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 7. Kolom Input Alamat
              TextFormField(
                maxLines: 3, 
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  hintText: 'Contoh: Jl. Mastrip, Jember',
                  border: OutlineInputBorder(),
                ),
                // VALIDASI ALAMAT
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 8. Kolom Input Password
              TextFormField(
                obscureText: _isPasswordHidden, 
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordHidden = !_isPasswordHidden;
                      });
                    },
                  ),
                ),
                // VALIDASI PASSWORD (Minimal 6 karakter)
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  } else if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // 9. Tombol Submit 
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16), 
                ),
                onPressed: () {
                  // LOGIKA VALIDASI SEBELUM SUBMIT
                  // _formKey.currentState!.validate() akan memicu semua 'validator' di atas.
                  // Jika ada satu saja yang return error (bukan null), maka nilainya false.
                  if (_formKey.currentState!.validate()) {
                    // Jika lolos semua validasi, munculkan notifikasi hijau
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mantap! Data registrasi berhasil disubmit.'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    // Jika ada kolom kosong, munculkan notifikasi merah
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gagal! Tolong lengkapi semua kolom yang wajib diisi.'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Submit', 
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