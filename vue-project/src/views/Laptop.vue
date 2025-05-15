<!-- LaptopListSection.vue -->
<script>
export default {
  name: "LaptopListSection",
  data() {
    return {
      laptops: [
        { id: 1, name: "Acer Aspire 3", category: "Low-End", price: 5000000, image: "src/img/Acer Aspire 3.png", description: "A reliable choice for everyday tasks, browsing, and light productivity. Offers good value for its price." },
        { id: 2, name: "HP 14s", category: "Low-End", price: 6000000, image: "src/img/Hp 14s.png", description: "Compact and lightweight, ideal for students and users on the go. Decent performance for basic applications." },
        { id: 3, name: "ASUS VivoBook 15", category: "Mid-Range", price: 8000000, image: "src/img/Asus Vivobook 15.png", description: "Balances performance and portability with a stylish design. Suitable for multitasking and moderate creative work." },
        { id: 4, name: "Lenovo IdeaPad 5", category: "Mid-Range", price: 10000000, image: "src/img/Lenovo IdeaPad 5.png", description: "Offers robust performance with modern features, good for work, study, and entertainment." },
        { id: 5, name: "Dell Inspiron 15", category: "Mid-Range", price: 12000000, image: "src/img/Dell Inspiron 15.png", description: "A versatile laptop known for its reliability and solid build quality. Handles demanding applications smoothly." },
        { id: 6, name: "MacBook Air M1", category: "High-End", price: 15000000, image: "src/img/MacBook Air M1.png", description: "Revolutionary performance and battery life with Apple's M1 chip. Sleek, light, and powerful for professionals and creatives." },
        { id: 7, name: "ASUS ROG Zephyrus G14", category: "High-End", price: 20000000, image: "src/img/ASUSROGZephyrusG14.png", description: "A gaming powerhouse in a compact form factor. Delivers exceptional performance for gaming and intensive tasks." },
        { id: 8, name: "Dell XPS 13", category: "High-End", price: 25000000, image: "src/img/Dell XPS 13.png", description: "Premium ultrabook with a stunning display and exceptional build quality. Perfect for professionals needing portability and power." },
        { id: 9, name: "MacBook Pro 16-inch", category: "High-End", price: 30000000, image: "/src/img/MacBook Pro 16-inch.png", description: "The ultimate Mac laptop for demanding creative workflows, offering incredible power, a large display, and long battery life." },
        { id: 10, name: "Razer Blade 15", category: "High-End", price: 35000000, image: "src/img/Razer Blade 15.png", description: "Sleek gaming laptop with top-tier performance, advanced cooling, and a high-refresh-rate display for an immersive experience." },
      ],
      searchQuery: "",
      selectedCategoryFilter: "", // Renamed for clarity
      isModalVisible: false,
      selectedLaptopForModal: null,
    };
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
      const uniqueCategories = ["Low-End", "Mid-Range", "High-End"]; // Define order
      
      const categoryData = uniqueCategories.map(categoryName => {
        // Get filtered laptops for this category
        const laptopsInCategory = this.filteredLaptops.filter(laptop => laptop.category === categoryName);
        
        // Find the first image for this category from the original (unfiltered) laptop list
        const firstLaptopOfCategory = this.laptops.find(l => l.category === categoryName);
        
        return {
          name: categoryName,
          laptops: laptopsInCategory,
          backgroundImage: firstLaptopOfCategory ? firstLaptopOfCategory.image : 'https://via.placeholder.com/800x200?text=No+Image',
        };
      });
      // Only return categories that either have laptops after filtering or if no category filter is active
      if (this.selectedCategoryFilter) {
        return categoryData.filter(cat => cat.name === this.selectedCategoryFilter && cat.laptops.length > 0);
      }
      return categoryData.filter(cat => cat.laptops.length > 0); // Show categories if they have matching laptops
    }
  },
  methods: {
    formatPrice(value) {
      if (typeof value !== "number") {
        return value;
      }
      return `Rp ${new Intl.NumberFormat('id-ID').format(value)}`;
    },
    openModal(laptop) {
      this.selectedLaptopForModal = laptop;
      this.isModalVisible = true;
    },
    closeModal() {
      this.isModalVisible = false;
      this.selectedLaptopForModal = null;
    }
  }
};
</script>

<template>
  <section class="laptop-list-section">
    <h2 class="section-title">List Laptop</h2>
    <div class="filters">
      <input
        type="text"
        v-model="searchQuery"
        placeholder="Cari laptop..."
        class="search-box"
        aria-label="Cari laptop"
      />
      <select v-model="selectedCategoryFilter" class="filter-button" aria-label="Pilih kategori laptop">
        <option value="">Semua Kategori</option>
        <option value="Low-End">Low-End</option>
        <option value="Mid-Range">Mid-Range</option>
        <option value="High-End">High-End</option>
      </select>
    </div>

    <div v-if="filteredLaptops.length > 0" class="categories-container">
      <div v-for="categoryData in categoriesWithLaptops" :key="categoryData.name" class="category-section">
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
            v-for="laptop in categoryData.laptops" 
            :key="laptop.id" 
            class="card"
            @click="openModal(laptop)"
            role="button"
            tabindex="0"
            @keydown.enter="openModal(laptop)"
            @keydown.space="openModal(laptop)"
          >
            <img :src="laptop.image" :alt="laptop.name" class="card-image" />
            <h4 class="card-title">{{ laptop.name }}</h4> <!-- Changed to h4 for semantic structure -->
            <p class="card-text">
              <!-- Kategori: {{ laptop.category }}<br /> Price is primary -->
              <strong>Harga:</strong> {{ formatPrice(laptop.price) }}
            </p>
          </div>
        </div>
      </div>
    </div>
    <div v-else class="no-results">
      <p>Tidak ada laptop yang cocok dengan kriteria pencarian Anda.</p>
    </div>

    <!-- Modal -->
    <div v-if="isModalVisible" class="modal-overlay" @click.self="closeModal" role="dialog" aria-modal="true" :aria-labelledby="selectedLaptopForModal ? 'modal-title-' + selectedLaptopForModal.id : ''">
      <div class="modal-content">
        <button class="modal-close-button" @click="closeModal" aria-label="Tutup detail laptop">×</button>
        <div v-if="selectedLaptopForModal">
          <img :src="selectedLaptopForModal.image" :alt="selectedLaptopForModal.name" class="modal-image" />
          <h2 :id="'modal-title-' + selectedLaptopForModal.id" class="modal-laptop-title">{{ selectedLaptopForModal.name }}</h2>
          <p><strong>Kategori:</strong> {{ selectedLaptopForModal.category }}</p>
          <p><strong>Harga:</strong> {{ formatPrice(selectedLaptopForModal.price) }}</p>
          <p><strong>Deskripsi:</strong> {{ selectedLaptopForModal.description }}</p>
          <!-- You can add more detailed specs here if you add them to your data -->
          <!-- 
          <div v-if="selectedLaptopForModal.specs" class="specs-section">
            <h4>Spesifikasi Detail:</h4>
            <ul>
              <li v-for="(value, key) in selectedLaptopForModal.specs" :key="key">
                <strong>{{ key.replace(/([A-Z])/g, ' $1').replace(/^./, str => str.toUpperCase()) }}:</strong> {{ value }}
              </li>
            </ul>
          </div>
          -->
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
