<script>
import { Modal } from 'bootstrap';

export default {
  name: "LaptopListSection",
  data() {
    return {
      laptops: [
        { id: 1, name: "Acer Aspire 3", category: "Low-End", price: 5000000, image: "src/img/Acer Aspire 3.png", description: "AMD Ryzen 3 3250U, RAM 4GB, SSD 256GB, Layar 15.6\" FHD, Radeon Graphics", stock: 12 },
        { id: 2, name: "HP 14s", category: "Low-End", price: 6000000, image: "src/img/Hp 14s.png", description: "Intel Core i3-1115G4, RAM 8GB, SSD 512GB, Layar 14\" FHD, Intel UHD Graphics", stock: 0 },
        { id: 3, name: "ASUS VivoBook 15", category: "Mid-Range", price: 8000000, image: "src/img/Asus Vivobook 15.png", description: "Intel Core i5-1135G7, RAM 8GB, SSD 512GB, Layar 15.6\" FHD, Intel Iris Xe Graphics", stock: 10 },
        { id: 4, name: "Lenovo IdeaPad 5", category: "Mid-Range", price: 10000000, image: "src/img/Lenovo IdeaPad 5.png", description: "AMD Ryzen 5 5500U, RAM 8GB, SSD 512GB, Layar 14\" FHD, Radeon Graphics", stock: 0 },
        { id: 5, name: "Dell Inspiron 15", category: "Mid-Range", price: 12000000, image: "src/img/Dell Inspiron 15.png", description: "Intel Core i7-1165G7, RAM 16GB, SSD 512GB, Layar 15.6\" FHD, Intel Iris Xe Graphics", stock: 9 },
        { id: 6, name: "MacBook Air M1", category: "High-End", price: 15000000, image: "src/img/MacBook Air M1.png", description: "Apple M1, RAM 8GB, SSD 256GB, Layar 13.3\" Retina, GPU 7-core/8-core", stock: 0 },
        { id: 7, name: "ASUS ROG Zephyrus G14", category: "High-End", price: 20000000, image: "src/img/ASUSROGZephyrusG14.png", description: "AMD Ryzen 7 4800HS, RAM 16GB, SSD 512GB, Layar 14\" FHD 120Hz, NVIDIA GTX 1650/RTX 2060", stock: 4 },
        { id: 8, name: "Dell XPS 13", category: "High-End", price: 25000000, image: "src/img/Dell XPS 13.png", description: "Intel Core i7-1165G7, RAM 16GB, SSD 1TB, Layar 13.4\" FHD+, Intel Iris Xe Graphics", stock: 0 },
        { id: 9, name: "MacBook Pro 16-inch", category: "High-End", price: 30000000, image: "src/img/MacBook Pro 16-inch.png", description: "Apple M1 Pro, RAM 16GB, SSD 512GB, Layar 16.2\" Liquid Retina XDR, GPU 16-core", stock: 3 },
        { id: 10, name: "Razer Blade 15", category: "High-End", price: 35000000, image: "src/img/Razer Blade 15.png", description: "Intel Core i7-11800H, RAM 16GB, SSD 1TB, Layar 15.6\" FHD 144Hz, NVIDIA RTX 3060", stock: 0 },
      ],
      searchQuery: "",
      selectedCategoryFilter: "",
      selectedLaptopForModal: null,
      bootstrapLaptopModal: null,
    };
  },
  mounted() {
    const modalElement = this.$refs.laptopDetailModalRef;
    if (modalElement) {
      this.bootstrapLaptopModal = new Modal(modalElement);
      modalElement.addEventListener('hidden.bs.modal', () => {
        this.selectedLaptopForModal = null;
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
        return matchesSearch && matchesCategory;
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
      });
      if (this.selectedCategoryFilter) {
        return categoryData.filter(cat => cat.name === this.selectedCategoryFilter && cat.laptops.length > 0);
      }
      return categoryData.filter(cat => cat.laptops.length > 0);
    }
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
      if (this.bootstrapLaptopModal) {
        this.bootstrapLaptopModal.show();
      }
    },
    closeModal() {
      if (this.bootstrapLaptopModal) {
        this.bootstrapLaptopModal.hide();
      }
    }
  }
};
</script>

<template>
  <section class="pc-list-section-bs">
    <div class="container py-4 py-md-5">
      <h2 class="section-title-bs text-center">List Laptop</h2>
      <!-- Filter Section -->
      <div class="row justify-content-center mb-4">
        <div class="col-lg-10 col-xl-8">
          <div class="filters-bs p-3 rounded-3">
            <div class="row g-2 g-md-3 align-items-center">
              <div class="col-md">
                <input
                  type="text"
                  v-model="searchQuery"
                  placeholder="Cari nama laptop..."
                  class="form-control form-control-lg search-box-bs"
                  aria-label="Cari laptop"
                />
              </div>
              <div class="col-md-auto">
                <select v-model="selectedCategoryFilter" class="form-select form-select-lg filter-select-bs" aria-label="Pilih kategori laptop">
                  <option value="">Semua Kategori</option>
                  <option value="Low-End">Low-End</option>
                  <option value="Mid-Range">Mid-Range</option>
                  <option value="High-End">High-End</option>
                </select>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- Laptop Categories and Cards -->
      <div v-if="filteredLaptops.length > 0">
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
              <div
                class="card h-100 card-bs"
                @click="openModal(laptop)"
                role="button"
                tabindex="0"
                @keydown.enter="openModal(laptop)"
                @keydown.space="openModal(laptop)"
              >
                <div class="card-img-wrapper-bs">
                  <img :src="laptop.image" :alt="laptop.name" class="card-img-top card-img-bs" />
                </div>
                <div class="card-body d-flex flex-column p-3">
                  <h4 class="card-title card-title-bs mb-2">{{ laptop.name }}</h4>
                  <p class="card-text-desc-bs small mb-2">{{ laptop.description.split(',')[0] }}</p>
                  <p class="card-text card-text-price-bs mt-auto mb-0">
                    <strong>Harga:</strong> {{ formatPrice(laptop.price) }}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div v-else class="no-results-bs text-center py-5">
        <p>Tidak ada laptop yang cocok dengan kriteria pencarian Anda.</p>
      </div>
      <!-- Modal Bootstrap -->
      <div class="modal fade" id="laptopDetailModalBs" tabindex="-1" aria-labelledby="laptopDetailModalLabelBs" aria-hidden="true" ref="laptopDetailModalRef">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg">
          <div class="modal-content modal-content-bs">
            <div class="modal-header modal-header-bs">
              <h5 class="modal-title w-100 text-center modal-pc-title-bs" id="laptopDetailModalLabelBs">
                {{ selectedLaptopForModal?.name }}
              </h5>
              <button type="button" class="btn-close modal-close-button-bs" @click="closeModal" aria-label="Tutup detail laptop"></button>
            </div>
            <div class="modal-body modal-body-bs">
              <div v-if="selectedLaptopForModal" class="row g-3 g-lg-4 align-items-center">
                <div class="col-lg-5 text-center">
                  <img :src="selectedLaptopForModal.image" :alt="selectedLaptopForModal.name" class="img-fluid rounded modal-image-bs" />
                </div>
                <div class="col-lg-7 modal-details-text">
                  <div class="modal-info-group mb-3">
                    <p><strong>Kategori:</strong> {{ selectedLaptopForModal.category }}</p>
                    <p><strong>Harga:</strong> {{ formatPrice(selectedLaptopForModal.price) }}</p>
                    <p>
                      <strong>Status Stok:</strong>
                      <span :class="{'text-stock-ready-bs': selectedLaptopForModal.stock > 0, 'text-stock-kosong-bs': selectedLaptopForModal.stock <= 0}">
                        {{ selectedLaptopForModal.stock > 0 ? 'Tersedia' : 'Kosong' }}
                      </span>
                    </p>
                  </div>
                  <div class="specs-section-bs">
                    <h4 class="text-center text-lg-start">Spesifikasi Detail:</h4>
                    <ul>
                      <li v-for="spec in selectedLaptopForModal.description.split(',')" :key="spec.trim()">
                        {{ spec.trim() }}
                      </li>
                    </ul>
                  </div>
                </div>
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
  max-width: 1100px;
  margin-left: auto;
  margin-right: auto;
  padding-left: 10px;
  padding-right: 10px;
  box-sizing: border-box;
}
@media (max-width: 1100px) {
  .container {
    max-width: 98vw;
    padding-left: 6px;
    padding-right: 6px;
  }
}
@media (max-width: 575.98px) {
  .container {
    max-width: 100vw;
    padding-left: 2px;
    padding-right: 2px;
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
  height: auto;
}
.search-box-bs::placeholder {
  color: rgba(224, 224, 224, 0.5);
}
.search-box-bs:focus, .filter-select-bs:focus {
  background-color: var(--background-section);
  border-color: var(--primary-color);
  box-shadow: 0 0 0 0.25rem rgba(var(--primary-color-rgb-val), 0.25);
  color: #fff;
}
.filter-select-bs {
  cursor: pointer;
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%2300d9ff' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3e%3c/svg%3e");
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
  justify-content: center;
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
  transition: transform 0.25s, box-shadow 0.25s, border-color 0.25s;
  cursor: pointer;
  color: var(--text-light);
  overflow: hidden;
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
  background-color: var(--background-section);
  padding: 10px;
  height: 190px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid var(--border-color-soft);
}
.card-img-bs {
  max-width: 220px;
  width: 100%;
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
  font-weight: 500;
  color: var(--primary-color);
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
.modal-content-bs {
  background: var(--background-modal);
  border-radius: 10px;
  box-shadow: 0 7px 25px rgba(var(--primary-color-rgb-val), 0.55);
  border: 1px solid var(--border-color-strong);
  color: var(--text-light);
  animation: scaleUpModal-bs 0.3s ease-out forwards;
  opacity: 0;
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
  padding: 0.35rem !important;
  transition: color 0.2s, transform 0.2s;
}
.modal-close-button-bs:hover {
  color: #fff !important;
  transform: scale(1.1);
  opacity: 1 !important;
}
.modal-close-button-bs:focus {
  box-shadow: none !important;
  outline: 1px solid var(--primary-color);
}
.modal-body-bs {
  padding: 1.25rem;
}
.modal-image-bs {
  width: 100%;
  max-width: 280px;
  max-height: 220px;
  object-fit: contain;
  border-radius: 6px;
  margin-bottom: 1.25rem;
  background-color: var(--background-card);
  border: 1px solid var(--border-color-medium);
  padding: 8px;
}
.modal-details-text {
  text-align: left;
}
.modal-info-group p {
  margin-bottom: 0.5rem;
  font-size: 0.875rem;
}
.modal-info-group strong {
  color: var(--primary-color);
  min-width: 70px;
  display: inline-block;
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
  list-style: disc;
  padding-left: 1.1rem;
  margin-bottom: 0;
}
.specs-section-bs li {
  margin-bottom: 0.35rem;
  font-size: 0.825rem;
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
@keyframes scaleUpModal-bs {
  from { transform: scale(0.92) translateY(12px); opacity: 0; }
  to { transform: scale(1) translateY(0); opacity: 1; }
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
    font-size: clamp(1.1rem, 2.8vw, 1.6rem);
  }
  .category-header-bs {
    margin-bottom: 1.5rem;
    padding: 0.6rem 0;
  }
  .modal-body-bs .row > div {
    text-align: center !important;
  }
  .specs-section-bs h4 {
    text-align: center !important;
  }
}
@media (max-width: 575.98px) {
  .pc-list-section-bs .container {
    padding-left: 10px;
    padding-right: 10px;
  }
  .card-img-wrapper-bs {
    height: 170px;
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
}
</style>