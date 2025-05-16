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
  <section class="laptop-list-section-bs">
    <div class="container py-5">
      <h2 class="section-title-bs text-center">List Laptop</h2>

      <!-- Filter Section -->
      <div class="row justify-content-center mb-4 mb-md-5">
        <div class="col-lg-10 col-xl-8">
          <div class="filters-bs p-3 rounded-3">
            <div class="row g-3 align-items-center">
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
            <h3 class="category-title-bs d-inline-block px-sm-4 px-3 py-2">{{ categoryData.name }}</h3>
          </div>

          <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 row-cols-xl-4 g-3 g-md-4 justify-content-center">
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
                <div class="card-img-container-bs">
                  <img :src="laptop.image" :alt="laptop.name" class="card-img-bs" />
                </div>
                <div class="card-body d-flex flex-column p-3">
                  <h4 class="card-title card-title-bs mb-2">{{ laptop.name }}</h4>
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
              <h5 class="modal-title w-100 text-center modal-laptop-title-bs" id="laptopDetailModalLabelBs">
                {{ selectedLaptopForModal?.name }}
              </h5>
              <button type="button" class="btn-close modal-close-button-bs" @click="closeModal" aria-label="Tutup detail laptop"></button>
            </div>
            <div class="modal-body modal-body-bs">
              <div v-if="selectedLaptopForModal" class="row g-3 g-md-4">
                <div class="col-md-5 text-center">
                  <img :src="selectedLaptopForModal.image" :alt="selectedLaptopForModal.name" class="img-fluid rounded modal-image-bs" />
                </div>
                <div class="col-md-7 modal-details-text">
                  <div class="modal-info-group mb-3">
                    <p><strong>Kategori:</strong> {{ selectedLaptopForModal.category }}</p>
                    <p><strong>Harga:</strong> {{ formatPrice(selectedLaptopForModal.price) }}</p>
                    <p>
                      <strong>Status Stok:</strong>
                      <span :class="{'text-stock-ready-bs': selectedLaptopForModal.stock > 0, 'text-stock-kosong-bs': selectedLaptopForModal.stock <= 0}">
                        {{ selectedLaptopForModal.stock > 0 ? 'Tersedia' : 'Kosong' }} ({{selectedLaptopForModal.stock}} unit)
                      </span>
                    </p>
                  </div>
                  <div class="specs-section-bs">
                    <h4 class="text-center text-md-start">Spesifikasi Detail:</h4>
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
/* Variabel Warna Lokal */
.laptop-list-section-bs {
  --primary-color: #00d9ff;
  --secondary-color: #00c6ff;
  --background-main: #0c101c; /* Lebih gelap & solid */
  --background-section: #11192b; /* Background untuk filter & header kategori */
  --background-card: #1a243a;   /* Background untuk kartu */
  --background-modal: #0f1626;  /* Background untuk modal */
  --text-light: #e0e0e0;
  --text-dark: #1a1a24; /* Untuk teks di atas background terang jika ada */
  --text-title: #ffffff;
  --primary-color-rgb-val: 0, 217, 255;
  --border-color-soft: rgba(var(--primary-color-rgb-val), 0.25);
  --border-color-medium: rgba(var(--primary-color-rgb-val), 0.45);
  --border-color-strong: var(--primary-color);

  font-family: 'Roboto', sans-serif;
  min-height: 100vh;
  background: var(--background-main);
  color: var(--text-light);
  overflow-x: hidden;
}

/* Judul Utama Section */
.section-title-bs {
  font-family: 'Orbitron', sans-serif;
  font-size: clamp(2rem, 5vw, 3rem);
  font-weight: 700;
  color: var(--text-title);
  text-shadow: 0 0 7px var(--text-title), 0 0 12px var(--primary-color), 0 0 18px var(--primary-color);
  margin-bottom: 2.5rem !important;
  position: relative;
  text-transform: uppercase;
  letter-spacing: 1.5px;
}
.section-title-bs::after {
  content: '';
  position: absolute;
  bottom: -12px;
  left: 50%;
  transform: translateX(-50%);
  width: 60px;
  height: 3px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
  border-radius: 2px;
  box-shadow: 0 0 10px var(--primary-color), 0 0 7px var(--secondary-color);
}

/* Filter Section */
.filters-bs {
  background-color: var(--background-section);
  border: 1px solid var(--border-color-soft);
  box-shadow: 0 5px 20px rgba(0,0,0,0.25);
}
.search-box-bs, .filter-select-bs {
  padding: 0.65rem 1rem; /* Padding lebih besar */
  border: 1px solid var(--border-color-medium);
  border-radius: 6px; /* Radius lebih besar */
  background-color: var(--background-card);
  color: var(--text-light);
  font-size: 0.95rem; /* Font size lebih besar */
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}
.search-box-bs::placeholder {
  color: rgba(224, 224, 224, 0.6);
}
.search-box-bs:focus, .filter-select-bs:focus {
  background-color: var(--background-section);
  border-color: var(--primary-color);
  box-shadow: 0 0 0 0.25rem rgba(var(--primary-color-rgb-val), 0.3);
  color: #fff;
}
.filter-select-bs {
  cursor: pointer;
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%2300d9ff' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3e%3c/svg%3e");
}

/* Category Section Styling */
.category-header-bs {
  position: relative;
  margin-bottom: 2rem; /* Jarak dari header ke kartu */
  background-color: transparent; /* Header tidak perlu background sendiri */
  border: none; /* Tidak perlu border */
}
.category-title-bs {
  font-family: 'Orbitron', sans-serif;
  font-size: clamp(1.4rem, 3vw, 2rem);
  font-weight: 600;
  color: var(--primary-color);
  text-shadow: 0 0 4px rgba(0,0,0,0.6), 0 0 8px var(--primary-color);
  text-transform: uppercase;
  background-color: var(--background-section);
  border-radius: 8px;
  box-shadow: 0 3px 10px rgba(var(--primary-color-rgb-val), 0.2);
  border: 1px solid var(--border-color-soft);
  /* Tambahan agar border panjang */
  display: block;
  width: 100%;
  padding-left: 0;
  padding-right: 0;
  margin-left: auto;
  margin-right: auto;
}

/* Card Styling */
.card-bs {
  background: var(--background-card);
  border-radius: 10px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
  border: 1px solid var(--border-color-soft);
  transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
  cursor: pointer;
  color: var(--text-light);
  overflow: hidden;
  display: flex;
  flex-direction: column;
}
.card-bs:hover, .card-bs:focus-visible {
  transform: translateY(-6px) scale(1.025);
  box-shadow: 0 8px 25px rgba(var(--primary-color-rgb-val), 0.45);
  border-color: var(--border-color-strong);
  outline: none;
}
.card-bs:focus-visible:not(:hover) {
  outline: 2px solid var(--primary-color);
  outline-offset: 1px;
}

.card-img-container-bs { /* Tidak lagi digunakan, gambar langsung di card-img-top */ }

.card-img-bs { /* Ganti nama dari card-image-bs */
  width: 100%;
  height: 180px;
  object-fit: contain;
  background-color: var(--background-section);
  padding: 10px; /* Padding agar gambar tidak menempel ke tepi */
  border-bottom: 1px solid var(--border-color-soft);
}
.card-bs .card-body {
  padding: 1rem;
  text-align: center; /* Konten kartu default center */
  flex-grow: 1;
}
.card-title-bs {
  font-family: 'Orbitron', sans-serif;
  font-size: 1.1rem;
  font-weight: 500;
  color: var(--primary-color);
  margin-bottom: 0.5rem;
  line-height: 1.3;
  min-height: calc(1.1rem * 1.3 * 2); /* Ruang untuk 2 baris judul */
  display: flex;
  align-items: center;
  justify-content: center;
}
.card-text-price-bs {
  font-size: 1rem; /* Harga lebih besar */
  font-weight: bold;
  color: #fff;
}
.card-text-price-bs strong {
  color: var(--primary-color);
  margin-right: 0.25rem;
}

.no-results-bs {
  font-size: 1.2rem;
  color: var(--primary-color);
  font-family: 'Orbitron', sans-serif;
}

/* Modal Styling */
.modal-content-bs {
  background: var(--background-modal);
  border-radius: 10px;
  box-shadow: 0 8px 30px rgba(var(--primary-color-rgb-val), 0.6);
  border: 1px solid var(--border-color-strong);
  color: var(--text-light);
  animation: scaleUpModal-bs 0.3s ease 0.05s forwards;
  opacity: 0; /* Awalnya transparan untuk animasi */
}
.modal-header-bs {
  background-color: var(--background-card);
  border-bottom: 1px solid var(--border-color-medium);
  padding: 1rem 1.25rem;
}
.modal-laptop-title-bs {
  font-family: 'Orbitron', sans-serif;
  color: var(--primary-color);
  font-size: 1.3rem;
  text-shadow: 0 0 5px var(--primary-color);
}
.modal-close-button-bs {
  background: transparent !important;
  border: none !important;
  font-size: 1.7rem !important;
  font-weight: bold !important;
  color: var(--primary-color) !important;
  opacity: 0.85 !important;
  text-shadow: none !important;
  padding: 0.4rem !important;
  transition: color 0.2s ease, transform 0.2s ease;
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
  padding: 1.25rem 1.5rem; /* Padding lebih seimbang */
}
.modal-image-bs {
  width: 100%;
  max-width: 300px; /* Gambar modal bisa lebih besar */
  max-height: 240px;
  object-fit: contain;
  border-radius: 8px;
  margin-bottom: 1.5rem; /* Jarak lebih */
  background-color: var(--background-card);
  border: 1px solid var(--border-color-medium);
  padding: 10px;
}
.modal-details-text {
  text-align: left; /* Detail teks rata kiri */
}
.modal-info-group p {
  margin-bottom: 0.6rem;
  font-size: 0.9rem;
}
.modal-info-group strong {
  color: var(--primary-color);
  min-width: 80px; /* Agar label sejajar */
  display: inline-block;
}
.specs-section-bs {
  margin-top: 1.25rem;
  padding-top: 1rem;
  border-top: 1px solid var(--border-color-soft);
}
.specs-section-bs h4 {
  font-family: 'Orbitron', sans-serif;
  color: var(--primary-color);
  margin-bottom: 0.6rem;
  font-size: 1rem;
  font-weight: 600;
  letter-spacing: 0.5px;
  text-transform: uppercase;
}
.specs-section-bs ul {
  list-style: disc;
  padding-left: 1.25rem;
  margin-bottom: 0;
}
.specs-section-bs li {
  margin-bottom: 0.4rem;
  font-size: 0.85rem;
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
  from { transform: scale(0.9) translateY(15px); opacity: 0; }
  to { transform: scale(1) translateY(0); opacity: 1; }
}

/* Responsive Adjustments */
@media (min-width: 768px) { /* md breakpoint ke atas */
  .card-bs .card-body {
    text-align: left; /* Konten kartu rata kiri di layar lebih besar */
  }
  .card-title-bs {
    justify-content: flex-start; /* Judul rata kiri */
  }
}
@media (max-width: 767.98px) { /* Di bawah md */
  .filters-bs .col-md, .filters-bs .col-md-auto {
    flex-basis: 100%; /* Filter jadi full width dan stack */
  }
  .filters-bs .form-select {
    width: 100%;
  }
  .section-title-bs {
    font-size: clamp(1.7rem, 4.5vw, 2.4rem);
    margin-bottom: 2rem !important;
  }
  .category-title-bs {
    font-size: clamp(1.2rem, 3.2vw, 1.7rem);
  }
  .category-header-bs {
    margin-bottom: 1.5rem;
    padding: 0.75rem 0;
  }
   .modal-body-bs .row > div { /* Pastikan gambar dan teks modal stack di mobile */
    text-align: center !important;
  }
  .specs-section-bs h4 {
    text-align: center !important;
  }
}

@media (max-width: 575.98px) { /* sm breakpoint */
  .laptop-list-section-bs .container {
    padding-left: 15px;
    padding-right: 15px;
  }
  .card-img-bs {
    height: 160px;
  }
  .card-title-bs {
    font-size: 0.9rem;
    min-height: calc(0.9rem * 1.3 * 2);
  }
   .card-text-price-bs {
    font-size: 0.8rem;
  }
  .card-bs .card-body {
    padding: 0.75rem;
  }
  .section-title-bs {
    font-size: clamp(1.5rem, 5vw, 2rem);
  }
  .category-title-bs {
    font-size: clamp(1.1rem, 3vw, 1.5rem);
    padding: 0.6rem 0.8rem;
  }
  .filters-bs {
    padding: 1rem;
  }
  .search-box-bs, .filter-select-bs {
    font-size: 0.9rem;
    padding: 0.55rem 0.8rem;
    height: auto;
  }
  .modal-laptop-title-bs {
    font-size: 1.1rem;
  }
   .modal-body-bs p, .specs-section-bs li {
    font-size: 0.8rem;
  }
  .modal-image-bs {
    max-height: 180px;
  }
  .specs-section-bs h4 {
    font-size: 0.9rem;
  }
  .row.g-3.g-md-4 { /* Kurangi gap lebih lanjut di mobile */
    --bs-gutter-x: 0.75rem;
    --bs-gutter-y: 0.75rem;
  }
}
</style>