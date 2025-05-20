<template>
  <section class="container py-5">
    <h2
      class="text-center fw-bold mb-4"
      style="font-family: 'Orbitron', sans-serif; text-shadow: 0 0 8px #00eaff, 0 0 18px #00eaff; color: #fff;"
    >
      HARDWARE <!-- //DIDIT// -->
    </h2>
    <!-- Loading indicator -->
    <div v-if="loading" class="text-center text-info py-5" style="font-family: 'Orbitron', sans-serif;">
      <span>Loading data hardware...</span>
    </div>
    <template v-else>
      <div class="d-flex flex-wrap justify-content-center gap-3 mb-4">
        <button
          v-for="(card, index) in cards"
          :key="index"
          class="btn btn-outline-info px-4 py-2 fw-bold"
          :class="{
            active: selectedCategory && selectedCategory.title === card.title,
            'bg-info border-info': selectedCategory && selectedCategory.title === card.title,
            'text-white': selectedCategory && selectedCategory.title === card.title
          }"
          :style="{
            fontFamily: '\'Orbitron\', sans-serif',
            letterSpacing: '0.04em',
            color: selectedCategory && selectedCategory.title === card.title ? '#fff' : '' //DIDIT//
          }"
          @click="selectCategory(card)"
        >
          {{ card.title }}
        </button>
      </div>

      <div v-if="selectedCategory" class="bg-dark bg-opacity-75 rounded-4 shadow p-4 mb-4">
        <h3
          class="text-center fw-bold mb-3"
          :style="{
            fontFamily: '\'Orbitron\', sans-serif',
            textShadow: '0 0 8px #00eaff',
            color: '#fff'
          }"
        >
          {{ selectedCategory.title }}
        </h3>
        <div class="row g-2 align-items-center mb-3">
          <div class="col-12 col-md-4 mb-2 mb-md-0">
            <input
              type="text"
              v-model="searchQuery"
              placeholder="Search Component"
              class="form-control bg-secondary bg-opacity-25 border-info text-white"
              style="background: #222; color: #fff;"
            />
          </div>
          <div class="col-12 col-md-4 mb-2 mb-md-0">
            <select
              v-model="selectedBrand"
              class="form-select bg-secondary bg-opacity-25 border-info text-white"
              :class="{'text-white': selectedBrand === '', 'text-light': selectedBrand !== ''}"
              style="background: #222; color: #fff;"
            >
              <option value="" class="text-white" style="background: #222; color: #fff;">All Brands</option>
              <option v-for="brand in filteredBrands" :key="brand" :value="brand" class="text-white" style="background: #222; color: #fff;">{{ brand }}</option>
            </select>
          </div>
          <div class="col-md-4">
            <select v-model="sortBy" class="form-select mb-2" style="background-color: #23272b; color: #fff; border-color: #17a2b8;">
              <option disabled value="">Urutkan</option>
              <option v-for="opt in sortOptions" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
            </select>
          </div>
        </div>
        <!-- //DIDIT// Start Price Range Filter dengan 2 slider -->
        <div class="row align-items-center mb-3">
          <div class="col-12">
            <label class="form-label text-white d-block mb-2">Rentang Harga</label>
            <div class="mb-2">
              <div class="d-flex align-items-center">
                <span class="me-3 text-white" style="min-width: 140px; text-align: left; font-variant-numeric: tabular-nums;">Min: {{ formatPrice(minPriceFilter) }}</span>
                <input
                  type="range"
                  class="form-range"
                  :min="minSliderBound"
                  :max="maxSliderBound"
                  v-model.number="minPriceFilter"
                  :step="priceStep"
                  style="accent-color: #00eaff;"
                  id="minPriceRange"
                />
              </div>
            </div>
            <div class="mb-2">
              <div class="d-flex align-items-center">
                <span class="me-3 text-white" style="min-width: 140px; text-align: left; font-variant-numeric: tabular-nums;">Max: {{ formatPrice(maxPriceFilter) }}</span>
                <input
                  type="range"
                  class="form-range"
                  :min="minSliderBound"
                  :max="maxSliderBound"
                  v-model.number="maxPriceFilter"
                  :step="priceStep"
                  style="accent-color: #00eaff;"
                  id="maxPriceRange"
                />
              </div>
            </div>
            <div class="d-flex justify-content-between text-white mt-1 px-1">
              <span class="small">Range: {{ formatPrice(minSliderBound) }} - {{ formatPrice(maxSliderBound) }}</span>
            </div>
          </div>
        </div>
        <!-- //DIDIT// End Price Range Filter -->

        <div v-if="filteredConsoles.length > 0" class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4 mt-2">
          <div
            v-for="consoleItem in filteredConsoles"
            :key="consoleItem.id"
            class="col"
          >
            <div
              class="card h-100 bg-secondary bg-opacity-75 border-info shadow-sm text-light cursor-pointer"
              role="button"
              tabindex="0"
              @click.stop="showDetails(consoleItem)"
              @keydown.enter.prevent="showDetails(consoleItem)"
              @keydown.space.prevent="showDetails(consoleItem)"
              @mouseover="hover = consoleItem.id"
              @mouseleave="hover = null"
              :style="hover === consoleItem.id ? 'transform: translateY(-4px) scale(1.03); box-shadow: 0 6px 24px #00eaff88; border-color: #00eaff;' : ''"
            >
              <img :src="consoleItem.image" :alt="consoleItem.name" class="card-img-top" style="height: 140px; object-fit: cover; background: #101829;" />
              <div class="card-body">
                <h4
                  class="card-title fw-bold mb-1"
                  :style="{
                    fontFamily: '\'Orbitron\', sans-serif',
                    textShadow: '0 0 6px #00eaff, 0 0 12px #00eaff',
                    color: '#fff'
                  }"
                >{{ consoleItem.name }}</h4>
                <p class="mb-1"><span class="fw-semibold">Brand:</span> {{ consoleItem.brand }}</p>
                <p class="mb-1">
                  <span class="fw-semibold">Stock:</span>
                  <span :class="getStockClass(consoleItem.stock)">
                    {{ consoleItem.stock }}
                  </span>
                </p>
                <p class="fw-bold mb-0">{{ formatPrice(consoleItem.price) }}</p>
              </div>
            </div>
          </div>
        </div>
        <div v-else class="text-center text-info py-5" style="font-family: 'Orbitron', sans-serif;">
          <p>No consoles match your current filters.</p>
        </div>
      </div>
      <div v-else class="text-center text-info py-5" style="font-family: 'Orbitron', sans-serif;">
        <p>✨ Please select a category above to explore our awesome consoles! ✨</p>
      </div>

      <!-- //DIDIT// Modal Dikelola oleh JS -->
      <div class="modal fade" id="consoleDetailModal" tabindex="-1" aria-labelledby="consoleDetailModalLabel" aria-hidden="true" ref="consoleModalRef">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content bg-dark text-light position-relative">
            <div class="modal-header border-0 pb-0">
              <h3
                class="modal-title w-100 text-center fw-bold"
                id="consoleDetailModalLabel"
                style="font-family: 'Orbitron', sans-serif; text-shadow: 0 0 8px #00eaff; color: #fff;"
              >
                {{ selectedProduct?.name }}
              </h3>
              <button type="button" class="btn-close btn-close-white" aria-label="Close" @click="closeDetails"></button>
            </div>
            <div class="modal-body">
              <img :src="selectedProduct?.image" :alt="selectedProduct?.name" class="d-block mx-auto mb-3 rounded" style="max-width: 280px; max-height: 180px; object-fit: contain; background: #101829;" />
              <div class="mb-3">
                <p class="mb-1"><strong>Price:</strong> <span>{{ formatPrice(selectedProduct?.price) }}</span></p>
                <p class="mb-1"><strong>Brand:</strong> <span>{{ selectedProduct?.brand }}</span></p>
                <p class="mb-1"><strong>Stock:</strong> <span :class="getStockClass(selectedProduct?.stock)">{{ selectedProduct?.stock }}</span></p>
              </div>
              <div v-if="selectedProduct?.specs && selectedProduct?.specs.length > 0">
                <p class="fw-bold text-info mb-1">Features:</p>
                <ul class="ps-3 mb-0">
                  <li v-for="(feature, index) in selectedProduct.specs" :key="index">{{ feature }}</li>
                </ul>
              </div>
              <!-- //DIDIT// Tambah Jumlah dan Tombol Keranjang -->
              <div v-if="selectedProduct && selectedProduct.stock === 'Ready'" class="mt-4">
                <div class="row g-2 align-items-center justify-content-center">
                  <div class="col-auto">
                    <label for="itemQuantity" class="form-label text-white mb-0 me-2">Jumlah:</label>
                  </div>
                  <div class="col-auto" style="max-width: 100px;">
                    <input 
                      type="number" 
                      id="itemQuantity" 
                      class="form-control form-control-sm text-center bg-secondary bg-opacity-25 border-info text-white"
                      v-model.number="itemQuantity"
                      min="1"
                      style="background: #222; color: #fff;"
                    >
                  </div>
                </div>
                <button 
                  class="btn btn-info w-100 mt-3 fw-bold"
                  style="font-family: 'Orbitron', sans-serif; letter-spacing: 0.04em;"
                  @click="addToCart"
                  :disabled="itemQuantity < 1"
                >
                  🛒 Tambah ke Keranjang
                </button>
              </div>
              <div v-else-if="selectedProduct && selectedProduct.stock !== 'Ready'" class="mt-4 text-center">
                <p class="text-danger fw-bold">Produk tidak tersedia untuk ditambahkan ke keranjang.</p>
              </div>
              <!-- //DIDIT// End Tambah Jumlah dan Tombol Keranjang -->
            </div>
          </div>
        </div>
      </div>
    </template>
  </section>
</template>

<script>
import { Modal } from 'bootstrap';

export default {
  name: "HardwareHub", // //DIDIT// Ganti nama komponen
  data() {
    return {
      cards: [
        // ... (isi kartu kategori Anda tetap sama)
        { title: "PROCESSOR INTEL", link: "/PROCESSOR INTEL" },
        { title: "PROCESSOR AMD", link: "/PROCESSOR AMD" },
        { title: "MAINBOARD", link: "/MAINBOARD" },
        { title: "MEMORY", link: "/MEMORY" },
        { title: "VGA", link: "/VGA" },
        { title: "HDD", link: "/HDD" },
        { title: "SSD", link: "/SSD" },
        { title: "PSU", link: "/PSU" },
        { title: "CASE", link: "/CASE" },
        { title: "LED MONITOR", link: "/LED MONITOR" },
        { title: "MOUSE", link: "/MOUSE" },
        { title: "KEYBOARD", link: "/KEYBOARD" },
        { title: "MOUSEPAD", link: "/MOUSEPAD" },
        { title: "WEBCAM", link: "/WEBCAM" },
        { title: "CABLE", link: "/CABLE" },
        { title: "HEADSET", link: "/HEADSET" },
        { title: "SPEAKER", link: "/SPEAKER" },
        { title: "USB FLASHDISK", link: "/USB FLASHDISK" },
        { title: "PRINTER", link: "/PRINTER" },
      ],
      selectedCategory: null,
      searchQuery: "",
      selectedBrand: "",
      // //DIDIT// Data untuk filter harga
      minPriceFilter: 0,    // Nilai minimum filter harga yang dipilih pengguna
      maxPriceFilter: 1500, // Nilai maksimum filter harga yang dipilih pengguna (beri nilai default awal)
      minSliderBound: 0,    // Batas bawah absolut untuk slider harga
      maxSliderBound: 1500, // Batas atas absolut untuk slider harga (akan diupdate)
      priceStep: 50,        // Step untuk slider harga
      // usdToIdrRate: 15000, // Tidak digunakan jika harga sudah dalam IDR
      selectedProduct: null,
      bootstrapModalInstance: null,
      hover: null,
      // isModalOpen: false, // Tidak diperlukan jika dikelola Bootstrap
      sortBy: 'lowToHigh',
      sortOptions: [
        { value: 'lowToHigh', label: 'Harga Termurah' },
        { value: 'highToLow', label: 'Harga Termahal' },
        // { value: 'populer', label: 'Paling Populer' }, // Implementasi populer nanti
        // { value: 'tidakPopuler', label: 'Paling Tidak Populer' } // Implementasi tidak populer nanti
      ],
      components: [], 
      loading: true,
      itemQuantity: 1, // //DIDIT// Jumlah item di modal
    };
  },
  computed: {
    // //DIDIT// ganti nama 'consoles' menjadi 'hardwareItems' agar lebih generik
    hardwareItems() {
      return this.components;
    },
    // //DIDIT// ganti nama 'brands' menjadi 'allBrandsInCategory'
    allBrandsInCategory() {
      if (!this.selectedCategory || !this.hardwareItems.length) return [];
      const itemsInCategory = this.hardwareItems.filter(c => c.category === this.selectedCategory.title);
      return [...new Set(itemsInCategory.map(c => c.brand))].sort();
    },
    // //DIDIT// ganti nama 'filteredBrands' menjadi 'availableBrandsForFilter' (sama dengan di atas, bisa disatukan)
    availableBrandsForFilter() { // Sebenarnya sama dengan allBrandsInCategory, bisa pakai satu saja
      return this.allBrandsInCategory;
    },
    filteredConsoles() { // //DIDIT// Sebaiknya ganti nama ini juga menjadi filteredHardwareItems
      if (!this.selectedCategory || !this.hardwareItems.length) return [];
      let filtered = this.hardwareItems.filter(
        c => c.category === this.selectedCategory.title
      );
      if (this.searchQuery) {
        filtered = filtered.filter(c =>
          c.name.toLowerCase().includes(this.searchQuery.toLowerCase())
        );
      }
      if (this.selectedBrand) {
        filtered = filtered.filter(c => c.brand === this.selectedBrand);
      }
      // //DIDIT// Filter berdasarkan minPriceFilter dan maxPriceFilter
      filtered = filtered.filter(c => c.price >= this.minPriceFilter && c.price <= this.maxPriceFilter);
      
      // Sorting
      if (this.sortBy === 'highToLow') {
        filtered.sort((a, b) => b.price - a.price);
      } else if (this.sortBy === 'lowToHigh') { // //DIDIT// Tambahkan sorting lowToHigh
         filtered.sort((a, b) => a.price - b.price);
      }
      // Tambahkan logika sorting lain jika ada (populer, dll)
      return filtered;
    },
    // //DIDIT// Hapus maxPriceInCategory dan minPriceInCategory, kita pakai sliderBound
  },
  methods: {
    // //DIDIT// Method untuk menginisialisasi batas slider dan nilai filter
    initializePriceFilters() {
      if (!this.selectedCategory || !this.hardwareItems.length) {
        this.minSliderBound = 0;
        this.maxSliderBound = 1500; // Default jika tidak ada item
        this.minPriceFilter = 0;
        this.maxPriceFilter = 1500;
        return;
      }
      const itemsInCategory = this.hardwareItems.filter(
        c => c.category === this.selectedCategory.title
      );
      if (itemsInCategory.length === 0) {
        this.minSliderBound = 0;
        this.maxSliderBound = 1500;
        this.minPriceFilter = 0;
        this.maxPriceFilter = 1500;
        return;
      }
      
      const prices = itemsInCategory.map(c => c.price);
      this.minSliderBound = Math.min(...prices, 0);
      this.maxSliderBound = Math.max(...prices, 0);

      // Pembulatan ke step terdekat
      this.minSliderBound = Math.floor(this.minSliderBound / this.priceStep) * this.priceStep;
      this.maxSliderBound = Math.ceil(this.maxSliderBound / this.priceStep) * this.priceStep;
      
      if (this.minSliderBound > this.maxSliderBound) { // Kasus jika hanya ada 1 produk atau semua harga sama
        this.maxSliderBound = this.minSliderBound + this.priceStep; // Pastikan max selalu lebih besar atau sama
      }


      this.minPriceFilter = this.minSliderBound;
      this.maxPriceFilter = this.maxSliderBound;
    },
    selectCategory(category) {
      this.selectedCategory = category;
      this.searchQuery = "";
      this.selectedBrand = "";
      // //DIDIT// Panggil inisialisasi filter harga setelah kategori dipilih
      this.$nextTick(() => {
        this.initializePriceFilters();
      });
    },
    formatPrice(price) {
      if (typeof price !== 'number' || isNaN(price)) {
        return 'Rp 0';
      }
      return new Intl.NumberFormat("id-ID", {
        style: "currency",
        currency: "IDR",
        minimumFractionDigits: 0,
        maximumFractionDigits: 0,
      }).format(price);
    },
    showDetails(consoleItem) {
      this.selectedProduct = consoleItem;
      this.itemQuantity = 1; // //DIDIT// Reset jumlah item saat modal dibuka
      // this.isModalOpen = true; // Tidak perlu
      if (this.bootstrapModalInstance) this.bootstrapModalInstance.show();
    },
    closeDetails() {
      // this.isModalOpen = false; // Tidak perlu
      if (this.bootstrapModalInstance) this.bootstrapModalInstance.hide();
    },
    getStockClass(stockStatus) {
      if (stockStatus === "Ready") {
        return 'text-success fw-bold';
      } else if (stockStatus === "Kosong") {
        return 'text-danger fw-bold';
      }
      return '';
    },
    // //DIDIT// Method untuk tambah ke keranjang
    addToCart() {
      if (!this.selectedProduct || this.itemQuantity < 1) {
        alert("Silakan pilih produk dan jumlah yang valid.");
        return;
      }
      // Logika sebenarnya untuk menambah ke keranjang akan ada di sini
      // Misalnya, emit event ke komponen parent, atau panggil Vuex action/mutation
      console.log(`Menambahkan ${this.itemQuantity} x ${this.selectedProduct.name} ke keranjang.`);
      alert(`${this.itemQuantity} x ${this.selectedProduct.name} telah ditambahkan ke keranjang! (Simulasi)`);
      this.closeDetails(); // Tutup modal setelah ditambahkan
    }
  },
  async mounted() {
    this.loading = true; // //DIDIT// Set loading true di awal
    try {
      const res = await fetch('/data/hardware-data.json'); // Pastikan path file JSON benar
      if (!res.ok) throw new Error(`HTTP error status: ${res.status}`)
      this.components = await res.json();
    } catch(e) {
      console.error("Gagal memuat data hardware:", e);
      this.components = [];
    } finally {
      this.loading = false;
    }

    const modalElement = this.$refs.consoleModalRef;
    if (modalElement) {
      this.bootstrapModalInstance = new Modal(modalElement);
      modalElement.addEventListener('hidden.bs.modal', () => {
        this.selectedProduct = null;
        document.body.style.overflow = '';
      });
      modalElement.addEventListener('shown.bs.modal', () => {
        document.body.style.overflow = 'hidden';
      });
    }

    if (this.cards && this.cards.length > 0) {
      this.selectCategory(this.cards[0]);
    }
  },
  watch: {
    // //DIDIT// Watcher untuk slider harga
    minPriceFilter(newMin) {
      const newMinValue = Number(newMin);
      if (newMinValue > this.maxPriceFilter) {
        this.maxPriceFilter = newMinValue; // Jika min melewati max, set max sama dengan min baru
      }
      // Pastikan tidak kurang dari batas bawah slider
      if (newMinValue < this.minSliderBound) {
        this.minPriceFilter = this.minSliderBound;
      }
    },
    maxPriceFilter(newMax) {
      const newMaxValue = Number(newMax);
      if (newMaxValue < this.minPriceFilter) {
        this.minPriceFilter = newMaxValue; // Jika max lebih kecil dari min, set min sama dengan max baru
      }
      // Pastikan tidak lebih dari batas atas slider
      if (newMaxValue > this.maxSliderBound) {
        this.maxPriceFilter = this.maxSliderBound;
      }
    },
    // //DIDIT// Tidak perlu lagi watch selectedCategory untuk priceRangeUSD karena sudah ditangani initializePriceFilters
  },
};
</script>

<style>
/* Gaya CSS Anda yang sudah ada bisa tetap di sini */
.modal-backdrop.show {
  backdrop-filter: blur(5px); /* //DIDIT// Kurangi blur agar tidak terlalu berat */
  background: rgba(16, 24, 41, 0.25) !important;
  transition: backdrop-filter 0.3s;
}

input::placeholder,
input.text-white::placeholder {
  color: #fff !important;
  opacity: 1;
}
</style>