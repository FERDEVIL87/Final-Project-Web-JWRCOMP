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
            <div class="category-header-overlay"></div>
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
                <div class="card-img-wrapper-bs">
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
  /* Animasi bisa ditambahkan di sini jika mau per kategori */
}
.category-header-bs {
  position: relative;
  margin-bottom: 2rem;
  border-radius: 10px; /* Radius lebih besar */
  background-color: var(--background-section);
  border: 1px solid var(--border-color-medium);
  box-shadow: 0 5px 18px rgba(0,0,0,0.25);
  padding: 0.75rem 0;
  /* Background image logic dari CSS asli bisa dipertahankan jika diinginkan */
  /* background-image: var(--bg-image); */
  /* background-size: cover; */
  /* background-position: center; */
  /* overflow: hidden; */
}
.category-header-overlay { /* Jika pakai background image, overlay ini membantu teks lebih terbaca */
  /* position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(17, 25, 43, 0.7); z-index: 1; border-radius: inherit; */
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
}

/* Card Styling */
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
}
.card-bs:hover, .card-bs:focus-visible {
  transform: translateY(-5px) scale(1.015); /* Efek lebih subtle */
  box-shadow: 0 7px 22px rgba(var(--primary-color-rgb-val), 0.4);
  border-color: var(--border-color-strong);
  outline: none;
}
.card-bs:focus-visible:not(:hover) {
  outline: 2px solid var(--primary-color);
  outline-offset: 1px;
}

.card-img-wrapper-bs { /* Wrapper untuk kontrol padding dan background gambar */
  background-color: var(--background-section);
  padding: 10px;
  height: 190px; /* Tinggi konsisten untuk area gambar */
  display: flex;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid var(--border-color-soft);
}
.card-img-bs {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
  border-radius: 4px; /* Radius kecil untuk gambar */
}
.card-bs .card-body {
  padding: 1rem;
  text-align: center;
  flex-grow: 1;
}
.card-title-bs {
  font-family: 'Orbitron', sans-serif;
  font-size: 1rem; /* Disesuaikan */
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
  /* Batasi jumlah baris jika perlu */
  display: -webkit-box;
  -webkit-line-clamp: 2; /* Tampilkan maksimal 2 baris */
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
  min-height: calc(0.8rem * 1.4 * 2); /* Ruang untuk 2 baris deskripsi */
}
.card-text-price-bs {
  font-size: 0.95rem; /* Disesuaikan */
  font-weight: bold;
  color: #fff;
}
.card-text-price-bs strong {
  color: var(--primary-color);
  margin-right: 0.25rem;
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