<script>
import { Modal } from 'bootstrap'; // Import Modal Bootstrap

export default {
  name: "PaketRakitanPC", // Mengganti nama komponen agar sesuai konteks
  data() {
    return {
      pcs: [ // Data PC Anda
        {
          id: 1,
          name: "Paket Gaming Low-End",
          category: "Gaming",
          price: 4500000,
          image: "src/imgcomp/gaming1.png", // Pastikan path ini benar
          description: "PC gaming hemat untuk game eSports seperti Valorant, Dota 2, dan CS:GO. Cocok untuk pelajar dan warnet.",
          specs: {
            CPU: "Intel Core i3 10100F",
            GPU: "GTX 750 Ti 2GB",
            RAM: "8GB DDR4",
            Storage: "SSD 240GB",
            PSU: "450W",
            Casing: "Mini ATX"
          }
        },
        {
          id: 2,
          name: "Paket Gaming Mid-End",
          category: "Gaming",
          price: 8500000,
          image: "src/imgcomp/gaming2.png",
          description: "PC gaming untuk game AAA setting medium-high, streaming ringan, dan editing video dasar.",
          specs: {
            CPU: "Intel Core i5 12400F",
            GPU: "GTX 1650 4GB",
            RAM: "16GB DDR4",
            Storage: "SSD 512GB",
            PSU: "500W",
            Casing: "ATX RGB"
          }
        },
        {
          id: 3,
          name: "Paket Gaming High-End",
          category: "Gaming",
          price: 18500000,
          image: "src/imgcomp/gaming3.png",
          description: "PC gaming untuk game AAA ultra, VR, streaming, dan editing profesional.",
          specs: {
            CPU: "AMD Ryzen 7 5800X",
            GPU: "RTX 3070 8GB",
            RAM: "32GB DDR4",
            Storage: "SSD NVMe 1TB",
            PSU: "750W 80+ Gold",
            Casing: "Full ATX RGB"
          }
        },
        {
          id: 4,
          name: "Paket Office Basic",
          category: "Office",
          price: 3500000,
          image: "src/imgcomp/office1.png",
          description: "PC untuk kebutuhan kantor, administrasi, browsing, dan meeting online.",
          specs: {
            CPU: "Intel Pentium G6400",
            GPU: "Integrated Intel UHD",
            RAM: "4GB DDR4",
            Storage: "SSD 120GB",
            PSU: "350W",
            Casing: "Mini Tower"
          }
        },
        {
          id: 5,
          name: "Paket Office Pro",
          category: "Office",
          price: 5500000,
          image: "src/imgcomp/office2.png",
          description: "PC office multitasking, cocok untuk desain ringan, Excel berat, dan meeting online.",
          specs: {
            CPU: "Intel Core i3 12100",
            GPU: "Integrated Intel UHD",
            RAM: "8GB DDR4",
            Storage: "SSD 256GB",
            PSU: "400W",
            Casing: "Slim Tower"
          }
        },
        // Duplikat 1 kolom di bagian office
        {
          id: 30,
          name: "Paket Office Pro",
          category: "Office",
          price: 5500000,
          image: "src/imgcomp/office2.png",
          description: "PC office multitasking, cocok untuk desain ringan, Excel berat, dan meeting online.",
          specs: {
            CPU: "Intel Core i3 12100",
            GPU: "Integrated Intel UHD",
            RAM: "8GB DDR4",
            Storage: "SSD 256GB",
            PSU: "400W",
            Casing: "Slim Tower"
          }
        },
        {
          id: 6,
          name: "Paket Editing & Desain",
          category: "Editing",
          price: 12000000,
          image: "src/imgcomp/edit1.png",
          description: "PC untuk editing video, desain grafis, dan rendering 3D ringan.",
          specs: {
            CPU: "AMD Ryzen 5 5600G",
            GPU: "GTX 1660 Super 6GB",
            RAM: "16GB DDR4",
            Storage: "SSD 512GB + HDD 1TB",
            PSU: "550W",
            Casing: "ATX"
          }
        },
        // Duplikat 1 kolom di bagian editing
        {
          id: 35,
          name: "Paket Editing & Desain",
          category: "Editing",
          price: 12000000,
          image: "src/imgcomp/edit1.png",
          description: "PC untuk editing video, desain grafis, dan rendering 3D ringan.",
          specs: {
            CPU: "AMD Ryzen 5 5600G",
            GPU: "GTX 1660 Super 6GB",
            RAM: "16GB DDR4",
            Storage: "SSD 512GB + HDD 1TB",
            PSU: "550W",
            Casing: "ATX"
          }
        },
        {
          id: 7,
          name: "Paket Streaming & Content Creator",
          category: "Streaming",
          price: 15500000,
          image: "src/imgcomp/streaming.png",
          description: "PC untuk streaming, recording, dan editing konten YouTube/TikTok.",
          specs: {
            CPU: "Intel Core i7 12700F",
            GPU: "RTX 3060 12GB",
            RAM: "32GB DDR4",
            Storage: "SSD NVMe 1TB",
            PSU: "750W",
            Casing: "Full ATX"
          }
        },
        // Duplikat 2 kolom di bagian streaming
        {
          id: 31,
          name: "Paket Streaming & Content Creator",
          category: "Streaming",
          price: 15500000,
          image: "src/imgcomp/streaming.png",
          description: "PC untuk streaming, recording, dan editing konten YouTube/TikTok.",
          specs: {
            CPU: "Intel Core i7 12700F",
            GPU: "RTX 3060 12GB",
            RAM: "32GB DDR4",
            Storage: "SSD NVMe 1TB",
            PSU: "750W",
            Casing: "Full ATX"
          }
        },
        {
          id: 32,
          name: "Paket Streaming & Content Creator",
          category: "Streaming",
          price: 15500000,
          image: "src/imgcomp/streaming.png",
          description: "PC untuk streaming, recording, dan editing konten YouTube/TikTok.",
          specs: {
            CPU: "Intel Core i7 12700F",
            GPU: "RTX 3060 12GB",
            RAM: "32GB DDR4",
            Storage: "SSD NVMe 1TB",
            PSU: "750W",
            Casing: "Full ATX"
          }
        },
        {
          id: 8,
          name: "Mining Rig 6 VGA",
          category: "Mining",
          price: 35000000,
          image: "src/imgcomp/mining.png",
          description: "Rig mining siap pakai, 6 slot VGA, cocok untuk ETH/altcoin mining.",
          specs: {
            CPU: "Intel Celeron G3930",
            GPU: "6x RX 580 8GB",
            RAM: "8GB DDR4",
            Storage: "SSD 120GB",
            PSU: "2x 1200W",
            Casing: "Open Frame Mining"
          }
        },
        // Duplikat 2 kolom di bagian mining
        {
          id: 36,
          name: "Mining Rig 6 VGA",
          category: "Mining",
          price: 35000000,
          image: "src/imgcomp/mining.png",
          description: "Rig mining siap pakai, 6 slot VGA, cocok untuk ETH/altcoin mining.",
          specs: {
            CPU: "Intel Celeron G3930",
            GPU: "6x RX 580 8GB",
            RAM: "8GB DDR4",
            Storage: "SSD 120GB",
            PSU: "2x 1200W",
            Casing: "Open Frame Mining"
          }
        },
        {
          id: 37,
          name: "Mining Rig 6 VGA",
          category: "Mining",
          price: 35000000,
          image: "src/imgcomp/mining.png",
          description: "Rig mining siap pakai, 6 slot VGA, cocok untuk ETH/altcoin mining.",
          specs: {
            CPU: "Intel Celeron G3930",
            GPU: "6x RX 580 8GB",
            RAM: "8GB DDR4",
            Storage: "SSD 120GB",
            PSU: "2x 1200W",
            Casing: "Open Frame Mining"
          }
        },
        {
          id: 9,
          name: "Paket Warnet eSports",
          category: "Warnet",
          price: 6500000,
          image: "src/imgcomp/warnet.png",
          description: "PC untuk usaha warnet, lancar main eSports dan browsing.",
          specs: {
            CPU: "Intel Core i3 10105F",
            GPU: "GT 1030 2GB",
            RAM: "8GB DDR4",
            Storage: "SSD 240GB",
            PSU: "400W",
            Casing: "Mini ATX"
          }
        },
        // Duplikat 2 kolom di bagian warnet
        {
          id: 33,
          name: "Paket Warnet eSports",
          category: "Warnet",
          price: 6500000,
          image: "src/imgcomp/warnet.png",
          description: "PC untuk usaha warnet, lancar main eSports dan browsing.",
          specs: {
            CPU: "Intel Core i3 10105F",
            GPU: "GT 1030 2GB",
            RAM: "8GB DDR4",
            Storage: "SSD 240GB",
            PSU: "400W",
            Casing: "Mini ATX"
          }
        },
        {
          id: 34,
          name: "Paket Warnet eSports",
          category: "Warnet",
          price: 6500000,
          image: "src/imgcomp/warnet.png",
          description: "PC untuk usaha warnet, lancar main eSports dan browsing.",
          specs: {
            CPU: "Intel Core i3 10105F",
            GPU: "GT 1030 2GB",
            RAM: "8GB DDR4",
            Storage: "SSD 240GB",
            PSU: "400W",
            Casing: "Mini ATX"
          }
        },
        {
          id: 10,
          name: "Paket Rendering 3D Pro",
          category: "Editing",
          price: 25000000,
          image: "src/imgcomp/edit2.png",
          description: "PC untuk rendering 3D berat, animasi, dan arsitektur.",
          specs: {
            CPU: "AMD Ryzen 9 5900X",
            GPU: "RTX 3080 10GB",
            RAM: "64GB DDR4",
            Storage: "SSD NVMe 2TB",
            PSU: "850W 80+ Gold",
            Casing: "Full ATX"
          }
        }
      ],
      searchQuery: "",
      selectedCategoryFilter: "",
      selectedPCForModal: null,
      bootstrapPCModal: null, // Instance untuk Modal Bootstrap
    };
  },
  mounted() {
    // Inisialisasi Modal Bootstrap
    const modalElement = this.$refs.pcDetailModalRef; // Ganti ref jika berbeda
    if (modalElement) {
      this.bootstrapPCModal = new Modal(modalElement);
      modalElement.addEventListener('hidden.bs.modal', () => {
        this.selectedPCForModal = null;
        document.body.style.overflow = '';
      });
      modalElement.addEventListener('shown.bs.modal', () => {
        document.body.style.overflow = 'hidden';
      });
    }
    // Jika ingin kategori pertama otomatis terpilih saat halaman dimuat
    // if (this.uniqueCategoriesList.length > 0) {
    //   this.selectedCategoryFilter = this.uniqueCategoriesList[0];
    // }
  },
  computed: {
    filteredPCs() {
      return this.pcs.filter((pc) => {
        const matchesSearch = pc.name.toLowerCase().includes(this.searchQuery.toLowerCase());
        const matchesCategory = this.selectedCategoryFilter ? pc.category === this.selectedCategoryFilter : true;
        return matchesSearch && matchesCategory;
      });
    },
    // Membuat daftar kategori unik dari data PC untuk filter dropdown
    uniqueCategoriesList() {
      const categories = this.pcs.map(pc => pc.category);
      return [...new Set(categories)].sort(); // Urutkan kategori
    },
    categoriesWithPCs() {
      // Menggunakan uniqueCategoriesList untuk urutan yang konsisten
      const categoryData = this.uniqueCategoriesList.map(categoryName => {
        const pcsInCategory = this.filteredPCs.filter(pc => pc.category === categoryName);
        // Mengambil gambar dari PC pertama dalam kategori tersebut sebagai background header (jika ada)
        const firstPCOfCategory = this.pcs.find(pc => pc.category === categoryName && pc.image);
        return {
          name: categoryName,
          pcs: pcsInCategory,
          // backgroundImage: firstPCOfCategory ? firstPCOfCategory.image : '', // Hapus jika tidak ingin background image di header
        };
      });

      // Filter kategori berdasarkan pilihan filter atau tampilkan semua yang memiliki PC
      if (this.selectedCategoryFilter) {
        return categoryData.filter(cat => cat.name === this.selectedCategoryFilter && cat.pcs.length > 0);
      }
      return categoryData.filter(cat => cat.pcs.length > 0);
    }
  },
  methods: {
    formatPrice(value) {
      if (typeof value !== "number" || isNaN(value)) {
        return 'Rp 0';
      }
      return `Rp ${new Intl.NumberFormat('id-ID', { minimumFractionDigits: 0, maximumFractionDigits: 0 }).format(value)}`;
    },
    openModal(pc) {
      this.selectedPCForModal = pc;
      if (this.bootstrapPCModal) {
        this.bootstrapPCModal.show();
      }
    },
    closeModal() {
      if (this.bootstrapPCModal) {
        this.bootstrapPCModal.hide();
      }
    }
  }
};
</script>

<template>
  <section class="pc-list-section-bs">
    <div class="container py-4 py-md-5">
      <h2 class="section-title-bs text-center">Paket Rakitan PC</h2>

      <!-- Filter Section -->
      <div class="row justify-content-center mb-4">
        <div class="col-lg-10 col-xl-8">
          <div class="filters-bs p-3 rounded-3">
            <div class="row g-2 g-md-3 align-items-center">
              <div class="col-md">
                <input
                  type="text"
                  v-model="searchQuery"
                  placeholder="Cari nama paket..."
                  class="form-control form-control-lg search-box-bs"
                  aria-label="Cari rakitan PC"
                />
              </div>
              <div class="col-md-auto">
                <select v-model="selectedCategoryFilter" class="form-select form-select-lg filter-select-bs" aria-label="Pilih kategori rakitan">
                  <option value="">Semua Kategori</option>
                  <option v-for="cat in uniqueCategoriesList" :key="cat" :value="cat">{{ cat }}</option>
                </select>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- PC Categories and Cards -->
      <div v-if="filteredPCs.length > 0">
        <div v-for="categoryData in categoriesWithPCs" :key="categoryData.name" class="category-section-bs mb-5">
          <div class="category-header-bs text-center" :style="categoryData.backgroundImage ? { '--bg-image': `url(${categoryData.backgroundImage})` } : {}">
            <h3 class="category-title-bs position-relative d-inline-block px-sm-4 px-3 py-2">{{ categoryData.name }}</h3>
          </div>

          <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 row-cols-xl-4 g-3 g-lg-4 justify-content-center">
            <div
              v-for="pc in categoryData.pcs"
              :key="pc.id"
              class="col d-flex align-items-stretch"
            >
              <div
                class="card h-100 card-bs"
                @click="openModal(pc)"
                role="button"
                tabindex="0"
                @keydown.enter="openModal(pc)"
                @keydown.space="openModal(pc)"
              >
                <div class="card-img-wrapper-bs pc-bg-wrapper">
                  <div class="pc-bg-decor"></div>
                  <!-- Hiasan SVG garis melengkung -->
                  <svg class="pc-curve-decor" width="100" height="40" viewBox="0 0 100 40" fill="none">
                    <path d="M0,35 Q50,0 100,35" stroke="#00ffe7" stroke-width="2.5" fill="none" opacity="0.18"/>
                  </svg>
                  <!-- Hiasan bintang -->
                  <span class="pc-star star1"></span>
                  <span class="pc-star star2"></span>
                  <span class="pc-star star3"></span>
                  <img :src="pc.image" :alt="pc.name" class="card-img-top card-img-bs" />
                </div>
                <div class="card-body d-flex flex-column p-3">
                  <h4 class="card-title card-title-bs mb-2">{{ pc.name }}</h4>
                  <p class="card-text-desc-bs small mb-2">{{ pc.description }}</p>
                  <p class="card-text card-text-price-bs mt-auto mb-0">
                    <strong>Harga:</strong> {{ formatPrice(pc.price) }}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div v-else class="no-results-bs text-center py-5">
        <p>Tidak ada rakitan PC yang cocok dengan kriteria pencarian Anda.</p>
      </div>

      <!-- Modal Bootstrap -->
      <div class="modal fade" id="pcDetailModalBs" tabindex="-1" aria-labelledby="pcDetailModalLabelBs" aria-hidden="true" ref="pcDetailModalRef">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg"> <!-- modal-lg untuk modal lebih lebar -->
          <div class="modal-content modal-content-bs">
            <div class="modal-header modal-header-bs">
              <h5 class="modal-title w-100 text-center modal-pc-title-bs" id="pcDetailModalLabelBs">
                {{ selectedPCForModal?.name }}
              </h5>
              <button type="button" class="btn-close modal-close-button-bs" @click="closeModal" aria-label="Tutup detail rakitan"></button>
            </div>
            <div class="modal-body modal-body-bs">
              <div v-if="selectedPCForModal" class="row g-3 g-lg-4 align-items-center">
                <div class="col-lg-5 text-center">
                  <img :src="selectedPCForModal.image" :alt="selectedPCForModal.name" class="img-fluid rounded modal-image-bs" />
                </div>
                <div class="col-lg-7 modal-details-text">
                  <div class="modal-info-group mb-3">
                    <p><strong>Kategori:</strong> {{ selectedPCForModal.category }}</p>
                    <p><strong>Harga:</strong> {{ formatPrice(selectedPCForModal.price) }}</p>
                    <p class="mb-2"><strong>Deskripsi:</strong> {{ selectedPCForModal.description }}</p>
                  </div>
                  <div v-if="selectedPCForModal.specs" class="specs-section-bs">
                    <h4 class="text-center text-lg-start">Spesifikasi Detail:</h4>
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

<style scoped>
/* Variabel Warna Lokal */
.pc-list-section-bs {
  --primary-color: #00d9ff;
  --secondary-color: #00c6ff;
  --background-main: #0c101c;
  --background-section: #11192b;
  --background-card: #1a243a;
  --background-modal: #0f1626;
  --text-light: #e8eff5; /* Warna teks lebih terang sedikit */
  --text-muted-bs: #adb5bd; /* Warna muted Bootstrap */
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

/* Container Styling */
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

/* Judul Utama Section */
.section-title-bs {
  font-family: 'Orbitron', sans-serif;
  font-size: clamp(1.8rem, 4.5vw, 2.8rem); /* Disesuaikan */
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
  width: 50px; /* Lebih pendek */
  height: 2.5px; /* Lebih tipis */
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
  border-radius: 1.5px;
  box-shadow: 0 0 8px var(--primary-color), 0 0 5px var(--secondary-color);
}

/* Filter Section */
.filters-bs {
  background-color: var(--background-section);
  border: 1px solid var(--border-color-soft);
  box-shadow: 0 4px 15px rgba(0,0,0,0.2);
  margin-bottom: 2.5rem !important;
}
.search-box-bs, .filter-select-bs {
  padding: 0.75rem 1.1rem; /* Padding lebih nyaman */
  border: 1px solid var(--border-color-medium);
  border-radius: 8px; /* Radius lebih besar */
  background-color: var(--background-card);
  color: var(--text-light);
  font-size: 1rem;
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
  height: auto; /* Biarkan tinggi otomatis berdasarkan padding */
}
.search-box-bs::placeholder {
  color: rgba(224, 224, 224, 0.5); /* Placeholder lebih soft */
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

/* Category Section Styling */
.category-section-bs {
  margin-bottom: 2.2rem !important;
}
.category-header-bs {
  position: relative;
  margin-bottom: 2rem;
  border-radius: 10px; /* Radius lebih besar */
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
  font-size: clamp(1.3rem, 2.8vw, 1.8rem); /* Disesuaikan */
  font-weight: 600;
  color: var(--primary-color);
  text-shadow: 0 0 3px rgba(0,0,0,0.5), 0 0 7px var(--primary-color);
  text-transform: uppercase;
  background-color: var(--background-card);
  border-radius: 6px;
  box-shadow: 0 2px 6px rgba(var(--primary-color-rgb-val), 0.15);
  border: 1px solid var(--border-color-soft);
  z-index: 2; /* Agar di atas overlay jika ada */
  padding: 0.5rem 2.5rem;
  margin: 0 auto;
  display: inline-block;
  min-width: 220px;
  text-align: center;
}

/* Card Styling */
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
  cursor: pointer;
  color: var(--text-light);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  position: relative;
  /* Efek glassmorphism */
  backdrop-filter: blur(2.5px) saturate(1.2);
  background-clip: padding-box;
}
.card-bs:hover, .card-bs:focus-visible {
  transform: translateY(-8px) scale(1.025) rotate(-0.5deg);
  box-shadow: 0 12px 38px 0 rgba(0,217,255,0.22), 0 2px 12px 0 rgba(143,92,255,0.18), 0 0 0 4px #00d9ff33;
  border-color: #00d9ff;
  outline: none;
  filter: brightness(1.07) saturate(1.15);
}
/* Efek garis gradasi di sisi kiri kolom */
.card-bs::before {
  content: '';
  position: absolute;
  left: 0; top: 0; bottom: 0;
  width: 7px;
  border-radius: 7px 0 0 7px;
  background: linear-gradient(180deg, #00d9ff 0%, #8f5cff 60%, #00ffe7 100%);
  opacity: 0.85;
  transition: opacity 0.2s;
  z-index: 1;
}
.card-bs:hover::before, .card-bs:focus-visible::before {
  opacity: 1;
  filter: brightness(1.15) drop-shadow(0 0 8px #00d9ff88);
}
/* Bunga SVG dekorasi background */
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
/* Efek animasi masuk untuk card */
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
/* Animasi delay bertingkat untuk grid */
.col.d-flex.align-items-stretch:nth-child(1) .card-bs { animation-delay: 0.05s; }
.col.d-flex.align-items-stretch:nth-child(2) .card-bs { animation-delay: 0.12s; }
.col.d-flex.align-items-stretch:nth-child(3) .card-bs { animation-delay: 0.18s; }
.col.d-flex.align-items-stretch:nth-child(4) .card-bs { animation-delay: 0.25s; }
.col.d-flex.align-items-stretch:nth-child(5) .card-bs { animation-delay: 0.32s; }
.col.d-flex.align-items-stretch:nth-child(6) .card-bs { animation-delay: 0.39s; }
/* Responsive: bunga lebih kecil di mobile */
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
/* Card inner shadow untuk depth */
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
}
.card-text-price-bs {
  font-size: 1.05rem;
  font-weight: bold;
  color: #fff;
  letter-spacing: 0.2px;
  text-shadow: 0 1px 8px #00eaff33;
}
.card-text-price-bs strong {
  color: #00ffe7;
  margin-right: 0.25rem;
  text-shadow: 0 0 8px #00ffe755;
}
/* Efek hover pada gambar */
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
  /* Neon border effect */
  box-shadow: 0 0 0 0 #00ffe7, 0 0 0 0 #8f5cff;
}
.card-bs:hover .card-img-wrapper-bs {
  background: linear-gradient(120deg, #11192b 40%, #00ffe7 100%);
  /* Neon glow on hover */
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
/* Neon border for image */
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
/* Neon flicker effect for image border */
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
  font-size: 1.1rem; /* Disesuaikan */
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
  animation: scaleUpModal-bs 0.3s ease-out forwards; /* Forwards agar state akhir tetap */
  opacity: 0;
}
.modal-header-bs {
  background-color: var(--background-card);
  border-bottom: 1px solid var(--border-color-medium);
  padding: 0.9rem 1.1rem; /* Disesuaikan */
}
.modal-pc-title-bs { /* Ganti nama agar lebih spesifik */
  font-family: 'Orbitron', sans-serif;
  color: var(--primary-color);
  font-size: 1.25rem; /* Disesuaikan */
  text-shadow: 0 0 4px var(--primary-color);
}
.modal-close-button-bs {
  background: transparent !important;
  border: none !important;
  font-size: 1.6rem !important; /* Disesuaikan */
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
  margin-bottom: 0.5rem; /* Disesuaikan */
  font-size: 0.875rem; /* Disesuaikan */
}
.modal-info-group strong {
  color: var(--primary-color);
  min-width: 70px; /* Disesuaikan */
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
  font-size: 1rem; /* Disesuaikan */
  font-weight: 600;
  letter-spacing: 0.5px;
  text-transform: uppercase;
}
.specs-section-bs ul {
  list-style: disc;
  padding-left: 1.1rem; /* Disesuaikan */
  margin-bottom: 0;
}
.specs-section-bs li {
  margin-bottom: 0.35rem; /* Disesuaikan */
  font-size: 0.825rem; /* Disesuaikan */
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

/* Responsive Adjustments */
@media (min-width: 768px) { /* md ke atas */
  .card-bs .card-body {
    text-align: left;
  }
  .card-title-bs {
    justify-content: flex-start;
  }
}
@media (max-width: 767.98px) { /* Di bawah md */
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
@media (max-width: 575.98px) { /* sm breakpoint */
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
  .row.g-3.g-lg-4 { /* Sesuaikan gap di mobile */
    --bs-gutter-x: 0.8rem;
    --bs-gutter-y: 0.8rem;
  }
}
</style>
