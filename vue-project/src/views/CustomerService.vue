<template>
  <section class="py-5 bg-black min-vh-100 d-flex align-items-center justify-content-center">
    <div class="container text-white text-center" style="max-width: 500px;">

      <h1 style="font-size: 2rem; font-weight: 600;">Hubungi Kami</h1>

      <p class="mb-3" style="font-size: 0.95rem; font-weight: 300;">
        Kirim pertanyaan atau pesan lewat formulir ini.
      </p>

      <!-- Tampilkan pesan sukses/error -->
      <div v-if="statusMessage" :class="['alert', isSuccess ? 'alert-success' : 'alert-danger']">
        {{ statusMessage }}
      </div>

      <!-- Gunakan v-if untuk menyembunyikan form setelah sukses -->
      <form @submit.prevent="submitForm" v-if="!isSuccess">
        <div class="mb-2">
          <input v-model="form.name" type="text" class="form-control" placeholder="Nama Anda" required autocomplete="name">
        </div>
        <div class="mb-2">
          <input v-model="form.email" type="email" class="form-control" placeholder="Email Anda" required autocomplete="email">
        </div>
        <div class="mb-3">
          <textarea v-model="form.message" class="form-control" placeholder="Pesan Anda" rows="4" required></textarea>
        </div>
        <button type="submit" class="btn btn-primary w-100" :disabled="isLoading">
          {{ isLoading ? 'Mengirim...' : 'Kirim' }}
        </button>
      </form>
    </div>
  </section>
</template>

<script>
// Impor axios secara langsung di komponen ini
import axios from 'axios';

export default {
  data() {
    return {
      form: {
        name: '',
        email: '',
        message: ''
      },
      isLoading: false,
      statusMessage: '',
      isSuccess: false,
    };
  },
  methods: {
    async submitForm() {
      this.isLoading = true;
      this.statusMessage = '';
      this.isSuccess = false;

      try {
        // Definisikan URL API lengkap di sini
        const apiUrl = 'http://127.0.0.1:8000/api/customer-service';

        // Kirim data ke API Laravel menggunakan axios
        // `this.form` akan dikirim sebagai { name: '...', email: '...', message: '...' }
        // yang sudah sesuai dengan validasi di Laravel
        const response = await axios.post(apiUrl, this.form);

        // Jika berhasil
        this.isSuccess = true;
        this.statusMessage = response.data.message;

        // Kosongkan form setelah berhasil
        this.form.name = '';
        this.form.email = '';
        this.form.message = '';

      } catch (error) {
        // Jika gagal
        this.isSuccess = false;
        if (error.response && error.response.data && error.response.data.message) {
          this.statusMessage = `Gagal mengirim: ${error.response.data.message}`;
        } else if (error.code === 'ERR_NETWORK') {
          this.statusMessage = 'Tidak dapat terhubung ke server. Pastikan backend berjalan.';
        } else {
          this.statusMessage = 'Terjadi kesalahan. Silakan coba lagi.';
        }
        console.error('Error submitting form:', error);
      } finally {
        this.isLoading = false;
      }
    }
  }
};
</script>

<style scoped>
/* Styling untuk form-control bisa ditambahkan jika belum ada secara global */
.form-control {
    background-color: #2a3038 !important; 
    color: #e8eff5 !important; 
    border-color: #00d9ff55 !important;
    padding: 0.75rem 1rem;
}
.form-control::placeholder {
    color: #adb5bdAA !important; 
}
.form-control:focus {
    border-color: #00d9ff !important;
    box-shadow: 0 0 0 0.2rem rgba(0, 217, 255, 0.25) !important;
}
.btn-primary {
    background-color: #00d9ff;
    border-color: #00d9ff;
    color: #181c22;
    font-weight: bold;
}
.alert {
  margin-bottom: 1rem;
}
</style>