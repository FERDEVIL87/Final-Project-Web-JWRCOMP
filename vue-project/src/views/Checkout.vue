<template>
  <div class="checkout-container">
    <h2>Checkout</h2>
    <form @submit.prevent="handleCheckout">
      <div class="table-responsive">
        <table class="checkout-table">
          <thead>
            <tr>
              <th>Nama Pesanan</th>
              <th>Harga</th>
              <th>Kategori</th>
              <th>Deskripsi</th>
              <th>Spesifikasi</th>
              <th>Jumlah</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in formItems" :key="item.id">
              <td data-label="Nama Pesanan">
                <input
                  v-model="item.name"
                  type="text"
                  required
                  placeholder="Nama Pesanan"
                  class="form-control"
                />
              </td>
              <td data-label="Harga">
                <input
                  v-model.number="item.price"
                  type="number"
                  min="0"
                  required
                  placeholder="Harga"
                  class="form-control"
                />
              </td>
              <td data-label="Kategori">
                <select v-model="item.category" required class="form-control">
                  <option disabled value="">Pilih Kategori</option>
                  <option>PC Rakitan</option>
                  <option>Laptop</option>
                  <option>Console</option>
                  <option>Hardware</option>
                </select>
              </td>
              <td data-label="Deskripsi">
                <input
                  v-model="item.description"
                  type="text"
                  required
                  placeholder="Deskripsi"
                  class="form-control"
                />
              </td>
              <td data-label="Spesifikasi">
                <input
                  v-model="item.specification"
                  type="text"
                  required
                  placeholder="Spesifikasi"
                  class="form-control"
                />
              </td>
              <td data-label="Jumlah">
                <input
                  v-model.number="item.qty"
                  type="number"
                  min="1"
                  required
                  class="form-control"
                />
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <p class="total-text"><strong>Total: Rp{{ totalPrice.toLocaleString() }}</strong></p>
      <button type="submit" :disabled="formItems.length === 0">Bayar Sekarang</button>
    </form>
  </div>
</template>

<script>
export default {
  name: "Checkout",
  data() {
    return {
      formItems: [
        {
          id: 1,
          name: " ",
          qty: 1,
          price: 0,
          category: " ",
          description: " ",
          specification: " "
        }
      ]
    };
  },
  computed: {
    totalPrice() {
      return this.formItems.reduce((sum, item) => sum + item.price * item.qty, 0);
    }
  },
  methods: {
    handleCheckout() {
      if (this.formItems.length === 0) {
        alert("Keranjang kosong!");
        return;
      }
      // Simulasi pembayaran
      alert(
        "Pembayaran berhasil!\nTotal: Rp" +
          this.totalPrice.toLocaleString() +
          "\n\nDetail Pesanan:\n" +
          this.formItems
            .map(
              (item) =>
                `${item.name} (${item.category})\nDeskripsi: ${item.description}\nSpesifikasi: ${item.specification}\nQty: ${item.qty}\nHarga: Rp${item.price.toLocaleString()}`
            )
            .join("\n\n")
      );
      this.formItems = [];
    }
  }
};
</script>

<style scoped>
.checkout-container {
  max-width: 900px;
  margin: 40px auto;
  background: #222;
  color: #fff;
  padding: 24px;
  border-radius: 8px;
  box-sizing: border-box;
}
.table-responsive {
  width: 100%;
  overflow-x: auto;
}
.checkout-table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 16px;
  background: transparent;
}
.checkout-table th,
.checkout-table td {
  border: 1px solid #444;
  padding: 8px 12px;
  text-align: left;
  vertical-align: top;
}
.checkout-table th {
  background: #333;
}
input,
select {
  width: 100%;
  padding: 4px 8px;
  border-radius: 4px;
  border: 1px solid #555;
  background: #333;
  color: #fff;
  box-sizing: border-box;
}
button {
  margin-top: 16px;
  padding: 10px 24px;
  background: #00bcd4;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-weight: bold;
  cursor: pointer;
  width: 100%;
  max-width: 300px;
  display: block;
  margin-left: auto;
  margin-right: auto;
}
button:disabled {
  background: #888;
  cursor: not-allowed;
}
.total-text {
  text-align: right;
  margin-bottom: 0;
  font-size: 1.1rem;
}

/* RESPONSIVE: Ubah tabel jadi card pada layar kecil */
@media (max-width: 700px) {
  .checkout-container {
    padding: 10px;
    margin: 16px 4px;
  }
  .checkout-table,
  .checkout-table thead,
  .checkout-table tbody,
  .checkout-table tr {
    display: block;
    width: 100%;
  }
  .checkout-table thead {
    display: none;
  }
  .checkout-table tr {
    margin-bottom: 18px;
    border-radius: 6px;
    background: #292929;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    border: 1px solid #333;
    padding: 8px 0;
  }
  .checkout-table td {
    display: flex;
    align-items: center;
    border: none;
    border-bottom: 1px solid #444;
    padding: 8px 10px;
    position: relative;
  }
  .checkout-table td:last-child {
    border-bottom: none;
  }
  .checkout-table td::before {
    content: attr(data-label) ": ";
    font-weight: bold;
    min-width: 110px;
    color: #00bcd4;
    flex-shrink: 0;
    margin-right: 8px;
    font-size: 0.98em;
  }
  .total-text {
    text-align: left;
    font-size: 1rem;
    margin-top: 10px;
  }
  button {
    font-size: 1rem;
    padding: 10px 0;
  }
}
</style>