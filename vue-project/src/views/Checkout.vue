<template>
  <div class="checkout-container">
    <h2>Checkout</h2>
    <form @submit.prevent="handleCheckout">
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
            <td>
              <input
                v-model="item.name"
                type="text"
                required
                placeholder="Nama Pesanan"
                class="form-control"
              />
            </td>
            <td>
              <input
                v-model.number="item.price"
                type="number"
                min="0"
                required
                placeholder="Harga"
                class="form-control"
              />
            </td>
            <td>
              <select v-model="item.category" required class="form-control">
                <option disabled value="">Pilih Kategori</option>
                <option>PC Rakitan</option>
                <option>Laptop</option>
                <option>Console</option>
                <option>Hardware</option>
              </select>
            </td>
            <td>
              <input
                v-model="item.description"
                type="text"
                required
                placeholder="Deskripsi"
                class="form-control"
              />
            </td>
            <td>
              <input
                v-model="item.specification"
                type="text"
                required
                placeholder="Spesifikasi"
                class="form-control"
              />
            </td>
            <td>
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
      <p><strong>Total: Rp{{ totalPrice.toLocaleString() }}</strong></p>
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
          jumlah: 0,
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
      return this.formItems.reduce((sum, item) => sum + item.price * item.jumlah, 0);
    }
  },
  methods: {
    handleCheckout() {
      if (
        this.formItems.length === 0 ||
        this.formItems.some(
          item =>
            !item.name ||
            !item.category ||
            !item.description ||
            !item.specification ||
            !item.qty ||
            !item.price
        )
      ) {
        alert("Semua kolom pesanan harus diisi dengan benar!");
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
                `\nNama Pesanan: (${item.name})\nKategori: (${item.category})\nDeskripsi: ${item.description}\nSpesifikasi: ${item.specification}\nJumlah: ${item.qty}\nHarga: Rp${item.price.toLocaleString()}`
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
}
.checkout-table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 16px;
}
.checkout-table th,
.checkout-table td {
  border: 1px solid #444;
  padding: 8px 12px;
  text-align: left;
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
}
button:disabled {
  background: #888;
  cursor: not-allowed;
}
</style>