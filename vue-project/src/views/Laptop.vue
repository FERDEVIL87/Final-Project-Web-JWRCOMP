<script>
import { Modal } from 'bootstrap';
import { cartStore } from '@/store/cartStore';
import { useRouter } from 'vue-router';

export default {
  name: "LaptopListSection",
  setup() {
    const router = useRouter();
    return { router, cartStore };
  },
  data() {
    return {
      laptops: [],
      searchQuery: "",
      selectedCategoryFilter: "",
      selectedLaptopForModal: null,
      bootstrapLaptopModal: null,
      minPrice: 0,
      maxPrice: 0,
      priceSlider: [0, 0],
      checkoutQty: 1,
      loading: true,
    };
  },
  async mounted() {
    try {
      const res = await fetch('/data/laptop.json');
      this.laptops = await res.json();
      if (this.laptops.length > 0) {
        const prices = this.laptops.map(l => l.price);
        this.minPrice = Math.min(...prices);
        this.maxPrice = Math.max(...prices);
        this.priceSlider = [this.minPrice, this.maxPrice];
      } else {
        this.minPrice = 0;
        this.maxPrice = 100000000;
        this.priceSlider = [0, 100000000];
      }
    } catch {
      this.laptops = [];
    } finally {
      this.loading = false;
    }
    const modalElement = this.$refs.laptopDetailModalRef;
    if (modalElement) {
      this.bootstrapLaptopModal = new Modal(modalElement);
      modalElement.addEventListener('hidden.bs.modal', () => {
        this.selectedLaptopForModal = null;
        this.checkoutQty = 1;
        document.body.style.overflow = '';
      });
      modalElement.addEventListener('shown.bs.modal', () => {
        document.body.style.overflow = 'hidden';
      });
    }
  },
  computed: {
    filteredLaptops() {
      return this.laptops.filter((laptop) => {
        const matchesSearch = laptop.name.toLowerCase().includes(this.searchQuery.toLowerCase());
        const matchesCategory = this.selectedCategoryFilter ? laptop.category === this.selectedCategoryFilter : true;
        const matchesPrice = laptop.price >= this.priceSlider[0] && laptop.price <= this.priceSlider[1];
        return matchesSearch && matchesCategory && matchesPrice;
      });
    },
    categoriesWithLaptops() {
      const uniqueCategories = ["Low-End", "Mid-Range", "High-End"];
      const categoryData = uniqueCategories.map(categoryName => {
        const laptopsInCategory = this.filteredLaptops.filter(laptop => laptop.category === categoryName);
        return {
          name: categoryName,
          laptops: laptopsInCategory,
        };
      }).filter(category => category.laptops.length > 0);

      if (this.selectedCategoryFilter) {
        return categoryData.filter(cat => cat.name === this.selectedCategoryFilter);
      }
      return categoryData;
    },
  },
  methods: {
    formatPrice(value) {
      if (typeof value !== "number" || isNaN(value)) {
        return 'Rp 0';
      }
      return `Rp ${new Intl.NumberFormat('id-ID', { minimumFractionDigits: 0, maximumFractionDigits: 0 }).format(value)}`;
    },
    openModal(laptop) {
      this.selectedLaptopForModal = laptop;
      this.checkoutQty = 1;
      if (this.bootstrapLaptopModal) {
        this.bootstrapLaptopModal.show();
      }
    },
    closeModal() {
      if (this.bootstrapLaptopModal) {
        this.bootstrapLaptopModal.hide();
      }
    },
    checkout(laptop) {
      if (!laptop || this.checkoutQty < 1 || this.checkoutQty > laptop.stock) {
        console.error("Checkout tidak valid:", laptop, this.checkoutQty);
        return;
      }
      console.log(`Checkout laptop: ${laptop.name}, Kategori: ${laptop.category}, Harga: ${this.formatPrice(laptop.price)}, Qty: ${this.checkoutQty}`);
      this.closeModal();
    },
    goToCheckout() {
      if (cartStore.items.length === 0) {
        alert("Keranjang belanja Anda kosong. Silakan tambahkan produk terlebih dahulu.");
        return;
      }
      this.router.push('/checkout');
    },
    addItemToCart(laptop) {
      if (laptop && this.checkoutQty > 0 && this.checkoutQty <= laptop.stock) {
        cartStore.addItem({
          id: laptop.id,
          name: laptop.name,
          price: laptop.price,
          qty: this.checkoutQty,
          image: laptop.image,
        });
        laptop.stock -= this.checkoutQty;
        this.closeModal();
      } else {
        alert("Jumlah yang Anda masukkan tidak valid atau stok tidak mencukupi.");
      }
    }
  }
};
</script>

<template>
  <section class="pc-list-section-bs">
    <div class="container py-4 py-md-5">
      <div class="hardware-title-wrapper text-center mb-4">
        <h1 class="hardware-title-bs">Toko Laptop</h1>
      </div>

      
      <div class="text-center my-4 py-3 border-top border-bottom border-secondary">
        <h4 class="mb-3">Keranjang Belanja Global</h4>
        <p v-if="cartStore.items.length > 0" class="mb-2">
          Total Item: {{ cartStore.items.reduce((acc, item) => acc + item.qty, 0) }} | Total Harga: <span class="text-success fw-bold">{{ formatPrice(cartStore.totalPrice) }}</span>
        </p>
        <p v-else class="text-muted mb-2">Keranjang belanja utama masih kosong.</p>
        <button class="btn btn-success btn-lg px-5" @click="goToCheckout">
           <i class="bi bi-cart-check-fill me-2"></i> Lihat Keranjang & Checkout
        </button>
      </div>

      
      <transition name="fade-slide" appear>
        <div class="row justify-content-center mb-4">
          <div class="col-lg-10 col-xl-8">
            <div class="filters-bs p-3 rounded-3">
              <div class="row g-2 g-md-3 align-items-center">
                <div class="col-md">
                  <label for="searchLaptop" class="visually-hidden">Cari nama laptop</label>
                  <input
                    id="searchLaptop"
                    type="text"
                    v-model.trim="searchQuery"
                    placeholder="Cari nama laptop..."
                    class="form-control form-control-lg search-box-bs"
                    aria-label="Cari laptop berdasarkan nama"
                  />
                </div>
                <div class="col-md-auto">
                  <label for="categoryFilter" class="visually-hidden">Filter berdasarkan kategori</label>
                  <select id="categoryFilter" v-model="selectedCategoryFilter" class="form-select form-select-lg filter-select-bs" aria-label="Pilih kategori laptop">
                    <option value="">Semua Kategori</option>
                    <option value="Low-End">Low-End</option>
                    <option value="Mid-Range">Mid-Range</option>
                    <option value="High-End">High-End</option>
                  </select>
                </div>
              </div>
              
              <div class="row mt-3 align-items-center">
                <div class="col-12">
                  <div class="slider-harga-bs d-flex flex-column flex-md-row align-items-center gap-3 p-2 rounded-3">
                    <label for="minPriceSlider" class="form-label mb-0 price-range-label-bs">Rentang Harga (Rp):</label>
                    <div class="slider-range-group d-flex align-items-center flex-grow-1"> 
                        <span class="harga-min-bs me-2" style="min-width: 100px;">{{ formatPrice(priceSlider[0]) }}</span>
                        <input
                          id="minPriceSlider"
                          type="range"
                          v-model.number="priceSlider[0]"
                          :min="minPrice"
                          :max="maxPrice" 
                          :step="minPrice > 1000000 ? 100000 : 50000"
                          class="form-range slider-min-bs flex-grow-1 mx-2"
                          aria-label="Slider harga minimum"
                          @input="priceSlider[1] = Math.max(priceSlider[0], priceSlider[1])"
                        />
                        <input
                          id="maxPriceSlider"
                          type="range"
                          v-model.number="priceSlider[1]"
                          :min="minPrice" 
                          :max="maxPrice"
                          :step="minPrice > 1000000 ? 100000 : 50000"
                          class="form-range slider-max-bs flex-grow-1 mx-2"
                          aria-label="Slider harga maksimum"
                           @input="priceSlider[0] = Math.min(priceSlider[0], priceSlider[1])"
                        />
                        <span class="harga-max-bs ms-2" style="min-width: 100px;">{{ formatPrice(priceSlider[1]) }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </transition>

      
      <transition-group name="fade-slide" tag="div" appear>
        <div v-if="filteredLaptops.length > 0" key="laptop-list-container">
          <div v-for="categoryData in categoriesWithLaptops" :key="categoryData.name" class="category-section-bs mb-5">
            <div class="category-header-bs text-center">
              <h3 class="category-title-bs position-relative d-inline-block px-sm-4 px-3 py-2">{{ categoryData.name }}</h3>
            </div>
            <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 row-cols-xl-4 g-3 g-lg-4 justify-content-center">
              <div
                v-for="laptop in categoryData.laptops"
                :key="laptop.id"
                class="col d-flex align-items-stretch"
              >
                <transition name="fade-slide" appear>
                  <div
                    class="card h-100 card-bs"
                    @click="openModal(laptop)"
                    role="button"
                    tabindex="0"
                    :aria-label="`Lihat detail ${laptop.name}`"
                    @keydown.enter="openModal(laptop)"
                    @keydown.space="openModal(laptop)"
                  >
                    <div class="card-img-wrapper-bs">
                      <img :src="laptop.image" :alt="`Gambar ${laptop.name}`" class="card-img-top card-img-bs" />
                    </div>
                    <div class="card-body d-flex flex-column p-3">
                      <h4 class="card-title card-title-bs mb-2">{{ laptop.name }}</h4>
                      <p class="card-text-desc-bs small mb-2">{{ laptop.description.split(',')[0] }}</p>
                       <div class="mt-auto"> 
                        <p class="card-text card-text-price-bs mb-2">
                            <strong>Harga:</strong> {{ formatPrice(laptop.price) }}
                        </p>
                        <button
                            v-if="laptop.stock > 0"
                            class="btn btn-sm btn-primary w-100"
                            @click.stop="openModal(laptop)" 
                        >
                            <i class="bi bi-cart-plus-fill me-1"></i> Pilih & Checkout
                        </button>
                        <button
                            v-else
                            class="btn btn-sm btn-secondary w-100"
                            disabled
                        >
                            Stok Habis
                        </button>
                      </div>
                    </div>
                  </div>
                </transition>
              </div>
            </div>
          </div>
        </div>
        <div v-else key="no-result-message" class="no-results-bs text-center py-5">
          <p>Tidak ada laptop yang cocok dengan kriteria pencarian Anda.</p>
        </div>
      </transition-group>

      
      <div class="modal fade" id="laptopDetailModalBs" tabindex="-1" aria-labelledby="laptopDetailModalLabelBs" aria-hidden="true" ref="laptopDetailModalRef">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg">
          <div class="modal-content modal-content-bs">
            <div class="modal-header modal-header-bs">
              <h5 class="modal-title w-100 text-center modal-pc-title-bs" id="laptopDetailModalLabelBs">
                {{ selectedLaptopForModal?.name || 'Detail Laptop' }}
              </h5>
              <button type="button" class="btn-close modal-close-button-bs" @click="closeModal" aria-label="Tutup detail laptop"></button>
            </div>
            <div class="modal-body modal-body-bs">
              <div v-if="selectedLaptopForModal" class="row g-3 g-lg-4 align-items-start">
                <div class="col-lg-5 text-center">
                  <img :src="selectedLaptopForModal.image" :alt="`Gambar detail ${selectedLaptopForModal.name}`" class="img-fluid rounded modal-image-bs" />
                </div>
                <div class="col-lg-7 modal-details-text">
                  <div class="modal-info-group mb-3">
                    <p><strong>Kategori:</strong> {{ selectedLaptopForModal.category }}</p>
                    <p><strong>Brand:</strong> {{ selectedLaptopForModal.brand }}</p>
                    <p><strong>Harga:</strong> {{ formatPrice(selectedLaptopForModal.price) }}</p>
                    <p>
                      <strong>Status Stok:</strong>
                      <span :class="{'text-stock-ready-bs': selectedLaptopForModal.stock > 0, 'text-stock-kosong-bs': selectedLaptopForModal.stock <= 0}">
                        {{ selectedLaptopForModal.stock > 0 ? `Tersedia (${selectedLaptopForModal.stock} unit)` : 'Kosong' }}
                      </span>
                    </p>
                  </div>
                  <div class="specs-section-bs">
                    <h4 class="text-center text-lg-start">Spesifikasi Detail:</h4>
                    <ul>
                      <li v-for="(spec, index) in selectedLaptopForModal.description.split(',')" :key="`${selectedLaptopForModal.id}-spec-${index}`">
                        {{ spec.trim() }}
                      </li>
                    </ul>
                    
                    <div class="d-flex flex-column flex-md-row align-items-center gap-3 justify-content-center justify-content-lg-start mt-4">
                      <div class="input-group checkout-qty-group-bs">
                        <label for="checkoutQtyInput" class="input-group-text">Qty:</label>
                        <input
                          id="checkoutQtyInput"
                          type="number"
                          min="1"
                          :max="selectedLaptopForModal.stock > 0 ? selectedLaptopForModal.stock : 1"
                          v-model.number="checkoutQty"
                          class="form-control"
                          :disabled="selectedLaptopForModal.stock <= 0"
                          aria-label="Jumlah pembelian"
                        />
                      </div>
                      <button
                        type="button"
                        class="btn btn-primary checkout-button-bs"
                        :disabled="selectedLaptopForModal.stock <= 0 || checkoutQty < 1 || (selectedLaptopForModal.stock > 0 && checkoutQty > selectedLaptopForModal.stock)"
                        @click="addItemToCart(selectedLaptopForModal)"
                      >
                        <i class="bi bi-cart-plus-fill me-1"></i> Tambah ke Keranjang
                      </button>
                    </div>
                  </div>
                </div>
              </div>
              <div v-else class="text-center">
                <p>Silakan pilih laptop untuk melihat detail.</p>
              </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" @click="closeModal">Tutup</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.pc-list-section-bs {
  --primary-color: #00d9ff;
  --background-main: #0c101c;
  color: #e8eff5;
  min-height: 100vh;
  background: var(--background-main);
}
.container {
  max-width: 1200px;
  margin: auto;
  padding: 24px;
}
.section-title-bs {
  font-family: 'Orbitron', sans-serif;
  font-size: 2rem;
  color: #fff;
  margin-bottom: 2rem;
  text-align: center;
}
.filters-bs {
  background: #11192b;
  border-radius: 8px;
  padding: 1rem;
  margin-bottom: 2rem;
}
.search-box-bs, .filter-select-bs {
  background: #1a243a;
  color: #e8eff5;
  border-radius: 8px;
  border: 1px solid #00d9ff33;
  padding: 0.75rem 1rem;
}
.slider-harga-bs {
  background: var(--background-card);
  border: 1px solid var(--border-color-soft);
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
}
.price-range-label-bs {
  color: var(--primary-color);
  font-weight: 500;
  min-width: 140px;
}
.slider-harga-bs .slider-range-group {
  display: flex;
  flex-direction: column;
  align-items: stretch;
  gap: 0.5rem;
  flex: 1 1 0%;
  min-width: 180px;
}
.slider-harga-bs .form-range {
  margin: 0.2rem 0;
  width: 100%;
  accent-color: var(--primary-color);
}
.harga-min-bs, .harga-max-bs {
  font-family: 'Orbitron', sans-serif;
  color: var(--primary-color);
  font-weight: 600;
  font-size: 1rem;
  text-align: center;
}

@media (max-width: 767.98px) {
  .slider-harga-bs {
    flex-direction: column !important;
    gap: 0.5rem !important;
    padding: 0.7rem 0.5rem !important;
  }
  .price-range-label-bs {
    min-width: unset;
    width: 100%;
    text-align: left;
  }
  .slider-harga-bs .slider-range-group {
    min-width: 100%;
  }
}

.category-section-bs {
  margin-bottom: 2.2rem !important;
}
.category-header-bs {
  position: relative;
  margin-bottom: 2rem;
  border-radius: 10px;
  background-color: var(--background-section);
  border: 1px solid var(--border-color-medium);
  box-shadow: 0 5px 18px rgba(0,0,0,0.25);
  padding: 0.75rem 0;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 70px;
}
.category-title-bs {
  font-family: 'Orbitron', sans-serif;
  font-size: clamp(1.3rem, 2.8vw, 1.8rem);
  font-weight: 600;
  color: var(--primary-color);
  text-shadow: 0 0 3px rgba(0,0,0,0.5), 0 0 7px var(--primary-color);
  text-transform: uppercase;
  background-color: var(--background-card);
  border-radius: 6px;
  box-shadow: 0 2px 6px rgba(var(--primary-color-rgb-val), 0.15);
  border: 1px solid var(--border-color-soft);
  z-index: 2;
  padding: 0.5rem 2.5rem;
  margin: 0 auto;
  display: inline-block;
  min-width: 220px;
  text-align: center;
}
.row.row-cols-1.row-cols-sm-2.row-cols-lg-3.row-cols-xl-4.g-3.g-lg-4.justify-content-center {
  --bs-gutter-x: 1.2rem;
  --bs-gutter-y: 1.2rem;
  margin-left: 0;
  margin-right: 0;
}
.col.d-flex.align-items-stretch {
  display: flex !important;
  align-items: stretch !important;
  justify-content: center !important;
}
.card-bs {
  background: #1a243a;
  border-radius: 10px;
  box-shadow: 0 5px 15px #0006;
  color: #e8eff5;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  margin: 0 auto;
}
.card-bs:hover, .card-bs:focus-visible {
  transform: translateY(-5px) scale(1.015);
  box-shadow: 0 7px 22px rgba(var(--primary-color-rgb-val), 0.4);
  border-color: var(--border-color-strong);
  outline: none;
}
.card-bs:focus-visible:not(:hover) {
  outline: 2px solid var(--primary-color);
  outline-offset: 1px;
}

.card-img-wrapper-bs {
  background: #11192b;
  padding: 10px;
  width: 100%;
  aspect-ratio: 4 / 3;
  display: flex;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid var(--border-color-soft);
  box-sizing: border-box;
  min-height: 190px;
}
.card-img-bs {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
  border-radius: 4px;
}

.card-bs .card-body {
  padding: 1rem;
  text-align: center;
  flex-grow: 1;
}
.card-title-bs {
  font-family: 'Orbitron', sans-serif;
  font-size: 1rem;
  color: #00d9ff;
  margin-bottom: 0.5rem;
  line-height: 1.35;
  min-height: calc(1rem * 1.35 * 2);
  display: flex;
  align-items: center;
  justify-content: center;
}
.card-text-desc-bs {
  font-size: 0.8rem;
  color: var(--text-muted-bs);
  line-height: 1.4;
  margin-bottom: 0.75rem !important;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
  min-height: calc(0.8rem * 1.4 * 2);
}
.card-text-price-bs {
  font-size: 0.95rem;
  font-weight: bold;
  color: #fff;
}
.no-results-bs {
  margin-top: 30px;
  font-size: 1.1rem;
  color: #00d9ff;
}
.modal-content-bs {
  background: #0f1626;
  border-radius: 10px;
  color: #e8eff5;
}
.modal-header-bs {
  background: #1a243a;
  border-bottom: 1px solid #00d9ff33;
}
.modal-pc-title-bs {
  font-family: 'Orbitron', sans-serif;
  color: #00d9ff;
  font-size: 1.25rem;
}
.modal-close-button-bs {
  background: transparent;
  border: none;
  font-size: 1.6rem;
  color: #00d9ff;
}
.modal-image-bs {
  width: 100%;
  max-width: 280px;
  max-height: 220px;
  object-fit: contain;
  border-radius: 6px;
  background: #1a243a;
  border: 1px solid #00d9ff33;
  padding: 8px;
}
.specs-section-bs h4 {
  font-family: 'Orbitron', sans-serif;
  color: var(--primary-color);
  margin-bottom: 0.5rem;
  font-size: 1rem;
  font-weight: 600;
  letter-spacing: 0.5px;
  text-transform: uppercase;
}
.specs-section-bs ul {
  list-style: disc;
  padding-left: 1.1rem;
  margin-bottom: 0;
}
.specs-section-bs li {
  margin-bottom: 0.35rem;
  font-size: 0.825rem;
  color: var(--text-light);
  text-shadow: none;
  font-style: normal;
}
.text-stock-ready-bs {
  color: #28f57a !important;
  font-weight: bold;
  text-shadow: 0 0 3px #28f57a80;
}
.text-stock-kosong-bs {
  color: #ff4d4d !important;
  font-weight: bold;
  text-shadow: 0 0 3px #ff4d4d80;
}
.checkout-qty-group-bs {
  max-width: 140px;
}
.checkout-qty-group-bs .form-control {
  min-width: 60px;
  text-align: center;
}
.checkout-button-bs {
  background: #00d9ff;
  border: none;
  color: var(--background-main);
  font-weight: 600;
  min-width: 140px;
}
.checkout-button-bs:disabled {
  background: #555;
  cursor: not-allowed;
}

@keyframes scaleUpModal-bs {
  from { transform: scale(0.92) translateY(12px); opacity: 0; }
  to { transform: scale(1) translateY(0); opacity: 1; }
}

.fade-slide-enter-active, .fade-slide-leave-active {
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}
.fade-slide-enter-from, .fade-slide-leave-to {
  opacity: 0;
  transform: translateY(30px) scale(0.97);
}
.fade-slide-enter-to, .fade-slide-leave-from {
  opacity: 1;
  transform: translateY(0) scale(1);
}

@media (min-width: 768px) {
  .card-bs .card-body {
    text-align: left;
  }
  .card-title-bs {
    justify-content: flex-start;
  }
}

@media (max-width: 767.98px) {
  .filters-bs .col-md, .filters-bs .col-md-auto {
    flex-basis: 100%;
  }
  .section-title-bs {
    font-size: clamp(1.6rem, 4vw, 2.2rem);
    margin-bottom: 2rem !important;
  }
  .category-title-bs {
    justify-content: flex-start;
  }
}

@media (max-width: 575.98px) {
  .pc-list-section-bs .container {
    padding-left: 10px;
    padding-right: 10px;
  }
  .card-title-bs {
    font-size: 0.9rem;
    min-height: calc(0.9rem * 1.35 * 2);
  }
  .card-text-desc-bs {
    font-size: 0.75rem;
    min-height: calc(0.75rem * 1.4 * 2);
  }
   .card-text-price-bs {
    font-size: 0.85rem;
  }
  .card-bs .card-body {
    padding: 0.75rem;
  }
  .section-title-bs {
    font-size: clamp(1.4rem, 4.5vw, 1.8rem);
  }
  .category-title-bs {
    font-size: clamp(1rem, 2.8vw, 1.4rem);
    padding: 0.5rem 0.7rem;
  }
  .filters-bs {
    padding: 0.7rem;
  }
  .search-box-bs, .filter-select-bs {
    font-size: 0.85rem;
    padding: 0.6rem 0.9rem;
  }
  .modal-pc-title-bs {
    font-size: 1.1rem;
  }
   .modal-body-bs p, .specs-section-bs li {
    font-size: 0.75rem;
  }
  .modal-image-bs {
    max-height: 170px;
  }
  .specs-section-bs h4 {
    font-size: 0.9rem;
  }
  .row.g-3.g-lg-4 {
    --bs-gutter-x: 0.8rem;
    --bs-gutter-y: 0.8rem;
  }
  .checkout-qty-group-bs {
    width: 100%;
    max-width: none;
  }
  .checkout-button-bs {
    width: 100%;
  }
}

.hardware-title-wrapper {
  margin-bottom: 2.5rem;
}
.hardware-title-bs {
  font-family: 'Orbitron', sans-serif;
  font-size: clamp(2.2rem, 5vw, 3.2rem);
  font-weight: 900;
  color: #fff; /* putih polos */
  text-shadow: none; /* hilangkan efek neon/glow */
  letter-spacing: 1.5px;
  text-transform: uppercase;
  margin-bottom: 0;
  line-height: 1.1;
  position: relative;
  display: inline-block;
}
.hardware-title-bs::after {
  content: '';
  display: block;
  margin: 0 auto;
  margin-top: 10px;
  width: 80px;
  height: 4px;
  border-radius: 2px;
  background: linear-gradient(90deg, #00d9ff 0%, #007bff 100%);
}
.hardware-title-wrapper {
  text-align: center;
}
</style>