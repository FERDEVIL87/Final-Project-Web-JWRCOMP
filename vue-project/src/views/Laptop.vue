<script>
import { Modal } from 'bootstrap';
import { cartStore } from '@/store/cartStore'; // Import global cart store
import { useRouter } from 'vue-router'; // Import for navigation

export default {
  name: "LaptopListSection",
  setup() {
    const router = useRouter(); // Initialize router
    return { router, cartStore }; // Expose to template
  },
  data() {
    return {
      laptops: [], // Initialize as empty, will be fetched
      searchQuery: "",
      selectedCategoryFilter: "",
      selectedLaptopForModal: null,
      bootstrapLaptopModal: null,
      minPrice: 0,
      maxPrice: 100000000, // Default max, will be updated
      priceSlider: [0, 100000000], // Default, will be updated
      checkoutQty: 1,
      loading: true, // For loading state
    };
  },
  async created() { // Changed to async for fetch
    await this.fetchLaptops(); // Call fetch method
    this.updatePriceSliderBounds();
    this.loading = false;
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
      if (this.loading) return []; // Return empty if still loading
      return this.laptops.filter((laptop) => {
        const matchesSearch = laptop.name.toLowerCase().includes(this.searchQuery.toLowerCase());
        const matchesCategory = this.selectedCategoryFilter ? laptop.category === this.selectedCategoryFilter : true;
        const matchesPrice = laptop.price >= this.priceSlider[0] && laptop.price <= this.priceSlider[1];
        return matchesSearch && matchesCategory && matchesPrice;
      });
    },
    categoriesWithLaptops() {
      if (this.loading) return [];
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
    async fetchLaptops() {
        this.loading = true;
        try {
            const response = await fetch('/data/laptop.json'); // Path to your JSON file
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const data = await response.json();
            this.laptops = data.map(laptop => ({
                ...laptop,
                id: String(laptop.id), // Ensure ID is a string
                // Brand should ideally be in the JSON, but fallback if not
                brand: laptop.brand || this.getBrandFromName(laptop.name),
                // Image path correction (remove /public/ if present)
                image: laptop.image.startsWith("/public/") ? laptop.image.replace("/public/", "/") : laptop.image,
                stock: Number(laptop.stock) || 0 // Ensure stock is a number
            }));
        } catch (error) {
            console.error("Could not fetch laptop data:", error);
            this.laptops = []; // Set to empty array on error
        } finally {
            this.loading = false;
        }
    },
    getBrandFromName(name) { // Helper to guess brand
        const lowerName = name.toLowerCase();
        if (lowerName.includes("acer")) return "Acer";
        if (lowerName.includes("hp")) return "HP";
        if (lowerName.includes("asus")) return "ASUS";
        if (lowerName.includes("lenovo")) return "Lenovo";
        if (lowerName.includes("dell")) return "Dell";
        if (lowerName.includes("macbook")) return "Apple";
        if (lowerName.includes("razer")) return "Razer";
        return "Other"; // Default brand
    },
    updatePriceSliderBounds() {
        if (this.laptops.length > 0) {
            const prices = this.laptops.map(l => l.price);
            this.minPrice = Math.min(...prices, 0); // Ensure min is at least 0
            this.maxPrice = Math.max(...prices, 1000000); // Ensure max is at least a sensible value
            // Reset slider to new bounds if it was at default or out of new range
            if (this.priceSlider[0] < this.minPrice || this.priceSlider[0] === 0 && this.priceSlider[1] === 100000000) {
                 this.priceSlider = [this.minPrice, this.maxPrice];
            } else {
                 this.priceSlider = [Math.max(this.minPrice, this.priceSlider[0]), Math.min(this.maxPrice, this.priceSlider[1])];
            }

        } else {
            // Defaults if no laptops loaded
            this.minPrice = 0;
            this.maxPrice = 100000000;
            this.priceSlider = [0, 100000000];
        }
    },
    formatPrice(value) {
      if (typeof value !== "number" || isNaN(value)) {
        return 'Rp 0';
      }
      return `Rp ${new Intl.NumberFormat('id-ID', { minimumFractionDigits: 0, maximumFractionDigits: 0 }).format(value)}`;
    },
    openModal(laptop) {
      this.selectedLaptopForModal = laptop;
      this.checkoutQty = 1; // Reset quantity on modal open
      if (this.bootstrapLaptopModal) {
        this.bootstrapLaptopModal.show();
      }
    },
    closeModal() {
      if (this.bootstrapLaptopModal) {
        this.bootstrapLaptopModal.hide();
      }
    },
    addItemToCart(laptop) { // Method to add item to cart
      if (!laptop || this.checkoutQty < 1 ) {
        alert("Invalid quantity.");
        return;
      }
      if (laptop.stock <= 0 || this.checkoutQty > laptop.stock) {
        alert(`Quantity (x${this.checkoutQty}) exceeds available stock (${laptop.stock}) or item is out of stock.`);
        return;
      }

      const laptopItem = {
        id: String(laptop.id), // Ensure ID is a string
        source: 'laptop', // Source identifier for Checkout.vue
        name: laptop.name,
        price: laptop.price,
        qty: this.checkoutQty,
        category: laptop.category,
        brand: laptop.brand, // Assumes brand is now populated
        image: laptop.image,
        specification: laptop.description // Full description as specification
      };

      cartStore.addItem(laptopItem);
      alert(`${laptop.name} (x${this.checkoutQty}) berhasil ditambahkan ke keranjang!`);
      this.closeModal();
    },
    goToCheckout() {
      if (cartStore.items.length === 0) {
        alert("Keranjang belanja Anda kosong. Silakan tambahkan produk terlebih dahulu.");
        return;
      }
      this.router.push('/checkout');
    }
  },
  watch: {
    laptops: { // Watch for changes in the laptops array (e.g., after fetching)
        handler() {
            this.updatePriceSliderBounds();
        },
        deep: true // Important if laptops array itself is replaced
    },
    priceSlider: { // Prevent min from exceeding max and vice-versa for the slider itself
        handler(newVal) {
            if (newVal[0] > newVal[1]) {
                // This can create a loop if not careful. A better way is to adjust in the @input event.
                // For now, let's assume the @input handlers on the range inputs manage this.
            }
        },
        deep: true
    }
  }
};
</script>

<template>
  <section class="pc-list-section-bs">
    <div class="container py-4 py-md-5">
      <h2 class="section-title-bs text-center">Toko Laptop</h2>

      <!-- Tombol Checkout Global -->
      <div class="text-center my-4 py-3 border-top border-bottom border-secondary">
        <h4 class="mb-3" style="font-family: 'Orbitron', sans-serif; color: #fff;">Keranjang Belanja Global</h4>
        <p v-if="cartStore.items.length > 0" class="mb-2 text-light">
          Total Item: {{ cartStore.items.reduce((acc, item) => acc + item.qty, 0) }} | Total Harga: <span class="text-success fw-bold">{{ formatPrice(cartStore.totalPrice) }}</span>
        </p>
        <p v-else class="text-muted mb-2">Keranjang belanja utama masih kosong.</p>
        <button class="btn btn-success btn-lg px-5" @click="goToCheckout" style="font-family: 'Orbitron', sans-serif;">
           <i class="bi bi-cart-check-fill me-2"></i> Lihat Keranjang & Checkout
        </button>
      </div>

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
                  <div class="slider-harga-bs d-flex flex-column flex-md-row align-items-center gap-md-3 p-2 rounded-3">
                    <label for="minPriceSlider" class="form-label mb-0 price-range-label-bs">Rentang Harga (Rp):</label>
                    <div class="slider-range-group d-flex align-items-center flex-grow-1 w-100">
                        <span class="harga-min-bs me-2" style="min-width: 100px; font-size:0.9em;">{{ formatPrice(priceSlider[0]) }}</span>
                        <input
                          id="minPriceSlider"
                          type="range"
                          v-model.number="priceSlider[0]"
                          :min="minPrice"
                          :max="maxPrice" 
                          :step="Math.max(100000, (maxPrice - minPrice) / 100)"
                          class="form-range slider-min-bs flex-grow-1 mx-md-2"
                          aria-label="Slider harga minimum"
                          @input="priceSlider[1] = Math.max(priceSlider[0], priceSlider[1])"
                        />
                        <input
                          id="maxPriceSlider"
                          type="range"
                          v-model.number="priceSlider[1]"
                          :min="minPrice" 
                          :max="maxPrice"
                          :step="Math.max(100000, (maxPrice - minPrice) / 100)"
                          class="form-range slider-max-bs flex-grow-1 mx-md-2"
                          aria-label="Slider harga maksimum"
                           @input="priceSlider[0] = Math.min(priceSlider[0], priceSlider[1])"
                        />
                        <span class="harga-max-bs ms-2" style="min-width: 100px; font-size:0.9em;">{{ formatPrice(priceSlider[1]) }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </transition>

      <!-- Loading Placeholder -->
      <div v-if="loading" class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 row-cols-xl-4 g-3 g-lg-4 justify-content-center">
        <div v-for="n in 8" :key="`placeholder-${n}`" class="col d-flex align-items-stretch">
            <div class="card h-100 card-bs w-100" style="background-color: #1a243a; border-color: #00d9ff33;">
                <div class="card-img-wrapper-bs" style="background-color: #11192b; aspect-ratio: 4/3; display:flex; align-items:center; justify-content:center;">
                    <div style="width: 80%; height: 60%; background-color: #232e4d; border-radius: 4px; animation: pulse-bg 1.5s infinite ease-in-out;"></div>
                </div>
                <div class="card-body p-3">
                    <div style="height: 1.25em; width: 75%; background-color: #232e4d; border-radius: 4px; margin-bottom: 0.75rem; animation: pulse-bg 1.5s infinite ease-in-out 0.2s;"></div>
                    <div style="height: 1em; width: 90%; background-color: #232e4d; border-radius: 4px; margin-bottom: 0.5rem; animation: pulse-bg 1.5s infinite ease-in-out 0.4s;"></div>
                    <div style="height: 1em; width: 60%; background-color: #232e4d; border-radius: 4px; margin-bottom: 1rem; animation: pulse-bg 1.5s infinite ease-in-out 0.6s;"></div>
                    <div style="height: 2.25em; width: 100%; background-color: #00d9ff44; border-radius: 4px; animation: pulse-bg 1.5s infinite ease-in-out 0.8s;"></div>
                </div>
            </div>
        </div>
      </div>


      <!-- Laptop Categories and Cards -->
      <transition-group name="fade-slide" tag="div" appear v-else>
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
                    role="button"
                    tabindex="0"
                    :aria-label="`Lihat detail ${laptop.name}`"
                    @keydown.enter="openModal(laptop)"
                    @keydown.space="openModal(laptop)"
                  >
                    <div class="card-img-wrapper-bs" @click="openModal(laptop)">
                      <img :src="laptop.image" :alt="`Gambar ${laptop.name}`" class="card-img-top card-img-bs" />
                    </div>
                    <div class="card-body d-flex flex-column p-3">
                      <h4 class="card-title card-title-bs mb-2" @click="openModal(laptop)">{{ laptop.name }}</h4>
                      <p class="card-text-desc-bs small mb-2" @click="openModal(laptop)">{{ laptop.description.split(',')[0] }}</p>
                       <div class="mt-auto"> 
                        <p class="card-text card-text-price-bs mb-2" @click="openModal(laptop)">
                            <strong>Harga:</strong> {{ formatPrice(laptop.price) }}
                        </p>
                        <button
                            v-if="laptop.stock > 0"
                            class="btn btn-sm btn-primary w-100"
                            @click.stop="openModal(laptop)" 
                            style="font-family: 'Orbitron', sans-serif;"
                        >
                            <i class="bi bi-eye-fill me-1"></i> Lihat Detail & Beli
                        </button>
                        <button
                            v-else
                            class="btn btn-sm btn-secondary w-100"
                            disabled
                            style="font-family: 'Orbitron', sans-serif;"
                        >
                            Stok Habis
                        </button>
                      </div>
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
                    <p><strong>Brand:</strong> {{ selectedLaptopForModal.brand }}</p>
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
                    <div v-if="selectedLaptopForModal.stock > 0" class="d-flex flex-column flex-md-row align-items-center gap-3 justify-content-center justify-content-lg-start mt-4">
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
                        :disabled="selectedLaptopForModal.stock <= 0 || checkoutQty < 1 || (selectedLaptopForModal.stock > 0 && checkoutQty > selectedLaptopForModal.stock)"
                        @click="addItemToCart(selectedLaptopForModal)"
                         style="font-family: 'Orbitron', sans-serif;"
                      >
                        <i class="bi bi-cart-plus-fill me-1"></i> Tambah ke Keranjang
                      </button>
                    </div>
                     <div v-else class="mt-4 text-center">
                        <p class="text-danger fw-bold" style="font-family: 'Orbitron', sans-serif;">STOK HABIS</p>
                    </div>
                  </div>
                </div>
              </div>
              <div v-else class="text-center">
                <p>Silakan pilih laptop untuk melihat detail.</p>
              </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" @click="closeModal" style="font-family: 'Orbitron', sans-serif;">Tutup</button>
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
  --secondary-color: #00c6ff; /* Added for consistency if used */
  --background-main: #0c101c;
  --background-section: #11192b;
  --background-card: #1a243a;
  --background-modal: #0f1626;
  --text-light: #e8eff5;
  --text-muted-bs: #adb5bd; /* For consistency */
  --text-title: #ffffff; /* For consistency */
  --primary-color-rgb-val: 0, 217, 255; /* For consistency */
  --border-color-soft: rgba(var(--primary-color-rgb-val), 0.2);
  --border-color-medium: rgba(var(--primary-color-rgb-val), 0.35);
  --border-color-strong: var(--primary-color);

  font-family: 'Roboto', sans-serif;
  min-height: 100vh;
  background: var(--background-main);
  color: var(--text-light);
  overflow-x: hidden; /* Prevent horizontal scroll */
}
.container {
  width: 100%;
  max-width: 1200px;
  margin-left: auto;
  margin-right: auto;
  padding-left: 1rem; /* Consistent padding */
  padding-right: 1rem;
  box-sizing: border-box;
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
.section-title-bs::after { /* Underline for title */
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
  border-radius: 8px; /* Consistent border-radius */
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

.slider-harga-bs {
  background: var(--background-card);
  border: 1px solid var(--border-color-soft);
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  border-radius: 6px; /* Consistent border-radius */
}
.price-range-label-bs {
  color: var(--primary-color);
  font-weight: 500;
  min-width: 140px; 
}
.slider-harga-bs .slider-range-group {
  display: flex;
  align-items: center; 
  gap: 0.75rem; 
  flex: 1 1 0%; 
  min-width: 180px; 
}
.slider-harga-bs .form-range {
  accent-color: var(--primary-color);
  flex-grow: 1; 
}
.harga-min-bs, .harga-max-bs {
  font-family: 'Orbitron', sans-serif;
  color: var(--primary-color);
  font-weight: 600;
  font-size: 0.95rem; 
  text-align: center; 
  flex-shrink: 0; 
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
  /* cursor: pointer; */ /* Clicks handled by inner elements or specific card sections */
  color: var(--text-light);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  margin: 0 auto; 
}
.card-bs:hover, .card-bs:focus-within { /* focus-within for keyboard nav on card */
  transform: translateY(-5px) scale(1.015);
  box-shadow: 0 7px 22px rgba(var(--primary-color-rgb-val), 0.4);
  border-color: var(--border-color-strong);
  outline: none;
}

.card-img-wrapper-bs {
  background-color: var(--background-section);
  padding: 10px;
  width: 100%; 
  aspect-ratio: 4 / 3; 
  display: flex;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid var(--border-color-soft);
  box-sizing: border-box; 
  cursor: pointer; /* Make image wrapper clickable for modal */
}

.card-img-bs {
  max-width: 100%; 
  max-height: 100%;
  object-fit: contain; 
  border-radius: 4px;
}

.card-bs .card-body {
  padding: 1rem;
  text-align: center; 
  flex-grow: 1; 
  display: flex; 
  flex-direction: column; 
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
  cursor: pointer; /* Make title clickable for modal */
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
  cursor: pointer; /* Make description clickable for modal */
}
.card-text-price-bs {
  font-size: 0.95rem;
  font-weight: bold;
  color: #fff;
  cursor: pointer; /* Make price clickable for modal */
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
  color: var(--text-light);
  text-shadow: none; 
  font-style: normal; 
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
.checkout-qty-group-bs {
  max-width: 140px;
}
.checkout-qty-group-bs .form-control {
  min-width: 60px;
  text-align: center; 
  background-color: var(--background-section); /* Match theme */
  color: var(--text-light);
  border-color: var(--border-color-medium);
}
.checkout-qty-group-bs .input-group-text {
  background-color: var(--background-card);
  color: var(--primary-color);
  border-color: var(--border-color-medium);
}

.checkout-button-bs {
  background: var(--primary-color);
  border: none;
  color: var(--background-main); /* Ensure contrast */
  font-weight: 600;
  min-width: 140px;
  transition: background-color 0.2s, transform 0.1s;
}
.checkout-button-bs:hover:not(:disabled) {
  background: var(--secondary-color);
  transform: scale(1.03);
}
.checkout-button-bs:disabled {
  background: #555; 
  cursor: not-allowed;
  opacity: 0.7; /* Visual cue for disabled */
}
.modal-footer {
    background-color: var(--background-card);
    border-top: 1px solid var(--border-color-medium);
    padding: 0.75rem 1rem; /* Standard modal footer padding */
}
.modal-footer .btn-secondary {
    background-color: #4a5568; /* A neutral dark gray */
    border-color: #4a5568;
}
.modal-footer .btn-secondary:hover {
    background-color: #2d3748; /* Darker gray on hover */
    border-color: #2d3748;
}


@keyframes scaleUpModal-bs {
  from { transform: scale(0.92) translateY(12px); opacity: 0; }
  to { transform: scale(1) translateY(0); opacity: 1; }
}

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

@keyframes pulse-bg {
  0% { background-color: #232e4d; }
  50% { background-color: #2c3a57; }
  100% { background-color: #232e4d; }
}


/* Responsive Adjustments */
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
  .modal-details-text {
    text-align: center; 
  }
  .specs-section-bs h4 {
    text-align: center !important; 
  }
  .specs-section-bs ul {
    padding-left: 1.5rem; 
    display: inline-block; 
    text-align: left; 
  }
  .slider-harga-bs .slider-range-group {
    flex-direction: column;
    align-items: stretch;
  }
  .slider-harga-bs .form-range {
    width: 100%; /* Ensure sliders take full width when stacked */
    margin: 0.5rem 0; /* Add some vertical spacing */
  }
  .harga-min-bs, .harga-max-bs {
    text-align: left;
    margin-bottom: 0.25rem; /* Space below price text when stacked */
  }
}

@media (max-width: 575.98px) {
  .pc-list-section-bs .container {
    padding-left: 0.75rem; 
    padding-right: 0.75rem;
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
  .checkout-qty-group-bs {
    width: 100%; 
    max-width: none;
  }
  .checkout-button-bs {
    width: 100%; 
  }
}
</style>