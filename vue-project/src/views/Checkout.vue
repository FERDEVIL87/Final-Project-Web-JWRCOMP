<template>
  <div class="checkout-container">
    <h2>Checkout Pesanan</h2>

    <div v-if="isLoadingPayment" class="payment-loading-overlay">
      <div class="spinner"></div>
      <p>Memproses pembayaran Anda...</p>
    </div>

    <div v-if="paymentStatusMessage" :class="['payment-status-message', paymentSuccess ? 'success' : 'error']">
      <p v-html="paymentStatusMessage.replace(/\n/g, '<br>')"></p> <!-- Allow line breaks in status -->
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
      <form @submit.prevent="handleFinalCheckout" v-else>
        <div class="table-responsive">
          <table class="checkout-table">
            <thead>
              <tr>
                <th>Gambar</th>
                <th>Nama Pesanan & Asal</th> 
                <th>Kategori</th>
                <th>Brand</th>
                <th>Harga Satuan</th>
                <th>Jumlah</th>
                <th>Subtotal</th>
                <th>Aksi</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="item in cartStore.items" :key="`${item.source}-${item.id}`">
                <td data-label="Gambar">
                  <img v-if="item.image" :src="item.image" :alt="item.name" class="checkout-item-image"/>
                  <span v-else class="no-image-placeholder">No Image</span>
                </td>
                <td data-label="Nama Pesanan & Asal">
                  {{ item.name }}
                  <div class="item-source-display">
                    <small><em>Dari: {{ getSourceDisplayName(item.source) }}</em></small>
                  </div>
                  <div v-if="item.source === 'rakitan_kustom' && item.specification && typeof item.specification.parts === 'object'" class="specs-list-checkout">
                    <small><i>Rakitan Kustom:</i></small>
                    <ul>
                      <li v-for="(partDetail, partKey) in item.specification.parts" :key="partKey">
                        <small v-if="partDetail"><em>{{ partKey }}: {{ partDetail.name }}</em></small>
                      </li>
                    </ul>
                  </div>
                  <div v-else-if="item.specification && typeof item.specification === 'string' && item.specification.length > 0" class="specs-list-checkout">
                    <small><em>Spesifikasi: {{ item.specification.substring(0, 50) }}{{ item.specification.length > 50 ? '...' : '' }}</em></small>
                  </div>
                </td>
                <td data-label="Kategori">{{ item.category }}</td>
                <td data-label="Brand">{{ item.brand || '-' }}</td>
                <td data-label="Harga Satuan">Rp{{ (Number(item.price) || 0).toLocaleString('id-ID') }}</td>
                <td data-label="Jumlah">
                  <input
                    type="number"
                    :value="item.qty"
                    @input="updateQuantity(`${item.source}-${item.id}`, $event.target.value)"
                    min="1"
                    class="qty-input"
                    :disabled="isLoadingPayment"
                  />
                </td>
                <td data-label="Subtotal">Rp{{ ((Number(item.price) || 0) * (Number(item.qty) || 0)).toLocaleString('id-ID') }}</td>
                <td data-label="Aksi">
                  <button
                    type="button"
                    @click="removeItem(`${item.source}-${item.id}`)"
                    class="remove-item-button"
                    :disabled="isLoadingPayment"
                  >
                    Hapus
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="checkout-summary">
          <div class="payment-method-selection">
            <h4>Pilih Metode Pembayaran (Simulasi)</h4>
            <select v-model="selectedPaymentMethod" :disabled="isLoadingPayment" class="payment-select">
              <option value="cc">Kartu Kredit/Debit</option>
              <option value="bank_transfer">Transfer Bank (Virtual Account)</option>
              <option value="ewallet">E-Wallet (GoPay/OVO/Dana)</option>
              <option value="cod">Bayar di Tempat (COD)</option>
            </select>
          </div>
          <p class="total-text"><strong>Total Keseluruhan: Rp{{ cartStore.totalPrice.toLocaleString('id-ID') }}</strong></p>
          <button type="submit" :disabled="cartStore.items.length === 0 || isLoadingPayment">
            {{ isLoadingPayment ? 'Memproses...' : 'Bayar Sekarang' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { cartStore } from '@/store/cartStore';

export default {
  name: "Checkout",
  data() {
    return {
      isLoadingPayment: false,
      paymentStatusMessage: '',
      paymentSuccess: false,
      selectedPaymentMethod: 'cc', 
    };
  },
  computed: {
    cartStore() {
      return cartStore;
    }
  },
  methods: {
    getSourceDisplayName(sourceKey) {
      const sourceMap = {
        'console': 'Game Consoles Hub',
        'hardware': 'Komponen Hardware',
        'laptop': 'Toko Laptop',
        'paket_rakitan': 'Paket Rakitan PC',
        'rakitan_kustom': 'Simulasi Rakitan Kustom',
      };
      return sourceMap[sourceKey] || sourceKey.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
    },
    updateQuantity(compositeId, newQuantity) {
      const qty = parseInt(newQuantity, 10);
      if (!isNaN(qty) && qty >= 1) { 
        cartStore.updateItemQuantity(compositeId, qty);
      } else if (!isNaN(qty) && qty < 1) {
        const item = cartStore.items.find(i => `${i.source}-${i.id}` === compositeId);
        if(item) item.qty = 1;
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
        if (this.$router) {
            this.$router.push('/');
        }
    },
    async mockPaymentGateway(orderDetails, paymentMethod) {
      return new Promise((resolve, reject) => {
        console.log("Mengirim ke Payment Gateway (Simulasi):", { orderDetails, paymentMethod });
        setTimeout(() => {
          const isSuccess = Math.random() > 0.1;
          if (isSuccess) {
            resolve({
              transactionId: `TRX-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
              message: `Pembayaran dengan metode ${paymentMethod.replace('_', ' ').toUpperCase()} berhasil!`,
              status: 'success'
            });
          } else {
            let failMessage = `Pembayaran gagal. `;
            if (paymentMethod === 'cod') {
                failMessage += 'Layanan COD tidak tersedia untuk pesanan Anda atau area Anda saat ini.';
            } else if (paymentMethod === 'ewallet') {
                failMessage += 'Saldo E-Wallet tidak mencukupi atau terjadi gangguan pada layanan E-Wallet.';
            } else {
                failMessage += 'Silakan coba lagi beberapa saat atau gunakan metode pembayaran lain.';
            }
            reject({
              message: failMessage,
              status: 'failed'
            });
          }
        }, 2500);
      });
    },
    async handleFinalCheckout() {
      if (cartStore.items.length === 0) {
        alert("Keranjang kosong!");
        return;
      }

      this.isLoadingPayment = true;
      this.paymentStatusMessage = '';

      const orderPayload = {
        orderId: `ORDER-${Date.now()}`,
        items: cartStore.items.map(item => ({
          productId: item.id,
          source: item.source,
          sourceDisplay: this.getSourceDisplayName(item.source),
          name: item.name,
          quantity: item.qty,
          unitPrice: item.price,
          category: item.category,
          brand: item.brand,
          image: item.image,
          specification: item.specification 
        })),
        totalAmount: cartStore.totalPrice,
        currency: 'IDR',
        customerInfo: {
          name: 'Pelanggan JWR', 
          email: 'customer@example.com', 
        },
        paymentMethod: this.selectedPaymentMethod,
        timestamp: new Date().toISOString()
      };

      try {
        const paymentResponse = await this.mockPaymentGateway(orderPayload, this.selectedPaymentMethod);
        this.paymentSuccess = true;
        let successDetails = `ID Transaksi: ${paymentResponse.transactionId}\n`
        successDetails += `Metode Pembayaran: ${this.selectedPaymentMethod.replace('_', ' ').toUpperCase()}\n`
        successDetails += `Total Pembayaran: Rp${orderPayload.totalAmount.toLocaleString('id-ID')}\n\n`
        successDetails += `Terima kasih telah berbelanja di JWR Comp! Pesanan Anda akan segera kami proses.`

        this.paymentStatusMessage = `${paymentResponse.message}\n\n${successDetails}`;
        cartStore.clearCart();
        console.log("Payment successful. Response:", paymentResponse);
        console.log("Order details sent:", orderPayload);

      } catch (error) {
        this.paymentSuccess = false;
        this.paymentStatusMessage = error.message || 'Terjadi kesalahan teknis saat memproses pembayaran. Mohon coba kembali.';
        console.error("Payment failed. Error:", error);
        console.log("Order details attempted:", orderPayload);
      } finally {
        this.isLoadingPayment = false;
      }
    }
  }
};
</script>

<style scoped>
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
.empty-cart-message p {
  margin-bottom: 15px;
}

.table-responsive {
  overflow-x: auto;
  margin-bottom: 20px;
}

.checkout-table {
  width: 100%;
  border-collapse: collapse;
}

.checkout-table th,
.checkout-table td {
  border: 1px solid #2d3748;
  padding: 12px 15px;
  text-align: left;
  vertical-align: middle;
}

.checkout-table th {
  background-color: #1f2937;
  color: #00d9ff;
  font-weight: 600;
  font-size: 0.9rem;
  text-transform: uppercase;
  white-space: nowrap; 
}

.checkout-item-image {
  max-width: 70px;
  max-height: 70px;
  object-fit: contain;
  border-radius: 6px;
  background-color: #252f42;
  padding: 4px;
  border: 1px solid #3a475b;
}
.no-image-placeholder {
  display: inline-block;
  width: 70px;
  height: 70px;
  line-height: 70px;
  text-align: center;
  background-color: #252f42;
  color: #718096;
  font-size: 0.75rem;
  border-radius: 6px;
  border: 1px solid #3a475b;
}

.item-source-display {
  font-size: 0.8em;
  color: #89a5c1;
  margin-top: 4px;
  display: block; 
}
.item-source-display em {
  font-style: normal;
}


.qty-input {
  width: 65px;
  padding: 8px 10px;
  border-radius: 5px;
  border: 1px solid #3a475b;
  background: #1f2937;
  color: #e0e0e0;
  text-align: center;
  font-size: 0.9rem;
}
.qty-input:focus {
  border-color: #00d9ff;
  box-shadow: 0 0 0 2px rgba(0, 217, 255, 0.2);
  outline: none;
}

.remove-item-button {
  background-color: transparent;
  color: #ff6b6b;
  border: 1px solid #ff6b6b;
  padding: 7px 12px;
  border-radius: 5px;
  cursor: pointer;
  font-size: 0.8rem;
  transition: background-color 0.2s, color 0.2s;
}
.remove-item-button:hover {
  background-color: #ff6b6b;
  color: #161a27;
}

.checkout-summary {
  margin-top: 30px;
  padding-top: 25px;
  border-top: 1px solid #2d3748;
}

.payment-method-selection {
  margin-bottom: 25px;
  text-align: left;
  padding: 20px;
  background-color: #1f2937; 
  border-radius: 8px;
  border: 1px solid #2d3748;
}
.payment-method-selection h4 {
  font-size: 1.1rem;
  color: #00d9ff;
  margin-bottom: 15px;
  font-family: 'Orbitron', sans-serif;
}
.payment-select {
  width: 100%;
  max-width: 400px;
  padding: 10px 12px;
  border-radius: 6px;
  border: 1px solid #3a475b;
  background: #161a27;
  color: #e0e0e0;
  font-size: 0.95rem;
}
.payment-select:focus {
  border-color: #00d9ff;
  box-shadow: 0 0 0 2px rgba(0, 217, 255, 0.2);
  outline: none;
}


.total-text {
  font-size: 1.4rem;
  font-weight: bold;
  color: #00d9ff;
  margin-bottom: 25px;
  text-align: right;
}
.total-text strong {
  color: #fff;
}

.checkout-summary button[type="submit"] { 
  padding: 14px 35px;
  background: linear-gradient(45deg, #00d9ff, #00aaff);
  color: #111622;
  border: none;
  border-radius: 8px;
  font-weight: bold;
  font-size: 1.05rem;
  cursor: pointer;
  transition: background 0.3s, transform 0.2s, box-shadow 0.3s;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  box-shadow: 0 4px 15px rgba(0, 170, 255, 0.2);
  display: block; 
  margin: 0 auto; 
  min-width: 250px; 
}
.checkout-summary button[type="submit"]:disabled {
  background: #4a5568;
  color: #a0aec0;
  cursor: not-allowed;
  box-shadow: none;
  opacity: 0.7;
}
.checkout-summary button[type="submit"]:hover:not(:disabled) {
  background: linear-gradient(45deg, #00c6ff, #0099ff);
  transform: translateY(-2px) scale(1.02);
  box-shadow: 0 6px 20px rgba(0, 170, 255, 0.3);
}

.specs-list-checkout {
  margin-top: 5px;
}
.specs-list-checkout ul {
  padding-left: 15px;
  margin: 5px 0 0 0;
  list-style-type: "- ";
  font-size: 0.8rem;
  color: #a0aec0;
}
.specs-list-checkout li {
  margin-bottom: 3px;
}
.specs-list-checkout small i {
    color: #00d9ff;
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

.payment-loading-overlay p {
  font-size: 1.1rem;
  font-family: 'Orbitron', sans-serif;
  letter-spacing: 0.5px;
}

.payment-status-message {
  padding: 25px;
  margin: 30px auto;
  border-radius: 8px;
  text-align: center;
  font-size: 1.1rem;
  max-width: 600px;
  box-shadow: 0 4px 15px rgba(0,0,0,0.2);
  line-height: 1.6;
}
.payment-status-message.success {
  background-color: #1f2937;
  border: 1px solid #28a745;
  color: #a8dbb3;
}
.payment-status-message.success p {
  color: #d4edda;
}
.payment-status-message.error {
  background-color: #1f2937;
  border: 1px solid #dc3545;
  color: #f0b6bc;
}
.payment-status-message.error p {
  color: #f8d7da;
}

.payment-status-message button.btn-small-action {
    margin-top: 20px;
    padding: 10px 22px;
    font-size: 0.95rem;
    border-radius: 6px;
    cursor: pointer;
    transition: background-color 0.2s, transform 0.1s;
    font-weight: 500;
}
.payment-status-message.success button.btn-small-action {
    background-color: #28a745;
    color: white;
    border: none;
}
.payment-status-message.success button.btn-small-action:hover {
    background-color: #218838;
    transform: translateY(-1px);
}
.payment-status-message.error button.btn-small-action {
    background-color: #dc3545;
    color: white;
    border: none;
}
.payment-status-message.error button.btn-small-action:hover {
    background-color: #c82333;
    transform: translateY(-1px);
}


form {
    transition: opacity 0.3s ease-in-out;
}

@media (max-width: 800px) {
  .checkout-container h2 {
    font-size: clamp(1.6rem, 5vw, 2rem);
  }
  .checkout-table thead {
    display: none;
  }
  .checkout-table, .checkout-table tbody, .checkout-table tr, .checkout-table td {
    display: block;
    width: 100%;
  }
  .checkout-table tr {
    margin-bottom: 20px;
    border: 1px solid #2d3748;
    border-radius: 8px;
    padding: 15px;
    background-color: #1f2937;
  }
  .checkout-table td {
    display: flex;
    justify-content: space-between;
    align-items: center;
    text-align: right;
    padding: 10px 0;
    position: relative;
    border: none;
    border-bottom: 1px dotted #3a475b;
  }
  .checkout-table td:last-child {
    border-bottom: none;
  }
  .checkout-table td::before {
    content: attr(data-label);
    text-align: left;
    font-weight: bold;
    color: #00d9ff;
    margin-right: 10px;
    flex-shrink: 0; 
    min-width: 100px; 
  }
  .checkout-item-image, .no-image-placeholder {
    max-width: 50px;
    max-height: 50px;
  }
  .item-source-display {
    text-align: right; 
    margin-top: 0;
    margin-left: 5px;
    font-size: 0.75em;
  }
  .checkout-table td[data-label="Nama Pesanan & Asal"] {
    flex-wrap: wrap;
  }
  .checkout-table td[data-label="Nama Pesanan & Asal"] > .item-source-display {
    width: 100%;
    text-align: right; 
    margin-top: 3px;
  }

  .qty-input {
    width: 50px;
    padding: 6px;
  }
  .total-text { font-size: 1.2rem; text-align: center;}
  .checkout-summary button[type="submit"] { font-size: 0.95rem; padding: 12px 25px; width: 100%; max-width: 300px; }
  .payment-method-selection { padding: 15px; }
  .payment-method-selection h4 { font-size: 1rem; }
  .payment-select { max-width: none; } 
}
</style>