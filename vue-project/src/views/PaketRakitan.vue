<template>
  <section class="pc-list-section-bs">
    <div class="container py-4 py-md-5">
      <h2 class="section-title-bs text-center">Paket Rakitan PC & Simulasi Kustom</h2>

      <!-- Tombol Simulasi -->
      <div class="text-center mb-4">
        <button class="btn btn-pembelian-paket-bs" @click="showSimulasi = !showSimulasi">
          {{ showSimulasi ? 'Tutup Simulasi Kustom' : 'Buat Rakitan Kustom' }}
        </button>
      </div>

      <!-- Bagian Simulasi Kustom -->
      <transition name="fade-slide">
        <div v-if="showSimulasi" class="simulasi-form-bs p-3 rounded-3 mb-4 shadow-lg">
          <div v-if="loadingParts" class="text-center p-5">Memuat komponen...</div>
          <div v-else-if="partsError" class="text-center p-5 text-danger">{{ partsError }}</div>
          <div v-else>
            <table class="table table-dark table-bordered align-middle mb-0">
              <thead>
                <tr>
                  <th>Komponen</th><th>Nama</th><th>Harga</th><th>Pilihan</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(options, part) in partsData" :key="part">
                  <td><strong>{{ part.replace(/_/g, ' ') }}</strong></td>
                  <td>{{ selectedParts[part] ? selectedParts[part].name : 'Belum dipilih' }}</td>
                  <td>{{ selectedParts[part] ? formatPrice(selectedParts[part].price) : '-' }}</td>
                  <td>
                    <div class="dropdown">
                      <button class="btn btn-sm btn-outline-info dropdown-toggle" type="button" data-bs-toggle="dropdown" :disabled="options.length === 0">
                        {{ options.length > 0 ? 'Pilih' : 'Kosong' }}
                      </button>
                      <ul class="dropdown-menu">
                        <li v-for="item in options" :key="item.id">
                          <a class="dropdown-item" href="#" @click.prevent="selectPart(part, item)">{{ item.name }} ({{ formatPrice(item.price) }})</a>
                        </li>
                        <li v-if="options.length === 0"><span class="dropdown-item-text text-muted">Komponen tidak tersedia</span></li>
                        <li v-if="selectedParts[part]"><hr class="dropdown-divider"><a class="dropdown-item text-danger" href="#" @click.prevent="selectPart(part, null)">Kosongkan</a></li>
                      </ul>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
            <div class="d-flex justify-content-between align-items-center mt-3">
              <div class="total-bs fs-5 fw-bold">Total Simulasi: {{ formatPrice(totalSimulasi) }}</div>
              <div>
                <button class="btn btn-secondary me-2" @click="resetSimulasi">Reset</button>
                <button class="btn btn-success" @click="addToCartSimulasi" :disabled="!isSimulasiLengkap" title="Harap lengkapi semua komponen">
                  Tambah ke Keranjang
                </button>
              </div>
            </div>
          </div>
        </div>
      </transition>
      
      <!-- Keranjang Belanja Global -->
      <div class="text-center my-4 py-3 border-top border-bottom border-secondary">
        <h4>Keranjang Belanja Global</h4>
        <p v-if="cartStore.items.length > 0">Total Item: {{ cartStore.items.length }} | Total Harga: <span class="text-success fw-bold">{{ formatPrice(cartStore.totalPrice) }}</span></p>
        <p v-else class="text-muted">Keranjang belanja utama masih kosong.</p>
        <button class="btn btn-success btn-lg px-5" @click="goToCheckout">Lihat Keranjang & Checkout</button>
      </div>

      <!-- Filter untuk Paket Jadi -->
      <div class="row justify-content-center mb-4">
        <div class="col-lg-10 col-xl-8">
          <div class="filters-bs p-3 rounded-3">
            <div class="row g-2 g-md-3 align-items-center">
              <div class="col-md">
                <input type="text" v-model="searchQuery" placeholder="Cari nama paket..." class="form-control form-control-lg"/>
              </div>
              <div class="col-md-auto">
                <select v-model="selectedCategoryFilter" class="form-select form-select-lg">
                  <option value="">Semua Kategori</option>
                  <option v-for="cat in uniqueCategoriesList" :key="cat" :value="cat">{{ cat }}</option>
                </select>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Tampilan Paket Jadi -->
      <div v-if="loadingPCs" class="text-center py-5">Memuat paket rakitan...</div>
      <div v-else-if="errorPCs" class="text-center text-danger py-5">{{ errorPCs }}</div>
      <div v-else-if="filteredPCs.length > 0">
        <div v-for="categoryData in categoriesWithPCs" :key="categoryData.name" class="category-section-bs mb-5">
          <div class="category-header-bs text-center">
            <h3 class="category-title-bs">{{ categoryData.name }}</h3>
          </div>
          <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 row-cols-xl-4 g-3 g-lg-4 justify-content-center">
            <div v-for="pc in categoryData.pcs" :key="pc.id" class="col d-flex align-items-stretch">
              <div class="card h-100 card-bs" role="button" tabindex="0">
                <div class="card-img-wrapper-bs" @click="openModal(pc)">
                  <img :src="pc.image" :alt="pc.name" class="card-img-top card-img-bs" />
                </div>
                <div class="card-body d-flex flex-column p-3">
                  <h4 class="card-title card-title-bs mb-2" @click="openModal(pc)">{{ pc.name }}</h4>
                  <p class="card-text-desc-bs small mb-2" @click="openModal(pc)">{{ pc.description }}</p>
                  <div class="mt-auto">
                    <p class="card-text card-text-price-bs mb-2"><strong>Harga:</strong> {{ formatPrice(pc.price) }}</p>
                    <button class="btn btn-sm btn-primary w-100" @click.stop="addPaketToCart(pc)">
                      <i class="bi bi-cart-plus-fill me-1"></i> Tambah ke Keranjang
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div v-else class="no-results-bs text-center py-5">
        <p>Tidak ada rakitan PC yang cocok dengan kriteria pencarian Anda.</p>
      </div>

      <!-- Modal Detail Paket Jadi -->
      <div class="modal fade" id="pcDetailModalBs" tabindex="-1" ref="pcDetailModalRef">
        <div class="modal-dialog modal-dialog-centered modal-lg">
          <div class="modal-content modal-content-bs">
            <div class="modal-header">
              <h5 class="modal-title w-100 text-center">{{ selectedPCForModal?.name }}</h5>
              <button type="button" class="btn-close" @click="closeModal"></button>
            </div>
            <div class="modal-body">
              <div v-if="selectedPCForModal" class="row">
                <div class="col-lg-5 text-center">
                  <img :src="selectedPCForModal.image" :alt="selectedPCForModal.name" class="img-fluid rounded" />
                </div>
                <div class="col-lg-7">
                  <p><strong>Kategori:</strong> {{ selectedPCForModal.category }}</p>
                  <p><strong>Harga:</strong> {{ formatPrice(selectedPCForModal.price) }}</p>
                  <p><strong>Deskripsi:</strong> {{ selectedPCForModal.description }}</p>
                  <div v-if="selectedPCForModal.specs">
                    <h4>Spesifikasi Detail:</h4>
                    <ul>
                      <li v-for="(value, key) in selectedPCForModal.specs" :key="key">
                        <strong>{{ key }}:</strong> {{ value }}
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

<script>
import { Modal } from 'bootstrap';
import { cartStore } from '@/store/cartStore';
import { useRouter } from 'vue-router';
import apiClient from '@/services/api.js';

export default {
  name: "PaketRakitanPC",
  setup() {
    const router = useRouter();
    return { router, cartStore };
  },
  data() {
    return {
      // Data untuk Paket Jadi
      pcs: [],
      loadingPCs: true,
      errorPCs: null,
      searchQuery: "",
      selectedCategoryFilter: "",
      selectedPCForModal: null,
      bootstrapPCModal: null,

      // Data untuk Simulasi
      showSimulasi: false,
      partsData: {},
      loadingParts: true,
      partsError: null,
      selectedParts: {},
    };
  },
  async created() {
    this.fetchPaketRakitans();
    this.fetchPcPartsForSimulasi();
  },
  computed: {
    // --- Computed untuk Paket Jadi ---
    uniqueCategoriesList() {
      if (!this.pcs || this.pcs.length === 0) return [];
      const categories = this.pcs.map(pc => pc.category);
      return [...new Set(categories)].sort();
    },
    filteredPCs() {
      if (!this.pcs) return [];
      return this.pcs.filter((pc) => {
        const matchesSearch = pc.name.toLowerCase().includes(this.searchQuery.toLowerCase());
        const matchesCategory = this.selectedCategoryFilter ? pc.category === this.selectedCategoryFilter : true;
        return matchesSearch && matchesCategory;
      });
    },
    categoriesWithPCs() {
      if (this.uniqueCategoriesList.length === 0) return [];
      const categoryData = this.uniqueCategoriesList.map(categoryName => ({
          name: categoryName,
          pcs: this.filteredPCs.filter(pc => pc.category === categoryName),
      }));
      if (this.selectedCategoryFilter) {
        return categoryData.filter(cat => cat.name === this.selectedCategoryFilter && cat.pcs.length > 0);
      }
      return categoryData.filter(cat => cat.pcs.length > 0);
    },

    // --- Computed untuk Simulasi ---
    totalSimulasi() {
      return Object.values(this.selectedParts).reduce((total, part) => {
        return total + (part ? Number(part.price) : 0);
      }, 0);
    },
    isSimulasiLengkap() {
      if (Object.keys(this.partsData).length === 0) return false;
      for (const partKey in this.partsData) {
        if (!this.selectedParts[partKey]) return false;
      }
      return true;
    }
  },
  methods: {
    // --- Metode untuk Paket Jadi ---
    async fetchPaketRakitans() {
      this.loadingPCs = true;
      this.errorPCs = null;
      try {
        const response = await apiClient.get('/pc-rakitans');
        this.pcs = response.data;
      } catch (error) {
        console.error("Gagal memuat paket rakitan:", error);
        this.errorPCs = "Gagal memuat data paket rakitan.";
      } finally {
        this.loadingPCs = false;
      }
    },
    addPaketToCart(pc) {
      const paketItem = {
        id: pc.id,
        source: 'paket_rakitan',
        name: pc.name,
        price: pc.price,
        qty: 1,
        category: pc.category,
        brand: 'Rakitan',
        image: pc.image,
        specification: Object.entries(pc.specs).map(([key, value]) => `${key}: ${value}`).join('; ')
      };
      cartStore.addItem(paketItem);
      alert(`${pc.name} berhasil ditambahkan ke keranjang!`);
    },
    openModal(pc) {
      this.selectedPCForModal = pc;
      if (!this.bootstrapPCModal) {
        this.bootstrapPCModal = new Modal(this.$refs.pcDetailModalRef);
      }
      this.bootstrapPCModal.show();
    },
    closeModal() {
      if (this.bootstrapPCModal) this.bootstrapPCModal.hide();
    },

    // --- Metode untuk Simulasi Kustom ---
    async fetchPcPartsForSimulasi() {
      this.loadingParts = true;
      this.partsError = null;
      try {
        const response = await apiClient.get('/simulasi-parts');
        this.partsData = response.data;
        this.resetSimulasi();
      } catch (error) {
        console.error("Gagal memuat komponen PC:", error);
        this.partsError = "Gagal memuat komponen untuk simulasi.";
      } finally {
        this.loadingParts = false;
      }
    },
    selectPart(part, item) {
      this.selectedParts[part] = item;
    },
    resetSimulasi() {
      const initialSelection = {};
      for (const partKey in this.partsData) {
        initialSelection[partKey] = null;
      }
      this.selectedParts = initialSelection;
    },
    addToCartSimulasi() {
      if (!this.isSimulasiLengkap) {
        alert('Harap lengkapi semua komponen sebelum melanjutkan!');
        return;
      }
      const selectedForCart = {};
      for (const partKey in this.selectedParts) {
        selectedForCart[partKey] = {
          name: this.selectedParts[partKey].name,
          price: this.selectedParts[partKey].price,
        };
      }
      const customBuildItem = {
        id: `sim-${Date.now()}`,
        source: 'rakitan_kustom',
        name: 'Simulasi Rakitan Kustom',
        price: this.totalSimulasi,
        qty: 1,
        image: '/path/to/placeholder.png', // Sesuaikan path placeholder jika perlu
        specification: { parts: selectedForCart }
      };
      cartStore.addItem(customBuildItem);
      alert('Simulasi rakitan berhasil ditambahkan ke keranjang!');
      this.resetSimulasi();
      this.showSimulasi = false;
    },

    // --- Metode Umum ---
    formatPrice(value) {
      return new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', minimumFractionDigits: 0 }).format(value || 0);
    },
    goToCheckout() {
      this.router.push('/checkout');
    },
  },
};
</script>

<style scoped>
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
  text-shadow: none;
  margin-bottom: 3rem !important;
  position: relative;
  text-transform: uppercase;
  letter-spacing: 1px;
  display: inline-block;
  left: 50%;
  transform: translateX(-50%);
  text-align: center;
  /* Tambahkan agar tidak menunggu animasi lain, percepat paint */
  will-change: auto;
}
.section-title-bs::after {
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
  .section-title-bs::after {
    width: 50px;
    height: 3px;
    margin-top: 7px;
  }
}

.filters-bs {
  background-color: var(--background-section);
  border: 1px solid var(--border-color-soft);
  box-shadow: 0 4px 15px rgba(0,0,0,0.2);
  margin-bottom: 2.5rem !important;
}
.search-box-bs, .filter-select-bs {
  padding: 0.75rem 1.1rem; 
  border: 1px solid var(--border-color-medium);
  border-radius: 8px; 
  background-color: var(--background-card);
  color: var(--text-light);
  font-size: 1rem;
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
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

.btn-pembelian-paket-bs {
  background: rgba(0,0,0,0.15);
  color: #00d9ff;
  border: 2px solid #00d9ff;
  border-radius: 8px;
  font-weight: 600;
  font-family: 'Orbitron', sans-serif;
  font-size: 1.08rem;
  padding: 0.65rem 2.2rem;
  box-shadow: 0 0 18px 2px #00d9ff33, 0 0 32px 8px #00c6ff22;
  transition: 
    background 0.18s, 
    color 0.18s, 
    border-color 0.18s, 
    box-shadow 0.18s, 
    transform 0.18s;
  backdrop-filter: blur(2px) saturate(1.2);
  outline: none;
}
.btn-pembelian-paket-bs:hover,
.btn-pembelian-paket-bs:focus {
  background: rgba(0,217,255,0.08);
  color: #fff;
  border-color: #00ffe7;
  box-shadow: 0 0 24px 6px #00ffe7aa, 0 0 32px 8px #00c6ff44;
  transform: scale(1.04) translateY(-2px);
  text-shadow: 0 0 8px #00ffe7, 0 0 2px #fff;
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
  background: linear-gradient(135deg, #1a243a 70%, #232e4d 100%);
  border-radius: 16px;
  box-shadow: 0 6px 22px 0 rgba(0, 217, 255, 0.10), 0 1.5px 8px 0 rgba(143, 92, 255, 0.10);
  border: 1.5px solid var(--border-color-medium);
  transition: 
    transform 0.25s cubic-bezier(.4,2,.6,1), 
    box-shadow 0.25s, 
    border-color 0.25s,
    filter 0.25s;
  color: var(--text-light);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  position: relative;
  backdrop-filter: blur(2.5px) saturate(1.2);
  background-clip: padding-box;
}
.card-bs:hover, .card-bs:focus-within { 
  transform: translateY(-8px) scale(1.025) rotate(-0.5deg);
  box-shadow: 0 12px 38px 0 rgba(0,217,255,0.22), 0 2px 12px 0 rgba(143,92,255,0.18), 0 0 0 4px #00d9ff33;
  border-color: #00d9ff;
  outline: none;
  filter: brightness(1.07) saturate(1.15);
}
.card-bs::before {
  content: '';
  position: absolute;
  left: 0; top: 0; bottom: 0;
  width: 7px;
  border-radius: 7px 0 0 7px;
  opacity: 0.85;
  transition: opacity 0.2s;
  z-index: 1;
}
.card-bs:hover::before, .card-bs:focus-within::before {
  opacity: 1;
  filter: brightness(1.15) drop-shadow(0 0 8px #00d9ff88);
}
.card-bs::after {
  content: '';
  position: absolute;
  top: -18px;
  right: -18px;
  width: 54px;
  height: 54px;
  background: url('data:image/svg+xml;utf8,<svg width="54" height="54" viewBox="0 0 54 54" fill="none" xmlns="http://www.w3.org/2000/svg"><g opacity="0.18"><path d="M27 6c2.5 6.5 8.5 8.5 15 7-2.5 6.5 0 13.5 7 15-6.5 2.5-8.5 8.5-7 15-6.5-2.5-13.5 0-15 7-2.5-6.5-8.5-8.5-15-7 2.5-6.5 0-13.5-7-15 6.5-2.5 8.5-8.5 7-15 6.5 2.5 13.5 0 15-7z" fill="%23ffb6f9"/><circle cx="27" cy="27" r="7" fill="%23a5f3fc"/></g></svg>');
  background-size: contain;
  background-repeat: no-repeat;
  pointer-events: none;
  z-index: 0;
}
.card-bs > * {
  position: relative;
  z-index: 2;
}
.card-bs {
  opacity: 0;
  transform: translateY(30px) scale(0.98);
  animation: fadeInCard 0.7s cubic-bezier(.4,2,.6,1) forwards;
}
@keyframes fadeInCard {
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}
.col.d-flex.align-items-stretch:nth-child(1) .card-bs { animation-delay: 0.05s; }
.col.d-flex.align-items-stretch:nth-child(2) .card-bs { animation-delay: 0.12s; }
.col.d-flex.align-items-stretch:nth-child(3) .card-bs { animation-delay: 0.18s; }
.col.d-flex.align-items-stretch:nth-child(4) .card-bs { animation-delay: 0.25s; }
.col.d-flex.align-items-stretch:nth-child(5) .card-bs { animation-delay: 0.32s; }
.col.d-flex.align-items-stretch:nth-child(6) .card-bs { animation-delay: 0.39s; }

.card-img-wrapper-bs, .card-title-bs, .card-text-desc-bs, .card-text-price-bs {
    cursor: pointer; 
}


@media (max-width: 575.98px) {
  .card-bs::after, .card-bs::before {
    width: 32px;
    height: 32px;
    top: -10px;
    right: -10px;
    left: -10px;
    bottom: -10px;
  }
  .card-bs {
    border-radius: 9px;
  }
}
.card-bs .card-body {
  box-shadow: 0 2px 12px 0 rgba(0,217,255,0.07) inset;
  border-radius: 0 0 12px 12px;
  background: linear-gradient(180deg, rgba(17,25,43,0.12) 0%, rgba(26,36,58,0.95) 100%);
  padding: 1.1rem 1rem 1.2rem 1rem;
  min-height: 210px;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
}
.card-title-bs {
  font-family: 'Orbitron', sans-serif;
  font-size: 1.08rem;
  font-weight: 600;
  color: #00eaff;
  margin-bottom: 0.5rem;
  line-height: 1.35;
  min-height: calc(1.08rem * 1.35 * 2);
  display: flex;
  align-items: center;
  justify-content: center;
  letter-spacing: 0.5px;
  text-shadow: 0 1px 8px #00eaff33;
}
.card-text-desc-bs {
  font-size: 0.85rem;
  color: #b8e0f7;
  line-height: 1.5;
  margin-bottom: 0.75rem !important;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
  min-height: calc(0.85rem * 1.5 * 2);
  text-align: center; 
}
.card-text-price-bs {
  font-size: 1.05rem;
  font-weight: bold;
  color: #fff;
  letter-spacing: 0.2px;
  text-shadow: 0 1px 8px #00eaff33;
  text-align: center;
}
.card-text-price-bs strong {
  color: #00ffe7;
  margin-right: 0.25rem;
  text-shadow: 0 0 8px #00ffe755;
}
.card-img-wrapper-bs {
  background: linear-gradient(120deg, #11192b 60%, #00d9ff22 100%);
  padding: 12px;
  height: 190px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid var(--border-color-soft);
  transition: background 0.2s, box-shadow 0.3s;
  position: relative;
  box-shadow: 0 0 0 0 #00ffe7, 0 0 0 0 #8f5cff;
}
.card-bs:hover .card-img-wrapper-bs {
  background: linear-gradient(120deg, #11192b 40%, #00ffe7 100%);
  box-shadow:
    0 0 18px 4px #00ffe7,
    0 0 24px 8px #8f5cff,
    0 4px 18px #00eaff44;
  animation: neon-glow-img 1.2s alternate infinite;
}
@keyframes neon-glow-img {
  0% {
    box-shadow:
      0 0 0 0 #00ffe7,
      0 0 0 0 #8f5cff,
      0 4px 18px #00eaff44;
  }
  100% {
    box-shadow:
      0 0 18px 8px #00ffe7,
      0 0 32px 16px #8f5cff,
      0 8px 32px #00eaff88;
  }
}
.card-img-bs {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
  border-radius: 7px;
  box-shadow:
    0 0 0 0 #00ffe7,
    0 2px 12px #00eaff22;
  transition: transform 0.18s cubic-bezier(.4,2,.6,1), box-shadow 0.3s;
  border: 1.5px solid transparent;
}
.card-bs:hover .card-img-bs {
  transform: scale(1.06) rotate(-2deg);
  box-shadow:
    0 0 16px 4px #00ffe7,
    0 0 24px 8px #8f5cff,
    0 4px 18px #00eaff44;
  border: 1.5px solid #00ffe7;
  filter: brightness(1.08) saturate(1.15);
}
@media (prefers-reduced-motion: no-preference) {
  .card-bs:hover .card-img-bs {
    animation: neon-flicker 1.7s infinite alternate;
  }
}
@keyframes neon-flicker {
  0% { border-color: #00ffe7; }
  20% { border-color: #8f5cff; }
  40% { border-color: #00ffe7; }
  60% { border-color: #00ffe7; }
  80% { border-color: #8f5cff; }
  100% { border-color: #00ffe7; }
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
  .card-title-bs {
    justify-content: flex-start; 
  }
  .card-text-desc-bs {
     text-align: left; 
  }
  .card-text-price-bs {
     text-align: left; 
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
    justify-content: center !important; 
  }
  .card-text-desc-bs {
    font-size: 0.75rem;
    min-height: calc(0.75rem * 1.4 * 2);
    text-align: center !important; 
  }
   .card-text-price-bs {
    font-size: 0.85rem;
    text-align: center !important; 
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
    padding: 0.75rem;
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

.simulasi-form-bs {
  background: #11192b;
  border: 1px solid #00d9ff33;
  box-shadow: 0 4px 15px rgba(0,0,0,0.2);
  animation: fadeInSimulasi 0.7s cubic-bezier(.4,2,.6,1);
}
@keyframes fadeInSimulasi {
  from { opacity: 0; transform: translateY(30px) scale(0.98);}
  to { opacity: 1; transform: translateY(0) scale(1);}
}
.fade-slide-enter-active, .fade-slide-leave-active {
  transition: all 0.5s cubic-bezier(.4,2,.6,1);
}
.fade-slide-enter-from, .fade-slide-leave-to {
  opacity: 0;
  transform: translateY(30px) scale(0.98);
}
.fade-slide-enter-to, .fade-slide-leave-from {
  opacity: 1;
  transform: translateY(0) scale(1);
}
.simulasi-table-bs tr.simulasi-row-bs {
  transition: background 0.2s, box-shadow 0.2s;
}
.simulasi-table-bs tr.simulasi-row-bs:hover {
  background: #232e4d !important;
  box-shadow: 0 0 12px #00d9ff44;
}
.simulasi-table-bs td, .simulasi-table-bs th {
  vertical-align: middle;
}
.animate-glow {
  box-shadow: 0 0 18px 2px #00d9ff44, 0 0 32px 8px #00c6ff22;
  animation: neon-glow-box 2.5s infinite alternate;
}
@keyframes neon-glow-box {
  0% { box-shadow: 0 0 18px 2px #00d9ff44, 0 0 32px 8px #00c6ff22; }
  100% { box-shadow: 0 0 32px 8px #00d9ff99, 0 0 48px 16px #00c6ff44; }
}
.neon-text-glow {
  color: #00d9ff;
  text-shadow: 0 0 8px #00d9ff, 0 0 16px #00c6ff, 0 0 2px #fff;
  animation: neon-text-flicker 2s infinite alternate;
}
@keyframes neon-text-flicker {
  0% { text-shadow: 0 0 8px #00d9ff, 0 0 16px #00c6ff, 0 0 2px #fff; }
  100% { text-shadow: 0 0 16px #00d9ff, 0 0 32px #00c6ff, 0 0 8px #fff; }
}
.preview-simulasi-bs {
  background: #1a243a;
  border: 1px solid #00d9ff55;
  color: #e8eff5;
  box-shadow: 0 2px 12px #00d9ff22;
  animation: fadeInSimulasi 0.7s cubic-bezier(.4,2,.6,1);
}

.pembelian-paket-highlight {
  position: relative;
  z-index: 2;
  /* animation: paket-glow-efek 2.5s infinite alternate; */
  filter: none; /* Ensure no filter is applied */
  box-shadow: 0 0 6px #00ffe7aa, 0 0 2px #00c6ff88; /* Add box-shadow for glow effect */
}
@keyframes paket-glow-efek {
  0% { box-shadow: 0 0 0px #00ffe7; }
  100% { box-shadow: 0 0 6px #00ffe7aa, 0 0 2px #00c6ff88; }
}

.paket-pointer-efek {
  position: absolute;
  left: 50%;
  top: 100%;
  transform: translateX(-50%);
  width: 0;
  height: 0;
  border-left: 18px solid transparent;
  border-right: 18px solid transparent;
  border-top: 18px solid #00ffe7;
  filter: blur(2px) opacity(0.45);
  margin-top: -2px;
  pointer-events: none;
  /* animation: paket-pointer-blink 1.7s infinite alternate; */
}
@keyframes paket-pointer-blink {
  0% { opacity: 0.45; }
  100% { opacity: 0.7; filter: blur(0.5px); }
}

.modal-footer {
    background-color: var(--background-card);
    border-top: 1px solid var(--border-color-medium);
}
</style>