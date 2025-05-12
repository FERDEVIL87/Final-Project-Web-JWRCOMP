<template>
  <section class="container my-5" data-aos="fade-up">
    <h2 class="h3 mb-4 text-primary text-center futuristic-title fw-bold">
  🎮 Ultimate Game Consoles Hub 🚀
</h2>


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
          placeholder="Search console..."
          class="form-control"
        />
        <select v-model="selectedBrand" class="form-control">
          <option value="">All Brands</option>
          <option v-for="brand in brands" :key="brand" :value="brand">{{ brand }}</option>
        </select>
        <input
          type="range"
          v-model="priceRange"
          min="0"
          max="1500"
          step="50"
          class="form-range"
        />
        <span>Max Price: ${{ priceRange }}</span>
      </div>

      <!-- List Konsol -->
      <ul class="component-list">
        <li
          v-for="console in filteredConsoles"
          :key="console.id"
          class="component-item"
          @click="showDetails(console)"
        >
          {{ console.name }} - ${{ console.price }} ({{ console.brand }})
        </li>
      </ul>
    </div>

    <!-- Modal Detail -->
    <div v-if="selectedProduct" class="modal-overlay" @click.self="closeDetails">
      <div class="modal-content">
        <h3>{{ selectedProduct.name }}</h3>
        <img :src="selectedProduct.image" alt="Console Image" class="product-image" />
        <p><strong>Price:</strong> ${{ selectedProduct.price }}</p>
        <p><strong>Brand:</strong> {{ selectedProduct.brand }}</p>
        <p><strong>Features:</strong></p>
        <ul>
          <li v-for="(feature, index) in selectedProduct.specs" :key="index">
            {{ feature }}
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
      { title: "🎮 PlayStation Powerhouse", link: "#" },
      { title: "🟩 Xbox Universe", link: "#" },
      { title: "🍄 Nintendo Magic", link: "#" },
      { title: "💻 Handheld PC Heroes", link: "#" },
      { title: "✨ Explore More Consoles", link: "#" },
    ],

    selectedCategory: null,
    searchQuery: "",
    selectedBrand: "",
    priceRange: 1500,
    selectedProduct: null,
    consoles: [
      {
        id: 1,
        name: "PlayStation 5",
        price: 499,
        brand: "Sony",
        category: "🎮 PlayStation Powerhouse",
        image: "https://via.placeholder.com/150",
        specs: ["8-core AMD Zen 2", "825GB SSD", "4K Gaming"],
      },
      {
        id: 2,
        name: "Xbox Series X",
        price: 499,
        brand: "Microsoft",
        category: "🟩 Xbox Universe",
        image: "https://via.placeholder.com/150",
        specs: ["12 TFLOPS GPU", "1TB SSD", "4K Gaming"],
      },
      {
        id: 3,
        name: "Nintendo Switch OLED",
        price: 349,
        brand: "Nintendo",
        category: "🍄 Nintendo Magic",
        image: "https://via.placeholder.com/150",
        specs: ["7-inch OLED", "Portable/TV Mode", "Joy-Con Controllers"],
      },
      {
        id: 4,
        name: "Steam Deck",
        price: 399,
        brand: "Valve",
        category: "💻 Handheld PC Heroes",
        image: "https://via.placeholder.com/150",
        specs: ["7-inch Touchscreen", "AMD APU", "SteamOS"],
      },
      {
        id: 5,
        name: "ROG Ally X",
        price: 799,
        brand: "ASUS",
        category: "💻 Handheld PC Heroes",
        image: "https://via.placeholder.com/150",
        specs: ["AMD Ryzen Z1 Extreme", "120Hz Display", "Windows 11"],
      },
      {
        id: 6,
        name: "PlayStation 4",
        price: 299,
        brand: "Sony",
        category: "🎮 PlayStation Powerhouse",
        image: "https://via.placeholder.com/150",
        specs: ["8-core Jaguar CPU", "500GB/1TB HDD", "1080p Gaming"],
      },
      {
        id: 7,
        name: "PlayStation 4 Pro",
        price: 399,
        brand: "Sony",
        category: "🎮 PlayStation Powerhouse",
        image: "https://via.placeholder.com/150",
        specs: ["4.2 TFLOPS GPU", "1TB HDD", "4K Upscaling"],
      },
      {
        id: 8,
        name: "PlayStation 5 Digital Edition",
        price: 399,
        brand: "Sony",
        category: "🎮 PlayStation Powerhouse",
        image: "https://via.placeholder.com/150",
        specs: ["No Disc Drive", "825GB SSD", "4K Gaming"],
      },
      {
        id: 9,
        name: "PlayStation Vita",
        price: 199,
        brand: "Sony",
        category: "🎮 PlayStation Powerhouse",
        image: "https://via.placeholder.com/150",
        specs: ["5-inch OLED", "Touchscreen", "Remote Play"],
      },
      {
        id: 10,
        name: "PlayStation Portable (PSP)",
        price: 149,
        brand: "Sony",
        category: "🎮 PlayStation Powerhouse",
        image: "https://via.placeholder.com/150",
        specs: ["4.3-inch LCD", "UMD Drive", "Multimedia Features"],
      },
      {
        id: 11,
        name: "Xbox One X",
        price: 499,
        brand: "Microsoft",
        category: "🟩 Xbox Universe",
        image: "https://via.placeholder.com/150",
        specs: ["6 TFLOPS GPU", "1TB HDD", "4K UHD Blu-ray"]
      },
      {
        id: 12,
        name: "Xbox One S",
        price: 299,
        brand: "Microsoft",
        category: "🟩 Xbox Universe",
        image: "https://via.placeholder.com/150",
        specs: ["1TB HDD", "1080p Gaming", "4K UHD Blu-ray"]
      },
      {
        id: 13,
        name: "Xbox Series S",
        price: 299,
        brand: "Microsoft",
        category: "🟩 Xbox Universe",
        image: "https://via.placeholder.com/150",
        specs: ["4 TFLOPS GPU", "512GB SSD", "1440p Gaming"]
      },
      {
        id: 14,
        name: "Xbox 360",
        price: 199,
        brand: "Microsoft",
        category: "🟩 Xbox Universe",
        image: "https://via.placeholder.com/150",
        specs: ["512MB RAM", "20GB HDD", "720p Gaming"]
      },
      {
        id: 15,
        name: "Xbox 360 Elite",
        price: 249,
        brand: "Microsoft",
        category: "🟩 Xbox Universe",
        image: "https://via.placeholder.com/150",
        specs: ["120GB HDD", "1080p Gaming", "HDMI Output"]
      },
      {
        id: 16,
        name: "Xbox One",
        price: 249,
        brand: "Microsoft",
        category: "🟩 Xbox Universe",
        image: "https://via.placeholder.com/150",
        specs: ["8-core AMD CPU", "500GB HDD", "1080p Gaming"]
      },
      {
        id: 17,
        name: "Nintendo Switch Lite",
        price: 199,
        brand: "Nintendo",
        category: "🍄 Nintendo Magic",
        image: "https://via.placeholder.com/150",
        specs: ["5.5-inch LCD", "Portable Mode", "No TV Dock"]
      },
      {
        id: 18,
        name: "Nintendo Switch Pro Controller",
        price: 69,
        brand: "Nintendo",
        category: "🍄 Nintendo Magic",
        image: "https://via.placeholder.com/150",
        specs: ["Wireless Controller", "HD Rumble", "Motion Controls"]
      },
      {
        id: 19,
        name: "Nintendo Wii U",
        price: 299,
        brand: "Nintendo",
        category: "🍄 Nintendo Magic",
        image: "https://via.placeholder.com/150",
        specs: ["Dual-screen gameplay", "Wii U GamePad", "HD Graphics"]
      },
      {
        id: 20,
        name: "Nintendo Wii U Pro Controller",
        price: 49,
        brand: "Nintendo",
        category: "🍄 Nintendo Magic",
        image: "https://via.placeholder.com/150",
        specs: ["Wireless Controller", "Ergonomic Design", "HD Rumble"]
      },
      {
        id: 21,
        name: "GPD Win 3",
        price: 799,
        brand: "GPD",
        category: "💻 Handheld PC Heroes",
        image: "https://via.placeholder.com/150",
        specs: ["Intel i5-1135G7", "8GB RAM", "512GB SSD", "5.5-inch Touchscreen"]
      },
      {
        id: 22,
        name: "GPD Win 2",
        price: 649,
        brand: "GPD",
        category: "💻 Handheld PC Heroes",
        image: "https://via.placeholder.com/150",
        specs: ["Intel Core m3-7Y30", "8GB RAM", "128GB SSD", "6-inch Touchscreen"]
      },
      {
        id: 23,
        name: "Ayaneo Next",
        price: 899,
        brand: "Ayaneo",
        category: "💻 Handheld PC Heroes",
        image: "https://via.placeholder.com/150",
        specs: ["AMD Ryzen 5 3500U", "16GB RAM", "512GB SSD", "7-inch Touchscreen"]
      },
      {
        id: 24,
        name: "OneXPlayer",
        price: 999,
        brand: "One-Netbook",
        category: "💻 Handheld PC Heroes",
        image: "https://via.placeholder.com/150",
        specs: ["Intel Core i7-1165G7", "16GB RAM", "1TB SSD", "8.4-inch Touchscreen"]
      },
      {
        id: 25,
        name: "GPD Win Max",
        price: 899,
        brand: "GPD",
        category: "💻 Handheld PC Heroes",
        image: "https://via.placeholder.com/150",
        specs: ["Intel i7-1165G7", "16GB RAM", "512GB SSD", "8-inch Touchscreen"]
      },
      {
        id: 26,
        name: "Atari 2600",
        price: 199,
        brand: "Atari",
        category: "✨ Explore More Consoles",
        image: "https://via.placeholder.com/150",
        specs: ["2600 Games Library", "Joystick Controllers", "Woodgrain Finish"],
      },
      {
        id: 27,
        name: "Sega Genesis",
        price: 149,
        brand: "Sega",
        category: "✨ Explore More Consoles",
        image: "https://via.placeholder.com/150",
        specs: ["16-bit Console", "Iconic Games Library", "Classic Controllers"],
      },
      {
        id: 28,
        name: "Super Nintendo Entertainment System (SNES)",
        price: 179,
        brand: "Nintendo",
        category: "✨ Explore More Consoles",
        image: "https://via.placeholder.com/150",
        specs: ["16-bit Console", "Super Mario World", "Two Controllers"],
      },
            {
        id: 29,
        name: "Neo Geo",
        price: 399,
        brand: "SNK",
        category: "✨ Explore More Consoles",
        image: "https://via.placeholder.com/150",
        specs: ["AES System", "Arcade Quality", "Iconic Games Library"],
      },
      {
        id: 30,
        name: "Dreamcast",
        price: 299,
        brand: "Sega",
        category: "✨ Explore More Consoles",
        image: "https://via.placeholder.com/150",
        specs: ["128-bit System", "VGA Output", "Virtual Fighter 3"],
      },
      {
        id: 31,
        name: "Xbox Series X (Carbon Black)",
        price: 499,
        brand: "Microsoft",
        category: "🟩 Xbox Universe",
        image: "https://via.placeholder.com/150",
        specs: ["12 TFLOPS GPU", "1TB SSD", "4K Gaming"],
      },
      {
        id: 32,
        name: "Xbox Series S (White)",
        price: 299,
        brand: "Microsoft",
        category: "🟩 Xbox Universe",
        image: "https://via.placeholder.com/150",
        specs: ["4 TFLOPS GPU", "512GB SSD", "1440p Gaming"],
      },
      {
        id: 33,
        name: "PS Vita Slim",
        price: 229,
        brand: "Sony",
        category: "🎮 PlayStation Powerhouse",
        image: "https://via.placeholder.com/150",
        specs: ["5-inch LCD", "Slim Design", "Wi-Fi + 3G Model"],
      },
      {
        id: 34,
        name: "Razer Edge 5G",
        price: 599,
        brand: "Razer",
        category: "💻 Handheld PC Heroes",
        image: "https://via.placeholder.com/150",
        specs: ["Snapdragon G3X", "5G Connectivity", "6.8-inch AMOLED"],
      },
      {
        id: 35,
        name: "GPD Pocket 2",
        price: 699,
        brand: "GPD",
        category: "💻 Handheld PC Heroes",
        image: "https://via.placeholder.com/150",
        specs: ["Intel Atom x7", "8GB RAM", "128GB SSD", "7-inch Display"],
      },
      {
        id: 36,
        name: "Alienware Concept UFO",
        price: 899,
        brand: "Alienware",
        category: "💻 Handheld PC Heroes",
        image: "https://via.placeholder.com/150",
        specs: ["Intel Core i7", "16GB RAM", "512GB SSD", "8-inch Display"],
      },
      {
        id: 37,
        name: "Ayn Odin Base",
        price: 199,
        brand: "Ayn",
        category: "💻 Handheld PC Heroes",
        image: "https://via.placeholder.com/150",
        specs: ["Snapdragon 845", "4GB RAM", "32GB Storage", "5.98-inch Display"],
      },
      {
        id: 38,
        name: "Ayn Odin Pro",
        price: 299,
        brand: "Ayn",
        category: "💻 Handheld PC Heroes",
        image: "https://via.placeholder.com/150",
        specs: ["Snapdragon 865", "8GB RAM", "128GB Storage", "6-inch Display"],
      },
      {
        id: 39,
        name: "Atari Jaguar",
        price: 199,
        brand: "Atari",
        category: "✨ Explore More Consoles",
        image: "https://via.placeholder.com/150",
        specs: ["64-bit Console", "Alien vs. Predator", "Jaguar Controller"],
      },
      {
        id: 40,
        name: "ColecoVision",
        price: 129,
        brand: "Coleco",
        category: "✨ Explore More Consoles",
        image: "https://via.placeholder.com/150",
        specs: ["8-bit Console", "Classic Games", "Expansion Modules"],
      },
      {
        id: 41,
        name: "Neo Geo CD",
        price: 399,
        brand: "SNK",
        category: "✨ Explore More Consoles",
        image: "https://via.placeholder.com/150",
        specs: ["CD-based Games", "128-bit Graphics", "Dual Joysticks"],
      },
      {
        id: 42,
        name: "Sega Saturn",
        price: 249,
        brand: "Sega",
        category: "✨ Explore More Consoles",
        image: "https://via.placeholder.com/150",
        specs: ["32-bit Console", "2D/3D Capabilities", "Iconic Games"],
      },
      {
        id: 43,
        name: "PlayStation Classic",
        price: 99,
        brand: "Sony",
        category: "🎮 PlayStation Powerhouse",
        image: "https://via.placeholder.com/150",
        specs: ["20 Pre-installed Games", "Mini Design", "HDMI Output"],
      },
      {
        id: 44,
        name: "Game Boy Advance",
        price: 129,
        brand: "Nintendo",
        category: "🍄 Nintendo Magic",
        image: "https://via.placeholder.com/150",
        specs: ["2.9-inch Display", "Backlit Screen", "Link Cable Support"],
      },
      {
        id: 45,
        name: "Game Boy Color",
        price: 89,
        brand: "Nintendo",
        category: "🍄 Nintendo Magic",
        image: "https://via.placeholder.com/150",
        specs: ["Color Screen", "Backward Compatibility", "Link Cable Support"],
      },
      {
        id: 46,
        name: "PlayStation TV",
        price: 99,
        brand: "Sony",
        category: "🎮 PlayStation Powerhouse",
        image: "https://via.placeholder.com/150",
        specs: ["PlayStation Vita Games", "Remote Play", "HDMI Output"],
      },
      {
        id: 47,
        name: "Super Nintendo Entertainment System Classic",
        price: 79,
        brand: "Nintendo",
        category: "🍄 Nintendo Magic",
        image: "https://via.placeholder.com/150",
        specs: ["21 Pre-installed Games", "Mini Design", "HDMI Output"],
      },
      {
        id: 48,
        name: "Sega Genesis Mini",
        price: 79,
        brand: "Sega",
        category: "✨ Explore More Consoles",
        image: "https://via.placeholder.com/150",
        specs: ["42 Pre-installed Games", "Mini Design", "HDMI Output"],
      },
      {
        id: 49,
        name: "Nintendo 64",
        price: 249,
        brand: "Nintendo",
        category: "🍄 Nintendo Magic",
        image: "https://via.placeholder.com/150",
        specs: ["64-bit System", "4 Controller Ports", "Iconic Games"],
      },
      {
        id: 50,
        name: "Nintendo 64 Controller",
        price: 49,
        brand: "Nintendo",
        category: "🍄 Nintendo Magic",
        image: "https://via.placeholder.com/150",
        specs: ["Analog Stick", "Z Button", "Iconic Design"],
      },
      {
        id: 51,
        name: "GPD Win 4",
        price: 899,
        brand: "GPD",
        category: "💻 Handheld PC Heroes",
        image: "https://via.placeholder.com/150",
        specs: ["AMD Ryzen 7 6800U", "16GB RAM", "512GB SSD", "6-inch Touchscreen"],
      },
      {
        id: 52,
        name: "OneXPlayer Mini Pro",
        price: 899,
        brand: "One-Netbook",
        category: "💻 Handheld PC Heroes",
        image: "https://via.placeholder.com/150",
        specs: ["Intel Core i7", "16GB RAM", "512GB SSD", "7-inch Display"],
      },
      {
        id: 53,
        name: "Ayn Odin Base 2",
        price: 249,
        brand: "Ayn",
        category: "💻 Handheld PC Heroes",
        image: "https://via.placeholder.com/150",
        specs: ["Snapdragon 865", "6GB RAM", "64GB Storage", "5.98-inch Display"],
      },
      {
        id: 54,
        name: "RetroFlag GPI Case",
        price: 99,
        brand: "RetroFlag",
        category: "✨ Explore More Consoles",
        image: "https://via.placeholder.com/150",
        specs: ["Retro Design", "Raspberry Pi Compatible", "Portable Gaming"],
      },
    ],
  };
},
  computed: {
    brands() {
      const allBrands = this.consoles.map((c) => c.brand);
      return [...new Set(allBrands)];
    },
    filteredConsoles() {
      return this.consoles.filter((console) => {
        return (
          console.category === this.selectedCategory.title &&
          console.name.toLowerCase().includes(this.searchQuery.toLowerCase()) &&
          (this.selectedBrand === "" || console.brand === this.selectedBrand) &&
          console.price <= this.priceRange
        );
      });
    },
  },
  methods: {
    selectCategory(card) {
      this.selectedCategory = card;
      this.searchQuery = "";
      this.selectedBrand = "";
      this.priceRange = 1500;
    },
    showDetails(console) {
      this.selectedProduct = console;
    },
    closeDetails() {
      this.selectedProduct = null;
    },
  },
};
</script>

<style scoped>
body {
  background-color: #000 !important;
  color: #00d4ff;
}

/* Grid Kategori */
.category-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 1rem;
  margin-bottom: 2rem;
}

.category-button {
  padding: 1rem;
  background: linear-gradient(145deg, #0d1b2a, #1b263b);
  color: #00d4ff;
  border: 1px solid #1b263b;
  border-radius: 10px;
  cursor: pointer;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.category-button:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 212, 255, 0.5);
}

/* Filter */
.filters {
  margin-top: 2rem;
  background: #0d1b2a;
  padding: 1rem;
  border-radius: 10px;
  border: 1px solid #1b263b;
  color: #00d4ff;
}

.filter-controls {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  margin-bottom: 1rem;
}

.form-control,
.form-range {
  flex: 1;
  min-width: 150px;
  background: #1b263b;
  color: #00d4ff;
  border: 1px solid #00d4ff;
  border-radius: 5px;
  padding: 0.5rem;
}

.form-control::placeholder {
  color: #00d4ff;
}

/* Komponen */
.component-list li {
  border: 1px solid #00bfff; /* warna border tetap */
  padding: 10px;
  margin-bottom: 10px;
  background-color: #1e1e2f;
  color: #fff;
  cursor: pointer;
  border-radius: 0; /* ubah dari misal 8px jadi 0 */
}


.component-item {
  padding: 0.5rem;
  background: #1b263b;
  color: #00d4ff;
  margin-bottom: 0.5rem;
  border-radius: 5px;
  border: 1px solid #00d4ff;
  cursor: pointer;
  transition: background 0.3s ease, box-shadow 0.3s ease;
}

.component-item:hover {
  background: #0d1b2a;
  box-shadow: 0 5px 15px rgba(0, 212, 255, 0.5);
}

/* Modal */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.9);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background: #0d1b2a;
  color: #00d4ff;
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
  border: 1px solid #00d4ff;
  border-radius: 5px;
}

.close-button {
  background: #00d4ff;
  color: #0d1b2a;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 5px;
  cursor: pointer;
  margin-top: 1rem;
  transition: background 0.3s ease, transform 0.3s ease;
}

.close-button:hover {
  background: #00a3cc;
  transform: scale(1.1);
}
</style>
