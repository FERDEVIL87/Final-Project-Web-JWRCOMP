//DIDIT//
<template>
  <section class="container py-4">
    <h2 class="text-center fw-bold mb-4" style="font-family:'Orbitron',sans-serif;color:#fff;min-height:2.5em;">
      HARDWARE
    </h2>
    <div v-if="loading" class="text-center text-info py-5" style="font-family:'Orbitron',sans-serif;">
      <span>Loading data hardware...</span>
    </div>
    <template v-else>
      <div class="d-flex flex-wrap justify-content-center gap-2 mb-4">
        <button
          v-for="(card, index) in cards"
          :key="index"
          class="btn btn-outline-info px-3 py-1 fw-bold"
          :class="{ active: selectedCategory && selectedCategory.title === card.title }"
          style="font-family:'Orbitron',sans-serif;"
          @click="selectCategory(card)"
        >
          {{ card.title }}
        </button>
      </div>
      <div v-if="selectedCategory" class="bg-dark rounded-4 shadow-sm p-3 mb-4" style="background:#181c22 !important;min-height:240px;">
        <h3 class="text-center fw-bold mb-3" style="font-family:'Orbitron',sans-serif;color:#fff;">
          {{ selectedCategory.title }}
        </h3>
        <div class="row g-2 align-items-center mb-3">
          <div class="col-12 col-md-4 mb-2 mb-md-0">
            <label for="searchComponentInput" class="form-label visually-hidden">Cari Komponen</label>
            <input
              id="searchComponentInput"
              type="text"
              v-model="searchQuery"
              placeholder="Search Component"
              class="form-control form-control-sm"
              autocomplete="off"
              aria-label="Cari komponen"
            />
          </div>
          <div class="col-12 col-md-4 mb-2 mb-md-0">
            <label for="brandSelect" class="form-label visually-hidden">Pilih Brand</label>
            <select
              id="brandSelect"
              v-model="selectedBrand"
              class="form-select form-select-sm"
              aria-label="Pilih brand"
            >
              <option value="">All Brands</option>
              <option v-for="brand in filteredBrands" :key="brand" :value="brand">{{ brand }}</option>
            </select>
          </div>
          <div class="col-md-4">
            <label for="sortSelect" class="form-label visually-hidden">Urutkan</label>
            <select id="sortSelect" v-model="sortBy" class="form-select form-select-sm" aria-label="Urutkan">
              <option disabled value="">Urutkan</option>
              <option v-for="opt in sortOptions" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
            </select>
          </div>
        </div>
        <div class="row align-items-center mb-3">
          <div class="col-12">
            <label for="priceRangeSlider" class="form-label text-white">Rentang Harga</label>
            <input
              id="priceRangeSlider"
              type="range"
              class="form-range"
              min="0"
              :max="maxPriceInCategory"
              v-model="priceRangeUSD"
              step="50"
              aria-label="Rentang harga"
              @input="
                if (priceRangeUSD < minPriceInCategory) {
                  priceRangeUSD = minPriceInCategory;
                } else if (priceRangeUSD > maxPriceInCategory) {
                  priceRangeUSD = maxPriceInCategory;
                }
              "
            />
            <div class="d-flex justify-content-between text-white small">
              <span>{{ formatPrice(minPriceInCategory) }}</span>
              <span>{{ formatPrice(maxPriceInCategory) }}</span>
            </div>
          </div>
        </div>
        <div v-if="filteredConsoles.length > 0" class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-3 mt-2" style="min-height:120px;">
          <div
            v-for="consoleItem in filteredConsoles"
            :key="consoleItem.id"
            class="col"
          >
            <div
              class="card h-100 border-info"
              role="button"
              tabindex="0"
              @click="showDetails(consoleItem)"
              @keydown.enter.prevent="showDetails(consoleItem)"
              @keydown.space.prevent="showDetails(consoleItem)"
              style="background:#232b36;color:#fff;cursor:pointer;"
            >
              <img
                :src="consoleItem.image"
                :alt="consoleItem.name"
                class="card-img-top"
                style="height:120px;width:100%;object-fit:cover;background:#101829;display:block;"
                loading="lazy"
                width="240"
                height="120"
              />
              <div class="card-body py-2">
                <h4 class="card-title fw-bold mb-1" style="font-family:'Orbitron',sans-serif;font-size:1rem;">{{ consoleItem.name }}</h4>
                <p class="mb-1"><span class="fw-semibold">Brand:</span> {{ consoleItem.brand }}</p>
                <p class="mb-1">
                  <span class="fw-semibold">Stock:</span>
                  <span :class="getStockClass(consoleItem.stock)" :style="consoleItem.stock === 'Ready' ? 'color:#1aff6b;' : 'color:#ff4d4d;'">
                    {{ consoleItem.stock }}
                  </span>
                </p>
                <p class="fw-bold mb-0" style="color:#fff;">{{ formatPrice(consoleItem.price) }}</p>
              </div>
            </div>
          </div>
        </div>
        <div v-else class="text-center text-info py-4" style="font-family:'Orbitron',sans-serif;min-height:80px;">
          <p>No consoles match your current filters.</p>
        </div>
      </div>
      <div v-else class="text-center text-info py-4" style="font-family:'Orbitron',sans-serif;">
        <p>✨ Please select a category above to explore our awesome consoles! ✨</p>
      </div>
      <div class="modal fade" id="consoleDetailModal" tabindex="-1" aria-labelledby="consoleDetailModalLabel" aria-hidden="true" ref="consoleModalRef">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content bg-dark text-light">
            <div class="modal-header border-0 pb-0">
              <h3 class="modal-title w-100 text-center fw-bold" id="consoleDetailModalLabel" style="font-family:'Orbitron',sans-serif;color:#fff;">
                {{ selectedProduct?.name }}
              </h3>
              <button type="button" class="btn-close btn-close-white" aria-label="Close" @click="closeDetails"></button>
            </div>
            <div class="modal-body">
              <img :src="selectedProduct?.image" :alt="selectedProduct?.name" class="d-block mx-auto mb-3 rounded" style="max-width:220px;max-height:120px;object-fit:contain;background:#101829;" loading="lazy" width="220" height="120" />
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
    </template>
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
      sortBy: 'lowToHigh',
      sortOptions: [
        { value: 'lowToHigh', label: 'Harga Termurah' },
        { value: 'highToLow', label: 'Harga Termahal' }
      ],
      components: [],
      loading: true,
    };
  },
  computed: {
    consoles() {
      return this.components;
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
      } else {
        filtered.sort((a, b) => a.price - b.price);
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
      if (this.bootstrapModalInstance) this.bootstrapModalInstance.show();
    },
    closeDetails() {
      if (this.bootstrapModalInstance) this.bootstrapModalInstance.hide();
    },
    getStockClass(stockStatus) {
      if (stockStatus === "Ready") {
        return 'fw-bold';
      } else if (stockStatus === "Kosong") {
        return 'fw-bold';
      }
      return '';
    }
  },
  async mounted() {
    try {
      const res = await fetch('/data/hardware.json');
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
      });
    }
    if (this.cards && this.cards.length > 0) {
      this.selectCategory(this.cards[0]);
    }
  }
};
</script>

<style scoped>
.bg-dark { background: #181c22 !important; }
.card { border-radius: 10px; border-width: 1.5px; background: #232b36 !important; color: #fff !important; }
.card-img-top { border-radius: 10px 10px 0 0; }
.btn-outline-info.active,
.btn-outline-info:active,
.btn-outline-info:focus {
  background-color: #00d9ff !important;
  color: #181c22 !important;
  border-color: #00d9ff !important;
}
</style>
