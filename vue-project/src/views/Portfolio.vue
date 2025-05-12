<template>
  <section class="container my-5" data-aos="fade-up">
    <h2 class="h3 mb-4 text-primary text-center futuristic-title">HARDWARE</h2>
    <!-- Kategori Grid -->
    <div class="category-grid">
      <button
        v-for="(card, index) in cards"
        :key="index"
        class="category-button"
        @click="selectCategory(card)"
      >
        {{ card.title }}
      </button>
    </div>

    <!-- Filter dan Search -->
    <div v-if="selectedCategory" class="filters">
      <h3 class="text-center">{{ selectedCategory.title }}</h3>
      <div class="filter-controls">
        <input
          type="text"
          v-model="searchQuery"
          placeholder="Search components..."
          class="form-control"
        />
        <select v-model="selectedBrand" class="form-control">
          <option value="">All Brands</option>
          <option v-for="brand in brands" :key="brand" :value="brand">
            {{ brand }}
          </option>
        </select>
        <input
          type="range"
          v-model="priceRange"
          min="0"
          max="1000"
          step="10"
          class="form-range"
        />
        <span>Max Price: ${{ priceRange }}</span>
      </div>

      <!-- List Komponen -->
      <ul class="component-list">
        <li
          v-for="component in filteredComponents"
          :key="component.id"
          class="component-item"
          @click="showDetails(component)"
        >
          {{ component.name }} - ${{ component.price }} ({{ component.brand }})
        </li>
      </ul>
    </div>

    <!-- Modal Detail Produk -->
    <div v-if="selectedProduct" class="modal-overlay" @click.self="closeDetails">
      <div class="modal-content">
        <h3>{{ selectedProduct.name }}</h3>
        <img :src="selectedProduct.image" alt="Product Image" class="product-image" />
        <p><strong>Price:</strong> ${{ selectedProduct.price }}</p>
        <p><strong>Brand:</strong> {{ selectedProduct.brand }}</p>
        <p><strong>Specifications:</strong></p>
        <ul>
          <li v-for="(spec, index) in selectedProduct.specs" :key="index">
            {{ spec }}
          </li>
        </ul>
        <button class="close-button" @click="closeDetails">Close</button>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  data() {
    return {
      cards: [
        { title: "PROCESSOR", link: "/PROCESSOR" },
        { title: "MAINBOARD", link: "/MAINBOARD" },
        { title: "MEMORY", link: "/MEMORY" },
        { title: "VGA", link: "/VGA" },
        { title: "HDD", link: "/HDD" },
        { title: "SDD", link: "/SDD" },
        { title: "PSU", link: "/PSU" },
        { title: "CASE", link: "/CASE" },
        { title: "LED MONITOR", link: "/LED MONITOR" },
      ],
      selectedCategory: null,
      components: [
        {
          id: 1,
          name: "Intel i9",
          price: 500,
          brand: "Intel",
          category: "PROCESSOR",
          image: "https://via.placeholder.com/150",
          specs: ["10 Cores", "20 Threads", "3.6 GHz Base Clock"],
        },
        {
          id: 2,
          name: "AMD Ryzen 7",
          price: 400,
          brand: "AMD",
          category: "PROCESSOR",
          image: "https://via.placeholder.com/150",
          specs: ["8 Cores", "16 Threads", "3.8 GHz Base Clock"],
        },
        {
          id: 3,
          name: "ASUS ROG",
          price: 300,
          brand: "ASUS",
          category: "MAINBOARD",
          image: "https://via.placeholder.com/150",
          specs: ["ATX Form Factor", "RGB Lighting", "PCIe 4.0 Support"],
        },
        {
          id: 4,
          name: "Corsair 16GB",
          price: 150,
          brand: "Corsair",
          category: "MEMORY",
          image: "https://via.placeholder.com/150",
          specs: ["16GB DDR4", "3200 MHz", "CL16"],
        },
        // Tambahkan data lainnya sesuai kebutuhan
      ],
      searchQuery: "",
      selectedBrand: "",
      priceRange: 1000,
      brands: ["Intel", "AMD", "ASUS", "Corsair"], // Daftar brand
      selectedProduct: null, // Produk yang dipilih
    };
  },
  computed: {
    filteredComponents() {
      return this.components.filter((component) => {
        return (
          component.category === this.selectedCategory.title &&
          component.name.toLowerCase().includes(this.searchQuery.toLowerCase()) &&
          (this.selectedBrand === "" || component.brand === this.selectedBrand) &&
          component.price <= this.priceRange
        );
      });
    },
  },
  methods: {
    selectCategory(card) {
      this.selectedCategory = card;
      this.searchQuery = "";
      this.selectedBrand = "";
      this.priceRange = 1000;
    },
    showDetails(component) {
      this.selectedProduct = component;
    },
    closeDetails() {
      this.selectedProduct = null;
    },
  },
};
</script>
<style scoped>
/* Grid untuk kategori */
.category-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 1rem;
  margin-bottom: 2rem;
}

.category-button {
  padding: 1rem;
  background: linear-gradient(145deg, #0d1b2a, #1b263b); /* Neon dark biru */
  color: #00d4ff; /* Neon biru */
  border: 1px solid #1b263b;
  border-radius: 10px;
  text-align: center;
  cursor: pointer;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.category-button:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 212, 255, 0.5); /* Neon efek */
}

/* Filter Controls */
.filters {
  margin-top: 2rem;
  background: #0d1b2a; /* Neon dark biru */
  padding: 1rem;
  border-radius: 10px;
  border: 1px solid #1b263b;
  color: #00d4ff; /* Neon biru */
}

.filter-controls {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  margin-bottom: 1rem;
}

.filter-controls .form-control,
.filter-controls .form-range {
  flex: 1;
  min-width: 150px;
  background: #1b263b; /* Neon dark biru */
  color: #00d4ff; /* Neon biru */
  border: 1px solid #00d4ff;
  border-radius: 5px;
  padding: 0.5rem;
}

.filter-controls .form-control::placeholder {
  color: #00d4ff; /* Placeholder neon biru */
}

/* List Komponen */
.component-list {
  list-style: none;
  padding: 0;
}

.component-item {
  padding: 0.5rem;
  background: #1b263b; /* Neon dark biru */
  color: #00d4ff; /* Neon biru */
  margin-bottom: 0.5rem;
  border-radius: 5px;
  border: 1px solid #00d4ff;
  cursor: pointer;
  transition: background 0.3s ease, box-shadow 0.3s ease;
}

.component-item:hover {
  background: #0d1b2a;
  box-shadow: 0 5px 15px rgba(0, 212, 255, 0.5); /* Neon efek */
}

/* Modal */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.9); /* Hitam transparan */
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background: #0d1b2a; /* Neon dark biru */
  color: #00d4ff; /* Neon biru */
  padding: 2rem;
  border-radius: 10px;
  max-width: 500px;
  width: 90%;
  text-align: center;
  border: 1px solid #00d4ff;
}

.product-image {
  max-width: 100%;
  height: auto;
  margin-bottom: 1rem;
  border: 1px solid #00d4ff; /* Neon biru */
  border-radius: 5px;
}

.close-button {
  background: #00d4ff; /* Neon biru */
  color: #0d1b2a; /* Dark biru */
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 5px;
  cursor: pointer;
  margin-top: 1rem;
  transition: background 0.3s ease, transform 0.3s ease;
}

.close-button:hover {
  background: #00a3cc; /* Biru lebih gelap */
  transform: scale(1.1);
}

/* Ubah latar belakang utama */
body {
  background-color: #000; /* Hitam */
  color: #00d4ff; /* Neon biru untuk teks */
}
</style>
