<template>
  <section class="checkout-bs">
    <div class="container py-4 py-md-5">
      <h2 class="section-title-bs text-center">Checkout</h2>
      <div class="row justify-content-center">
        <div class="col-lg-7">
          <form class="admin-card-bs p-4" @submit.prevent="submitForm">
            <div class="mb-3">
              <label class="form-label">Nama Pesanan</label>
              <input v-model="nama" type="text" class="form-control" required />
            </div>
            <div class="mb-3">
              <label class="form-label">Harga</label>
              <input v-model="harga" type="number" class="form-control" required min="0" />
            </div>
            <div class="mb-3">
              <label class="form-label">Kategori</label>
              <select v-model="kategori" class="form-select" required>
                <option value="">Pilih Kategori</option>
                <option value="Paket Rakitan PC">Paket Rakitan PC</option>
                <option value="Laptop">Laptop</option>
                <option value="Console and Handheld">Console and Handheld</option>
                <option value="PC Part">PC Part</option>
              </select>
            </div>
            <div class="mb-3">
              <label class="form-label">Spesifikasi</label>
              <input v-model="spesifikasi" type="text" class="form-control" required min="0" />
            </div>
            <div class="mb-3">
              <label class="form-label">Deskripsi</label>
              <textarea v-model="deskripsi" class="form-control" rows="3" required></textarea>
            </div>
            <button class="login-btn-bs w-100" type="submit">Bayar Sekarang</button>
            <p v-if="success" class="success-bs mt-3">Anda Sudah Memesan Barang Pesanan!</p>
          </form>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue'
const nama = ref('')
const harga = ref('')
const spesifikasi = ref('')
const kategori = ref('')
const deskripsi = ref('')
const success = ref(false)
function submitForm() {
 
  success.value = true
  setTimeout(() => success.value = false, 2000)
  nama.value = ''
  harga.value = ''
  spesifikasi.value = ''
  kategori.value = ''
  deskripsi.value = ''
}
</script>

<style scoped>
.checkout-bs {
  --primary-color: #00d9ff;
  --secondary-color: #00c6ff;
  --background-main: #0c101c;
  --background-section: #11192b;
  --background-card: #1a243a;
  --text-light: #e8eff5;
  min-height: 100vh;
  background: var(--background-main);
  color: var(--text-light);
  font-family: 'Roboto', sans-serif;
}
.container {
  width: 100%;
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
  padding-left: 10px;
  padding-right: 10px;
  box-sizing: border-box;
}
.section-title-bs {
  font-family: 'Orbitron', sans-serif;
  font-size: clamp(1.5rem, 4vw, 2.2rem);
  font-weight: 700;
  color: #fff;
  text-shadow: 0 0 6px #fff, 0 0 11px var(--primary-color), 0 0 16px var(--primary-color);
  margin-bottom: 2.5rem !important;
  position: relative;
  text-transform: uppercase;
  letter-spacing: 1px;
}
.section-title-bs::after {
  content: '';
  position: absolute;
  bottom: -10px;
  left: 50%;
  transform: translateX(-50%);
  width: 50px;
  height: 2.5px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
  border-radius: 1.5px;
  box-shadow: 0 0 8px var(--primary-color), 0 0 5px var(--secondary-color);
}
.admin-card-bs {
  background: var(--background-card);
  border-radius: 10px;
  box-shadow: 0 5px 15px rgba(0,0,0,0.3);
  border: 1px solid var(--primary-color);
  color: var(--text-light);
}
.form-label {
  color: #e8eff5;
  font-weight: 500;
}
.form-control, .form-select {
  background: #11192b;
  color: #e8eff5;
  border: 1.5px solid #22304a;
  border-radius: 8px;
  font-size: 1rem;
  margin-bottom: 0.5rem;
}
.form-control:focus, .form-select:focus {
  border: 1.5px solid #00d9ff;
  background: #1a243a;
  color: #fff;
}
.login-btn-bs {
  width: 100%;
  padding: 0.95rem 0;
  background: #00d9ff;
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 1.1rem;
  font-weight: 500;
  cursor: pointer;
  margin-top: 0.5rem;
  transition: background 0.2s;
  box-shadow: 0 1px 4px 0 rgba(0,217,255,0.08);
}
.login-btn-bs:hover {
  background: #00bcd4;
}
.success-bs {
  color: #00e676;
  font-weight: 500;
  text-align: center;
}
</style>
