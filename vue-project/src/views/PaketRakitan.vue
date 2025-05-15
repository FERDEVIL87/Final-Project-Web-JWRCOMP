<script>
export default {
  name: "LaptopListSection",
  data() {
    return {
      pcs: [
        {
          id: 1,
          name: "Paket Gaming Low-End",
          category: "Gaming",
          price: 4500000,
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/7/7/1b7b6b6d-7e1a-4b7c-8e2e-7e1e6e6e6e6e.jpg",
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
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/7/7/2b7b6b6d-7e1a-4b7c-8e2e-7e1e6e6e6e6e.jpg",
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
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/7/7/3b7b6b6d-7e1a-4b7c-8e2e-7e1e6e6e6e6e.jpg",
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
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/7/7/4b7b6b6d-7e1a-4b7c-8e2e-7e1e6e6e6e6e.jpg",
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
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/7/7/5b7b6b6d-7e1a-4b7c-8e2e-7e1e6e6e6e6e.jpg",
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
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/7/7/6b7b6b6d-7e1a-4b7c-8e2e-7e1e6e6e6e6e.jpg",
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
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/7/7/7b7b6b6d-7e1a-4b7c-8e2e-7e1e6e6e6e6e.jpg",
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
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/7/7/8b7b6b6d-7e1a-4b7c-8e2e-7e1e6e6e6e6e.jpg",
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
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/7/7/9b7b6b6d-7e1a-4b7c-8e2e-7e1e6e6e6e6e.jpg",
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
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/7/7/10b7b6b6d-7e1a-4b7c-8e2e-7e1e6e6e6e6e.jpg",
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
      isModalVisible: false,
      selectedPCForModal: null,
    };
  },
  computed: {
    filteredPCs() {
      return this.pcs.filter((pc) => {
        const matchesSearch = pc.name.toLowerCase().includes(this.searchQuery.toLowerCase());
        const matchesCategory = this.selectedCategoryFilter ? pc.category === this.selectedCategoryFilter : true;
        return matchesSearch && matchesCategory;
      });
    },
    categoriesWithPCs() {
      const uniqueCategories = ["Gaming", "Office", "Editing", "Streaming", "Mining", "Warnet"];
      const categoryData = uniqueCategories.map(categoryName => {
        const pcsInCategory = this.filteredPCs.filter(pc => pc.category === categoryName);
        const firstPCOfCategory = this.pcs.find(pc => pc.category === categoryName);
        return {
          name: categoryName,
          pcs: pcsInCategory,
          backgroundImage: firstPCOfCategory ? firstPCOfCategory.image : 'https://via.placeholder.com/800x200?text=No+Image',
        };
      });
      if (this.selectedCategoryFilter) {
        return categoryData.filter(cat => cat.name === this.selectedCategoryFilter && cat.pcs.length > 0);
      }
      return categoryData.filter(cat => cat.pcs.length > 0);
    }
  },
  methods: {
    formatPrice(value) {
      if (typeof value !== "number") {
        return value;
      }
      return `Rp ${new Intl.NumberFormat('id-ID').format(value)}`;
    },
    openModal(pc) {
      this.selectedPCForModal = pc;
      this.isModalVisible = true;
    },
    closeModal() {
      this.isModalVisible = false;
      this.selectedPCForModal = null;
    }
  }
};
</script>

<template>
  <section class="laptop-list-section">
    <h2 class="section-title">Paket Rakitan PC</h2>
    <div class="filters">
      <input
        type="text"
        v-model="searchQuery"
        placeholder="Cari rakitan PC..."
        class="search-box"
        aria-label="Cari rakitan PC"
      />
      <select v-model="selectedCategoryFilter" class="filter-button" aria-label="Pilih kategori rakitan">
        <option value="">Semua Kategori</option>
        <option value="Gaming">Gaming</option>
        <option value="Office">Office</option>
        <option value="Editing">Editing</option>
        <option value="Streaming">Streaming</option>
        <option value="Mining">Mining</option>
        <option value="Warnet">Warnet</option>
      </select>
    </div>

    <div v-if="filteredPCs.length > 0" class="categories-container">
      <div v-for="categoryData in categoriesWithPCs" :key="categoryData.name" class="category-section">
        <div class="category-header">
          <img 
            :src="categoryData.backgroundImage" 
            class="category-background-image" 
            :alt="`${categoryData.name} category background`" 
            aria-hidden="true" 
          />
          <h3 class="category-title">{{ categoryData.name }}</h3>
        </div>
        
        <div class="cards-grid">
          <div 
            v-for="pc in categoryData.pcs" 
            :key="pc.id" 
            class="card"
            @click="openModal(pc)"
            role="button"
            tabindex="0"
            @keydown.enter="openModal(pc)"
            @keydown.space="openModal(pc)"
          >
            <img :src="pc.image" :alt="pc.name" class="card-image" />
            <h4 class="card-title">{{ pc.name }}</h4>
            <p class="card-text">
              <strong>Harga:</strong> {{ formatPrice(pc.price) }}
            </p>
          </div>
        </div>
      </div>
    </div>
    <div v-else class="no-results">
      <p>Tidak ada rakitan PC yang cocok dengan kriteria pencarian Anda.</p>
    </div>

    <!-- Modal -->
    <div v-if="isModalVisible" class="modal-overlay" @click.self="closeModal" role="dialog" aria-modal="true" :aria-labelledby="selectedPCForModal ? 'modal-title-' + selectedPCForModal.id : ''">
      <div class="modal-content">
        <button class="modal-close-button" @click="closeModal" aria-label="Tutup detail rakitan">×</button>
        <div v-if="selectedPCForModal">
          <img :src="selectedPCForModal.image" :alt="selectedPCForModal.name" class="modal-image" />
          <h2 :id="'modal-title-' + selectedPCForModal.id" class="modal-laptop-title">{{ selectedPCForModal.name }}</h2>
          <p><strong>Kategori:</strong> {{ selectedPCForModal.category }}</p>
          <p><strong>Harga:</strong> {{ formatPrice(selectedPCForModal.price) }}</p>
          <p><strong>Deskripsi:</strong> {{ selectedPCForModal.description }}</p>
          <div v-if="selectedPCForModal.specs" class="specs-section">
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
  </section>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@400;500;700&family=Roboto:wght@300;400;700&display=swap');

:root {
  --primary-color-rgb: 125, 30, 255; 
}

.laptop-list-section {
  --primary-color: #00d9ff;
  --secondary-color: #00c6ff;
  --background-dark1: #12121a;
  --background-dark2: #1a1a24;
  --background-dark3: #23232e;
  --text-color: #e0e0e0;
  --text-section-title: #ffffff;
  
  font-family: 'Roboto', sans-serif;
  min-height: 100vh;
  background: linear-gradient(120deg, var(--background-dark1) 0%, var(--background-dark2) 50%, var(--primary-color) 100%);
  background-size: 200% 200%;
  color: var(--text-color);
  text-align: center;
  padding: 60px 20px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  align-items: center;
  overflow-x: hidden;
}

.section-title {
  font-family: 'Orbitron', sans-serif;
  font-size: clamp(2rem, 5vw, 3.2rem);
  font-weight: 700;
  color: var(--text-section-title);
  text-shadow: 0 0 8px var(--text-section-title), 0 0 15px var(--primary-color), 0 0 20px var(--primary-color);
  margin-bottom: 50px;
  position: relative;
  text-transform: uppercase;
  letter-spacing: 2px;
  opacity: 0;
  animation: fadeIn 0.8s ease-out 0.2s forwards;
}

.section-title::after {
  content: '';
  position: absolute;
  bottom: -15px;
  left: 50%;
  transform: translateX(-50%);
  width: 70px;
  height: 3px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
  border-radius: 2px;
  box-shadow: 0 0 12px var(--primary-color), 0 0 8px var(--secondary-color);
}

.filters {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 30px;
  width: 100%;
  max-width: 700px;
  justify-content: center;
}

.search-box {
  flex: 1 1 200px;
  padding: 12px 15px;
  border: 1px solid #333;
  border-radius: 5px;
  background-color: var(--background-dark2);
  color: #fff;
  font-size: 1rem;
}

.search-box::placeholder {
  color: #aaa;
}

.filter-button {
  padding: 12px 15px;
  border: 1px solid #333;
  border-radius: 5px;
  background-color: var(--background-dark2);
  color: #fff;
  cursor: pointer;
  font-size: 1rem;
  flex: 0 1 auto;
}

/* Styling for category sections */
.categories-container {
  width: 100%;
  max-width: 1200px; /* Max width for all content */
}
.category-section {
  margin-bottom: 50px; /* Space between category groups */
  width: 100%;
}

.category-header {
  position: relative;
  padding: 25px 15px; /* Padding for the title */
  margin-bottom: 25px;
  border-radius: 8px;
  overflow: hidden; /* Crucial for containing the absolute positioned image */
  background-color: var(--background-dark2); /* Fallback if image is broken */
  border: 1px solid rgba(var(--primary-color-rgb), 0.2);
}

.category-background-image {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: cover; /* Cover the area, might crop */
  opacity: 0.15; /* Translucency */
  z-index: 1; /* Behind the title */
  pointer-events: none; /* Image itself is not interactive */
}

.category-title {
  font-family: 'Orbitron', sans-serif;
  font-size: clamp(1.8rem, 4vw, 2.5rem);
  font-weight: 700;
  color: var(--primary-color);
  text-shadow: 0 0 5px rgba(0,0,0,0.7), 0 0 10px var(--primary-color); /* Ensure readability */
  position: relative;
  z-index: 2; /* Above the background image */
  margin: 0;
  text-transform: uppercase;
}


.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 25px;
  width: 100%;
  justify-content: start;
}

.card {
  background: var(--background-dark3);
  border-radius: 10px;
  padding: 20px;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
  text-align: left;
  border: 1px solid rgba(var(--primary-color-rgb), 0.3);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  cursor: pointer; /* Indicate it's clickable */
}

.card:hover, .card:focus-visible { /* Added focus for accessibility */
  transform: translateY(-5px) scale(1.02);
  box-shadow: 0 8px 25px rgba(var(--primary-color-rgb), 0.5);
  outline: 2px solid var(--primary-color); /* Focus outline */
}

.card-title { /* Was h3, changed to h4 to be sub-heading of category-title (h3) */
  font-family: 'Orbitron', sans-serif;
  font-size: 1.3rem;
  font-weight: 500;
  margin-top: 0; /* Reset margin for h4 */
  margin-bottom: 12px;
  color: var(--primary-color);
}

.card-text {
  font-size: 0.95rem;
  line-height: 1.6;
  color: var(--text-color);
}

.card-text strong {
  color: #fff;
}

.card-image {
  width: 100%;
  height: 180px; /* Fixed height for images in cards */
  object-fit: contain; /* Show full image, may leave space */
  border-radius: 8px;
  margin-bottom: 15px; /* Increased margin */
  background-color: #2c2c3a; /* Placeholder background for images */
}

.no-results {
  margin-top: 30px;
  font-size: 1.2rem;
  color: var(--text-color);
  width: 100%;
  text-align: center;
}

/* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.85); /* Darker overlay */
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  padding: 20px;
  box-sizing: border-box;
  opacity: 0;
  animation: fadeInModal 0.3s ease forwards;
}

.modal-content {
  background: var(--background-dark2); /* Slightly different from card for depth */
  padding: 30px;
  border-radius: 12px; /* Softer radius */
  box-shadow: 0 10px 40px rgba(var(--primary-color-rgb), 0.6);
  position: relative;
  width: 100%;
  max-width: 650px; /* Slightly wider modal */
  max-height: 90vh;
  overflow-y: auto;
  border: 1px solid rgba(var(--primary-color-rgb), 0.5);
  color: var(--text-color);
  transform: scale(0.95);
  animation: scaleUpModal 0.3s ease 0.1s forwards;
}

.modal-close-button {
  position: absolute;
  top: 15px;
  right: 15px;
  background: transparent;
  border: none;
  font-size: 2.2rem; /* Larger close icon */
  font-weight: bold;
  color: var(--primary-color);
  cursor: pointer;
  line-height: 1;
  padding: 5px;
  transition: color 0.2s ease, transform 0.2s ease;
}
.modal-close-button:hover {
  color: #fff;
  transform: scale(1.1);
}

.modal-image {
  width: 100%;
  max-height: 300px; /* Max height for modal image */
  object-fit: contain; /* Display full image, best for various aspect ratios */
  border-radius: 8px;
  margin-bottom: 20px;
  background-color: var(--background-dark3); /* Placeholder bg for image area */
  border: 1px solid rgba(var(--primary-color-rgb), 0.2);
}

.modal-laptop-title { /* Specific class for modal's H2 */
  font-family: 'Orbitron', sans-serif;
  color: var(--primary-color);
  font-size: 1.8rem;
  margin-top: 0;
  margin-bottom: 15px;
  text-shadow: 0 0 5px var(--primary-color);
}

.modal-content p {
  margin-bottom: 12px;
  line-height: 1.7;
  font-size: 1rem;
}
.modal-content p strong {
  color: #fff; /* Highlight labels */
}

.specs-section {
  margin-top: 20px;
  padding-top: 15px;
  border-top: 1px solid rgba(var(--primary-color-rgb), 0.2);
}
.specs-section h4 {
  font-family: 'Orbitron', sans-serif;
  color: var(--secondary-color);
  margin-bottom: 10px;
}
.specs-section ul {
  list-style: none;
  padding: 0;
}
.specs-section li {
  margin-bottom: 8px;
}


@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes fadeInModal {
  from { opacity: 0; }
  to { opacity: 1; }
}
@keyframes scaleUpModal {
  from { transform: scale(0.95); opacity: 0.5; }
  to { transform: scale(1); opacity: 1; }
}
</style>
