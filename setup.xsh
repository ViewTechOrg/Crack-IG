#!/usr/bin/env xonsh

# setup tools xonsh by ViewTech Team
# simple version

import os
import sys

# Menampilkan informasi awal
print("\033[1;32m>> Memulai Setup...\033[0m")

# TODO: Daftar modul Python
required_modules = [
    "requests",
    "emoji",
    "rich",
    "faker",
    "random_user_agent",
    "cython"
]

def ensure_module_installed(module_name):
    """
    Memeriksa apakah modul Python sudah terpasang dan menginstall jika belum ada.
    
    Args:
        module_name (str): Nama modul Python yang akan diperiksa.
    
    Returns:
        bool: True jika modul tersedia atau berhasil diinstall, False jika gagal.
    """
    try:
        __import__(module_name)
        print(f"\033[32m✓ Modul {module_name} sudah terpasang\033[0m")
        return True
    except ImportError:
        print(f"\033[33m! Modul {module_name} belum terpasang, menginstall...\033[0m")
        result = ![pip install @(module_name)]
        if result.returncode == 0:
            print(f"\033[32m✓ Berhasil menginstall {module_name}\033[0m")
            return True
        else:
            print(f"\033[1;31m✗ Gagal menginstall {module_name}: {result.stderr}\033[0m")
            return False

def check_command_exists(command):
    """
    Memeriksa apakah perintah tersedia di sistem.
    
    Args:
        command (str): Perintah yang akan diperiksa.
    
    Returns:
        bool: True jika perintah ditemukan, False jika tidak.
    """
    return $(which @(command)).strip() != ""

# Memeriksa dan menginstall semua modul Python
print("\033[36m>> Mengecek dan menginstall dependensi Python...\033[0m")
for module in required_modules:
    if not ensure_module_installed(module):
        print(f"\033[1;31m✗ Setup dibatalkan karena gagal menginstall {module}\033[0m")
        sys.exit(1)

# Memeriksa keberadaan compiler g++
if not check_command_exists("g++"):
    print("\033[1;31m✗ Compiler g++ tidak ditemukan! Silakan install dengan: pkg install clang\033[0m")
    sys.exit(1)

# Memeriksa file main.cpp
if not os.path.isfile("main.cpp"):
    print("\033[1;31m✗ File main.cpp tidak ditemukan\033[0m")
    sys.exit(1)

# Mengkompilasi main.cpp
print("\033[36m>> Mengkompilasi main.cpp menjadi out.bin menggunakan g++...\033[0m")
compile_command = [
    "g++",
    "-Os",
    "-std=c++17",
    f"-I{os.environ.get('PREFIX', '/usr')}/include/python3.12",
    "src/main.cpp",
    "-o",
    "out.bin",
    "-lpython3.12",
    "-lpthread",
    "-lm",
    "-lutil",
    "-ldl"
]

result = ![ @(compile_command) ]
if result.returncode == 0 and os.path.isfile("out.bin"):
    print("\033[1;32m✓ Berhasil dikompilasi ke out.bin!\033[0m")
    echo "\033[1;36m > \033[1;37mmenjalankan perintah \033[35m~>\033[1;37m ./out.bin"
else:
    print(f"\033[1;31m✗ Gagal saat kompilasi: {result.stderr}\033[0 ./out.bin")
    sys.exit(1)
