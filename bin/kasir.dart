
import 'dart:io';

void main() {
  // Katalog produk toko oleh-oleh
  final Map<String, ({String nama, String kategori, int harga})> katalog = {
    'P01': (
      nama: 'Kopi Sidikalang 250 g',
      kategori: 'Kopi',
      harga: 45000,
    ),
    'P02': (
      nama: 'Kopi Gayo 250 g',
      kategori: 'Kopi',
      harga: 55000,
    ),
    'P03': (
      nama: 'Teh Kayu Aro 100 g',
      kategori: 'Teh',
      harga: 25000,
    ),
    'P04': (
      nama: 'Gula Aren 500 g',
      kategori: 'Pemanis',
      harga: 30000,
    ),
    'P05': (
      nama: 'Bolu Meranti',
      kategori: 'Makanan',
      harga: 80000,
    ),
  };

  // Menampilkan katalog
  print('====================================================');
  print('             KASIR TOKO OLEH-OLEH MEDAN');
  print('====================================================');
  print('KODE   NAMA PRODUK                    HARGA');
  print('----------------------------------------------------');

  katalog.forEach((kode, produk) {
    print(
      '${kode.padRight(7)}'
      '${produk.nama.padRight(32)}'
      'Rp ${produk.harga}',
    );
  });

  print('====================================================');

  // Input pesanan pelanggan
  stdout.write('Masukkan pesanan (contoh: P01x2, P03x1): ');
  final String input = stdin.readLineSync() ?? '';

  // Menyimpan pesanan valid dan ditolak
  final List<({
    String kode,
    String nama,
    String kategori,
    int harga,
    int jumlah,
  })> keranjang = [];

  final List<String> pesananDitolak = [];

  // Memproses setiap pesanan
  for (final pesanan in input.split(',')) {
    final bagian = pesanan.trim().split(
      RegExp(r'\s*[xX]\s*'),
    );

    if (bagian.length != 2) {
      pesananDitolak.add(pesanan.trim());
      continue;
    }

    final String kode = bagian[0].trim().toUpperCase();
    final int? jumlah = int.tryParse(bagian[1].trim());

    if (jumlah == null || jumlah <= 0) {
      pesananDitolak.add(pesanan.trim());
      continue;
    }

    final produk = katalog[kode];

    if (produk == null) {
      pesananDitolak.add(pesanan.trim());
      continue;
    }

    keranjang.add((
      kode: kode,
      nama: produk.nama,
      kategori: produk.kategori,
      harga: produk.harga,
      jumlah: jumlah,
    ));
  }

  // Menghitung subtotal setiap produk menggunakan map
  final List<int> daftarSubtotal = keranjang
      .map((item) => item.harga * item.jumlah)
      .toList();

  // Menghitung total belanja menggunakan fold
  final int total = daftarSubtotal.fold(
    0,
    (jumlah, subtotal) => jumlah + subtotal,
  );

  // Menghitung diskon 10%
  final int diskon = total >= 100000 ? (total * 0.10).round() : 0;

  final int totalBayar = total - diskon;

  // Mengumpulkan kategori menggunakan Set
  final Set<String> kategoriDibeli = keranjang
      .map((item) => item.kategori)
      .toSet();

  // Menampilkan struk
  print('\n');
  print('====================================================');
  print('                    STRUK BELANJA');
  print('====================================================');

  if (keranjang.isEmpty) {
    print('Tidak ada pesanan yang valid.');
  } else {
    for (int i = 0; i < keranjang.length; i++) {
      final item = keranjang[i];

      print(item.nama);
      print(
        '  ${item.jumlah} x Rp ${item.harga} = Rp ${daftarSubtotal[i]}',
      );
    }

    print('----------------------------------------------------');
    print('Total Belanja : Rp $total');
    print('Diskon        : Rp $diskon');
    print('Total Bayar   : Rp $totalBayar');
    print('Kategori      : ${kategoriDibeli.join(', ')}');
  }

  // Menampilkan pesanan yang ditolak
  if (pesananDitolak.isNotEmpty) {
    print('\nPesanan Ditolak:');

    for (final item in pesananDitolak) {
      print('- $item');
    }
  }

  print('====================================================');
  print('             TERIMA KASIH TELAH BERBELANJA');
  print('====================================================');
}
