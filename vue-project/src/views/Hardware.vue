<template>
  <section class="container my-5" data-aos="fade-up">
    <h2 class="h3 mb-4 text-center futuristic-title-bs neon-title-bs">HARDWARE</h2>

    <!-- Kategori Grid -->
    <div class="d-flex flex-wrap justify-content-center gap-2 mb-4">
      <button
        v-for="(card, index) in cards"
        :key="index"
        class="btn category-button-bs"
        :class="{ active: selectedCategory && selectedCategory.title === card.title }"
        @click="selectCategory(card)"
      >
        {{ card.title }}
      </button>
    </div>

    <!-- Judul Kategori -->
    <div v-if="selectedCategory" class="text-center mb-4">
      <h3 class="category-title-bs">{{ selectedCategory.title }}</h3>
    </div>

    <!-- Kontrol Filter dan Tabel Produk -->
    <div v-if="selectedCategory" class="product-section-bs">
      <div class="row g-3 mb-3">
        <div class="col-md-6">
          <input
            type="text"
            v-model="searchQuery"
            placeholder="Search products..."
            class="form-control form-control-bs"
          />
        </div>
        <div class="col-md-6">
          <select v-model="selectedBrand" class="form-select form-control-bs">
            <option value="">All Brands</option>
            <option v-for="brand in uniqueBrandsInCategory" :key="brand" :value="brand">
              {{ brand }}
            </option>
          </select>
        </div>
      </div>

      <div v-if="filteredComponents.length > 0" class="table-responsive-custom table-background-bs">
        <table class="table product-table-bs">
          <thead>
            <tr>
              <th>Image</th>
              <th>Name</th>
              <th>Price</th>
              <th>Brand</th>
              <th>Stock</th>
              <th>Details</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="component in filteredComponents" :key="component.id">
              <td data-label="Image:">
                <img :src="component.image" alt="Product Image" class="table-thumbnail-bs" />
              </td>
              <td data-label="Name:">{{ component.name }}</td>
              <td data-label="Price:">{{ formatPrice(component.price) }}</td>
              <td data-label="Brand:">{{ component.brand }}</td>
              <td data-label="Stock:" :class="{'text-stock-ready': component.stock === 'Ready', 'text-stock-kosong': component.stock === 'Kosong'}">
                {{ component.stock }}
              </td>
              <td data-label="Details:">
                <button class="btn btn-sm details-button-bs" @click="openModal(component)">
                  View
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div v-else class="text-center py-4 no-results-bs">
        <p>No products match your current filters.</p>
      </div>
    </div>
    <div v-if="!selectedCategory" class="text-center py-5 select-category-prompt-bs">
      <p>✨ Please select a category to view hardware components. ✨</p>
    </div>

    <!-- Custom Modal Pop Up Produk -->
    <div
      v-if="showProductModal"
      class="custom-modal-backdrop"
      @click.self="closeModal"
    >
      <div class="custom-modal-content">
        <div class="custom-modal-header">
          <span class="custom-modal-title">{{ selectedProduct?.name }}</span>
          <button class="custom-modal-close" @click="closeModal" aria-label="Close">&times;</button>
        </div>
        <div class="custom-modal-body">
          <img
            v-if="selectedProduct?.image"
            :src="selectedProduct.image"
            alt="Product Image"
            class="custom-modal-image"
          />
          <div class="details-text-group">
            <p><strong>Price:</strong> {{ formatPrice(selectedProduct?.price) }}</p>
            <p><strong>Brand:</strong> {{ selectedProduct?.brand }}</p>
          </div>
          <div v-if="selectedProduct?.specs && selectedProduct.specs.length > 0" class="specs-list">
            <p class="mb-1"><strong>Specifications:</strong></p>
            <ul>
              <li v-for="(spec, index) in selectedProduct.specs" :key="index">
                {{ spec }}
              </li>
            </ul>
          </div>
        </div>
        <div class="custom-modal-footer">
          <button class="btn close-button-bs" @click="closeModal">Close</button>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  data() {
    return {
      cards: [
        { title: "PROCESSOR INTEL", link: "/PROCESSOR INTEL" },
        { title: "PROCESSOR AMD", link: "/PROCESSOR AMD" },
        { title: "MAINBOARD", link: "/MAINBOARD" },
        { title: "MEMORY", link: "/MEMORY" },
        { title: "VGA", link: "/VGA" },
        { title: "HDD", link: "/HDD" },
        { title: "SSD", link: "/SSD" },
        { title: "PSU", link: "/PSU" },
        { title: "CASE", link: "/CASE" },
        { title: "LED MONITOR", link: "/LED MONITOR" },
        { title: "MOUSE", link: "/MOUSE" },
        { title: "KEYBOARD", link: "/KEYBOARD" },
        { title: "MOUSEPAD", link: "/MOUSEPAD" },
        { title: "WEBCAM", link: "/WEBCAM" },
        { title: "CABLE", link: "/CABLE" },
        { title: "HEADSET", link: "/HEADSET" },
        { title: "SPEAKER", link: "/SPEAKER" },
        { title: "USB FLASHDISK", link: "/USB FLASHDISK" },
        { title: "PRINTER", link: "/PRINTER" },
      ],
      selectedCategory: null,
      components: [
        {
          id: 1,
          name: "Intel Processor Core i9-13900KF",
          price: 10000000,
          brand: "Intel",
          category: "PROCESSOR INTEL",
          image: "https://images.tokopedia.net/img/cache/700/hDjmkQ/2023/11/4/c3cb0c74-cd14-4c4d-b5af-8915c4e733b2.jpg",
          specs: ["24 Cores", "32 Threads", "5.80 GHz Base Clock"],
          stock: "Ready",
        },
        {
          id: 2,
          name: "Intel Processor Core i9-13900KF",
          price: 10000000,
          brand: "Intel",
          category: "PROCESSOR INTEL",
          image: "https://images.tokopedia.net/img/cache/700/hDjmkQ/2023/11/4/c3cb0c74-cd14-4c4d-b5af-8915c4e733b2.jpg",
          specs: ["24 Cores", "32 Threads", "5.80 GHz Base Clock"],
          stock: "Ready",
        },
        // ... (DATA PRODUK LENGKAP ANDA DI SINI) ...
      ],
      searchQuery: "",
      selectedBrand: "",
      selectedProduct: null,
      showProductModal: false,
    };
  },
  computed: {
    filteredComponents() {
      if (!this.selectedCategory) return [];
      return this.components.filter((component) => {
        const categoryMatch = component.category === this.selectedCategory.title;
        const searchMatch = component.name.toLowerCase().includes(this.searchQuery.toLowerCase());
        const brandMatch = this.selectedBrand === "" || component.brand === this.selectedBrand;
        return categoryMatch && searchMatch && brandMatch;
      });
    },
    uniqueBrandsInCategory() {
      if (!this.selectedCategory) return [];
      const componentsInCategory = this.components.filter(
        (component) => component.category === this.selectedCategory.title
      );
      return [...new Set(componentsInCategory.map((component) => component.brand))].sort();
    }
  },
  methods: {
    selectCategory(category) {
      this.selectedCategory = category;
      this.searchQuery = "";
      this.selectedBrand = "";
    },
    formatPrice(priceIDR) {
      if (typeof priceIDR !== 'number' || isNaN(priceIDR)) {
        return 'Rp 0';
      }
      return new Intl.NumberFormat("id-ID", {
        style: "currency",
        currency: "IDR",
        minimumFractionDigits: 0,
        maximumFractionDigits: 0,
      }).format(priceIDR);
    },
    openModal(component) {
      this.selectedProduct = component;
      this.showProductModal = true;
      document.body.style.overflow = 'hidden';
    },
    closeModal() {
      this.showProductModal = false;
      this.selectedProduct = null;
      document.body.style.overflow = '';
    },
  },
  mounted() {
    if (this.cards.length > 0) {
      this.selectCategory(this.cards[0]);
    }
  }
};
</script>

<style scoped>
/* Neon & Futuristic Styles */
.futuristic-title-bs {}

.neon-title-bs {
  font-size: 2.5rem;
  font-weight: bold;
  color: #f5f5f5 !important;
  text-shadow: 0 0 5px #00d4ff, 0 0 10px #00d4ff, 0 0 20px #00d4ff, 0 0 40px #00a3cc, 0 0 80px #00a3cc;
  animation: glow 1.5s infinite alternate;
}
@keyframes glow {
  from {
    text-shadow: 0 0 5px #00d4ff, 0 0 10px #00d4ff, 0 0 15px #00d4ff, 0 0 20px #00a3cc, 0 0 35px #00a3cc;
  }
  to {
    text-shadow: 0 0 10px #00d4ff, 0 0 20px #00d4ff, 0 0 30px #00d4ff, 0 0 50px #00a3cc, 0 0 75px #00a3cc;
  }
}

.category-button-bs {
  padding: 0.75rem 1rem;
  background: linear-gradient(145deg, #0d1b2a, #1b263b);
  color: #00d4ff;
  border: 1px solid #1b263b;
  border-radius: 10px;
  text-align: center;
  transition: transform 0.3s, box-shadow 0.3s, color 0.3s, background 0.3s;
  font-size: 0.9rem;
  min-width: 140px;
}
.category-button-bs.active {
  font-weight: bold;
  color: #fff !important;
  background: #00a3cc;
  border-color: #00a3cc;
  box-shadow: 0 0 10px rgba(0, 212, 255, 0.7);
}
.category-button-bs:hover:not(.active) {
  transform: translateY(-3px);
  box-shadow: 0 5px 15px rgba(0, 212, 255, 0.5);
  color: #fff;
  background: #123450;
}

.category-title-bs {
  font-weight: bold;
  color: #fff;
  text-shadow: 0 0 5px #00d4ff;
}

.product-section-bs {
  background-color: rgba(13, 27, 42, 0.85);
  padding: 1.5rem;
  border-radius: 15px;
  box-shadow: 0 8px 25px rgba(0, 212, 255, 0.3);
  border: 1px solid #00a3cc;
}

.form-control-bs, .form-select-bs {
  background-color: #1b263b;
  color: #00d4ff;
  border: 1px solid #00d4ff;
  border-radius: 5px;
}
.form-control-bs::placeholder {
  color: #00d4ff80;
}
.form-control-bs:focus, .form-select-bs:focus {
  background-color: #203A55;
  color: #fff;
  border-color: #00d4ff;
  box-shadow: 0 0 0 0.25rem rgba(0, 212, 255, 0.25);
}
.form-select-bs {
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%2300d4ff' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3e%3c/svg%3e");
}

.table-responsive-custom {
  overflow-x: auto;
}
.product-table-bs {
  margin-top: 1rem;
  color: #00d4ff;
  background-color: transparent;
  width: 100%;
}
.product-table-bs th,
.product-table-bs td {
  border: 1px solid #00d4ff30;
  padding: 0.75rem;
  text-align: center;
  vertical-align: middle;
  color: #f5f5f5;
  background-color: #12283f;
}
.product-table-bs thead th {
  background-color: #1b263b;
  color: #fff;
  font-weight: bold;
  border-color: #00d4ff;
}
.table-thumbnail-bs {
  max-width: 70px;
  height: auto;
  border-radius: 5px;
  background-color: #0d1b2a;
  padding: 2px;
  border: 1px solid #00a3cc50;
}
.details-button-bs {
  background-color: #00d4ff;
  color: #0d1b2a;
  border: none;
  border-radius: 5px;
  font-weight: bold;
  transition: background-color 0.3s, transform 0.2s;
  padding: 0.3rem 0.8rem;
  font-size: 0.9em;
}
.details-button-bs:hover {
  background-color: #00a3cc;
  color: #fff;
  transform: scale(1.05);
}
.text-stock-ready {
  color: #28a745 !important;
  font-weight: bold;
}
.text-stock-kosong {
  color: #dc3545 !important;
  font-weight: bold;
}
.no-results-bs, .select-category-prompt-bs {
  color: #00d4ff;
  font-family: 'Orbitron', sans-serif;
  font-size: 1.1rem;
  padding: 2rem 0;
}

/* --- Custom Modal Styles --- */
.custom-modal-backdrop {
  position: fixed;
  z-index: 2000;
  top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(0, 0, 0, 0.25);
  display: flex;
  align-items: center;
  justify-content: center;
}

.custom-modal-content {
  background: #0d1b2a;
  color: #00d4ff;
  border-radius: 12px;
  border: 1px solid #00d4ff;
  box-shadow: 0 0 24px rgba(0, 212, 255, 0.4);
  max-width: 340px;
  width: 95vw;
  padding: 1.2rem 1.2rem 1rem 1.2rem;
  /* Hapus position: fixed, top, left, transform */
  position: relative;
  animation: modalPop .25s cubic-bezier(.4,2,.6,1) both;
}

@keyframes modalPop {
  from { transform: scale(0.85); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
}
.custom-modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid #00a3cc;
  margin-bottom: 0.7rem;
  padding-bottom: 0.3rem;
}
.custom-modal-title {
  font-family: 'Orbitron', sans-serif;
  font-size: 1.1rem;
  font-weight: bold;
  text-shadow: 0 0 5px #00d4ff;
  flex: 1;
  text-align: center;
}
.custom-modal-close {
  background: none;
  border: none;
  color: #00d4ff;
  font-size: 1.7rem;
  font-weight: bold;
  cursor: pointer;
  margin-left: 0.5rem;
  transition: color 0.2s;
  line-height: 1;
}
.custom-modal-close:hover {
  color: #fff;
}
.custom-modal-body {
  text-align: center;
  margin-bottom: 0.7rem;
}
.custom-modal-image {
  max-width: 140px;
  max-height: 140px;
  object-fit: contain;
  border: 1px solid #00d4ff;
  border-radius: 8px;
  background-color: #1b263b;
  margin-bottom: 0.7rem;
}
.details-text-group p {
  margin-bottom: 0.5rem;
  color: #f0f0f0;
}
.details-text-group strong {
  color: #00d4ff;
}
.specs-list ul {
  list-style-type: disc;
  padding-left: 1.5rem;
  color: #f5f5f5;
  text-align: left;
}
.specs-list p {
  color: #00d4ff;
}
.specs-list ul li {
  margin-bottom: 0.25rem;
}
.custom-modal-footer {
  border-top: 1px solid #00a3cc;
  justify-content: center;
  padding-top: 0.7rem;
  display: flex;
}

/* Responsive Table to Card */
@media (max-width: 575.98px) {
  .table-responsive-custom {
    overflow-x: visible;
    border: none;
  }
  .product-table-bs,
  .product-table-bs thead,
  .product-table-bs tbody,
  .product-table-bs th,
  .product-table-bs td,
  .product-table-bs tr {
    display: block;
  }
  .product-table-bs thead {
    display: none;
  }
  .product-table-bs tr {
    margin-bottom: 1.5rem;
    border-radius: 10px;
    background: #122030dd;
    border: 1px solid #00d4ff40;
    padding: 1rem;
    box-shadow: 0 4px 15px rgba(0, 172, 204, 0.15);
    display: flex;
    flex-direction: column;
    align-items: center;
  }
  .product-table-bs td {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    padding: 0.5rem 0.25rem;
    border: none;
    width: 100%;
    margin-bottom: 0.5rem;
    color: #fff;
    background-color: #12283f;
  }
  .product-table-bs td:last-child {
    margin-bottom: 0;
  }
  .product-table-bs td:before {
    content: attr(data-label);
    font-weight: bold;
    color: #00d4ff;
    font-size: 0.9em;
    margin-bottom: 0.25rem;
    display: block;
    text-shadow: 0 0 2px #00d4ff80;
  }
  .product-table-bs td[data-label="Image:"] {
    padding: 0.5rem 0;
  }
  .product-table-bs td[data-label="Image:"]:before {
    display: none;
  }
  .table-thumbnail-bs {
    max-width: 100px;
    margin: 0 auto 0.5rem auto;
  }
  .details-button-bs {
    width: auto;
    padding: 0.4rem 1rem;
  }
}
</style>
