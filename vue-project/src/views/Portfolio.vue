<template>
  <section class="container my-5" data-aos="fade-up">
    <h2 class="h3 mb-4 text-primary text-center futuristic-title neon-title">HARDWARE</h2>
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
          max="60000000"
          step="10"
          class="form-range"
        />
        <span>Max Price: Rp.{{ priceRange }}</span>
      </div>

      <!-- List Komponen -->
      <ul class="component-list">
        <li
          v-for="component in filteredComponents"
          :key="component.id"
          class="component-item"
          @click="showDetails(component)"
        >
          {{ component.name }} - Rp.{{ component.price }} ({{ component.brand }})
        </li>
      </ul>
    </div>

    <!-- Modal Detail Produk -->
    <div v-if="selectedProduct" class="modal-overlay" @click.self="closeDetails">
      <div class="modal-content">
        <h3>{{ selectedProduct.name }}</h3>
        <img :src="selectedProduct.image" alt="Product Image" class="product-image" />
        <p><strong>Price:</strong> Rp.{{ selectedProduct.price }}</p>
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
        { title: "PROCESSOR Intel", link: "/PROCESSOR Intel" },
        { title: "PROCESSOR AMD", link: "/PROCESSOR AMD" },
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
          name: "Intel Processor Core i9-13900KF",
          price: 8000000,
          brand: "Intel",
          category: "PROCESSOR Intel",
          image: "/src/img part/Intel Processor Core i9-13900KF.png",
          specs: ["24 Cores", "32 Threads", "5.80 GHz Base Clock"],
        },
        {
          id: 2,
          name: "Intel Processor Core I5 12400F (LGA 1700) - I5 12400F",
          price: 2000000,
          brand: "Intel",
          category: "PROCESSOR Intel",
          image: "/src/img part/Intel Processor Core I5 12400F.png",
          specs: ["6 Cores", "12 Threads", "4.40 GHz Base Clock"],
        },
        {
          id: 3,
          name: "Intel Processor Core i5-6500",
          price: 500000,
          brand: "Intel",
          category: "PROCESSOR Intel",
          image: "/src/img part/Intel Processor Core Core i5-6500 (2).png",
          specs: ["6 Cores", "Cache 6 MB Intel Smart Cache", " 3.20 GHz Base Clock"],
        },
        {
          id: 4,
          name: "INTEL CORE i7 10700KF 3.8GHZ 8C/16T LGA- 1200 CL",
          price: 4000000,
          brand: "Intel",
          category: "PROCESSOR Intel",
          image: "/src/img part/INTEL CORE i7 10700KF.png",
          specs: ["8 Cores", "16Threads", "5.10 GHz Base Clock"],
        },
        {
          id: 5,
          name: "Intel Processor Core  i9-13900K LGA 1700",
          price: 10000000,
          brand: "Intel",
          category: "PROCESSOR Intel",
          image: "/src/img part/Intel Processor Core  i9-13900K LGA 1700.png",
          specs: ["24 Cores", "32 Threads", " 5.80 GHz Base Clock"],
        },
        {
          id: 6,
          name: "AMD Ryzen 5 5600X",
          price: 2000000,
          brand: "AMD",
          category: "PROCESSOR AMD",
          image: "/src/img part/AMD Ryzen 5 5600X.png",
          specs: ["6 Cores", "12 Threads", "4.6 GHz Boost Clock"],
        },
        {
          id: 7,
          name: "AMD Ryzen 7 5800X",
          price: 4000000,
          brand: "AMD",
          category: "PROCESSOR AMD",
          image: "/src/img part/AMD Ryzen 7 5800X.png",
          specs: ["8 Cores", "16 Threads", "4.7 GHz Boost Clock"],
        },
        {
          id: 8,
          name: "AMD Ryzen 9 5900X",
          price: 5000000,
          brand: "AMD",
          category: "PROCESSOR AMD",
          image: "/src/img part/AMD Ryzen 9 5900X.png",
          specs: ["12 Cores", "24 Threads", "4.8 GHz Boost Clock"],
        },
        {
          id: 9,
          name: "AMD Ryzen 9 5950X",
          price: 7500000,
          brand: "AMD",
          category: "PROCESSOR AMD",
          image: "/src/img part/AMD Ryzen 9 5950X.png",
          specs: ["16 Cores", "32 Threads", "4.9 GHz Boost Clock"],
        },
        {
          id: 10,
          name: "AMD Ryzen Threadripper 3990X",
          price: 40000000,
          brand: "AMD",
          category: "PROCESSOR AMD",
          image: "/src/img part/AMD Ryzen Threadripper 3990X.png",
          specs: ["64 Cores", "128 Threads", "4.3 GHz Boost Clock"],
        },
       {
          id: 11,
          name: "ASUS ROG Strix B550-F",
          price: 3500000,
          brand: "ASUS",
          category: "MAINBOARD",
          image: "/src/img part/ASUS ROG Strix B550-F.png",
          specs: ["ATX Form Factor", "PCIe 4.0", "Wi-Fi 6"],
        },
        {
          id: 12,
          name: "MSI MPG B550 Gaming Edge",
          price: 3500000,
          brand: "MSI",
          category: "MAINBOARD",
          image: "/src/img part/MSI MPG B550 Gaming Edge.png",
          specs: ["ATX Form Factor", "PCIe 4.0", "Mystic Light RGB"],
        },
        {
          id: 13,
          name: "Gigabyte AORUS X570 Master",
          price: 7500000,
          brand: "Gigabyte",
          category: "MAINBOARD",
          image: "/src/img part/Gigabyte AORUS X570 Master.png",
          specs: ["ATX Form Factor", "PCIe 4.0", "Triple M.2 Slots"],
        },
        {
          id: 14,
          name: "ASRock B450M Steel Legend",
          price: 1500000,
          brand: "ASRock",
          category: "MAINBOARD",
          image: "/src/img part/ASRock B450M Steel Legend.png",
          specs: ["Micro-ATX Form Factor", "RGB Lighting", "Dual M.2 Slots"],
        },
        {
          id: 15,
          name: "ASUS TUF Gaming X570-Plus",
          price: 4200000,
          brand: "ASUS",
          category: "MAINBOARD",
          image: "/src/img part/ASUS TUF Gaming X570-Plus.png",
          specs: ["ATX Form Factor", "PCIe 4.0", "Military-Grade Components"],
        },
        {
          id: 16,
          name: "Corsair Vengeance LPX 16GB",
          price: 750000,
          brand: "Corsair",
          category: "MEMORY",
          image: "/src/img part/Corsair Vengeance LPX 16GB.png",
          specs: ["16GB DDR4", "3200 MHz", "CL16"],
        },
        {
          id: 17,
          name: "G.Skill Trident Z RGB 32GB",
          price: 1200000,
          brand: "G.Skill",
          category: "MEMORY",
          image: "/src/img part/G.Skill Trident Z RGB 32GB.png",
          specs: ["32GB DDR4", "3600 MHz", "RGB Lighting"],
        },
        {
          id: 18,
          name: "Kingston Fury Beast 16GB",
          price: 800000,
          brand: "Kingston",
          category: "MEMORY",
          image: "/src/img part/Kingston Fury Beast 16GB.png",
          specs: ["16GB DDR4", "2666 MHz", "Low Profile"],
        },
        {
          id: 19,
          name: "TeamGroup T-Force Delta RGB 16GB",
          price: 900000,
          brand: "TeamGroup",
          category: "MEMORY",
          image: "/src/img part/TeamGroup T-Force Delta RGB 16GB.png",
          specs: ["16GB DDR4", "3200 MHz", "RGB Lighting"],
        },
        {
          id: 20,
          name: "Crucial Ballistix 32GB",
          price: 7000000,
          brand: "Crucial",
          category: "MEMORY",
          image: "/src/img part/Crucial Ballistix 32GB.png",
          specs: ["32GB DDR4", "3600 MHz", "CL16"],
        },
        {
          id: 21,
          name: "NVIDIA GeForce RTX 3080",
          price: 7000000,
          brand: "NVIDIA",
          category: "VGA",
          image: "/src/img part/NVIDIA GeForce RTX 3080.png",
          specs: ["10GB GDDR6X", "PCIe 4.0", "Ray Tracing"],
        },
        {
          id: 22,
          name: "AMD Radeon RX 6800 XT",
          price: 5600000,
          brand: "AMD",
          category: "VGA",
          image: "/src/img part/AMD Radeon RX 6800 XT.png",
          specs: ["16GB GDDR6", "PCIe 4.0", "Ray Tracing"],
        },
        {
          id: 23,
          name: "ASUS ROG Strix GeForce RTX 3090",
          price: 25000000,
          brand: "ASUS",
          category: "VGA",
          image: "/src/img part/ASUS ROG Strix GeForce RTX 3090.png",
          specs: ["24GB GDDR6X", "PCIe 4.0", "RGB Lighting"],
        },
        {
          id: 24,
          name: "MSI Gaming Radeon RX 6700 XT",
          price: 15500000,
          brand: "MSI",
          category: "VGA",
          image: "/src/img part/MSI Gaming Radeon RX 6700 XT.png",
          specs: ["12GB GDDR6", "PCIe 4.0", "Ray Tracing"],
        },
        {
          id: 25,
          name: "Gigabyte AORUS GeForce RTX 3070",
          price: 5000000,
          brand: "Gigabyte",
          category: "VGA",
          image: "/src/img part/Gigabyte AORUS GeForce RTX 3070.png",
          specs: ["8GB GDDR6", "PCIe 4.0", "RGB Lighting"],
        },
       {
          id: 26,
          name: "Seagate Barracuda 2TB",
          price: 1000000,
          brand: "Seagate",
          category: "HDD",
          image: "/src/img part/Seagate Barracuda 2TB.png",
          specs: ["2TB", "7200 RPM", "SATA III"],
        },
        {
          id: 27,
          name: "Western Digital Blue 1TB",
          price: 40,
          brand: "Western Digital",
          category: "HDD",
          image: "/src/img part/Western Digital Blue 1TB.png",
          specs: ["1TB", "7200 RPM", "SATA III"],
        },
        {
          id: 28,
          name: "Toshiba X300 4TB",
          price: 1000000,
          brand: "Toshiba",
          category: "HDD",
          image: "/src/img part/Toshiba X300 4TB.png",
          specs: ["4TB", "7200 RPM", "SATA III"],
        },
        {
          id: 29,
          name: "Seagate IronWolf 8TB",
          price: 5000000,
          brand: "Seagate",
          category: "HDD",
          image: "/src/img part/Seagate IronWolf 8TB.png",
          specs: ["8TB", "7200 RPM", "SATA III"],
        },
        {
          id: 30,
          name: "Western Digital Black 6TB",
          price: 3000000,
          brand: "Western Digital",
          category: "HDD",
          image: "/src/img part/Western Digital Black 6TB.png",
          specs: ["6TB", "7200 RPM", "SATA III"],
        },
        {
          id: 31,
          name: "Kingston A2000 1TB SSD",
          price: 1000000,
          brand: "Kingston",
          category: "SDD",
          image: "/src/img part/Kingston A2000 1TB SSD.png",
          specs: ["1TB NVMe M.2", "2200 MB/s Read", "2000 MB/s Write"],
        },
        {
          id: 32,
          name: "Corsair MP600 2TB SSD",
          price: 2500000,
          brand: "Corsair",
          category: "SDD",
          image: "/src/img part/Corsair MP600 2TB SSD.webp",
          specs: ["2TB NVMe M.2", "4950 MB/s Read", "4250 MB/s Write"],
        },
        {
          id: 33,
          name: "Samsung 970 EVO Plus 1TB SSD",
          price: 1500000,
          brand: "Samsung",
          category: "SDD",
          image: "/src/img part/Samsung 970 EVO Plus 1TB SSD.png",
          specs: ["1TB NVMe M.2", "3500 MB/s Read", "3300 MB/s Write"],
        },
        {
          id: 34,
          name: "Crucial MX500 500GB SSD",
          price: 1500000,
          brand: "Crucial",
          category: "SDD",
          image: "/src/img part/Crucial MX500 500GB SSD.png",
          specs: ["500GB SATA III", "560 MB/s Read", "510 MB/s Write"],
        },
        {
          id: 35,
          name: "Western Digital Black SN850 1TB SSD",
          price: 4000000,
          brand: "Western Digital",
          category: "SDD",
          image: "/src/img part/Western Digital Black SN850 1TB SSD.png",
          specs: ["1TB NVMe M.2", "7000 MB/s Read", "5300 MB/s Write"],
        },
       {
          id: 36,
          name: "Thermaltake Toughpower GF1 750W PSU",
          price: 1500000,
          brand: "Thermaltake",
          category: "PSU",
          image: "/src/img part/Thermaltake Toughpower GF1 750W PSU.png",
          specs: ["750W", "80+ Gold", "Fully Modular"],
        },
        {
          id: 37,
          name: "Corsair RM850x PSU",
          price: 2500000,
          brand: "Corsair",
          category: "PSU",
          image: "/src/img part/Corsair RM850x PSU.png",
          specs: ["850W", "80+ Gold", "Fully Modular"],
        },
        {
          id: 38,
          name: "EVGA SuperNOVA 750 G5 PSU",
          price: 2000000,
          brand: "EVGA",
          category: "PSU",
          image: "/src/img part/EVGA SuperNOVA 750 G5 PSU.png",
          specs: ["750W", "80+ Gold", "Fully Modular"],
        },
        {
          id: 39,
          name: "Seasonic Focus GX-650 PSU",
          price: 1500000,
          brand: "Seasonic",
          category: "PSU",
          image: "/src/img part/Seasonic Focus GX-650 PSU.png",
          specs: ["650W", "80+ Gold", "Fully Modular"],
        },
        {
          id: 40,
          name: "Cooler Master MWE Gold 750 PSU",
          price: 1700000,
          brand: "Cooler Master",
          category: "PSU",
          image: "/src/img part/Cooler Master MWE Gold 750 PSU.png",
          specs: ["750W", "80+ Gold", "Semi Modular"],
        },
        {
          id: 41,
          name: "Cooler Master MasterBox Q300L",
          price: 60,
          brand: "Cooler Master",
          category: "CASE",
          image: "/src/img part/Cooler Master MasterBox Q300L.png",
          specs: ["Micro-ATX", "Tempered Glass", "RGB Fans"],
        },
        {
          id: 42,
          name: "NZXT H510",
          price: 700000,
          brand: "NZXT",
          category: "CASE",
          image: "/src/img part/NZXT H510.png",
          specs: ["Mid Tower", "Tempered Glass", "Cable Management"],
        },
        {
          id: 43,
          name: "Fractal Design Meshify C",
          price: 1500000,
          brand: "Fractal Design",
          category: "CASE",
          image: "/src/img part/Fractal Design Meshify C.png",
          specs: ["Mid Tower", "Mesh Front Panel", "Good Airflow"],
        },
        {
          id: 44,
          name: "Lian Li PC-O11 Dynamic",
          price: 3000000,
          brand: "Lian Li",
          category: "CASE",
          image: "/src/img part/Lian Li PC-O11 Dynamic.png",
          specs: ["Mid Tower", "Tempered Glass", "Excellent Cooling"],
        },
        {
          id: 45,
          name: "Corsair 4000D Airflow",
          price: 1500000,
          brand: "Corsair",
          category: "CASE",
          image: "/src/img part/Corsair 4000D Airflow.png",
          specs: ["Mid Tower", "High Airflow", "Cable Management"],
        },
        {
          id: 46,
          name: "LG UltraGear 27GN950-B",
          price: 10000000,
          brand: "LG",
          category: "LED MONITOR",
          image: "/src/img part/LG UltraGear 27GN950-B.avif",
          specs: ["27 inch", "4K UHD", "144Hz"],
        },
        {
          id: 47,
          name: "Samsung Odyssey G7",
          price: 11000000,
          brand: "Samsung",
          category: "LED MONITOR",
          image: "/src/img part/Samsung Odyssey G7.png",
          specs: ["27 inch", "QHD", "240Hz"],
        },
        {
          id: 48,
          name: "ASUS ROG Swift PG32UQX",
          price: 50000000,
          brand: "ASUS",
          category: "LED MONITOR",
          image: "/src/img part/ASUS ROG Swift PG32UQX.png",
          specs: ["32 inch", "4K UHD", "144Hz"],
        },
        {
          id: 49,
          name: "Dell Alienware AW2521H",
          price: 13000000,
          brand: "Dell",
          category: "LED MONITOR",
          image: "/src/img part/Dell Alienware AW2521H.png",
          specs: ["25 inch", "QHD", "360Hz"],
        },
        {
          id: 50,
          name: "Acer Predator X27",
          price: 45000000,
          brand: "Acer",
          category: "LED MONITOR",
          image: "/src/img part/Acer Predator X27.png",
          specs: ["27 inch", "4K UHD", "144Hz"],
        },
      ],
      searchQuery: "",
      selectedBrand: "",
      priceRange:60000000,
      brands: ["Intel", "AMD", "ASUS", "Corsair", "Acer", "Kingston", "Crucial", "Western Digital", "Samsung", "Dell", "LG"], // Daftar brand
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
      this.priceRange = 60000000;
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
.neon-title {
  font-size: 4rem; /* Ukuran font lebih besar */
  font-weight: bold;
  color: #f5f5f5 !important; /* Warna font baru dengan prioritas tinggi */
  text-shadow: 0 0 5px #00d4ff, 0 0 10px #00d4ff, 0 0 20px #00d4ff, 0 0 40px #00a3cc, 0 0 80px #00a3cc;
  animation: glow 1.5s infinite alternate;
}

/* Animasi glow */
@keyframes glow {
  from {
    color: #f5f5f5; /* Warna font baru */
    text-shadow: 0 0 5px #00d4ff, 0 0 10px #00d4ff, 0 0 20px #00d4ff, 0 0 40px #00a3cc, 0 0 80px #00a3cc;
  }
  to {
    color: #f5f5f5; /* Warna font baru */
    text-shadow: 0 0 10px #00d4ff, 0 0 20px #00d4ff, 0 0 40px #00a3cc, 0 0 80px #00a3cc, 0 0 120px #00a3cc;
  }
}
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
