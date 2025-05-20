<template>
  <section class="container py-4">
    <h2 class="text-center fw-bold mb-4" style="font-family:'Orbitron',sans-serif;color:#fff;">
      🎮 ULTIMATE GAME CONSOLES HUB 🚀
    </h2>
    <!-- Kategori -->
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

    <div v-if="selectedCategory" class="bg-dark bg-opacity-75 rounded-3 p-3 mb-4">
      <h3 class="text-center fw-bold mb-3" style="font-family:'Orbitron',sans-serif;color:#fff;">
        {{ selectedCategory.title }}
      </h3>
      <div class="row g-2 align-items-center mb-2">
        <div class="col-12 col-md-6">
          <label for="searchConsoleInput" class="visually-hidden">Search Console</label>
          <input
            type="text"
            id="searchConsoleInput"
            v-model="searchQuery"
            placeholder="Search console..."
            class="form-control bg-secondary bg-opacity-25 text-light border-info"
            autocomplete="off"
          />
        </div>
        <div class="col-12 col-md-6">
          <label for="brandSelect" class="visually-hidden">Select Brand</label>
          <select id="brandSelect" v-model="selectedBrand" class="form-select bg-secondary bg-opacity-25 text-light border-info">
            <option value="">All Brands</option>
            <option v-for="brand in brands" :key="brand" :value="brand">{{ brand }}</option>
          </select>
        </div>
      </div>

      <!-- Price Range Filter -->
      <div class="mb-3">
        <label class="form-label text-light fw-bold d-block mb-1">Rentang Harga</label>
        <div class="d-flex align-items-center mb-1">
          <span class="me-2 text-light" style="min-width:100px;">{{ formatPrice(minPriceIDR) }}</span>
          <input
            type="range"
            v-model.number="minPriceIDR"
            :min="minSliderBoundIDR"
            :max="maxSliderBoundIDR"
            :step="priceStepIDR"
            class="form-range"
            style="accent-color:#00d9ff;"
            id="minPriceRange"
          />
        </div>
        <div class="d-flex align-items-center mb-1">
          <span class="me-2 text-light" style="min-width:100px;">{{ formatPrice(maxPriceIDR) }}</span>
          <input
            type="range"
            v-model.number="maxPriceIDR"
            :min="minSliderBoundIDR"
            :max="maxSliderBoundIDR"
            :step="priceStepIDR"
            class="form-range"
            style="accent-color:#00d9ff;"
            id="maxPriceRange"
          />
        </div>
        <div class="d-flex justify-content-between text-light mt-1 px-1 small">
          <span>Min: {{ formatPrice(minPriceIDR) }}</span>
          <span>Max: {{ formatPrice(maxPriceIDR) }}</span>
        </div>
      </div>

<div v-if="loading" class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-3 mt-2">
  <div v-for="n in 8" :key="n" class="col">
    <div class="card placeholder-card h-100 bg-secondary bg-opacity-50 border-info text-light">
      <div class="placeholder-img mb-2"></div>
      <div class="card-body py-2">
        <div class="placeholder-line w-75 mb-2"></div>
        <div class="placeholder-line w-50 mb-2"></div>
        <div class="placeholder-line w-100 mb-1"></div>
        <div class="placeholder-line w-50"></div>
      </div>
    </div>
  </div>
</div>
      <div v-else-if="filteredConsoles.length > 0" class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-3 mt-2">
        <div v-for="consoleItem in filteredConsoles" :key="consoleItem.id" class="col">
          <div
            class="card h-100 bg-secondary bg-opacity-75 border-info text-light"
            @click="showDetails(consoleItem)"
            tabindex="0"
            role="button"
            style="cursor:pointer;"
          >
            <img
              :src="consoleItem.image"
              :alt="consoleItem.name"
              class="card-img-top"
              style="height:120px;object-fit:cover;background:#101829;"
              loading="lazy"
              width="240"
              height="120"
            />
            <div class="card-body py-2">
              <h4 class="card-title fw-bold mb-1" style="font-family:'Orbitron',sans-serif;color:#fff;">
                {{ consoleItem.name }}
              </h4>
              <p class="mb-1"><span class="fw-semibold">Brand:</span> {{ consoleItem.brand }}</p>
              <p class="mb-1">
                <span class="fw-semibold">Stock:</span>
                <span :class="getStockClass(consoleItem.stock)">
                  {{ consoleItem.stock }}
                </span>
              </p>
              <p class="fw-bold mb-0">{{ formatPrice(consoleItem.price * usdToIdrRate) }}</p>
            </div>
          </div>
        </div>
      </div>
      <div v-else class="text-center text-info py-4" style="font-family:'Orbitron',sans-serif;">
        <p>No consoles match your current filters.</p>
      </div>
    </div>
    <div v-else class="text-center text-info py-4" style="font-family:'Orbitron',sans-serif;">
      <p>✨ Please select a category above to explore our awesome consoles! ✨</p>
    </div>

    <!-- MODAL Bootstrap -->
    <div class="modal fade" id="consoleDetailModal" tabindex="-1" aria-labelledby="consoleDetailModalLabel" aria-hidden="true" ref="consoleModalRef">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content bg-dark text-light">
          <div class="modal-header border-0 pb-0">
            <h3 class="modal-title w-100 text-center fw-bold" id="consoleDetailModalLabel" style="font-family:'Orbitron',sans-serif;color:#fff;">
              {{ selectedProduct?.name }}
            </h3>
            <button type="button" class="btn-close btn-close-white" aria-label="Close modal" @click="closeDetails"></button>
          </div>
          <div class="modal-body">
            <img
              v-if="selectedProduct"
              :src="selectedProduct.image"
              :alt="selectedProduct.name"
              class="d-block mx-auto mb-3 rounded"
              style="max-width:220px;max-height:120px;object-fit:contain;background:#101829;"
              loading="lazy"
              width="220"
              height="120"
            />
            <div v-if="selectedProduct" class="mb-2">
              <p class="mb-1"><strong>Price:</strong> <span>{{ formatPrice(selectedProduct.price * usdToIdrRate) }}</span></p>
              <p class="mb-1"><strong>Brand:</strong> <span>{{ selectedProduct.brand }}</span></p>
              <p class="mb-1"><strong>Stock:</strong> <span :class="getStockClass(selectedProduct.stock)">{{ selectedProduct.stock }}</span></p>
            </div>
            <div v-if="selectedProduct?.specs && selectedProduct.specs.length > 0">
              <p class="fw-bold text-info mb-1">Features:</p>
              <ul class="ps-3 mb-0">
                <li v-for="(feature, index) in selectedProduct.specs" :key="index">{{ feature }}</li>
              </ul>
            </div>
            <div v-else-if="selectedProduct">
              <p class="text-muted">No additional features listed.</p>
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
        { title: "🎮 PlayStation Powerhouse" },
        { title: "🟩 Xbox Universe" },
        { title: "🍄 Nintendo Magic" },
        { title: "💻 Handheld PC Heroes" },
        { title: "✨ Explore More Consoles" },
      ],
      selectedCategory: null,
      searchQuery: "",
      selectedBrand: "",
      usdToIdrRate: 15000,
      minPriceIDR: 0,
      maxPriceIDR: 12000000,
      priceStepIDR: 100000,
      selectedProduct: null,
      bootstrapModalInstance: null,
      consoles: [],
      loading: true,
    };
  },
  async mounted() {
    try {
      const res = await fetch('/data/console.json');
      this.consoles = await res.json();
      // Set max price slider sesuai data
      const maxUSD = Math.max(...this.consoles.map(c => c.price || 0), 0);
      this.maxPriceIDR = Math.ceil((maxUSD * this.usdToIdrRate) / this.priceStepIDR) * this.priceStepIDR;
    } catch {
      this.consoles = [];
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
    if (this.cards.length > 0) this.selectCategory(this.cards[0]);
  },
  computed: {
    brands() {
      if (!this.selectedCategory) return [];
      const consolesInCategory = this.consoles.filter(c => c.category === this.selectedCategory.title);
      return [...new Set(consolesInCategory.map(c => c.brand))].sort();
    },
    minSliderBoundIDR() {
      return 0;
    },
    maxSliderBoundIDR() {
      if (!this.consoles.length) return 12000000;
      const maxUSD = Math.max(...this.consoles.map(c => c.price || 0), 0);
      return Math.ceil((maxUSD * this.usdToIdrRate) / this.priceStepIDR) * this.priceStepIDR;
    },
    filteredConsoles() {
      if (!this.selectedCategory) return [];
      let filtered = this.consoles.filter(
        c => c.category === this.selectedCategory.title
      );
      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase();
        filtered = filtered.filter(c =>
          c.name.toLowerCase().includes(query)
        );
      }
      if (this.selectedBrand) {
        filtered = filtered.filter(c => c.brand === this.selectedBrand);
      }
      filtered = filtered.filter(c => {
        const priceIDR = (c.price || 0) * this.usdToIdrRate;
        return priceIDR >= this.minPriceIDR && priceIDR <= this.maxPriceIDR;
      });
      return filtered;
    },
  },
  methods: {
    selectCategory(category) {
      this.selectedCategory = category;
      this.searchQuery = "";
      this.selectedBrand = "";
      this.minPriceIDR = 0;
      this.maxPriceIDR = this.maxSliderBoundIDR;
    },
    formatPrice(price) {
      if (typeof price !== 'number' || isNaN(price)) return 'Rp 0';
      return new Intl.NumberFormat("id-ID", {
        style: "currency",
        currency: "IDR",
        minimumFractionDigits: 0,
        maximumFractionDigits: 0,
      }).format(price);
    },
    showDetails(consoleItem) {
      this.selectedProduct = consoleItem;
      if (this.bootstrapModalInstance) {
        this.bootstrapModalInstance.show();
      }
    },
    closeDetails() {
      if (this.bootstrapModalInstance) {
        this.bootstrapModalInstance.hide();
      }
    },
    getStockClass(stockStatus) {
      if (stockStatus === "Ready") return 'text-success fw-bold';
      if (stockStatus === "Kosong") return 'text-danger fw-bold';
      return 'text-warning fw-bold';
    }
  }
};
</script>

<style scoped>
.bg-dark { background: #181c22 !important; }
.card { border-radius: 10px; border-width: 1.5px; }
.card-img-top { border-radius: 10px 10px 0 0; }
.visually-hidden {
  position: absolute !important;
  width: 1px !important;
  height: 1px !important;
  padding: 0 !important;
  margin: -1px !important;
  overflow: hidden !important;
  clip: rect(0,0,0,0) !important;
  white-space: nowrap !important;
  border: 0 !important;
}

.placeholder-card {
  border-radius: 10px;
  overflow: hidden;
  position: relative;
}

.placeholder-img {
  height: 120px;
  background: linear-gradient(90deg, #222 25%, #333 50%, #222 75%);
  background-size: 200% 100%;
  animation: shimmer 1.2s infinite linear;
  border-radius: 10px 10px 0 0;
}

.placeholder-line {
  height: 14px;
  background: linear-gradient(90deg, #222 25%, #333 50%, #222 75%);
  background-size: 200% 100%;
  animation: shimmer 1.2s infinite linear;
  border-radius: 4px;
}

@keyframes shimmer {
  0% { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}
</style>