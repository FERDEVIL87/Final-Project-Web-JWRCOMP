//DIDIT//
<template>
  <section class="container py-5">
    <h2
      class="text-center fw-bold mb-4"
      style="font-family: 'Orbitron', sans-serif; text-shadow: 0 0 8px #00eaff, 0 0 18px #00eaff; color: #fff;"
    >
      HARDWARE
    </h2>
    <!-- Kategori -->
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
          color: selectedCategory && selectedCategory.title === card.title ? '#fff' : ''
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
            <option value=""class="text-white"style="background: #222; color: #fff;">All Brands</option>
  <option v-for="brand in filteredBrands":key="brand":value="brand"class="text-white"style="background: #222; color: #fff;">{{ brand }}</option>
</select>
        </div>
        <div class="col-md-4">
          <select v-model="sortBy" class="form-select mb-2" style="background-color: #23272b; color: #fff; border-color: #17a2b8;">
    <option disabled value="">Urutkan</option>
    <option v-for="opt in sortOptions" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
  </select>
        </div>
      </div>
      <div class="row align-items-center mb-3">
  <div class="col-12">
    <label class="form-label text-white">Rentang Harga</label>
    <input
      type="range"
      class="form-range"
      min="0"
      :max="maxPriceInCategory"
      v-model="priceRangeUSD"
      step="50"
      style="accent-color: #00eaff;"
      @input="
        if (priceRangeUSD < minPriceInCategory) {
          priceRangeUSD = minPriceInCategory;
        } else if (priceRangeUSD > maxPriceInCategory) {
          priceRangeUSD = maxPriceInCategory;
        }
      "
    />
    <div class="d-flex justify-content-between text-white">
      <span>{{ formatPrice(minPriceInCategory) }}</span>
      <span>{{ formatPrice(maxPriceInCategory) }}</span>
    </div>
  </div>
</div>

      <div v-if="filteredConsoles.length > 0" class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4 mt-2">
        <div
          v-for="consoleItem in filteredConsoles"
          :key="consoleItem.id"
          class="col"
        >
          <div
            class="card h-100 bg-secondary bg-opacity-75 border-info shadow-sm text-light cursor-pointer"
            @click="showDetails(consoleItem)"
            tabindex="0"
            style="transition: transform 0.18s, box-shadow 0.18s; cursor: pointer;"
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

    <!-- MODAL Bootstrap Dikelola oleh JS -->
    <!-- Bagian ini (modal) sudah ada di dalam kodingan yang Anda berikan, jadi saya akan menggunakan yang sudah ada -->
    <!-- dan memastikan tag <section> terluar adalah yang baru -->
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
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
import { Modal } from 'bootstrap';

export default {
  name: "GameConsolesHub",
  data() {
    return {
      cards: [
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
      priceRangeUSD: 1500,
      usdToIdrRate: 15000,
      selectedProduct: null,
      bootstrapModalInstance: null,
      hover: null,
      isModalOpen: false,
      sortBy: 'lowToHigh', // default
    sortOptions: [
      { value: 'lowToHigh', label: 'Harga Termurah' },
      { value: 'highToLow', label: 'Harga Termahal' },
      { value: 'populer', label: 'Paling Populer' },
      { value: 'tidakPopuler', label: 'Paling Tidak Populer' }
    ],
      components: [], // Akan diisi dari fetch
      loading: true,
    };
  },
  computed: {
    consoles() {
      // Gunakan data dari components agar tetap konsisten
      return this.components;
    },
    brands() {
      if (!this.selectedCategory) return [];
      const consolesInCategory = this.consoles.filter(c => c.category === this.selectedCategory.title);
      return [...new Set(consolesInCategory.map(c => c.brand))].sort();
    },
    filteredBrands() {
      if (!this.selectedCategory) return [];
      const consolesInCategory = this.consoles.filter(c => c.category === this.selectedCategory.title);
      return [...new Set(consolesInCategory.map(c => c.brand))].sort();
    },
    filteredConsoles() {
      if (!this.selectedCategory) return [];
      let filtered = this.consoles.filter(
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
      filtered = filtered.filter(c => c.price <= Number(this.priceRangeUSD));
      if (this.sortBy === 'highToLow') {
        filtered.sort((a, b) => b.price - a.price);
      } else if (this.sortBy === 'populer') {
        // Implementasi logika untuk menyortir berdasarkan popularitas
        // Misalnya, berdasarkan jumlah terjual atau rating
        // Untuk saat ini, kita anggap semua item memiliki tingkat popularitas yang sama
        filtered.sort(() => Math.random() - 0.5); // Acak urutan sebagai placeholder
      } else if (this.sortBy === 'tidakPopuler') {
        // Implementasi logika untuk menyortir berdasarkan tidak populernya
        // Misalnya, berdasarkan jumlah stok atau tanggal ditambahkan
        // Untuk saat ini, kita anggap semua item memiliki tingkat tidak populer yang sama
        filtered.sort(() => Math.random() - 0.5); // Acak urutan sebagai placeholder
      }
      return filtered;
    },
    maxPriceInCategory() {
      if (!this.selectedCategory) return 1500;
      const consolesInCategory = this.consoles.filter(
        c => c.category === this.selectedCategory.title
      );
      if (consolesInCategory.length === 0) return 1500;
      const maxPrice = Math.max(...consolesInCategory.map(c => c.price), 0);
      return Math.ceil(maxPrice / 50) * 50 || 50;
    },
    minPriceInCategory() {
  if (!this.selectedCategory) return 50;
  const consolesInCategory = this.consoles.filter(
    c => c.category === this.selectedCategory.title
  );
  if (consolesInCategory.length === 0) return 50;
  const minPrice = Math.min(...consolesInCategory.map(c => c.price));
  return minPrice > 0 ? Math.floor(minPrice / 50) * 50 : 50;
},
  },
  methods: {
    selectCategory(category) {
      this.selectedCategory = category;
      this.searchQuery = "";
      this.selectedBrand = "";
      this.$nextTick(() => {
        this.priceRangeUSD = this.maxPriceInCategory;
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
    this.isModalOpen = true;
    if (this.bootstrapModalInstance) this.bootstrapModalInstance.show();
  },
    closeDetails() {
    this.isModalOpen = false;
    if (this.bootstrapModalInstance) this.bootstrapModalInstance.hide();
  },
    getStockClass(stockStatus) {
      if (stockStatus === "Ready") {
        return 'text-success fw-bold';
      } else if (stockStatus === "Kosong") {
        return 'text-danger fw-bold';
      }
      return '';
    }
  },
  async mounted() {
    try {
      const res = await fetch('/data/hardware-data.json');
      this.components = await res.json();
    } catch {
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
  selectedCategory(newCategory, oldCategory) {
    if (newCategory !== oldCategory) {
      this.$nextTick(() => {
        this.priceRangeUSD = this.maxPriceInCategory;
      });
    }
  },
  minPriceInCategory(val) {
    if (this.priceRangeUSD < val) {
      this.priceRangeUSD = val;
    }
  },
  maxPriceInCategory(val) {
    if (this.priceRangeUSD > val) {
      this.priceRangeUSD = val;
    }
  },
  priceRangeUSD(val) {
    // Batasi agar tidak keluar dari range min-max
    if (val < this.minPriceInCategory) {
      this.priceRangeUSD = this.minPriceInCategory;
    } else if (val > this.maxPriceInCategory) {
      this.priceRangeUSD = this.maxPriceInCategory;
    }
  }
},
};
</script>

<style>
/* Blur hanya pada backdrop modal Bootstrap */
.modal-backdrop.show {
  backdrop-filter: blur(150px);
  background: rgba(16, 24, 41, 0.25) !important;
  transition: backdrop-filter 0.3s;
}


input::placeholder,
input.text-white::placeholder {
  color: #fff !important;
  opacity: 1;
}
</style>
