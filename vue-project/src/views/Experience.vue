<template>
  <section class="container my-5" data-aos="fade-up">
    <h2 class="h3 mb-4 text-primary text-center futuristic-title fw-bold">
      🎮 Ultimate Game Consoles Hub 🚀
    </h2>

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
          <option v-for="brand in brands" :key="brand" :value="brand">
            {{ brand }}
          </option>
        </select>
        <input
          type="range"
          v-model="priceRangeUSD"
          min="0"
          max="1500"
          step="50"
          class="form-range"
        />
        <span>Max Price: {{ formatPrice(priceRangeUSD) }}</span>
      </div>

      <div class="console-grid">
        <div
          v-for="console in filteredConsoles"
          :key="console.id"
          class="console-card"
          @click="showDetails(console)"
        >
          <img :src="console.image" :alt="console.name" class="console-image" />
          <div class="console-info">
            <h4 class="console-name">{{ console.name }}</h4>
            <p class="console-brand">Brand: {{ console.brand }}</p>
            <p class="console-price">Price: {{ formatPrice(console.price) }}</p>
          </div>
        </div>
      </div>
    </div>

    <div v-if="selectedProduct" class="modal-overlay" @click.self="closeDetails">
      <div class="modal-content">
        <h3>{{ selectedProduct.name }}</h3>
        <img :src="selectedProduct.image" alt="Console Image" class="product-image" />
        <p><strong>Price:</strong> {{ formatPrice(selectedProduct.price) }}</p>
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
      priceRangeUSD: 1500, // Harga dalam USD
      usdToIdrRate: 15000, // Nilai tukar USD ke IDR (perkiraan)
      selectedProduct: null,
      consoles: [
        {
          id: 1,
          name: "PlayStation 5",
          price: 499,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://media.dinomarket.com/docs/imgTD/2024-02/DM_CA961EB8D9C88E81647BBFE7417EB9C0_210224140212_ll.jpg",
          specs: ["8-core AMD Zen 2", "825GB SSD", "4K Gaming"],
        },
        {
          id: 2,
          name: "Xbox Series X",
          price: 499,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2022/3/31/3452a01b-0074-481c-9f97-3ae89748f356.jpg",
          specs: ["12 TFLOPS GPU", "1TB SSD", "4K Gaming"],
        },
        {
          id: 3,
          name: "Nintendo Switch OLED",
          price: 349,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//106/MTA-29636638/no_brand_nintendo_switch_-oled_model-_white_set_full01_h7q23tmg.jpg",
          specs: ["7-inch OLED", "Portable/TV Mode", "Joy-Con Controllers"],
        },
        {
          id: 4,
          name: "Steam Deck",
          price: 399,
          brand: "Valve",
          category: "💻 Handheld PC Heroes",
          image: "https://jnewsonline.com/wp-content/uploads/2021/07/Image_from_iOS.0.jpg",
          specs: ["7-inch Touchscreen", "AMD APU", "SteamOS"],
        },
        {
          id: 5,
          name: "ROG Ally X",
          price: 799,
          brand: "ASUS",
          category: "💻 Handheld PC Heroes",
          image: "https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/106/MTA-181590765/asus_asus_rog_ally_x_rc72la_amd_ryzen_z1_extreme_24gb_1tb_7-_ips_120hz_w11_-_z1_extreme_full02_v2s6kpyo.jpg",
          specs: ["AMD Ryzen Z1 Extreme", "120Hz Display", "Windows 11"],
        },
        {
          id: 6,
          name: "PlayStation 4",
          price: 299,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGVIbBHnZlGYBuSOr5Nm099nzJEsLI23SA0DOzRT-vUw&s&ec=72940545",
          specs: ["8-core Jaguar CPU", "500GB/1TB HDD", "1080p Gaming"],
        },
        {
          id: 7,
          name: "PlayStation 4 Pro",
          price: 399,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQV_8MbIBX9_iLMgnIJMYJWqe3VEtbPlF1JOevhmfgppw&s&ec=72940545",
          specs: ["4.2 TFLOPS GPU", "1TB HDD", "4K Upscaling"],
        },
        {
          id: 8,
          name: "PlayStation 5 Digital Edition",
          price: 399,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://prof.lv/media/catalog/product/cache/bb2e4f278882af2cb0666a1a14d552d6/5/d/5d661c774e13cf7908e1d6adcb06e4af9f9f02e223aa68acb72215c17984c441.jpeg",
          specs: ["No Disc Drive", "825GB SSD", "4K Gaming"],
        },
        {
          id: 9,
          name: "PlayStation Vita",
          price: 199,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://i0.wp.com/www.gamezone.co.id/wp-content/uploads/2017/11/ps_vita_new_slim_wi-fi-1.jpg?fit=760%2C473&ssl=1",
          specs: ["5-inch OLED", "Touchscreen", "Remote Play"],
        },
        {
          id: 10,
          name: "PlayStation Portable (PSP)",
          price: 149,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//108/MTA-38389437/no_brand_sony_playstation_portable_3000_-_psp_3000_16_gb_-_psp_16gb_____________________________________________________________________________________________full01_qmq6qc3.jpg",
          specs: ["4.3-inch LCD", "UMD Drive", "Multimedia Features"],
        },
        {
          id: 11,
          name: "Xbox One X",
          price: 499,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://imageio.forbes.com/blogs-images/erikkain/files/2017/11/xbox-one-x.jpg?format=jpg&height=900&width=1600&fit=bounds",
          specs: ["6 TFLOPS GPU", "1TB HDD", "4K UHD Blu-ray"]
        },
        {
          id: 12,
          name: "Xbox One S",
          price: 299,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://images-cdn.ubuy.co.id/66aafaba562fd2552837a847-pre-owned-microsoft-xbox-one-s-1tb.jpg",
          specs: ["1TB HDD", "1080p Gaming", "4K UHD Blu-ray"]
        },
        {
          id: 13,
          name: "Xbox Series S",
          price: 299,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://i.insider.com/5fa3eee9f7d1cb0019e39edd?width=1018&format=jpeg",
          specs: ["4 TFLOPS GPU", "512GB SSD", "1440p Gaming"]
        },
        {
          id: 14,
          name: "Xbox 360",
          price: 199,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://images-cdn.ubuy.co.id/65e978f5455678301d52711a-pre-owned-microsoft-xbox-360-60gb-pro.jpg",
          specs: ["512MB RAM", "20GB HDD", "720p Gaming"]
        },
        {
          id: 15,
          name: "Xbox 360 Elite",
          price: 249,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://i5.walmartimages.com/seo/Restored-Xbox-360-Elite-500GB-Gaming-Console-Black-885370889277-Refurbished_865ddc6f-3ab0-4ecc-8a12-e5403bc46576.b8e1effe415660f2b34a36db0d4b21ec.jpeg",
          specs: ["120GB HDD", "1080p Gaming", "HDMI Output"]
        },
        {
          id: 16,
          name: "Xbox One",
          price: 249,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://images.tokopedia.net/img/cache/500-square/product-1/2018/10/1/272055672/272055672_2808661a-98bf-47c6-aa0d-da4a62d6e7b5_455_455.jpg",
          specs: ["8-core AMD CPU", "500GB HDD", "1080p Gaming"]
        },
        {
          id: 17,
          name: "Nintendo Switch Lite",
          price: 199,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://down-id.img.susercontent.com/file/id-11134207-7qul6-ljy3daam9o9ufd",
          specs: ["5.5-inch LCD", "Portable Mode", "No TV Dock"]
        },
        {
          id: 18,
          name: "Nintendo Switch Pro Controller",
          price: 69,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Switch+Pro",
          specs: ["Wireless Controller", "HD Rumble", "Motion Controls"]
        },
        {
          id: 19,
          name: "Nintendo Wii U",
          price: 299,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Wii+U",
          specs: ["Dual-screen gameplay", "Wii U GamePad", "HD Graphics"]
        },
        {
          id: 20,
          name: "Nintendo Wii U Pro Controller",
          price: 49,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Wii+U+Pro",
          specs: ["Wireless Controller", "Ergonomic Design", "HD Rumble"]
        },
        {
          id: 21,
          name: "GPD Win 3",
          price: 799,
          brand: "GPD",
          category: "💻 Handheld PC Heroes",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=GPD+Win+3",
          specs: ["Intel i5-1135G7", "8GB RAM", "512GB SSD", "5.5-inch Touchscreen"]
        },
        {
          id: 22,
          name: "GPD Win 2",
          price: 649,
          brand: "GPD",
          category: "💻 Handheld PC Heroes",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=GPD+Win+2",
          specs: ["Intel Core m3-7Y30", "8GB RAM", "128GB SSD", "6-inch Touchscreen"]
        },
        {
          id: 23,
          name: "Ayaneo Next",
          price: 899,
          brand: "Ayaneo",
          category: "💻 Handheld PC Heroes",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Ayaneo+Next",
          specs: ["AMD Ryzen 5 3500U", "16GB RAM", "512GB SSD", "7-inch Touchscreen"]
        },
        {
          id: 24,
          name: "OneXPlayer",
          price: 999,
          brand: "One-Netbook",
          category: "💻 Handheld PC Heroes",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=OneXPlayer",
          specs: ["Intel Core i7-1165G7", "16GB RAM", "1TB SSD", "8.4-inch Touchscreen"]
        },
        {
          id: 25,
          name: "GPD Win Max",
          price: 899,
          brand: "GPD",
          category: "💻 Handheld PC Heroes",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=GPD+Win+Max",
          specs: ["Intel i7-1165G7", "16GB RAM", "512GB SSD", "8-inch Touchscreen"]
        },
        {
          id: 26,
          name: "Atari 2600",
          price: 199,
          brand: "Atari",
          category: "✨ Explore More Consoles",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Atari+2600",
          specs: ["2600 Games Library", "Joystick Controllers", "Woodgrain Finish"],
        },
        {
          id: 27,
          name: "Sega Genesis",
          price: 149,
          brand: "Sega",
          category: "✨ Explore More Consoles",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Sega+Genesis",
          specs: ["16-bit Console", "Iconic Games Library", "Classic Controllers"],
        },
        {
          id: 28,
          name: "Super Nintendo Entertainment System (SNES)",
          price: 179,
          brand: "Nintendo",
          category: "✨ Explore More Consoles",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=SNES",
          specs: ["16-bit Console", "Super Mario World", "Two Controllers"],
        },
        {
          id: 29,
          name: "Neo Geo",
          price: 399,
          brand: "SNK",
          category: "✨ Explore More Consoles",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Neo+Geo",
          specs: ["AES System", "Arcade Quality", "Iconic Games Library"],
        },
        {
          id: 30,
          name: "Dreamcast",
          price: 299,brand: "Sega",
          category: "✨ Explore More Consoles",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Dreamcast",
          specs: ["128-bit System", "VGA Output", "Virtual Fighter 3"],
        },
        {
          id: 31,
          name: "Xbox Series X (Carbon Black)",
          price: 499,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Xbox+Series+X+(Black)",
          specs: ["12 TFLOPS GPU", "1TB SSD", "4K Gaming"],
        },
        {
          id: 32,
          name: "Xbox Series S (White)",
          price: 299,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Xbox+Series+S+(White)",
          specs: ["4 TFLOPS GPU", "512GB SSD", "1440p Gaming"],
        },
        {
          id: 33,
          name: "PS Vita Slim",
          price: 229,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=PS+Vita+Slim",
          specs: ["5-inch LCD", "Slim Design", "Wi-Fi + 3G Model"],
        },
        {
          id: 34,
          name: "Razer Edge 5G",
          price: 599,
          brand: "Razer",
          category: "💻 Handheld PC Heroes",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Razer+Edge+5G",
          specs: ["Snapdragon G3X", "5G Connectivity", "6.8-inch AMOLED"],
        },
        {
          id: 35,
          name: "GPD Pocket 2",
          price: 699,
          brand: "GPD",
          category: "💻 Handheld PC Heroes",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=GPD+Pocket+2",
          specs: ["Intel Atom x7", "8GB RAM", "128GB SSD", "7-inch Display"],
        },
        {
          id: 36,
          name: "Alienware Concept UFO",
          price: 899,
          brand: "Alienware",
          category: "💻 Handheld PC Heroes",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Alienware+UFO",
          specs: ["Intel Core i7", "16GB RAM", "512GB SSD", "8-inch Display"],
        },
         {
          id: 37,
          name: "Ayn Odin Base",
          price: 199,
          brand: "Ayn",
          category: "💻 Handheld PC Heroes",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Ayn+Odin+Base",
          specs: ["Snapdragon 845", "4GB RAM", "32GB Storage", "5.98-inch Display"],
        },
        {
          id: 38,
          name: "Ayn Odin Pro",
          price: 299,
          brand: "Ayn",
          category: "💻 Handheld PC Heroes",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Ayn+Odin+Pro",
          specs: ["Snapdragon 865", "8GB RAM", "128GB Storage", "6-inch Display"],
        },
        {
          id: 39,
          name: "Atari Jaguar",
          price: 199,
          brand: "Atari",
          category: "✨ Explore More Consoles",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Atari+Jaguar",
          specs: ["64-bit Console", "Alien vs. Predator", "Jaguar Controller"],
        },
        {
          id: 40,
          name: "ColecoVision",
          price: 129,
          brand: "Coleco",
          category: "✨ Explore More Consoles",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=ColecoVision",
          specs: ["8-bit Console", "Classic Games", "Expansion Modules"],
        },
        {
          id: 41,
          name: "Neo Geo CD",
          price: 399,
          brand: "SNK",
          category: "✨ Explore More Consoles",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Neo+Geo+CD",
          specs: ["CD-based Games", "128-bit Graphics", "Dual Joysticks"],
        },
        {
          id: 42,
          name: "Sega Saturn",
          price: 249,
          brand: "Sega",
          category: "✨ Explore More Consoles",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Sega+Saturn",
          specs: ["32-bit Console", "2D/3D Capabilities", "Iconic Games"],
        },
        {
          id: 43,
          name: "PlayStation Classic",
          price: 99,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=PS+Classic",
          specs: ["20 Pre-installed Games", "Mini Design", "HDMI Output"],
        },
        {
          id: 44,
          name: "Game Boy Advance",
          price: 129,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Game+Boy+Advance",
          specs: ["2.9-inch Display", "Backlit Screen", "Link Cable Support"],
        },
        {
          id: 45,
          name: "Game Boy Color",
          price: 89,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Game+Boy+Color",
          specs: ["Color Screen", "Backward Compatibility", "Link Cable Support"],
        },
        {
          id: 46,
          name: "PlayStation TV",
          price: 99,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=PS+TV",
          specs: ["PlayStation Vita Games", "Remote Play", "HDMI Output"],
        },
        {
          id: 47,
          name: "Super Nintendo Entertainment System Classic",
          price: 79,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=SNES+Classic",
          specs: ["21 Pre-installed Games", "Mini Design", "HDMI Output"],
        },
        {
          id: 48,
          name: "Sega Genesis Mini",
          price: 79,
          brand: "Sega",
          category: "✨ Explore More Consoles",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Genesis+Mini",
          specs: ["42 Pre-installed Games", "Mini Design", "HDMI Output"],
        },
        {
          id: 49,
          name: "Nintendo 64",
          price: 249,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=N64",
          specs: ["64-bit System", "4 Controller Ports", "Iconic Games"],
        },
        {
          id: 50,
          name: "Nintendo 64 Controller",
          price: 49,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=N64+Controller",
          specs: ["Analog Stick", "Z Button", "Iconic Design"],
        },
         {
          id: 51,
          name: "GPD Win 4",
          price: 899,
          brand: "GPD",
          category: "💻 Handheld PC Heroes",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=GPD+Win+4",
          specs: ["AMD Ryzen 7 6800U", "16GB RAM", "512GB SSD", "6-inch Touchscreen"],
        },
        {
          id: 52,
          name: "OneXPlayer Mini Pro",
          price: 899,
          brand: "One-Netbook",
          category: "💻 Handheld PC Heroes",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=OneXPlayer+Mini+Pro",
          specs: ["Intel Core i7", "16GB RAM", "512GB SSD", "7-inch Display"],
        },
        {
          id: 53,
          name: "Ayn Odin Base 2",
          price: 249,
          brand: "Ayn",
          category: "💻 Handheld PC Heroes",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=Ayn+Odin+Base+2",
          specs: ["Snapdragon 865", "6GB RAM", "64GB Storage", "5.98-inch Display"],
        },
        {
          id: 54,
          name: "RetroFlag GPI Case",
          price: 99,
          brand: "RetroFlag",
          category: "✨ Explore More Consoles",
          image: "https://via.placeholder.com/150/00d4ff/ffffff?text=RetroFlag+GPI+Case",
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
          console.price <= this.priceRangeUSD
        );
      });
    },
    priceRangeIDR() {
      return this.priceRangeUSD * this.usdToIdrRate;
    },
  },
  methods: {
    selectCategory(card) {
      this.selectedCategory = card;
      this.searchQuery = "";
      this.selectedBrand = "";
      this.priceRangeUSD = 1500;
    },
    showDetails(console) {
      this.selectedProduct = console;
    },
    closeDetails() {
      this.selectedProduct = null;
    },
    formatPrice(priceUSD) {
      const priceIDR = priceUSD * this.usdToIdrRate;
      return new Intl.NumberFormat("id-ID", {
        style: "currency",
        currency: "IDR",
        minimumFractionDigits: 0,
        maximumFractionDigits: 0,
      }).format(priceIDR);
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

/* Grid Konsol */
.console-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-top: 1rem;
}

.console-card {
  background: #1b263b;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  cursor: pointer;
}

.console-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 6px 18px rgba(0, 212, 255, 0.5);
}

.console-image {
  width: 100%;
  height: 150px;
  object-fit: cover;
}

.console-info {
  padding: 1rem;
}

.console-name {
  margin-bottom: 0.5rem;
  color: #00d4ff;
}

.console-brand {
  font-size: 0.9em;
  color: #aaa;
  margin-bottom: 0.3rem;
}

.console-price {
  font-weight: bold;
  color: #fff;
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
  animation: fadeIn 0.3s ease-out forwards;
}

.modal-content {
  background: #0d1b2a;
  color: #00d4ff;
  padding: 2rem;
  border-radius: 10px;
  max-width: 500px;
  width: 90%;
  text-width: 90%;
  text-align: center;
  border: 1px solid #00d4ff;
  animation: slideIn 0.3s ease-out forwards;
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

/* Animasi */
@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

@keyframes slideIn {
  from {
    transform: translateY(20px);
  }
  to {
    transform: translateY(0);
  }
}

/* Futuristic Title */
.futuristic-title {
  text-transform: uppercase;
  letter-spacing: 0.1em;
  text-shadow: 0 0 0.5em #00d4ff;
}
</style>
