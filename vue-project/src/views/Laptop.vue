<script>
// ... (JavaScript Anda tetap sama) ...
import { Modal } from 'bootstrap';

export default {
  name: "LaptopListSection",
  data() {
    return {
      laptops: [
        { id: 1, name: "Acer Aspire 3", category: "Low-End", price: 5000000, image: "/public/img/Acer Aspire 3.webp", description: "AMD Ryzen 3 3250U, RAM 4GB, SSD 256GB, Layar 15.6\" FHD, Radeon Graphics", stock: 12 },
        { id: 2, name: "HP 14s", category: "Low-End", price: 6000000, image: "/public/img/Hp 14s.webp", description: "Intel Core i3-1115G4, RAM 8GB, SSD 512GB, Layar 14\" FHD, Intel UHD Graphics", stock: 0 },
        { id: 3, name: "ASUS VivoBook 15", category: "Mid-Range", price: 8000000, image: "/public/img/Asus Vivobook 15.webp", description: "Intel Core i5-1135G7, RAM 8GB, SSD 512GB, Layar 15.6\" FHD, Intel Iris Xe Graphics", stock: 10 },
        { id: 4, name: "Lenovo IdeaPad 5", category: "Mid-Range", price: 10000000, image: "/public/img/Lenovo IdeaPad 5.webp", description: "AMD Ryzen 5 5500U, RAM 8GB, SSD 512GB, Layar 14\" FHD, Radeon Graphics", stock: 0 },
        { id: 5, name: "Dell Inspiron 15", category: "Mid-Range", price: 12000000, image: "/public/img/Dell Inspiron 15.webp", description: "Intel Core i7-1165G7, RAM 16GB, SSD 512GB, Layar 15.6\" FHD, Intel Iris Xe Graphics", stock: 9 },
        { id: 6, name: "MacBook Air M1", category: "High-End", price: 15000000, image: "/public/img/MacBook Air M1.webp", description: "Apple M1, RAM 8GB, SSD 256GB, Layar 13.3\" Retina, GPU 7-core/8-core", stock: 0 },
        { id: 7, name: "ASUS ROG Zephyrus G14", category: "High-End", price: 20000000, image: "/public/img/ASUSROGZephyrusG14.webp", description: "AMD Ryzen 7 4800HS, RAM 16GB, SSD 512GB, Layar 14\" FHD 120Hz, NVIDIA GTX 1650/RTX 2060", stock: 4 },
        { id: 8, name: "Dell XPS 13", category: "High-End", price: 25000000, image: "/public/img/Dell XPS 13.webp", description: "Intel Core i7-1165G7, RAM 16GB, SSD 1TB, Layar 13.4\" FHD+, Intel Iris Xe Graphics", stock: 0 },
        { id: 9, name: "MacBook Pro 16-inch", category: "High-End", price: 30000000, image: "/public/img/MacBook Pro 16-inch.webp", description: "Apple M1 Pro, RAM 16GB, SSD 512GB, Layar 16.2\" Liquid Retina XDR, GPU 16-core", stock: 3 },
        { id: 10, name: "Razer Blade 15", category: "High-End", price: 35000000, image: "/public/img/Razer Blade 15.webp", description: "Intel Core i7-11800H, RAM 16GB, SSD 1TB, Layar 15.6\" FHD 144Hz, NVIDIA RTX 3060", stock: 0 },
      ],
      searchQuery: "",
      selectedCategoryFilter: "",
      selectedLaptopForModal: null,
      bootstrapLaptopModal: null,
      minPrice: 0,
      maxPrice: 0,
      priceSlider: [0, 0],
      checkoutQty: 1,
    };
  },
  created() {
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
  },
  mounted() {
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
        console.error("Checkout tidak valid:", laptop, this.checkoutQty);
        return;
      }
      console.log(`Checkout laptop: ${laptop.name}, Kategori: ${laptop.category}, Harga: ${this.formatPrice(laptop.price)}, Qty: ${this.checkoutQty}`);
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
  --secondary-color: #00c6ff;
  --background-main: #0c101c;
  --background-section: #11192b;
  --background-card: #1a243a;
  --background-modal: #0f1626;
  --text-light: #e8eff5;
  --text-muted-bs: #adb5bd;
  --text-title: #ffffff;
  --primary-color-rgb-val: 0, 217, 255;
  --border-color-soft: rgba(var(--primary-color-rgb-val), 0.2);
  --border-color-medium: rgba(var(--primary-color-rgb-val), 0.35);
  --border-color-strong: var(--primary-color);
  font-family: 'Roboto', sans-serif;
  min-height: 100vh;
  background: var(--background-main);
  color: var(--text-light);
  overflow-x: hidden;
}
.container {
  width: 100%;
  max-width: 1200px; /* Samakan ukuran container, misal 1200px */
  margin-left: auto;
  margin-right: auto;
  padding-left: 24px;
  padding-right: 24px;
  box-sizing: border-box;
}
@media (max-width: 1200px) {
  .container {
    max-width: 98vw;
    padding-left: 12px;
    padding-right: 12px;
  }
}
@media (max-width: 767.98px) {
  .container {
    max-width: 100vw;
    padding-left: 6px;
    padding-right: 6px;
  }
}
.section-title-bs {
  font-family: 'Orbitron', sans-serif;
  font-size: clamp(1.8rem, 4.5vw, 2.8rem);
  font-weight: 700;
  color: var(--text-title);
  text-shadow: 0 0 6px var(--text-title), 0 0 11px var(--primary-color), 0 0 16px var(--primary-color);
  margin-bottom: 3rem !important;
  position: relative;
  text-transform: uppercase;
  letter-spacing: 1px;
}
.section-title-bs::after {
  content: '';
  position: absolute;
  bottom: -10px;
  left: 50%;
  transform: translateX(-50%);
  width: 50px;
  height: 2.5px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
  border-radius: 1.5px;
  box-shadow: 0 0 8px var(--primary-color), 0 0 5px var(--secondary-color);
}
.filters-bs {
  background-color: var(--background-section);
  border: 1px solid var(--border-color-soft);
  box-shadow: 0 5px 20px rgba(0,0,0,0.18);
}
.search-box-bs, .filter-select-bs {
  padding: 0.75rem 1.1rem;
  border: 1px solid var(--border-color-medium);
  border-radius: 8px;
  background-color: var(--background-card);
  color: var(--text-light);
  font-size: 1rem;
  transition: border-color 0.2s, box-shadow 0.2s;
  height: auto; /* Override default form-control height if needed */
}
.search-box-bs::placeholder {
  color: rgba(224, 224, 224, 0.5);
}
.search-box-bs:focus, .filter-select-bs:focus {
  background-color: var(--background-section); /* Slightly darker on focus */
  border-color: var(--primary-color);
  box-shadow: 0 0 0 0.25rem rgba(var(--primary-color-rgb-val), 0.25);
  color: #fff;
}
.filter-select-bs {
  cursor: pointer;
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%2300d9ff' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3e%3c/svg%3e");
}

/* Price Slider Styling */
.slider-harga-bs {
  background: var(--background-card);
  border: 1px solid var(--border-color-soft);
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
}
.price-range-label-bs {
  color: var(--primary-color);
  font-weight: 500;
  min-width: 140px; /* Ensure label width is consistent */
}
.slider-harga-bs .slider-range-group {
  display: flex;
  flex-direction: column; /* Stack sliders vertically for better control */
  align-items: stretch; /* Make sliders take full width available */
  gap: 0.5rem; /* Space between sliders */
  flex: 1 1 0%; /* Allow group to grow */
  min-width: 180px; /* Minimum width for the slider group */
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
  text-align: center; /* Center price text */
}

@media (max-width: 767.98px) {
  .slider-harga-bs {
    flex-direction: column !important; /* Force column layout on smaller screens */
    gap: 0.5rem !important;
    padding: 0.7rem 0.5rem !important;
  }
  .price-range-label-bs {
    min-width: unset; /* Remove min-width for label */
    width: 100%;
    text-align: left; /* Align label to left */
  }
  .slider-harga-bs .slider-range-group {
    min-width: 100%; /* Group takes full width */
  }
}

.category-section-bs {
  margin-bottom: 2.2rem !important; /* Consistent bottom margin */
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
  padding: 0.5rem 2.5rem; /* Generous padding */
  margin: 0 auto; /* Center title */
  display: inline-block;
  min-width: 220px; /* Minimum width for title */
  text-align: center;
}
.row.row-cols-1.row-cols-sm-2.row-cols-lg-3.row-cols-xl-4.g-3.g-lg-4.justify-content-center {
  --bs-gutter-x: 1.2rem; /* Custom gutter for card grid */
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
  background: var(--background-card);
  border-radius: 10px;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
  border: 1px solid var(--border-color-medium);
  transition: transform 0.25s ease-out, box-shadow 0.25s ease-out, border-color 0.25s ease-out;
  cursor: pointer;
  color: var(--text-light);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  margin: 0 auto; /* Center card if col is wider */
}
.card-bs:hover, .card-bs:focus-visible {
  transform: translateY(-5px) scale(1.015);
  box-shadow: 0 7px 22px rgba(var(--primary-color-rgb-val), 0.4);
  border-color: var(--border-color-strong);
  outline: none;
}
.card-bs:focus-visible:not(:hover) { /* Style for focus without hover */
  outline: 2px solid var(--primary-color);
  outline-offset: 1px;
}

/* === PERUBAHAN DI SINI === */
.card-img-wrapper-bs {
  background-color: var(--background-section);
  padding: 10px;
  width: 100%; /* Mengikuti lebar card content area */
  aspect-ratio: 4 / 3; /* Menetapkan rasio aspek, misal 4:3. Sesuaikan jika perlu (misal 16/10, 1/1) */
  display: flex;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid var(--border-color-soft);
  box-sizing: border-box; /* Pastikan padding & border masuk dalam perhitungan width/height */
  min-height: 190px; /* Tambahkan tinggi minimum agar semua card sama tinggi, termasuk ASUS ROG Zephyrus G14 */
}

.card-img-bs {
  max-width: 100%; /* Gambar akan mengisi sebanyak mungkin wrapper sambil menjaga rasio aspek */
  max-height: 100%;
  object-fit: contain; /* Memastikan seluruh gambar terlihat, menjaga rasio aspek */
  border-radius: 4px;
}
/* === AKHIR PERUBAHAN === */

.card-bs .card-body {
  padding: 1rem;
  text-align: center; /* Default text align */
  flex-grow: 1; /* Allow body to take remaining space */
}
.card-title-bs {
  font-family: 'Orbitron', sans-serif;
  font-size: 1rem;
  font-weight: 500;
  color: var(--primary-color);
  margin-bottom: 0.5rem;
  line-height: 1.35;
  min-height: calc(1rem * 1.35 * 2); /* Ensure 2 lines of text height */
  display: flex;
  align-items: center;
  justify-content: center; /* Center title text */
}
.card-text-desc-bs {
  font-size: 0.8rem;
  color: var(--text-muted-bs);
  line-height: 1.4;
  margin-bottom: 0.75rem !important;
  display: -webkit-box;
  -webkit-line-clamp: 2; /* Limit to 2 lines */
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
  min-height: calc(0.8rem * 1.4 * 2); /* Ensure 2 lines height */
}
.card-text-price-bs {
  font-size: 0.95rem;
  font-weight: bold;
  color: #fff;
}
.card-text-price-bs strong {
  color: var(--primary-color);
  margin-right: 0.25rem;
}
.no-results-bs {
  margin-top: 30px;
  font-size: 1.1rem;
  color: var(--primary-color);
  font-family: 'Orbitron', sans-serif;
}

/* Modal Styling */
.modal-content-bs {
  background: var(--background-modal);
  border-radius: 10px;
  box-shadow: 0 7px 25px rgba(var(--primary-color-rgb-val), 0.55);
  border: 1px solid var(--border-color-strong);
  color: var(--text-light);
  animation: scaleUpModal-bs 0.3s ease-out forwards;
  opacity: 0; /* Initial state for animation */
}
.modal-header-bs {
  background-color: var(--background-card);
  border-bottom: 1px solid var(--border-color-medium);
  padding: 0.9rem 1.1rem;
}
.modal-pc-title-bs {
  font-family: 'Orbitron', sans-serif;
  color: var(--primary-color);
  font-size: 1.25rem;
  text-shadow: 0 0 4px var(--primary-color);
}
.modal-close-button-bs {
  background: transparent !important;
  border: none !important;
  font-size: 1.6rem !important;
  font-weight: bold !important;
  color: var(--primary-color) !important;
  opacity: 0.8 !important;
  text-shadow: none !important;
  padding: 0.35rem !important; /* Easier to click */
  transition: color 0.2s, transform 0.2s;
}
.modal-close-button-bs:hover {
  color: #fff !important;
  transform: scale(1.1);
  opacity: 1 !important;
}
.modal-close-button-bs:focus {
  box-shadow: none !important; /* Remove default Bootstrap focus */
  outline: 1px solid var(--primary-color); /* Custom focus for accessibility */
}
.modal-body-bs {
  padding: 1.25rem;
}
.modal-image-bs {
  width: 100%;
  max-width: 280px; /* Max width for modal image */
  max-height: 220px; /* Max height for modal image */
  object-fit: contain;
  border-radius: 6px;
  margin-bottom: 1.25rem;
  background-color: var(--background-card); /* Background for image container */
  border: 1px solid var(--border-color-medium);
  padding: 8px; /* Padding around image */
}
.modal-details-text {
  text-align: left; /* Align text to left in details section */
}
.modal-info-group p {
  margin-bottom: 0.5rem;
  font-size: 0.875rem;
}
.modal-info-group strong {
  color: var(--primary-color);
  min-width: 70px; /* Ensure consistent label width */
  display: inline-block; /* For min-width to take effect */
}
.specs-section-bs {
  margin-top: 1rem;
  padding-top: 0.8rem;
  border-top: 1px solid var(--border-color-soft);
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
  list-style: disc; /* Standard disc bullets */
  padding-left: 1.1rem;
  margin-bottom: 0;
}
.specs-section-bs li {
  margin-bottom: 0.35rem;
  font-size: 0.825rem;
  color: var(--text-light);
  text-shadow: none; /* Remove any inherited text-shadow */
  font-style: normal; /* Ensure normal font style */
}
.text-stock-ready-bs {
  color: #28f57a !important; /* Use !important carefully */
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
  text-align: center; /* Center quantity text */
}
.checkout-button-bs {
  background: var(--primary-color);
  border: none;
  font-weight: 600;
  min-width: 140px;
  transition: background-color 0.2s, transform 0.1s;
}
.checkout-button-bs:hover:not(:disabled) {
  background: var(--secondary-color);
  transform: scale(1.03);
}
.checkout-button-bs:disabled {
  background: #555; /* Darker background for disabled state */
  cursor: not-allowed;
}

@keyframes scaleUpModal-bs {
  from { transform: scale(0.92) translateY(12px); opacity: 0; }
  to { transform: scale(1) translateY(0); opacity: 1; }
}

/* Transitions for list items and sections */
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

/* Responsive Adjustments */
@media (min-width: 768px) {
  .card-bs .card-body {
    text-align: left; /* Align card body text to left on md and up */
  }
  .card-title-bs {
    justify-content: flex-start; /* Align title to left */
  }
}

@media (max-width: 767.98px) {
  .filters-bs .col-md, .filters-bs .col-md-auto {
    flex-basis: 100%; /* Stack filter inputs */
  }
  .section-title-bs {
    font-size: clamp(1.6rem, 4vw, 2.2rem);
    margin-bottom: 2rem !important;
  }
  .category-title-bs {
    font-size: clamp(1.1rem, 2.8vw, 1.6rem);
  }
  .category-header-bs {
    margin-bottom: 1.5rem;
    padding: 0.6rem 0;
  }
  .modal-body-bs .row > div { /* Center content in modal on small screens */
    text-align: center !important;
  }
  .modal-details-text {
    text-align: center; /* Ensure details text is also centered if content above it is */
  }
  .specs-section-bs h4 {
    text-align: center !important; /* Center specs title */
  }
  .specs-section-bs ul {
    padding-left: 1.5rem; /* Adjust padding for centered list */
    display: inline-block; /* Allows text-align:center on parent to work for ul */
    text-align: left; /* Re-align list items to left */
  }
}

@media (max-width: 575.98px) {
  .pc-list-section-bs .container {
    padding-left: 10px; /* Slightly more padding on very small screens */
    padding-right: 10px;
  }
  /* Hapus pengaturan height eksplisit untuk card-img-wrapper-bs di sini karena sudah diatur oleh aspect-ratio */
  /* .card-img-wrapper-bs {
    height: 170px;
  } */
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
    padding: 0.75rem; /* Reduce card body padding */
  }
  .section-title-bs {
    font-size: clamp(1.4rem, 4.5vw, 1.8rem);
  }
  .category-title-bs {
    font-size: clamp(1rem, 2.8vw, 1.4rem);
    padding: 0.5rem 0.7rem; /* Reduce padding */
  }
  .filters-bs {
    padding: 0.7rem; /* Reduce filter padding */
  }
  .search-box-bs, .filter-select-bs {
    font-size: 0.85rem;
    padding: 0.6rem 0.9rem; /* Adjust input padding */
  }
  .modal-pc-title-bs {
    font-size: 1.1rem;
  }
   .modal-body-bs p, .specs-section-bs li {
    font-size: 0.75rem;
  }
  .modal-image-bs {
    max-height: 170px; /* Adjust modal image height */
  }
  .specs-section-bs h4 {
    font-size: 0.9rem;
  }
  .row.g-3.g-lg-4 { /* Reduce gutter on small screens */
    --bs-gutter-x: 0.8rem;
    --bs-gutter-y: 0.8rem;
  }
  .checkout-qty-group-bs {
    width: 100%; /* Make Qty input group full width */
    max-width: none;
  }
  .checkout-button-bs {
    width: 100%; /* Make checkout button full width */
  }
}
</style>