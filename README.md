# Harvest Star

> Tugas Besar IF2121 Logika Komputasi <br /> Harvest Star <br /> Semester Ganjil 2021/2022

## Developed by
Kelompok 6 K02
- 13520062 / Rifqi Naufal Abdjul
- 13520094 / Saul Sayers
- 13520103 / Amar Fadil
- 13520105 / Malik Akbar Hashemi Rafsanjani

## Table of Contents
* [Program Structure](#program-structure)
* [Features and Commands](#features-and-commands)
* [Usage](#usage)
* [Pembagian Tugas](#pembagian-tugas)

## Program Structure
Program ini memiliki source code `main.pl` untuk main program. Main program kemudian dibagi menjadi beberapa bagian:
### Helper
- `helper.pl`
    Berisi snippet predikat pembantu (general purpose).
### Facts
- `items.pl`
    Fakta-fakta berisi item yang ada pada permainan.
### Systems and Dynamics
- `player.pl`
    Fakta dan predikat untuk pemain (XP, Money, Level, dst).
- `map.pl`
    Fakta dan predikat untuk peta (Posisi Player, Objek Map, dst).
- `inventory.pl`
    Fakta dan predikat untuk inventory logic pemain.
- `world.pl`
    Fakta dan predikat terkait dunia permainan (waktu, season, weather, dst).
- `list_diary.pl`
    Fakta dan predikat untuk melihat daftar diari yang ditulis pemain.
- `saves.pl`
    Fakta dan predikat untuk menyimpan state permainan yang berjalan.
### Gameplay
- `exploration.pl`
    Movement/pergerakan pemain (move, w, a, s, d).
- `quest.pl`
    Menjalankan atau mendapatkan reward quest.
- `fishing.pl`
    Melakukan fishing untuk mendapatkan ikan.
- `farming.pl`
    Melakukan farming untuk mendapatkan item harvest.
- `ranching.pl`
    Melakukan ranching untuk mendapatkan item ranching.
- `marketplace.pl`
    Jual beli barang/item.
- `house.pl`
    Rumah untuk tidur, menyimpan diary, dan membaca diary.
- `alchemist.pl`
    Mendatangkan alkemi terkenal yang menjual barang mahal dengan kuantitas sedikit.
- `fairy.pl`
    Menjalankan gameplay peri dan gacha kemunculannya.
    > Rem wangy huaaa

## Features and Commands
Terdapat beberapa fitur dan command yang dapat digunakan dalam program:
- Status `status.`
- Inventory `inventory.`
- Throw Item `throwItem.`
- Dig `dig.`
- Plant `plant.`
- Harvest `harvest.`
- Farm `farm.`
- Fish `fish.`
- Ranch `ranch.`
- Map `map.`
- Movement `w. / a. / s. / d.`
- Quest `quest.`
- House `house.`
- Sleep `sleep.`
- Write Dairy `writeDairy.`
- Read Dairy `readDairy.`
- Market `market.`
- Buy `buy.`
- Sell `sell.`
- Help `help.`
- Exit `exit.`
- Start `start.`
- Quit Game `quitGame.`
- Fail and Goal State
- [BONUS] Fairy (will teleport you to any place inside the map. Just sleep until she comes :D)
- [BONUS] Alchemist (`alchemist.` when available)
- [BONUS] Weather and Season System (different seeds and plant buffs)
- [BONUS] Time System (fatigue stamina-like gameplay)

## Usage
### Menjalankan Permainan
- Pastikan GNU Prolog telah diinstall pada mesin anda.
- Jalankan program dengan change directory ke folder root program ini dan consult file  `main.pl` pada GNU Prolog:
    ```
    [main].
    ```
- Atau untuk Windows, dengan asumsi menginstall GNU Prolog pada folder `C:\GNU-Prolog\bin\gprolog`, jalankan `run.bat` pada command prompt atau powershell:
    ```
    run.bat
    ```
### Dalam Permainan
- Permainan dapat dimulai dengan `start.`
- Untuk melihat banner permainan, gunakan `startGame.`
- Daftar command dapat dilihat dengan command `help.`


## Pembagian Tugas
| Nama / NIM | Pembagian Kerja | Persentase Kerja |
| ---------- | --------------- | ---------------- |
| Rifqi Naufal Abdjul / 13520062 | marketplace, house, goal and fail state, diary, wrap up | 25% |
| Saul Sayers / 13520094 | player, inventory, items, saveload | 25% |
| Amar Fadil / 13520103 | map, quest, exploration, peri, alchemist | 25% |
| Malik Akbar Hashemi Rafsajani / 13520105 | farming, fishing, ranching, weather | 25% |
