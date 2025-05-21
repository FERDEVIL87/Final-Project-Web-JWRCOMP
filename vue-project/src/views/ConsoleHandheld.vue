<template>
  <section class="container py-4">
    <h1 class="text-center fw-bold mb-4" style="font-family:'Orbitron',sans-serif;color:#fff;min-height:2.5em;will-change: transform;">
      ULTIMATE GAME CONSOLES HUB
    </h1>

    
    <div class="text-center my-4 py-3 border-top border-bottom border-secondary">
        <h2 class="mb-3" style="font-family:'Orbitron',sans-serif;color:#fff;">Keranjang Belanja Global</h2>
        <p v-if="cartStore.items.length > 0" class="mb-2" style="color:#1aff6b;">
          Total Item: {{ cartStore.items.reduce((acc, item) => acc + item.qty, 0) }} | Total Harga: <span style="color:#1aff6b;font-weight:bold;">{{ formatPrice(cartStore.totalPrice) }}</span>
        </p>
        <p v-else class="mb-2" style="color:#b0b0b0;">Keranjang belanja utama masih kosong.</p>
        <button class="btn btn-success btn-lg px-5" @click="goToCheckout" style="font-family:'Orbitron',sans-serif;">
           <i class="bi bi-cart-check-fill me-2"></i> Lihat Keranjang & Checkout
        </button>
      </div>

    
    <div class="d-flex flex-wrap justify-content-center gap-2 mb-4">
      <button
        v-for="(card, index) in cards"
        :key="index"
        class="btn btn-outline-info px-3 py-1 fw-bold"
        :class="{ active: selectedCategory && selectedCategory.title === card.title }"
        @click="selectCategory(card)"
      >
        {{ card.title }}
      </button>
    </div>

    <div v-if="selectedCategory" class="bg-dark bg-opacity-85 rounded-3 p-3 mb-4" style="background:#181c22 !important;min-height:350px;transition:min-height 0.2s cubic-bezier(.4,0,.2,1);">
      <h2 class="text-center fw-bold mb-3" style="font-family:'Orbitron',sans-serif;color:#fff;">
        {{ selectedCategory.title }}
      </h2>
      <div class="row g-2 align-items-center mb-2">
        <div class="col-12 col-md-6">
          <label for="searchConsoleInput" class="form-label visually-hidden">Search Console</label>
          <input
            type="text"
            id="searchConsoleInput"
            v-model="searchQuery"
            placeholder="Search console..."
            class="form-control bg-secondary bg-opacity-25 text-light border-info"
            autocomplete="off"
            aria-label="Cari konsol"
          />
        </div>
        <div class="col-12 col-md-6">
          <label for="brandSelect" class="form-label visually-hidden">Select Brand</label>
          <select id="brandSelect" v-model="selectedBrand" class="form-select bg-secondary bg-opacity-25 text-light border-info" aria-label="Pilih brand">
            <option value="">All Brands</option>
            <option v-for="brand in brands" :key="brand" :value="brand">{{ brand }}</option>
          </select>
        </div>
      </div>

      
      <div class="mb-3">
        <label class="form-label text-light fw-bold d-block mb-1" for="minPriceRange">Rentang Harga</label>
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
            aria-label="Harga minimum"
            @input="maxPriceIDR = Math.max(minPriceIDR, maxPriceIDR)"
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
            aria-label="Harga maksimum"
            @input="minPriceIDR = Math.min(minPriceIDR, maxPriceIDR)"
          />
        </div>
        <div class="d-flex justify-content-between text-light mt-1 px-1 small">
          <span>Min: {{ formatPrice(minPriceIDR) }}</span>
          <span>Max: {{ formatPrice(maxPriceIDR) }}</span>
        </div>
      </div>

      <div v-if="loading" class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-3 mt-2" style="min-height:320px;">
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
      <div v-else-if="filteredConsoles.length > 0" class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-3 mt-2" style="min-height:320px;">
        <div v-for="consoleItem in filteredConsoles" :key="consoleItem.id" class="col">
          <div
            class="card h-100 bg-secondary bg-opacity-75 border-info text-light d-flex flex-column"
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
              @click="showDetails(consoleItem)"
            />
            <div class="card-body py-2 d-flex flex-column flex-grow-1">
              <h4 class="card-title fw-bold mb-1" style="font-family:'Orbitron',sans-serif;color:#fff;" @click="showDetails(consoleItem)">
                {{ consoleItem.name }}
              </h4>
              <p class="mb-1" @click="showDetails(consoleItem)"><span class="fw-semibold">Brand:</span> {{ consoleItem.brand }}</p>
              <p class="mb-1" @click="showDetails(consoleItem)">
                <span class="fw-semibold">Stock:</span>
                <span :class="getStockClass(consoleItem.stock)">
                  {{ consoleItem.stock }}
                </span>
              </p>
              <p class="fw-bold mb-2" @click="showDetails(consoleItem)">{{ formatPrice(consoleItem.price * usdToIdrRate) }}</p>
               <button 
                class="btn btn-sm btn-info fw-bold mt-auto" 
                style="font-family:'Orbitron',sans-serif;"
                @click.stop="addItemToCartFromCard(consoleItem)"
                :disabled="consoleItem.stock === 'Kosong' || consoleItem.stock === 0"
              >
                <i class="bi bi-cart-plus-fill"></i> Add to Cart
              </button>
            </div>
          </div>
        </div>
      </div>
      <div v-else class="text-center text-info py-4" style="font-family:'Orbitron',sans-serif;min-height:120px;">
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

            
            <div v-if="selectedProduct && (selectedProduct.stock !== 'Kosong' && selectedProduct.stock > 0)" class="mt-3 pt-3 border-top border-secondary">
                <div class="d-flex align-items-center justify-content-center gap-2 mb-2">
                    <label for="modalQtyConsole" class="form-label mb-0 text-light">Qty:</label>
                    <input 
                        type="number" 
                        id="modalQtyConsole" 
                        v-model.number="modalQuantity" 
                        min="1" 
                        :max="selectedProduct.stock === 'Ready' ? 99 : selectedProduct.stock"
                        class="form-control form-control-sm bg-secondary bg-opacity-25 text-light border-info" 
                        style="width: 70px;"
                    >
                </div>
                <button 
                    class="btn btn-info w-100 fw-bold" 
                    style="font-family:'Orbitron',sans-serif;"
                    @click="addItemToCartFromModal(selectedProduct)"
                >
                    <i class="bi bi-cart-plus-fill"></i> Add to Cart
                </button>
            </div>
            <div v-else-if="selectedProduct" class="mt-3 text-center">
                <p class="text-danger fw-bold">This item is currently out of stock.</p>
            </div>

          </div>
           <div class="modal-footer border-0 pt-0">
                <button type="button" class="btn btn-outline-secondary" @click="closeDetails">Close</button>
            </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
import { Modal } from 'bootstrap';
import { cartStore } from '@/store/cartStore';
import { useRouter } from 'vue-router';

export default {
  name: "GameConsolesHub",
  setup() {
    const router = useRouter();
    return { router, cartStore };
  },
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
      modalQuantity: 1,
    };
  },
  async mounted() {
    try {
      const res = await fetch('/data/console.json');
      if (!res.ok) throw new Error(`HTTP error! status: ${res.status}`);
      const jsonData = await res.json();
      this.consoles = jsonData.map(console => ({
          ...console,
          stock: console.stock === "Ready" ? 10 : (console.stock === "Kosong" ? 0 : (Number(console.stock) || 0)),
          id: String(console.id || `console-${Math.random().toString(36).substr(2, 9)}`)
      }));
      this.updatePriceSliderBounds();
    } catch (error) {
      console.error("Failed to load console data:", error);
      this.consoles = [];
    } finally {
      this.loading = false;
    }
    const modalElement = this.$refs.consoleModalRef;
    if (modalElement) {
      this.bootstrapModalInstance = new Modal(modalElement);
      modalElement.addEventListener('hidden.bs.modal', () => {
        this.selectedProduct = null;
        this.modalQuantity = 1;
      });
    }
    if (this.cards.length > 0 && !this.selectedCategory) {
        this.selectCategory(this.cards[0]);
    }
  },
  computed: {
    brands() {
      if (!this.selectedCategory || !this.consoles.length) return [];
      const consolesInCategory = this.consoles.filter(c => c.category === this.selectedCategory.title);
      return [...new Set(consolesInCategory.map(c => c.brand))].sort();
    },
    minSliderBoundIDR() {
      return 0;
    },
    maxSliderBoundIDR() {
      if (!this.consoles.length) return 12000000;
      const maxUSD = Math.max(...this.consoles.map(c => c.price || 0), 0);
      return Math.ceil((maxUSD * this.usdToIdrRate) / this.priceStepIDR) * this.priceStepIDR || 12000000;
    },
    filteredConsoles() {
      if (!this.selectedCategory || !this.consoles.length) return [];
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
    updatePriceSliderBounds() {
        if (this.consoles.length > 0) {
            const maxUSD = Math.max(...this.consoles.map(c => c.price || 0), 0);
            const calculatedMaxIDR = Math.ceil((maxUSD * this.usdToIdrRate) / this.priceStepIDR) * this.priceStepIDR;
            this.maxPriceIDR = calculatedMaxIDR > 0 ? calculatedMaxIDR : 12000000;
        } else {
            this.maxPriceIDR = 12000000;
        }
        if (this.selectedCategory) {
        }
    },
    selectCategory(category) {
      this.selectedCategory = category;
      this.searchQuery = "";
      this.selectedBrand = "";
      this.minPriceIDR = this.minSliderBoundIDR;
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
      this.modalQuantity = 1;
      if (this.bootstrapModalInstance) {
        this.bootstrapModalInstance.show();
      }
    },
    closeDetails() {
      if (this.bootstrapModalInstance) {
        this.bootstrapModalInstance.hide();
      }
    },
    getStockClass(stock) {
      if (stock > 0) return 'text-success fw-bold';
      return 'text-danger fw-bold';
    },
    addItemToCart(consoleItem, quantity) {
        if (!consoleItem || quantity < 1) {
            alert("Invalid item or quantity.");
            return;
        }
        const stockNumber = Number(consoleItem.stock);
        if (isNaN(stockNumber) || stockNumber <= 0 || quantity > stockNumber) {
            alert(`Quantity (x${quantity}) exceeds available stock (${stockNumber}) or item is out of stock.`);
            return;
        }

        const itemToAdd = {
            id: String(consoleItem.id),
            source: 'console',
            name: consoleItem.name,
            price: consoleItem.price * this.usdToIdrRate,
            qty: quantity,
            category: consoleItem.category,
            brand: consoleItem.brand,
            image: consoleItem.image,
            specification: consoleItem.specs ? consoleItem.specs.join(', ') : 'No specific features listed.'
        };
        cartStore.addItem(itemToAdd);
        alert(`${consoleItem.name} (x${quantity}) added to cart!`);
    },
    addItemToCartFromCard(consoleItem) {
        this.addItemToCart(consoleItem, 1);
    },
    addItemToCartFromModal(consoleItem) {
        this.addItemToCart(consoleItem, this.modalQuantity);
        this.closeDetails();
    },
    goToCheckout() {
      if (cartStore.items.length === 0) {
        alert("Keranjang belanja Anda kosong. Silakan tambahkan produk terlebih dahulu.");
        return;
      }
      this.router.push('/checkout');
    }
  },
  watch: {
    consoles: {
        handler() {
            this.updatePriceSliderBounds();
        },
        deep: true
    },
    minPriceIDR(newVal, oldVal) {
        if (newVal > this.maxPriceIDR) {
            this.minPriceIDR = oldVal;
        }
    },
    maxPriceIDR(newVal, oldVal) {
        if (newVal < this.minPriceIDR) {
            this.maxPriceIDR = oldVal;
        }
    }
  }
};
</script>

<style scoped>
.bg-dark { background: #181c22 !important; }
.card { border-radius: 10px; border-width: 1.5px; background: #232b36 !important; color: #fff !important; }
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
  border-color: var(--bs-info);
}

.placeholder-img {
  height: 120px;
  background: linear-gradient(90deg, rgba(var(--bs-secondary-rgb), 0.3) 25%, rgba(var(--bs-secondary-rgb), 0.5) 50%, rgba(var(--bs-secondary-rgb), 0.3) 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite linear;
  border-radius: 10px 10px 0 0;
}

.placeholder-line {
  height: 14px;
  background: linear-gradient(90deg, rgba(var(--bs-secondary-rgb), 0.3) 25%, rgba(var(--bs-secondary-rgb), 0.5) 50%, rgba(var(--bs-secondary-rgb), 0.3) 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite linear;
  border-radius: 4px;
}

@keyframes shimmer {
  0% { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}

.btn-outline-info.active,
.btn-outline-info:active,
.btn-outline-info:focus {
  background-color: #00d9ff !important;
  color: #181c22 !important;
  border-color: #00d9ff !important;
}
.text-success, .fw-bold.text-success, span.text-success.fw-bold {
  color: #1aff6b !important;
  font-weight: bold !important;
}
.text-muted, .mb-2.text-muted, p.text-muted.mb-2 {
  color: #b0b0b0 !important;
}
.bg-opacity-85 { opacity: 0.85; }
.modal-footer {
    border-top-color: var(--bs-secondary);
}
.btn-close-white {
    filter: invert(1) grayscale(100%) brightness(200%);
}
h1.text-center.fw-bold.mb-4 {
  position: relative;
  display: inline-block;
}
h1.text-center.fw-bold.mb-4::after {
  content: '';
  display: block;
  margin: 0 auto;
  margin-top: 10px;
  width: 80px;
  height: 4px;
  border-radius: 2px;
  background: linear-gradient(90deg, #00d9ff 0%, #007bff 100%);
}
@media (max-width: 575.98px) {
  h1.text-center.fw-bold.mb-4::after {
    width: 50px;
    height: 3px;
    margin-top: 7px;
  }
}
</style>