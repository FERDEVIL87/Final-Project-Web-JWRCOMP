<template>
  <div class="checkout-container">
    <h2>Checkout Pesanan</h2>

    <div v-if="isLoadingPayment" class="payment-loading-overlay">
      <div class="spinner"></div>
      <p>Menyimpan pesanan Anda...</p>
    </div>

    <div v-if="paymentStatusMessage" :class="['payment-status-message', paymentSuccess ? 'success' : 'error']">
      <p v-html="paymentStatusMessage.replace(/\n/g, '<br>')"></p>
      <button v-if="paymentSuccess" @click="resetAndGoHome" class="btn-small-action">
        Kembali ke Beranda
      </button>
      <button v-else @click="resetPaymentStatus" class="btn-small-action">
        Coba Lagi
      </button>
    </div>

    <div v-if="!isLoadingPayment && !paymentStatusMessage">
      <div v-if="cartStore.items.length === 0" class="empty-cart-message">
        <p>Keranjang belanja Anda kosong.</p>
        <p>Silakan tambahkan produk terlebih dahulu untuk melanjutkan.</p>
      </div>
      
      <!-- Menggunakan satu form untuk semua -->
      <form @submit.prevent="handleFinalCheckout" v-else>
        
        <!-- ========================================================== -->
        <!-- BAGIAN BARU: FORM DATA PEMBELI -->
        <!-- ========================================================== -->
        <div class="customer-details-form">
          <h4>Detail Pengiriman</h4>
          <div class="form-group">
            <label for="customer_name">Nama Lengkap</label>
            <input type="text" id="customer_name" v-model="customer.name" class="form-control-checkout" required>
          </div>
          <div class="form-group">
            <label for="customer_address">Alamat Lengkap</label>
            <textarea id="customer_address" v-model="customer.address" class="form-control-checkout" rows="3" required></textarea>
          </div>
          <div class="form-group">
            <label for="customer_phone">Nomor HP</label>
            <input type="tel" id="customer_phone" v-model="customer.phone" class="form-control-checkout" required>
          </div>
        </div>
        <!-- ========================================================== -->
        
        <h4>Ringkasan Pesanan</h4>
        <div class="table-responsive">
          <table class="checkout-table">
            <thead>
              <tr>
                <th>Gambar</th>
                <th>Nama Pesanan</th>
                <th>Jumlah</th>
                <th>Subtotal</th>
                <th>Aksi</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="item in cartStore.items" :key="`${item.source}-${item.id}`">
                <td data-label="Gambar"><img v-if="item.image" :src="item.image" :alt="item.name" class="checkout-item-image"/></td>
                <td data-label="Nama Pesanan">{{ item.name }}</td>
                <td data-label="Jumlah">
                  <input type="number" :value="item.qty" @input="updateQuantity(`${item.source}-${item.id}`, $event.target.value)" min="1" class="qty-input"/>
                </td>
                <td data-label="Subtotal">Rp{{ ((Number(item.price) || 0) * (Number(item.qty) || 0)).toLocaleString('id-ID') }}</td>
                <td data-label="Aksi">
                  <button type="button" @click="removeItem(`${item.source}-${item.id}`)" class="remove-item-button">Hapus</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="checkout-summary">
          <p class="total-text"><strong>Total Keseluruhan: Rp{{ cartStore.totalPrice.toLocaleString('id-ID') }}</strong></p>
          <button type="submit" :disabled="cartStore.items.length === 0 || isLoadingPayment">
            {{ isLoadingPayment ? 'Memproses...' : 'Konfirmasi Pesanan' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { cartStore } from '@/store/cartStore';
import apiClient from '@/services/api.js'; // Use centralized API client

export default {
  setup() {
    return { cartStore };
  },
  data() {
    return {
      isLoadingPayment: false,
      paymentStatusMessage: '',
      paymentSuccess: false,
      customer: {
        name: '',
        address: '',
        phone: ''
      }
    };
  },
  methods: {
    updateQuantity(compositeId, newQuantity) {
      const qty = parseInt(newQuantity, 10);
      if (!isNaN(qty) && qty >= 1) { 
        cartStore.updateItemQuantity(compositeId, qty);
      }
    },
    removeItem(compositeId) {
      cartStore.removeItem(compositeId);
    },
    resetPaymentStatus() {
      this.paymentStatusMessage = '';
      this.paymentSuccess = false;
      this.isLoadingPayment = false;
    },
    resetAndGoHome() {
        this.resetPaymentStatus();
        this.$router.push('/');
    },
    async handleFinalCheckout() {
      if (cartStore.items.length === 0) return;

      if (!this.customer.name || !this.customer.address || !this.customer.phone) {
        alert("Harap isi semua detail pengiriman.");
        return;
      }

      this.isLoadingPayment = true;
      this.paymentStatusMessage = '';

      const orderPayload = {
        customer_name: this.customer.name,
        customer_address: this.customer.address,
        customer_phone: this.customer.phone,
        items: cartStore.items.map(item => ({
          name: item.name,
          quantity: item.qty,
          price: item.price, // <-- TAMBAHKAN HARGA DI SINI
        })),
      };

      try {
        // Use the shared API instance
        const response = await apiClient.post('/checkout', orderPayload);
        
        this.paymentSuccess = true;
        this.paymentStatusMessage = `${response.data.message}\nID Transaksi Anda: ${response.data.transaction_id}`;
        
        cartStore.clearCart();
        
      } catch (error) {
        this.paymentSuccess = false;
        if (error.response && error.response.data && error.response.data.message) {
            this.paymentStatusMessage = `Gagal menyimpan pesanan: ${error.response.data.message}`;
        } else if (error.code === 'ERR_NETWORK') {
            this.paymentStatusMessage = 'Tidak dapat terhubung ke server. Pastikan server backend berjalan.';
        } else {
            this.paymentStatusMessage = 'Terjadi kesalahan teknis. Mohon coba kembali.';
        }
        console.error("Gagal mengirim checkout:", error);
      } finally {
        this.isLoadingPayment = false;
      }
    },
  }
};
</script>

<style scoped>
/* Tambahkan style untuk form customer */
.customer-details-form {
  margin-bottom: 40px;
  padding: 25px;
  background-color: #1f2937;
  border-radius: 8px;
  border: 1px solid #2d3748;
}
.customer-details-form h4 {
  font-size: 1.2rem;
  color: #00d9ff;
  margin-bottom: 20px;
  font-family: 'Orbitron', sans-serif;
}
.form-group {
  margin-bottom: 15px;
}
.form-group label {
  display: block;
  margin-bottom: 8px;
  font-weight: 500;
  color: #a0aec0;
}
.form-control-checkout {
  width: 100%;
  padding: 12px;
  border-radius: 6px;
  border: 1px solid #3a475b;
  background: #161a27;
  color: #e0e0e0;
  font-size: 0.95rem;
}
.form-control-checkout:focus {
  border-color: #00d9ff;
  box-shadow: 0 0 0 2px rgba(0, 217, 255, 0.2);
  outline: none;
}
/* Sisa CSS bisa dibiarkan sama */
/* ... */
.checkout-container {
  max-width: 1100px;
  margin: 30px auto;
  padding: 25px;
  background-color: #161a27;
  color: #e8eff5;
  border-radius: 12px;
  font-family: 'Roboto', sans-serif;
  border: 1px solid rgba(0, 217, 255, 0.25);
  box-shadow: 0 6px 25px rgba(0, 217, 255, 0.1);
}

.checkout-container h2 {
  text-align: center;
  color: #00d9ff;
  font-family: 'Orbitron', sans-serif;
  margin-bottom: 30px;
  text-shadow: 0 0 8px rgba(0, 217, 255, 0.7);
  font-size: clamp(1.8rem, 4vw, 2.5rem);
}

.empty-cart-message {
  text-align: center;
  padding: 50px 20px;
  font-size: 1.2rem;
  color: #adb5bd;
  background-color: rgba(31, 41, 55, 0.5);
  border-radius: 8px;
  border: 1px solid #2d3748;
}

.table-responsive {
  overflow-x: auto;
  margin-bottom: 20px;
}

.checkout-table {
  width: 100%;
  border-collapse: collapse;
}

.checkout-table th, .checkout-table td {
  border: 1px solid #2d3748;
  padding: 12px 15px;
  text-align: left;
  vertical-align: middle;
}

.checkout-table th {
  background-color: #1f2937;
  color: #00d9ff;
  font-weight: 600;
  white-space: nowrap; 
}

.checkout-item-image {
  max-width: 70px;
  max-height: 70px;
  object-fit: contain;
  border-radius: 6px;
  background-color: #252f42;
  border: 1px solid #3a475b;
}

.qty-input {
  width: 65px;
  padding: 8px 10px;
  border-radius: 5px;
  border: 1px solid #3a475b;
  background: #1f2937;
  color: #e0e0e0;
  text-align: center;
}

.remove-item-button {
  background-color: transparent;
  color: #ff6b6b;
  border: 1px solid #ff6b6b;
  padding: 7px 12px;
  border-radius: 5px;
  cursor: pointer;
  font-size: 0.8rem;
}

.checkout-summary {
  margin-top: 30px;
  padding-top: 25px;
  border-top: 1px solid #2d3748;
}

.total-text {
  font-size: 1.4rem;
  font-weight: bold;
  color: #00d9ff;
  margin-bottom: 25px;
  text-align: right;
}

.checkout-summary button[type="submit"] { 
  padding: 14px 35px;
  background: linear-gradient(45deg, #00d9ff, #00aaff);
  color: #111622;
  border: none;
  border-radius: 8px;
  font-weight: bold;
  display: block; 
  margin: 0 auto; 
}
.checkout-summary button[type="submit"]:disabled {
  background: #4a5568;
  cursor: not-allowed;
}

.payment-loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(22, 26, 39, 0.9);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  z-index: 1050; 
  color: #e8eff5;
  backdrop-filter: blur(5px);
}

.spinner {
  border: 6px solid #3a475b;
  border-top: 6px solid #00d9ff;
  border-radius: 50%;
  width: 60px;
  height: 60px;
  animation: spin 1s linear infinite;
  margin-bottom: 20px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.payment-status-message {
  padding: 25px;
  margin: 30px auto;
  border-radius: 8px;
  text-align: center;
  max-width: 600px;
  line-height: 1.6;
}
.payment-status-message.success {
  background-color: #1f2937;
  border: 1px solid #28a745;
  color: #d4edda;
}
.payment-status-message.error {
  background-color: #1f2937;
  border: 1px solid #dc3545;
  color: #f8d7da;
}
.payment-status-message button.btn-small-action {
  margin-top: 20px;
  padding: 10px 22px;
  border-radius: 6px;
  cursor: pointer;
}
.payment-status-message.success button.btn-small-action { background-color: #28a745; color: white; border: none; }
.payment-status-message.error button.btn-small-action { background-color: #dc3545; color: white; border: none; }
</style>