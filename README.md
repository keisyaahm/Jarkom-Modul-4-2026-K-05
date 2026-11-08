# JARKOM MODUL 4 K-05

## Subnetting dan Routing: VLSM dan CIDR

## Anggota Kelompok

| Nama | NRP | Tugas |
|---|---|---|
| Ronnin Raditya Putra Purbono | 5027251119 | VLSM Cisco Packet Tracer |
| Keisya Halimah Mulia | 5027251068 | CIDR GNS3 |

## Link Spreadsheet

- [Spreadsheet subnetting dan routing](https://docs.google.com/spreadsheets/d/1tnrkMIINtIfA9lkkEz2IxHoiGxdWwslZ/edit?usp=sharing&ouid=105300267501229657358&rtpof=true&sd=true)

## Ringkasan Implementasi

Dokumentasi ini mencakup dua implementasi praktikum:

- **CIDR GNS3**: 25 subnet, 13 router, 25 client, dan 1 NAT1 sehingga terdapat 39 perangkat.
- **VLSM Cisco Packet Tracer**: alokasi alamat berdasarkan kebutuhan host dan routing OSPF.

Pada CIDR GNS3 terdapat 38 script konfigurasi, yaitu 13 script router dan 25 script client. NAT1 merupakan node eksternal GNS3 sehingga tidak memiliki script konfigurasi.

## Daftar Isi

### A. CIDR GNS3

1. [Tujuan dan Topologi GNS3](#1-tujuan-dan-topologi-gns3)
2. [Menentukan 25 Subnet dari Topologi](#2-menentukan-25-subnet-dari-topologi)
3. [Menghitung Kebutuhan Host](#3-menghitung-kebutuhan-host)
4. [Menentukan Prefix dan Block Size](#4-menentukan-prefix-dan-block-size)
5. [Tabel Pembagian Subnet A1-A25](#5-tabel-pembagian-subnet-a1-a25)
6. [Penggabungan CIDR](#6-penggabungan-cidr)
7. [Tree CIDR](#7-tree-cidr)
8. [Pembagian Network ID, Broadcast, dan Range IP](#8-pembagian-network-id-broadcast-dan-range-ip)
9. [Konfigurasi Router dan Client](#9-konfigurasi-router-dan-client)
10. [Static Routing dan NAT](#10-static-routing-dan-nat)
11. [Testing Konektivitas](#11-testing-konektivitas)
12. [Kesimpulan CIDR](#12-kesimpulan-cidr)

### B. VLSM Cisco Packet Tracer

13. [Topologi VLSM](#13-topologi-vlsm)
14. [Perhitungan VLSM](#14-perhitungan-vlsm)
15. [Tabel Pembagian IP VLSM](#15-tabel-pembagian-ip-vlsm)
16. [Konfigurasi Router dan Client VLSM](#16-konfigurasi-router-dan-client-vlsm)
17. [Testing VLSM](#17-testing-vlsm)
18. [Kesimpulan VLSM](#18-kesimpulan-vlsm)


## 1. Tujuan dan Topologi GNS3

Pada praktikum ini kami melakukan subnetting dan routing menggunakan VLSM pada Cisco Packet Tracer serta CIDR dan route summarization pada GNS3.

Pada GNS3, kami membaca topologi untuk mengidentifikasi setiap segmen jaringan sebelum menentukan alamat IP. Satu LAN client, satu link langsung antar-router, dan satu jaringan bersama dihitung sebagai satu subnet.

![Topologi GNS3](Assets/cidr-gns3/topologi-gns3.png)


## 2. Menentukan 25 Subnet dari Topologi

Jumlah 25 subnet diperoleh dari jumlah segmen jaringan pada topologi, bukan dari hasil penggabungan CIDR.

Terdapat 15 LAN client, 9 link langsung antar-router, dan 1 jaringan bersama antara Wired, Psyche, Copland, dan Schumann. Dengan demikian:

`15 + 9 + 1 = 25 subnet`

| Jenis jaringan | Subnet | Jumlah |
|---|---|---:|
| LAN client | A1, A6-A9, A11, A13, A15, A17, A19-A23, A25 | 15 |
| Link antar-router | A2, A3, A4, A10, A12, A14, A16, A18, A24 | 9 |
| LAN bersama | A5 | 1 |
| **Total** | **A1-A25** | **25** |

![Topologi GNS3 dengan pembagian subnet A1-A25](Assets/cidr-gns3/subnet1.png)


## 3. Menghitung Kebutuhan Host

Kami menghitung kebutuhan usable IP berdasarkan jumlah perangkat pada setiap segmen. Rumus yang digunakan adalah:

`2^h - 2 >= jumlah host`

`h` adalah jumlah bit host. Dua alamat dikurangi karena satu alamat digunakan sebagai network ID dan satu alamat digunakan sebagai broadcast.

### Contoh A1

Pada A1, JJ membutuhkan 95 host dan MyuMyu membutuhkan 30 host. Kami juga menyediakan satu alamat untuk gateway Cyberia:

`95 + 30 + 1 gateway = 126 IP usable`

Usable IP berbeda dengan block size. Pada A1, `/25` menyediakan 128 alamat total, sehingga 128 - 2 = 126 usable IP.


## 4. Menentukan Prefix dan Block Size

Setelah kebutuhan usable IP diketahui, kami menentukan jumlah bit host dan prefix dengan rumus `prefix = 32 - h`.

| Kebutuhan usable IP | Perhitungan | Prefix | Block size |
|---:|---:|---:|---:|
| 2 | 2^2 - 2 = 2 | /30 | 4 |
| 6 | 2^3 - 2 = 6 | /29 | 8 |
| 30 | 2^5 - 2 = 30 | /27 | 32 |
| 62 | 2^6 - 2 = 62 | /26 | 64 |
| 126 | 2^7 - 2 = 126 | /25 | 128 |
| 254 | 2^8 - 2 = 254 | /24 | 256 |
| 1.022 | 2^10 - 2 = 1.022 | /22 | 1.024 |

A1 menggunakan `10.66.24.0/25`:

- Network ID: `10.66.24.0`
- Usable IP: `10.66.24.1-10.66.24.126`
- Broadcast: `10.66.24.127`

### Perbedaan usable IP dan block size

Usable IP adalah alamat yang dapat dipakai perangkat, sedangkan block size
adalah seluruh alamat dalam blok, termasuk Network ID dan broadcast.

| Prefix | Block size | Usable IP |
|---|---:|---:|
| `/25` | 128 | 126 |
| `/26` | 64 | 62 |
| `/30` | 4 | 2 |

VLSM digunakan untuk mengalokasikan alamat berdasarkan kebutuhan host, dengan
subnet terbesar ditempatkan lebih dahulu. CIDR digunakan untuk menggabungkan
subnet contiguous yang memiliki jalur routing sama menjadi summary route.


## 5. Tabel Pembagian Subnet A1-A25

Kami mencatat kebutuhan, prefix, kapasitas usable, dan block size setiap subnet pada spreadsheet tab Rute.

| Subnet | Kebutuhan usable IP | Prefix dipilih | Available | Block size |
|---|---:|---:|---:|---:|
| A1 | 126 | /25 | 126 | 128 |
| A13 | 33 | /26 | 62 | 64 |
| A20 | 881 | /22 | 1.022 | 1.024 |
| A25 | 514 | /22 | 1.022 | 1.024 |


## 6. Penggabungan CIDR

Setelah subnet A1-A25 ditentukan, kami menggabungkan subnet berdasarkan wilayah topologi dan jalur routing yang sama. Penggabungan menggunakan block size, bukan jumlah usable IP.

Tahapan awal penggabungan adalah:

- A4 + A10 -> B1
- A12 + A14 -> B2
- A16 + A18 -> B3

Setiap pasangan `/30` memiliki 4 + 4 = 8 alamat, sehingga summary-nya menjadi `/29`. Summary berikutnya digabung lagi secara bertahap sampai membentuk B11, C3, D6, E1, F1, F2, dan F3.

| Summary | Gabungan | Hasil |
|---|---|---:|
| B11 | A9 dan jaringan Tachibana-Shibuya | /22 |
| C3 | Jaringan cabang Navi | /22 |
| D6 | Schumann, Copland, Psyche, dan Accela | /20 |
| E1 | A1 dan A2 | /24 |
| F1 | B11 dan C3 | /21 |
| F2 | F1 dan E1 | /20 |
| F3 | D6 dan F2 | /19 |

Penggabungan terakhir adalah `D6 /20 + F2 /20`: 4.096 + 4.096 = 8.192 alamat. Karena 8.192 alamat setara dengan `/19`, hasil akhirnya adalah `F3 = 10.66.0.0/19`.

Pengelompokan wilayahnya adalah:

- `B1-B11`: cabang Tachibana sampai Shibuya
- `C1-C3`: cabang Navi
- `D1-D6`: Schumann, Copland, Psyche, dan Accela
- `E1`: cabang Cyberia
- `F1-F3`: penggabungan seluruh wilayah

Spreadsheet Penggabungan CIDR menunjukkan proses bottom-up, yaitu subnet
A1-A25 digabung sampai F3 `/19`. Sebaliknya, tree CIDR menunjukkan proses
top-down dari `10.66.0.0/19` sampai subnet A1-A25.

### Bukti spreadsheet penggabungan CIDR

1. **Bukti tab Penggabungan CIDR**

![Bukti tab Penggabungan CIDR](Assets/cidr-gns3/gabungCIDR.png)

2. **Bukti lanjutan tab Penggabungan CIDR**

![Bukti lanjutan tab Penggabungan CIDR](Assets/cidr-gns3/gabungCIDR2.png)


## 7. Tree CIDR

Tree CIDR menunjukkan pembagian alamat secara top-down. Root tree adalah `10.66.0.0/19`, yang dibagi menjadi `10.66.0.0/20` dan `10.66.16.0/20`. Diagram berikut memperlihatkan pembagian blok induk sampai subnet A1-A25.

![Tree CIDR](Assets/cidr-gns3/subnet2.png)

<div style="overflow:auto; resize:both; width:100%; min-height:420px; border:1px solid #ccc; padding:8px;">

```mermaid
%%{init: {"flowchart": {"htmlLabels": true, "nodeWidth": 240, "padding": 18, "nodeSpacing": 30, "rankSpacing": 45, "curve": "basis"}}}%%
flowchart TD
    R["10.66.0.0/19"]

    R --> B0["10.66.0.0/20"]
    R --> B16["10.66.16.0/20"]

    B0 --> C0["10.66.0.0/21"]
    B0 --> C8["10.66.8.0/21"]

    C0 --> D0["10.66.0.0/22"]
    C0 --> A20["A20 - 10.66.4.0/22"]

    C8 --> A25["A25 - 10.66.8.0/22"]

    D0 --> E0["10.66.0.0/23"]
    D0 --> A21["A21 - 10.66.2.0/23"]

    E0 --> F0["10.66.0.0/24"]
    F0 --> G0["10.66.0.0/25"]

    G0 --> H0["10.66.0.0/26"]
    G0 --> A22["A22 - 10.66.0.64/26"]

    H0 --> I0["10.66.0.0/27"]

    I0 --> J0["10.66.0.0/28"]
    I0 --> J16["10.66.0.16/28"]

    J0 --> A23["A23 - 10.66.0.0/29"]
    J0 --> K8["10.66.0.8/29"]

    K8 --> A24["A24 - 10.66.0.8/30"]
    J16 --> A5["A5 - 10.66.0.16/29"]

    B16 --> C16["10.66.16.0/21"]
    B16 --> C24["10.66.24.0/21"]

    C16 --> D16["10.66.16.0/22"]
    C16 --> D20["10.66.20.0/22"]

    D16 --> A9["A9 - 10.66.16.0/23"]
    D16 --> E18["10.66.18.0/23"]

    E18 --> F18["10.66.18.0/24"]
    E18 --> F19["10.66.19.0/24"]

    F18 --> G18["10.66.18.0/25"]
    F18 --> A11["A11 - 10.66.18.128/25"]

    G18 --> H18["10.66.18.0/26"]
    G18 --> A13["A13 - 10.66.18.64/26"]

    H18 --> I18["10.66.18.0/27"]
    H18 --> A17["A17 - 10.66.18.32/27"]

    I18 --> J18["10.66.18.0/28"]
    I18 --> J18B["10.66.18.16/28"]

    J18 --> K18["10.66.18.0/29"]
    J18 --> K18B["10.66.18.8/29"]

    K18 --> A4["A4 - 10.66.18.0/30"]
    K18 --> A10["A10 - 10.66.18.4/30"]

    K18B --> A12["A12 - 10.66.18.8/30"]
    K18B --> A14["A14 - 10.66.18.12/30"]

    J18B --> K18C["10.66.18.16/29"]
    J18B --> A15["A15 - 10.66.18.24/29"]

    K18C --> A16["A16 - 10.66.18.16/30"]
    K18C --> A18["A18 - 10.66.18.20/30"]

    F19 --> G19["10.66.19.0/25"]
    G19 --> A19["A19 - 10.66.19.0/26"]

    D20 --> E20["10.66.20.0/23"]
    D20 --> E22["10.66.22.0/23"]

    E20 --> A6["A6 - 10.66.20.0/24"]
    E20 --> A8["A8 - 10.66.21.0/24"]

    E22 --> F22["10.66.22.0/24"]
    F22 --> G22["10.66.22.0/25"]

    G22 --> A7["A7 - 10.66.22.0/26"]
    G22 --> H22["10.66.22.64/26"]

    H22 --> I22["10.66.22.64/27"]
    I22 --> J22["10.66.22.64/28"]
    J22 --> K22["10.66.22.64/29"]
    K22 --> A3["A3 - 10.66.22.64/30"]

    C24 --> D24["10.66.24.0/22"]
    D24 --> E24["10.66.24.0/23"]
    E24 --> F24["10.66.24.0/24"]

    F24 --> A1["A1 - 10.66.24.0/25"]
    F24 --> G24["10.66.24.128/25"]

    G24 --> H24["10.66.24.128/26"]
    H24 --> I24["10.66.24.128/27"]
    I24 --> J24["10.66.24.128/28"]
    J24 --> K24["10.66.24.128/29"]
    K24 --> A2["A2 - 10.66.24.128/30"]

    classDef root fill:#234e70,stroke:#79b8ff,color:#fff,stroke-width:3px;
    classDef branch fill:#252525,stroke:#888,color:#fff;
    classDef subnet fill:#fff,stroke:#bbb,color:#111,stroke-width:2px;
    class R root;
    class B0,B16,C0,C8,C16,C24,D0,D16,D20,D24,E0,E18,E20,E22,E24,F0,F18,F19,F22,F24 branch;
    class G0,G18,G19,G22,G24,H0,H18,H22,H24,I0,I18,I22,I24,J0,J16,J18,J18B,J22,J24,K8,K18,K18B,K18C,K22,K24 branch;
    class A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16,A17,A18,A19,A20,A21,A22,A23,A24,A25 subnet;
```

</div>

Spreadsheet Penggabungan - CIDR menunjukkan proses bottom-up, sedangkan tree menunjukkan proses top-down.


## 8. Pembagian Network ID, Broadcast, dan Range IP

Setelah tree terbentuk, kami menetapkan Network ID, prefix, broadcast, dan range IP usable untuk setiap subnet. Tabel ini menjadi dasar konfigurasi interface router dan client.

| Subnet | Network ID | Prefix | Broadcast | Range usable | Segmen |
|---|---|---:|---|---|---|
| A1 | 10.66.24.0 | /25 | 10.66.24.127 | 10.66.24.1-10.66.24.126 | Cyberia - JJ/MyuMyu |
| A2 | 10.66.24.128 | /30 | 10.66.24.131 | 10.66.24.129-10.66.24.130 | Cyberia - Wired |
| A3 | 10.66.22.64 | /30 | 10.66.22.67 | 10.66.22.65-10.66.22.66 | Wired - Navi |
| A4 | 10.66.18.0 | /30 | 10.66.18.3 | 10.66.18.1-10.66.18.2 | Wired - Tachibana |
| A5 | 10.66.0.16 | /29 | 10.66.0.23 | 10.66.0.17-10.66.0.22 | Wired - Psyche/Copland/Schumann |
| A6 | 10.66.20.0 | /24 | 10.66.20.255 | 10.66.20.1-10.66.20.254 | Navi - Alice/Reika |
| A7 | 10.66.22.0 | /26 | 10.66.22.63 | 10.66.22.1-10.66.22.62 | Navi - Taro |
| A8 | 10.66.21.0 | /24 | 10.66.21.255 | 10.66.21.1-10.66.21.254 | Navi - Yasuo/Miho/Kuma |
| A9 | 10.66.16.0 | /23 | 10.66.17.255 | 10.66.16.1-10.66.17.254 | Tachibana - Collective/Ghost |
| A10 | 10.66.18.4 | /30 | 10.66.18.7 | 10.66.18.5-10.66.18.6 | Tachibana - Deus |
| A11 | 10.66.18.128 | /25 | 10.66.18.255 | 10.66.18.129-10.66.18.254 | Deus - Lillith/Specter |
| A12 | 10.66.18.8 | /30 | 10.66.18.11 | 10.66.18.9-10.66.18.10 | Deus - Protocol7 |
| A13 | 10.66.18.64 | /26 | 10.66.18.127 | 10.66.18.65-10.66.18.126 | Protocol7 - Chisa/Hodgeson |
| A14 | 10.66.18.12 | /30 | 10.66.18.15 | 10.66.18.13-10.66.18.14 | Protocol7 - Knights |
| A15 | 10.66.18.24 | /29 | 10.66.18.31 | 10.66.18.25-10.66.18.30 | Knights - Eiri |
| A16 | 10.66.18.16 | /30 | 10.66.18.19 | 10.66.18.17-10.66.18.18 | Knights - Phantoma |
| A17 | 10.66.18.32 | /27 | 10.66.18.63 | 10.66.18.33-10.66.18.62 | Phantoma - Semi |
| A18 | 10.66.18.20 | /30 | 10.66.18.23 | 10.66.18.21-10.66.18.22 | Phantoma - Shibuya |
| A19 | 10.66.19.0 | /26 | 10.66.19.63 | 10.66.19.1-10.66.19.62 | Shibuya - Lain/Mika |
| A20 | 10.66.4.0 | /22 | 10.66.7.255 | 10.66.4.1-10.66.7.254 | Psyche - Karl/Lin |
| A21 | 10.66.2.0 | /23 | 10.66.3.255 | 10.66.2.1-10.66.3.254 | Copland - Masayuki |
| A22 | 10.66.0.64 | /26 | 10.66.0.127 | 10.66.0.65-10.66.0.126 | Copland - Juri |
| A23 | 10.66.0.0 | /29 | 10.66.0.7 | 10.66.0.1-10.66.0.6 | Schumann - Akashic |
| A24 | 10.66.0.8 | /30 | 10.66.0.11 | 10.66.0.9-10.66.0.10 | Schumann - Accela |
| A25 | 10.66.8.0 | /22 | 10.66.11.255 | 10.66.8.1-10.66.11.254 | Accela - OmniPresence/Denpa |

Tabel ini menjadi referensi final untuk konfigurasi interface router dan client.

## 9. Konfigurasi Router dan Client

Kami mengonfigurasi 13 router menggunakan `ip link`, `ip addr`, `ip route`, dan `net.ipv4.ip_forward=1`. Cyberia menangani koneksi NAT dengan `iptables -t nat ... MASQUERADE` pada eth0, sedangkan router lain meneruskan paket mengikuti rute yang kami tentukan. Seluruh file konfigurasi kami simpan dalam direktori `script/CIDR GNS/router/`.

Pola menjalankan script pada masing-masing router:

```sh
chmod +x /root/config-<nama-router>.sh
sh /root/config-<nama-router>.sh
ip -br -4 addr
ip route
cat /proc/sys/net/ipv4/ip_forward
```

Cyberia menggunakan alamat statis pada interface WAN karena image node tidak
menyediakan `udhcpc`, `dhclient`, atau BusyBox untuk DHCP:

```sh
ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 192.168.122.25/24 dev eth0
ip route replace default via 192.168.122.1 dev eth0

ip link set eth1 up
ip -4 addr flush dev eth1
ip addr add 10.66.24.1/25 dev eth1

ip link set eth2 up
ip -4 addr flush dev eth2
ip addr add 10.66.24.129/30 dev eth2

ip route replace 10.66.0.0/19 via 10.66.24.130 dev eth2
iptables -t nat -A POSTROUTING -s 10.66.0.0/19 -o eth0 -j MASQUERADE
```

| Interface | Alamat | Fungsi |
|---|---|---|
| `eth0` | `192.168.122.25/24` | NAT1/Internet |
| `eth1` | `10.66.24.1/25` | A1, JJ dan MyuMyu |
| `eth2` | `10.66.24.129/30` | A2, menuju Wired |

Expected route Cyberia:

```text
default via 192.168.122.1 dev eth0
10.66.0.0/19 via 10.66.24.130 dev eth2
```

Mapping koneksi utama yang dipertahankan:

```text
NAT1 nat0 → Cyberia eth0
Cyberia eth1 → Switch1 → JJ/MyuMyu
Cyberia eth2 → Wired eth0
Wired eth1 → Navi eth0
Wired eth2 → Switch2 bersama
Wired eth3 → Tachibana eth0
```

Router non-core menggunakan default route menuju parent karena seluruh
jaringan di luar cabangnya memiliki arah keluar yang sama. Static route ke
child tetap diperlukan agar jaringan di bawah cabang dapat dicapai. Jika
beberapa route cocok, router memilih prefix paling panjang; karena itu route
`/22` yang lebih spesifik dipilih sebelum default route `/0`.

### Rekap konfigurasi dan bukti per router

1. **Bukti konfigurasi interface Cyberia**: [script](script/CIDR%20GNS/router/config-cyberia.sh), interface `10.66.24.1/25`, `10.66.24.129/30`<br>
   [![Konfigurasi Cyberia](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/raw/main/Assets/cidr-gns3/01-cyberia-config.png)](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/blob/main/Assets/cidr-gns3/01-cyberia-config.png)
2. **Bukti konfigurasi interface Wired**: [script](script/CIDR%20GNS/router/config-wired.sh), interface `10.66.24.130/30`, `10.66.22.65/30`, `10.66.0.17/29`, `10.66.18.1/30`<br>
   [![Konfigurasi Wired 1](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/raw/main/Assets/cidr-gns3/02-1wired-config.png)](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/blob/main/Assets/cidr-gns3/02-1wired-config.png) [![Konfigurasi Wired 2](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/raw/main/Assets/cidr-gns3/02-2wired-config.png)](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/blob/main/Assets/cidr-gns3/02-2wired-config.png)
3. **Bukti konfigurasi interface Navi**: [script](script/CIDR%20GNS/router/config-navi.sh), interface `10.66.22.66/30`, `10.66.20.1/24`, `10.66.22.1/26`, `10.66.21.1/24`<br>
   [![Konfigurasi Navi](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/raw/main/Assets/cidr-gns3/03-navi-config.png)](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/blob/main/Assets/cidr-gns3/03-navi-config.png)
4. **Bukti konfigurasi interface Tachibana**: [script](script/CIDR%20GNS/router/config-tachibana.sh), interface `10.66.18.2/30`, `10.66.16.1/23`, `10.66.18.5/30`<br>
   [![Konfigurasi Tachibana 1](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/raw/main/Assets/cidr-gns3/04-1tachibana-config.png)](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/blob/main/Assets/cidr-gns3/04-1tachibana-config.png) [![Konfigurasi Tachibana 2](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/raw/main/Assets/cidr-gns3/04-2tachibana-config.png)](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/blob/main/Assets/cidr-gns3/04-2tachibana-config.png)
5. **Bukti konfigurasi interface Deus**: [script](script/CIDR%20GNS/router/config-deus.sh), interface `10.66.18.6/30`, `10.66.18.129/25`, `10.66.18.9/30`<br>
   [![Konfigurasi Deus](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/raw/main/Assets/cidr-gns3/05-deus-config.png)](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/blob/main/Assets/cidr-gns3/05-deus-config.png)
6. **Bukti konfigurasi interface Protocol7**: [script](script/CIDR%20GNS/router/config-protocol7.sh), interface `10.66.18.10/30`, `10.66.18.65/26`, `10.66.18.13/30`<br>
   [![Konfigurasi Protocol7](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/raw/main/Assets/cidr-gns3/06-protocol7-config.png)](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/blob/main/Assets/cidr-gns3/06-protocol7-config.png)
7. **Bukti konfigurasi interface Knights**: [script](script/CIDR%20GNS/router/config-knights.sh), interface `10.66.18.14/30`, `10.66.18.25/29`, `10.66.18.17/30`<br>
   [![Konfigurasi Knights](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/raw/main/Assets/cidr-gns3/07-knights-config.png)](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/blob/main/Assets/cidr-gns3/07-knights-config.png)
8. **Bukti konfigurasi interface Phantoma**: [script](script/CIDR%20GNS/router/config-phantoma.sh), interface `10.66.18.18/30`, `10.66.18.33/27`, `10.66.18.21/30`<br>
   [![Konfigurasi Phantoma](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/raw/main/Assets/cidr-gns3/08-phantoma-config.png)](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/blob/main/Assets/cidr-gns3/08-phantoma-config.png)
9. **Bukti konfigurasi interface Shibuya**: [script](script/CIDR%20GNS/router/config-shibuya.sh), interface `10.66.18.22/30`, `10.66.19.1/26`<br>
   [![Konfigurasi Shibuya](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/raw/main/Assets/cidr-gns3/09-shibuya-config.png)](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/blob/main/Assets/cidr-gns3/09-shibuya-config.png)
10. **Bukti konfigurasi interface Psyche**: [script](script/CIDR%20GNS/router/config-psyche.sh), interface `10.66.0.18/29`, `10.66.4.1/22`<br>
    [![Konfigurasi Psyche](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/raw/main/Assets/cidr-gns3/10-psyche-config.png)](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/blob/main/Assets/cidr-gns3/10-psyche-config.png)
11. **Bukti konfigurasi interface Copland**: [script](script/CIDR%20GNS/router/config-copland.sh), interface `10.66.0.19/29`, `10.66.2.1/23`, `10.66.0.65/26`<br>
    [![Konfigurasi Copland](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/raw/main/Assets/cidr-gns3/11-copland-config.png)](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/blob/main/Assets/cidr-gns3/11-copland-config.png)
12. **Bukti konfigurasi interface Schumann**: [script](script/CIDR%20GNS/router/config-schumann.sh), interface `10.66.0.20/29`, `10.66.0.1/29`, `10.66.0.9/30`<br>
    [![Konfigurasi Schumann](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/raw/main/Assets/cidr-gns3/12-schumann-config.png)](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/blob/main/Assets/cidr-gns3/12-schumann-config.png)
13. **Bukti konfigurasi interface Accela**: [script](script/CIDR%20GNS/router/config-accela.sh), interface `10.66.0.10/30`, `10.66.8.1/22`<br>
    [![Konfigurasi Accela](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/raw/main/Assets/cidr-gns3/13-accela-config.png)](https://github.com/keisyaahm/Jarkom-Modul-4-2026-K-05/blob/main/Assets/cidr-gns3/13-accela-config.png)

Kami menggunakan satu interface eth0 pada 25 client, dengan IP statis sesuai subnet masing-masing dan default gateway menuju router LAN. Setiap script berada di direktori `script/CIDR GNS/client/`.

Contoh konfigurasi pada Chisa:

```sh
ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add 10.66.18.66/26 dev eth0
ip route replace default via 10.66.18.65 dev eth0
```

| Client | Subnet | IP | Gateway |
|---|---|---|---|
| [JJ](script/CIDR%20GNS/client/config-jj.sh) | A1 | 10.66.24.2/25 | 10.66.24.1 |
| [MyuMyu](script/CIDR%20GNS/client/config-myumyu.sh) | A1 | 10.66.24.3/25 | 10.66.24.1 |
| [Alice](script/CIDR%20GNS/client/config-alice.sh) | A6 | 10.66.20.2/24 | 10.66.20.1 |
| [Reika](script/CIDR%20GNS/client/config-reika.sh) | A6 | 10.66.20.3/24 | 10.66.20.1 |
| [Taro](script/CIDR%20GNS/client/config-taro.sh) | A7 | 10.66.22.2/26 | 10.66.22.1 |
| [Yasuo](script/CIDR%20GNS/client/config-yasuo.sh) | A8 | 10.66.21.2/24 | 10.66.21.1 |
| [Miho](script/CIDR%20GNS/client/config-miho.sh) | A8 | 10.66.21.3/24 | 10.66.21.1 |
| [Kuma](script/CIDR%20GNS/client/config-kuma.sh) | A8 | 10.66.21.4/24 | 10.66.21.1 |
| [Collective](script/CIDR%20GNS/client/config-collective.sh) | A9 | 10.66.16.2/23 | 10.66.16.1 |
| [Ghost](script/CIDR%20GNS/client/config-ghost.sh) | A9 | 10.66.16.3/23 | 10.66.16.1 |
| [Lillith](script/CIDR%20GNS/client/config-lillith.sh) | A11 | 10.66.18.130/25 | 10.66.18.129 |
| [Specter](script/CIDR%20GNS/client/config-specter.sh) | A11 | 10.66.18.131/25 | 10.66.18.129 |
| [Chisa](script/CIDR%20GNS/client/config-chisa.sh) | A13 | 10.66.18.66/26 | 10.66.18.65 |
| [Hodgeson](script/CIDR%20GNS/client/config-hodgeson.sh) | A13 | 10.66.18.67/26 | 10.66.18.65 |
| [Eiri](script/CIDR%20GNS/client/config-eiri.sh) | A15 | 10.66.18.26/29 | 10.66.18.25 |
| [Semi](script/CIDR%20GNS/client/config-semi.sh) | A17 | 10.66.18.34/27 | 10.66.18.33 |
| [Lain](script/CIDR%20GNS/client/config-lain.sh) | A19 | 10.66.19.2/26 | 10.66.19.1 |
| [Mika](script/CIDR%20GNS/client/config-mika.sh) | A19 | 10.66.19.3/26 | 10.66.19.1 |
| [Karl](script/CIDR%20GNS/client/config-karl.sh) | A20 | 10.66.4.2/22 | 10.66.4.1 |
| [Lin](script/CIDR%20GNS/client/config-lin.sh) | A20 | 10.66.4.3/22 | 10.66.4.1 |
| [Masayuki](script/CIDR%20GNS/client/config-masayuki.sh) | A21 | 10.66.2.2/23 | 10.66.2.1 |
| [Juri](script/CIDR%20GNS/client/config-juri.sh) | A22 | 10.66.0.66/26 | 10.66.0.65 |
| [Akashic](script/CIDR%20GNS/client/config-akashic.sh) | A23 | 10.66.0.2/29 | 10.66.0.1 |
| [OmniPresence](script/CIDR%20GNS/client/config-omnipresence.sh) | A25 | 10.66.8.2/22 | 10.66.8.1 |
| [Denpa](script/CIDR%20GNS/client/config-denpa.sh) | A25 | 10.66.8.3/22 | 10.66.8.1 |

Seluruh script client mengikuti pola berikut dan tidak menjalankan ping
otomatis. Ping dijalankan manual pada tahap testing agar bukti screenshot
hanya menampilkan pengujian yang sudah bersih:

```sh
ip link set eth0 up
ip -4 addr flush dev eth0
ip addr add <IP-client>/<prefix> dev eth0
ip route replace default via <gateway> dev eth0
ip -br -4 addr
ip route
```

Daftar script konfigurasi terdiri dari 13 router (`config-accela.sh`,
`config-copland.sh`, `config-cyberia.sh`, `config-deus.sh`,
`config-knights.sh`, `config-navi.sh`, `config-phantoma.sh`,
`config-protocol7.sh`, `config-psyche.sh`, `config-schumann.sh`,
`config-shibuya.sh`, `config-tachibana.sh`, dan `config-wired.sh`) serta 25
client (`config-jj.sh`, `config-myumyu.sh`, `config-alice.sh`,
`config-reika.sh`, `config-taro.sh`, `config-yasuo.sh`, `config-miho.sh`,
`config-kuma.sh`, `config-collective.sh`, `config-ghost.sh`,
`config-lillith.sh`, `config-specter.sh`, `config-chisa.sh`,
`config-hodgeson.sh`, `config-eiri.sh`, `config-semi.sh`, `config-lain.sh`,
`config-mika.sh`, `config-karl.sh`, `config-lin.sh`, `config-masayuki.sh`,
`config-juri.sh`, `config-akashic.sh`, `config-omnipresence.sh`, dan
`config-denpa.sh`).

## 10. Static Routing dan NAT

Static route digunakan agar setiap router mengetahui jalur menuju jaringan yang tidak langsung terhubung. Route summary mengurangi jumlah entri routing, sedangkan route connected yang lebih spesifik tetap dipertahankan karena longest prefix match.

Berikut adalah contoh ringkasan rute yang kami gunakan dalam implementasi:

| Router | Route ringkasan / static route | Next hop |
|---|---|---|
| Cyberia | 10.66.0.0/19 | 10.66.24.130 (Wired) |
| Wired | 10.66.16.0/22 | 10.66.18.2 (Tachibana) |
| Wired | 10.66.20.0/22 | 10.66.22.66 (Navi) |
| Wired | 10.66.8.0/22 | 10.66.0.20 (Schumann) |
| Tachibana | 10.66.18.0/23 | 10.66.18.6 (Deus) |
| Schumann | 10.66.8.0/22 | 10.66.0.10 (Accela) |
| Phantoma | 10.66.19.0/26 | 10.66.18.22 (Shibuya) |

Kami mempertahankan rute yang langsung terhubung ke interface dengan prefix yang lebih spesifik agar tetap dipilih melalui mekanisme longest prefix match. Karena itu, agregasi rute tidak menggantikan route connected pada router.

Cyberia menjadi edge router menuju NAT. NAT dilakukan dengan `iptables` menggunakan source blok induk `10.66.0.0/19` dan interface keluar menuju Internet.

Kami menguji konektivitas lokal, antar-router, lintas cabang, dan akses Internet. Tabel berikut berisi command utama dan fungsi pengujiannya.

## 11. Testing Konektivitas

Sebelum mengambil screenshot ping, jalankan satu ping pemanasan untuk ARP dan
pembelajaran MAC switch, lalu bersihkan terminal:

```sh
ping -c 1 <IP-tujuan> >/dev/null 2>&1
clear
ping -c 3 <IP-tujuan>
```

Setiap screenshot ping harus memperlihatkan tiga reply dan
`3 packets transmitted, 3 received, 0% packet loss`. Screenshot dengan
`Destination Host Unreachable`, `Destination Net Unreachable`, atau packet
loss tidak digunakan sebagai bukti final.

### Sembilan screenshot pengujian final

| No. | Node dan pengujian | Command utama | File bukti |
|---:|---|---|---|
| 1 | Konfigurasi client Lain | `sh /root/config-lain.sh` | `Assets/01-lain-konfigurasi-client.png` |
| 2 | Protocol7 ke Knights (A14) | `ping -c 3 10.66.18.14` | `Assets/02-protocol7-ke-knights.png` |
| 3 | Navi ke Kuma (A8) | `ping -c 3 10.66.21.4` | `Assets/03-navi-ke-kuma-satu-lan.png` |
| 4 | Alice ke Denpa | `ping -c 3 10.66.8.3` | `Assets/04-alice-ke-denpa.png` |
| 5 | Lain ke JJ lintas routing | `ping -c 3 10.66.24.2` | `Assets/05-lain-ke-jj-lintas-routing.png` |
| 6 | Summary route Wired | `sh /root/config-wired.sh` | `Assets/06-wired-summary-routing.png` |
| 7 | NAT dan routing Cyberia | `sh /root/config-cyberia.sh` | `Assets/07-cyberia-nat-routing.png` |
| 8 | Lain ke Internet | `ping -c 3 8.8.8.8` | `Assets/08-lain-ke-internet.png` |
| 9 | Denpa ke Alice | `ping -c 3 10.66.20.2` | `Assets/09-denpa-ke-alice.png` |

SS 1 harus memperlihatkan `10.66.19.2/26` dan gateway `10.66.19.1`.
SS 6 harus memperlihatkan summary route `/22`, default route, dan
`ip_forward = 1`. SS 7 harus memperlihatkan `eth0 192.168.122.25/24`,
default route ke `192.168.122.1`, serta rule `MASQUERADE` untuk source
`10.66.0.0/19`.

### Pengujian komunikasi dua arah

Alice dan Denpa digunakan sebagai contoh komunikasi antar-cabang. Uji dari
Alice ke Denpa:

```sh
ping -c 1 10.66.8.3 >/dev/null 2>&1
clear
ping -c 3 10.66.8.3
```

Jalurnya adalah `Alice → Navi → Wired → Schumann → Accela → Denpa`.
Kemudian uji arah balik dari Denpa ke Alice:

```sh
ping -c 1 10.66.20.2 >/dev/null 2>&1
clear
ping -c 3 10.66.20.2
```

Jalurnya adalah `Denpa → Accela → Schumann → Wired → Navi → Alice`.
Kedua arah yang menghasilkan 0% packet loss membuktikan default gateway,
static route, summary CIDR, IP forwarding, dan return route bekerja.

### Hubungan bukti dengan pertanyaan praktikum

| Pertanyaan atau konsep | Bukti |
|---|---|
| Host dan interface router membutuhkan IP | SS 1 dan tabel Pembagian IP CIDR |
| Perbedaan VLSM dan CIDR | Spreadsheet VLSM, tree CIDR, dan SS 6 |
| VLSM dimulai dari subnet terbesar | Tab `Rute vlsm` pada spreadsheet |
| CIDR menggabungkan jaringan contiguous | Tree, tab `Penggabungan - CIDR`, dan SS 5 |
| Default route ke parent dan static route ke child | SS 5 dan SS 6 |
| Longest prefix match dan summary route | SS 4, SS 6, dan SS 8 |
| Komunikasi dua arah dan return route | SS 4 dan SS 9 |
| NAT dan akses Internet | SS 7 dan SS 8 |

### Bukti pengujian yang tersedia

1. **Bukti ping Cyberia ke Wired dan Internet**

![Bukti ping Cyberia ke Wired dan Internet](Assets/cidr-gns3/01-2-cyberia-ping.png)

2. **Bukti ping Wired ke jaringan cabang dan Internet**

![Bukti ping Wired ke jaringan cabang dan Internet](Assets/cidr-gns3/02-2-wired-ping.png)

3. **Bukti ping Navi ke client dalam jaringan lokal**

![Bukti ping Navi ke client dalam jaringan lokal](Assets/cidr-gns3/03-2-navi-ping.png)

Hasil pengujian dinyatakan berhasil apabila output command menunjukkan:

```text
3 packets transmitted, 3 received, 0% packet loss
```

### Command pengujian dan fungsi

| Sumber | Tujuan | Command | Fungsi |
|---|---|---|---|
| Chisa | Gateway Protocol7 | `ping -c 3 10.66.18.65` | Menguji LAN A13 |
| Protocol7 | Knights | `ping -c 3 10.66.18.14` | Menguji link A14 |
| Lain | JJ | `ping -c 3 10.66.24.2` | Menguji lintas cabang |
| Alice | Denpa | `ping -c 3 10.66.8.3` | Menguji Navi ke Accela |
| Lain | Internet | `ping -c 3 8.8.8.8` | Menguji NAT |

Catatan Protocol7-Knights: jalankan ulang `ping -c 3 10.66.18.14` dari Protocol7 setelah route A14 diperiksa. Pengujian berhasil jika menghasilkan `3 packets transmitted, 3 received, 0% packet loss`.

Setiap pengujian berhasil apabila outputnya memuat `3 packets transmitted, 3 received, 0% packet loss`. Jika berbeda, periksa IP, gateway, route, forwarding, dan NAT.

## 12. Kesimpulan CIDR

Kami menyelesaikan alur CIDR GNS3 dari identifikasi topologi, penentuan 25 subnet, perhitungan host, penentuan prefix, pembagian A1-A25, penggabungan CIDR, pembentukan tree, penetapan alamat final, konfigurasi perangkat, static routing, NAT, dan testing konektivitas.

Blok induk hasil route summarization adalah `10.66.0.0/19`. Seluruh
skenario pengujian representatif dinyatakan berhasil apabila menghasilkan
`3 packets transmitted, 3 received, 0% packet loss`.

Pengujian Alice-Denpa dan Denpa-Alice membuktikan komunikasi lintas cabang
dan return route berjalan dua arah. Pengujian Lain-JJ membuktikan static
routing end-to-end serta summary CIDR bekerja. Pengujian Lain menuju
`8.8.8.8` membuktikan default route, IP forwarding, dan NAT MASQUERADE pada
Cyberia berfungsi.


# B. VLSM Cisco Packet Tracer

## 13. Topologi VLSM

Kami menggunakan Cisco Packet Tracer untuk pembahasan VLSM. Topologi dan pembagian perangkat mengikuti rancangan pada spreadsheet praktikum.

## 14. Perhitungan VLSM

Kami menghitung kebutuhan host setiap jaringan, memilih prefix yang memenuhi kebutuhan tersebut, lalu mengalokasikan alamat dari kebutuhan terbesar ke kebutuhan terkecil. Rincian perhitungan tersedia pada spreadsheet subnetting.

## 15. Tabel Pembagian IP VLSM

Tabel pembagian alamat VLSM kami cantumkan pada spreadsheet. Bukti tab pembagian alamat tersedia pada bagian ini.

1. **Bukti tabel Rute VLSM**

![Bukti tabel Rute VLSM](Assets/vlsm-cpt/rute1.png)

2. **Bukti tabel perhitungan Rute VLSM**

![Bukti tabel perhitungan Rute VLSM](Assets/vlsm-cpt/rutevlsm.png)

3. **Bukti tabel Pembagian IP VLSM**

![Bukti tabel Pembagian IP VLSM](Assets/vlsm-cpt/bagiipvlsm.png)

## 16. Konfigurasi Router dan Client VLSM

Kami menerapkan alamat hasil perhitungan VLSM pada router dan client Cisco Packet Tracer. Bukti konfigurasi dan routing OSPF tersedia pada bagian Testing VLSM.

## 17. Testing VLSM

Kami menguji konektivitas antarperangkat dan memeriksa proses routing OSPF. Bukti yang tersedia:

1. **Bukti ping Juri ke gateway pada percobaan awal**

![Bukti ping Juri ke gateway pada percobaan awal](Assets/vlsm-cpt/01_Ping_Juri_Gateway_dan_gagal_awal.png)

2. **Bukti ping Juri ke Masayuki pada percobaan awal**

![Bukti ping Juri ke Masayuki pada percobaan awal](Assets/vlsm-cpt/02_Ping_Juri_ke_Masayuki_awal.png)

3. **Bukti ping Masayuki ke Juri berhasil**

![Bukti ping Masayuki ke Juri berhasil](Assets/vlsm-cpt/03_Ping_Masayuki_ke_Juri_berhasil.png)

4. **Bukti ping Karl ke Juri berhasil**

![Bukti ping Karl ke Juri berhasil](Assets/vlsm-cpt/04_Ping_Karl_ke_Juri_berhasil.png)

5. **Bukti ping Juri ke Karl sebelum perbaikan**

![Bukti ping Juri ke Karl sebelum perbaikan](Assets/vlsm-cpt/05_Ping_Juri_ke_Karl_sebelum_perbaikan.png)

6. **Bukti OSPF neighbor Copland pada kondisi awal**

![Bukti OSPF neighbor Copland pada kondisi awal](Assets/vlsm-cpt/06_OSPF_Copland_neighbor_awal.png)

7. **Bukti routing table OSPF Copland**

![Bukti routing table OSPF Copland](Assets/vlsm-cpt/07_OSPF_Copland_routing_table.png)

8. **Bukti log adjacency OSPF Copland**

![Bukti log adjacency OSPF Copland](Assets/vlsm-cpt/08_OSPF_Copland_adjacency_log.png)

9. **Bukti OSPF EXSTART Psyche pada kondisi awal**

![Bukti OSPF EXSTART Psyche pada kondisi awal](Assets/vlsm-cpt/09_OSPF_Psyche_EXSTART_awal.png)

10. **Bukti ping Juri ke Karl berhasil**

![Bukti ping Juri ke Karl berhasil](Assets/vlsm-cpt/10_Ping_Juri_ke_Karl_berhasil.png)

## 18. Kesimpulan VLSM

Kami menggunakan VLSM untuk membagi alamat berdasarkan kebutuhan host setiap jaringan. Hasil pengujian dan bukti konfigurasi ditampilkan melalui screenshot Cisco Packet Tracer yang tersedia pada bagian sebelumnya.
