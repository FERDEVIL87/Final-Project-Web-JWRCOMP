import subprocess
import os
import time
import signal
import sys
import re

# ==============================================================================
# --- KONFIGURASI YANG SUDAH DIPERBAIKI ---
# ==============================================================================

# Sesuaikan nama folder jika berbeda
FRONTEND_DIR = 'frontend'
BACKEND_DIR = 'backend'

# Konfigurasi ngrok untuk Frontend (Akun A)
FRONTEND_NGROK_TOKEN = '30dc6AQoQwWszCX8SHyhN29DCOT_ijqyBmNE4LxK76V8Cvbh'
FRONTEND_NGROK_DOMAIN = 'antelope-balanced-ferret.ngrok-free.app'

# Konfigurasi ngrok untuk Backend (Akun B)
BACKEND_NGROK_TOKEN = '30dcPZhtN5BzmEZf7qpncqZQx5u_55VRuY92AEYLj242nzz5M'
BACKEND_NGROK_DOMAIN = 'alpaca-neat-treefrog.ngrok-free.app'

# Daftar untuk menyimpan SEMUA proses yang berjalan (NPM dan Ngrok)
all_processes = []

def cleanup(sig=None, frame=None):
    """Fungsi untuk menghentikan semua proses saat script dihentikan."""
    print("\n[INFO] Menerima sinyal keluar... Menghentikan semua proses.")
    
    for p in reversed(all_processes):
        try:
            print(f"[INFO] Menghentikan proses PID: {p.pid}")
            if sys.platform == "win32":
                subprocess.call(['taskkill', '/F', '/T', '/PID', str(p.pid)])
            else:
                os.killpg(os.getpgid(p.pid), signal.SIGTERM)
        except (ProcessLookupError, OSError):
            pass
    
    print("[INFO] Semua proses telah dihentikan. Keluar.")
    sys.exit(0)

def start_process(command, name, working_dir=None):
    """Memulai proses, menambahkannya ke daftar cleanup, dan mengembalikan objek prosesnya."""
    print(f"\n[INFO] Memulai {name}...")
    print(f"[PERINTAH] {command}")

    proc = subprocess.Popen(
        command,
        cwd=working_dir,
        shell=True,
        # Kita tidak menangkap output ngrok agar bisa tampil langsung
        stdout=subprocess.PIPE if "npm" in command else None,
        stderr=subprocess.STDOUT if "npm" in command else None,
        encoding='utf-8',
        errors='ignore',
        bufsize=1,
        preexec_fn=os.setsid if sys.platform != "win32" else None
    )
    all_processes.append(proc)
    return proc

def find_port_from_npm_process(command, name, working_dir, timeout=30):
    """Memulai proses NPM, mendeteksi port, dan mengembalikan portnya."""
    proc = start_process(command, name, working_dir)
    
    print(f"[INFO] Menunggu {name} untuk mengumumkan port (timeout: {timeout} detik)...")
    
    start_time = time.time()
    port_regex = re.compile(r'localhost:(\d{4,5})| port (\d{4,5})| on port (\d{4,5})|:(\d{4,5})', re.IGNORECASE)

    for line in iter(proc.stdout.readline, ''):
        if not line:
            break
        
        safe_line_to_print = line.strip().encode('ascii', 'ignore').decode('ascii')
        print(f"[{name}] {safe_line_to_print}")
        
        match = port_regex.search(line)
        if match:
            port = next((g for g in match.groups() if g is not None), None)
            if port and "in use, trying another one" not in line:
                print(f"\n[SUCCESS] Port untuk {name} terdeteksi: {port}\n")
                return int(port)

        if time.time() - start_time > timeout:
            print(f"[ERROR] Timeout! Tidak dapat menemukan port untuk {name} dalam {timeout} detik.")
            return None

    print(f"[ERROR] Proses {name} berhenti sebelum port dapat ditemukan.")
    return None


if __name__ == "__main__":
    signal.signal(signal.SIGINT, cleanup)

    print("="*80)
    print("      MEMULAI LAYANAN UNTUK DUA AKUN NGROK BERBEDA")
    print("      VERSI YANG SUDAH DIPERBAIKI")
    print("="*80)

    # 1. Deteksi port frontend dan backend
    frontend_port = find_port_from_npm_process("npm run dev", "Server Frontend", FRONTEND_DIR)
    if not frontend_port:
        cleanup()

    backend_port = find_port_from_npm_process("npm run dev", "Server Backend", BACKEND_DIR)
    if not backend_port:
        cleanup()

    # Beri jeda krusial sebelum menjalankan ngrok
    print("\n[INFO] Deteksi port selesai. Menunggu 5 detik sebelum meluncurkan ngrok...")
    time.sleep(5)

    # 2. Bangun perintah dan jalankan DUA proses ngrok TERPISAH
    ngrok_frontend_cmd = f"ngrok http {frontend_port} --authtoken {FRONTEND_NGROK_TOKEN} --domain {FRONTEND_NGROK_DOMAIN}"
    start_process(ngrok_frontend_cmd, "Ngrok Frontend")
    
    ngrok_backend_cmd = f"ngrok http {backend_port} --authtoken {BACKEND_NGROK_TOKEN} --domain {BACKEND_NGROK_DOMAIN}"
    start_process(ngrok_backend_cmd, "Ngrok Backend")

    print("\n" + "="*80)
    print("      SEMUA LAYANAN SUDAH DILUNCURKAN - KONFIGURASI YANG BENAR")
    print("="*80)
    print(f"  Frontend : https://{FRONTEND_NGROK_DOMAIN}  (Lokal: http://localhost:{frontend_port})")
    print(f"  Backend  : https://{BACKEND_NGROK_DOMAIN}  (Lokal: http://localhost:{backend_port})")
    print()
    print("  PENTING: Pastikan frontend menggunakan URL backend yang benar!")
    print(f"  Environment variable VITE_NGROK_API_URL sudah diset ke:")
    print(f"  https://{BACKEND_NGROK_DOMAIN}/api")
    print()
    print("[INFO] Tekan CTRL+C untuk menghentikan semua layanan.")
    print("="*80 + "\n")

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        cleanup()

