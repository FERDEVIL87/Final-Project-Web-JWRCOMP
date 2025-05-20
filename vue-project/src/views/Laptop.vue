<script>
import { Modal } from 'bootstrap';

export default {
  name: "LaptopListSection",
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
      return uniqueCategories.map(categoryName => {
        const laptopsInCategory = this.filteredLaptops.filter(laptop => laptop.category === categoryName);
        return {
          name: categoryName,
          laptops: laptopsInCategory,
        };
      }).filter(category => category.laptops.length > 0);
    },
  },
  methods: {
    formatPrice(value) {
      if (typeof value !== "number" || isNaN(value)) {
        return 'Rp 0';
      }
      return `Rp ${new Intl.NumberFormat('id-ID').format(value)}`;
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
        return;
      }
      this.closeModal();
    }
  }
};
</script>

<template>
  <!-- ... (Template Anda tetap sama) ... -->
  <section class="pc-list-section-bs">
    <div class="container py-4 py-md-5">
      <h2 class="section-title-bs text-center">List Laptop</h2>

      <!-- Filter Section -->
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
              <!-- Price Range Slider -->
              <div class="row mt-3 align-items-center">
                <div class="col-12">
                  <div class="slider-harga-bs d-flex flex-column flex-md-row align-items-center gap-3 p-2 rounded-3">
                    <label for="minPriceSlider" class="form-label mb-0 price-range-label-bs">Rentang Harga (Rp):</label>
                    <div class="slider-range-group">
                      <span class="harga-min-bs" style="min-width: 90px;">{{ formatPrice(priceSlider[0]) }}</span>
                      <input
                        id="minPriceSlider"
                        type="range"
                        v-model.number="priceSlider[0]"
                        :min="minPrice"
                        :max="priceSlider[1]"
                        step="100000"
                        class="form-range slider-min-bs"
                        aria-label="Slider harga minimum"
                      />
                      <input
                        id="maxPriceSlider"
                        type="range"
                        v-model.number="priceSlider[1]"
                        :min="priceSlider[0]"
                        :max="maxPrice"
                        step="100000"
                        class="form-range slider-max-bs"
                        aria-label="Slider harga maksimum"
                      />
                      <span class="harga-max-bs" style="min-width: 90px;">{{ formatPrice(priceSlider[1]) }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </transition>

      <!-- Laptop Categories and Cards -->
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
                      <p class="card-text card-text-price-bs mt-auto mb-0">
                        <strong>Harga:</strong> {{ formatPrice(laptop.price) }}
                      </p>
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

      <!-- Bootstrap Modal for Laptop Details -->
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
                    <!-- Checkout Section -->
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
                        :disabled="selectedLaptopForModal.stock <= 0 || checkoutQty < 1 || checkoutQty > selectedLaptopForModal.stock"
                        @click="checkout(selectedLaptopForModal)"
                      >
                        Checkout
                      </button>
                    </div>
                  </div>
                </div>
              </div>
              <div v-else class="text-center">
                <p>Silakan pilih laptop untuk melihat detail.</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* Variabel Warna Lokal dan layout utama mirip PaketRakitan */
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
  background: #1a243a;
  border-radius: 8px;
  padding: 1rem;
}
.card-bs {
  background: #1a243a;
  border-radius: 10px;
  box-shadow: 0 5px 15px #0006;
  color: #e8eff5;
  cursor: pointer;
  display: flex;
  flex-direction: column;
}
.card-img-wrapper-bs {
  background: #11192b;
  padding: 10px;
  aspect-ratio: 4/3;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 190px;
}
.card-img-bs {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
  border-radius: 4px;
}
.card-title-bs {
  font-family: 'Orbitron', sans-serif;
  font-size: 1rem;
  color: #00d9ff;
  margin-bottom: 0.5rem;
}
.card-text-desc-bs {
  font-size: 0.8rem;
  color: #adb5bd;
  min-height: 2.2em;
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
.text-stock-ready-bs { color: #28f57a; font-weight: bold; }
.text-stock-kosong-bs { color: #ff4d4d; font-weight: bold; }
.checkout-qty-group-bs { max-width: 140px; }
.checkout-button-bs {
  background: #00d9ff;
  border: none;
  font-weight: 600;
  min-width: 140px;
}
.checkout-button-bs:disabled {
  background: #555;
  cursor: not-allowed;
}
</style>