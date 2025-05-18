<template>
  <section class="container py-5">
  <h2
      class="text-center fw-bold mb-4"
      style="font-family: 'Orbitron', sans-serif; text-shadow: 0 0 8px #00eaff, 0 0 18px #00eaff; color: #fff;"
    >
      🎮 ULTIMATE GAME CONSOLES HUB 🚀
    </h2>
    <!-- Kategori -->
    <div class="d-flex flex-wrap justify-content-center gap-3 mb-4">
      <button
        v-for="(card, index) in cards"
        :key="index"
        class="btn btn-outline-info px-4 py-2 fw-bold"
        :class="{ active: selectedCategory && selectedCategory.title === card.title, 'bg-info text-dark border-info': selectedCategory && selectedCategory.title === card.title }"
        style="font-family: 'Orbitron', sans-serif; letter-spacing: 0.04em;"
        @click="selectCategory(card)"
      >
        {{ card.title }}
      </button>
    </div>

    <div v-if="selectedCategory" class="bg-dark bg-opacity-75 rounded-4 shadow p-4 mb-4">
      <h3
        class="text-center fw-bold mb-3"
        :style="{
          fontFamily: '\'Orbitron\', sans-serif',
          textShadow: '0 0 8px #00eaff',
          color: '#fff'
        }"
      >
        {{ selectedCategory.title }}
      </h3>
      <div class="row g-3 align-items-center mb-3">
        <div class="col-12 col-md-6">
          <input
            type="text"
            v-model ="searchQuery"
            placeholder="Search console..."
            class="form-control bg-secondary bg-opacity-25 text-light border-info"
          />
        </div>
        <div class="col-12 col-md-6">
          <select v-model="selectedBrand" class="form-select bg-secondary bg-opacity-25 text-light border-info" style="color: #111;">
            <option value="" style="color: #111;">All Brands</option>
            <option v-for="brand in brands" :key="brand" :value="brand" style="color: #111;">{{ brand }}</option>
          </select>
        </div>
      </div>

      <!-- New Price Range Filter -->
      <div class="mb-4">
        <label class="form-label text-light fw-bold d-block mb-2 fs-5">Rentang Harga</label>
        <div class="mb-2">
          <div class="d-flex align-items-center">
            <span class="me-3 text-light" style="min-width: 140px; text-align: left; font-variant-numeric: tabular-nums;">{{ formatPrice(minPriceIDR) }}</span>
            <input
              type="range"
              v-model.number="minPriceIDR"
              :min="minSliderBoundIDR"
              :max="maxSliderBoundIDR"
              :step="priceStepIDR"
              class="form-range"
              style="accent-color: #00d9ff;"
              id="minPriceRange"
            />
          </div>
        </div>
        <div class="mb-2">
          <div class="d-flex align-items-center">
            <span class="me-3 text-light" style="min-width: 140px; text-align: left; font-variant-numeric: tabular-nums;">{{ formatPrice(maxPriceIDR) }}</span>
            <input
              type="range"
              v-model.number="maxPriceIDR"
              :min="minSliderBoundIDR"
              :max="maxSliderBoundIDR"
              :step="priceStepIDR"
              class="form-range"
              style="accent-color: #00d9ff;"
              id="maxPriceRange"
            />
          </div>
        </div>
        <div class="d-flex justify-content-between text-light mt-1 px-1">
          <span class="small">Min: {{ formatPrice(minPriceIDR) }}</span>
          <span class="small">Max: {{ formatPrice(maxPriceIDR) }}</span>
        </div>
      </div>


      <div v-if="filteredConsoles.length > 0" class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4 mt-2">
        <div
          v-for="consoleItem in filteredConsoles"
          :key="consoleItem.id"
          class="col"
        >
          <div
            class="card h-100 bg-secondary bg-opacity-75 border-info shadow-sm text-light cursor-pointer"
            @click="showDetails(consoleItem)"
            tabindex="0"
            style="transition: transform 0.18s, box-shadow 0.18s; cursor: pointer;"
            @mouseover="hover = consoleItem.id"
            @mouseleave="hover = null"
            :style="hover === consoleItem.id ? 'transform: translateY(-4px) scale(1.03); box-shadow: 0 6px 24px #00eaff88; border-color: #00eaff;' : ''"
          >
            <img :src="consoleItem.image" :alt="consoleItem.name" class="card-img-top" style="height: 140px; object-fit: cover; background: #101829;" />
            <div class="card-body">
              <h4
                class="card-title fw-bold mb-1"
                :style="{
                  fontFamily: '\'Orbitron\', sans-serif',
                  textShadow: '0 0 6px #00eaff, 0 0 12px #00eaff',
                  color: '#fff'
                }"
              >{{ consoleItem.name }}</h4>
              <p class="mb-1"><span class="fw-semibold">Brand:</span> {{ consoleItem.brand }}</p>
              <p class="mb-1">
                <span class="fw-semibold">Stock:</span>
                <span :class="getStockClass(consoleItem.stock)">
                  {{ consoleItem.stock }}
                </span>
              </p>
              <p class="fw-bold mb-0">{{ formatPrice(consoleItem.price * usdToIdrRate) }}</p>
            </div>
          </div>
        </div>
      </div>
      <div v-else class="text-center text-info py-5" style="font-family: 'Orbitron', sans-serif;">
        <p>No consoles match your current filters.</p>
      </div>
    </div>
    <div v-else class="text-center text-info py-5" style="font-family: 'Orbitron', sans-serif;">
      <p>✨ Please select a category above to explore our awesome consoles! ✨</p>
    </div>

    <!-- MODAL Bootstrap Dikelola oleh JS -->
    <div class="modal fade" id="consoleDetailModal" tabindex="-1" aria-labelledby="consoleDetailModalLabel" aria-hidden="true" ref="consoleModalRef">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content bg-dark text-light position-relative">
          <div class="modal-header border-0 pb-0">
            <h3
              class="modal-title w-100 text-center fw-bold"
              id="consoleDetailModalLabel"
              style="font-family: 'Orbitron', sans-serif; text-shadow: 0 0 8px #00eaff; color: #fff;"
            >
              {{ selectedProduct?.name }}
            </h3>
            <button type="button" class="btn-close btn-close-white" aria-label="Close" @click="closeDetails"></button>
          </div>
          <div class="modal-body">
            <img :src="selectedProduct?.image" :alt="selectedProduct?.name" class="d-block mx-auto mb-3 rounded" style="max-width: 280px; max-height: 180px; object-fit: contain; background: #101829;" />
            <div class="mb-3">
              <p class="mb-1"><strong>Price:</strong> <span>{{ formatPrice(selectedProduct?.price ? selectedProduct.price * usdToIdrRate : 0) }}</span></p>
              <p class="mb-1"><strong>Brand:</strong> <span>{{ selectedProduct?.brand }}</span></p>
              <p class="mb-1"><strong>Stock:</strong> <span :class="getStockClass(selectedProduct?.stock)">{{ selectedProduct?.stock }}</span></p>
            </div>
            <div v-if="selectedProduct?.specs && selectedProduct?.specs.length > 0">
              <p class="fw-bold text-info mb-1">Features:</p>
              <ul class="ps-3 mb-0">
                <li v-for="(feature, index) in selectedProduct.specs" :key="index">{{ feature }}</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
import { Modal } from 'bootstrap';

export default {
  name: "GameConsolesHub",
  data() {
    return {
      cards: [
        { title: "🎮 PlayStation Powerhouse" },
        { title: "🟩 Xbox Universe" },
        { title: "🍄 Nintendo Magic" },
        { title: "💻 Handheld PC Heroes" },
        { title: "✨ Explore More Consoles" },
      ],
      selectedCategory: null,
      searchQuery: "",
      selectedBrand: "",
      usdToIdrRate: 15000,
      minPriceIDR: 0,          // Updated to match error image
      maxPriceIDR: 12200000,    // Updated to match error image
      defaultMinPriceIDR: 0,    // Updated to match error image
      defaultMaxPriceIDR: 12200000, // Updated to match error image
      priceStepIDR: 100000,

      selectedProduct: null,
      bootstrapModalInstance: null,
      hover: null,
      consoles: [
        // ... (data konsol Anda yang panjang ada di sini) ...
        {
          id: 1,
          name: "PlayStation 5",
          price: 499, // Price in USD
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://media.dinomarket.com/docs/imgTD/2024-02/DM_CA961EB8D9C88E81647BBFE7417EB9C0_210224140212_ll.jpg",
          specs: ["8-core AMD Zen 2", "825GB SSD", "4K Gaming"],
          stock: "Ready",
        },
        {
          id: 2,
          name: "Xbox Series X",
          price: 499,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2022/3/31/3452a01b-0074-481c-9f97-3ae89748f356.jpg",
          specs: ["12 TFLOPS GPU", "1TB SSD", "4K Gaming"],
          stock: "Ready",
        },
        {
          id: 3,
          name: "Nintendo Switch OLED",
          price: 349,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//106/MTA-29636638/no_brand_nintendo_switch_-oled_model-_white_set_full01_h7q23tmg.jpg",
          specs: ["7-inch OLED", "Portable/TV Mode", "Joy-Con Controllers"],
          stock: "Ready",
        },
        {
          id: 4,
          name: "Steam Deck",
          price: 399,
          brand: "Valve",
          category: "💻 Handheld PC Heroes",
          image: "https://jnewsonline.com/wp-content/uploads/2021/07/Image_from_iOS.0.jpg",
          specs: ["7-inch Touchscreen", "AMD APU", "SteamOS"],
          stock: "Ready",
        },
        {
          id: 5,
          name: "ROG Ally X",
          price: 799,
          brand: "ASUS",
          category: "💻 Handheld PC Heroes",
          image: "https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/106/MTA-181590765/asus_asus_rog_ally_x_rc72la_amd_ryzen_z1_extreme_24gb_1tb_7-_ips_120hz_w11_-_z1_extreme_full02_v2s6kpyo.jpg",
          specs: ["AMD Ryzen Z1 Extreme", "120Hz Display", "Windows 11"],
          stock: "Ready",
        },
        {
          id: 6,
          name: "PlayStation 4",
          price: 299,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Sony-PlayStation-4-PS4-wDualShock-4.jpg/330px-Sony-PlayStation-4-PS4-wDualShock-4.jpg",
          specs: ["8-core Jaguar CPU", "500GB/1TB HDD", "1080p Gaming"],
          stock: "Ready",
        },
        {
          id: 7,
          name: "PlayStation 4 Pro",
          price: 399,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://img.antaranews.com/cache/1200x800/2018/08/PS4-Pro.jpg.webp",
          specs: ["4.2 TFLOPS GPU", "1TB HDD", "4K Upscaling"],
          stock: "Ready",
        },
        {
          id: 8,
          name: "PlayStation 5 Digital Edition",
          price: 399,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://akcdn.detik.net.id/community/media/visual/2024/09/12/ps5_169.webp?w=700&q=90",
          specs: ["No Disc Drive", "825GB SSD", "4K Gaming"],
          stock: "Ready",
        },
        {
          id: 9,
          name: "PlayStation Vita",
          price: 199,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://i0.wp.com/www.gamezone.co.id/wp-content/uploads/2017/11/ps_vita_new_slim_wi-fi-1.jpg?fit=760%2C473&ssl=1",
          specs: ["5-inch OLED", "Touchscreen", "Remote Play"],
          stock: "Kosong",
        },
        {
          id: 10,
          name: "PlayStation Portable (PSP)",
          price: 149,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//108/MTA-38389437/no_brand_sony_playstation_portable_3000_-_psp_3000_16_gb_-_psp_16gb_____________________________________________________________________________________________full01_qmq6qc3.jpg",
          specs: ["4.3-inch LCD", "UMD Drive", "Multimedia Features"],
          stock: "Kosong",
        },
        {
          id: 11,
          name: "Xbox One X",
          price: 499,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://imageio.forbes.com/blogs-images/erikkain/files/2017/11/xbox-one-x.jpg?format=jpg&height=900&width=1600&fit=bounds",
          specs: ["6 TFLOPS GPU", "1TB HDD", "4K UHD Blu-ray"],
          stock: "Ready",
        },
        {
          id: 12,
          name: "Xbox One S",
          price: 299,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://images-cdn.ubuy.co.id/66aafaba562fd2552837a847-pre-owned-microsoft-xbox-one-s-1tb.jpg",
          specs: ["1TB HDD", "1080p Gaming", "4K UHD Blu-ray"],
          stock: "Ready",
        },
        {
          id: 13,
          name: "Xbox Series S",
          price: 299,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://i.insider.com/5fa3eee9f7d1cb0019e39edd?width=1018&format=jpeg",
          specs: ["4 TFLOPS GPU", "512GB SSD", "1440p Gaming"],
          stock: "Ready",
        },
        {
          id: 14,
          name: "Xbox 360",
          price: 199,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://images-cdn.ubuy.co.id/65e978f5455678301d52711a-pre-owned-microsoft-xbox-360-60gb-pro.jpg",
          specs: ["512MB RAM", "20GB HDD", "720p Gaming"],
          stock: "Kosong",
        },
        {
          id: 15,
          name: "Xbox 360 Elite",
          price: 249,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://i5.walmartimages.com/seo/Restored-Xbox-360-Elite-500GB-Gaming-Console-Black-885370889277-Refurbished_865ddc6f-3ab0-4ecc-8a12-e5403bc46576.b8e1effe415660f2b34a36db0d4b21ec.jpeg",
          specs: ["120GB HDD", "1080p Gaming", "HDMI Output"],
          stock: "Kosong",
        },
        {
          id: 16,
          name: "Xbox One",
          price: 249,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://images.tokopedia.net/img/cache/500-square/product-1/2018/10/1/272055672/272055672_2808661a-98bf-47c6-aa0d-da4a62d6e7b5_455_455.jpg",
          specs: ["8-core AMD CPU", "500GB HDD", "1080p Gaming"],
          stock: "Ready",
        },
        {
          id: 17,
          name: "Nintendo Switch Lite",
          price: 199,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://down-id.img.susercontent.com/file/id-11134207-7qul6-ljy3daam9o9ufd",
          specs: ["5.5-inch LCD", "Portable Mode", "No TV Dock"],
          stock: "Ready",
        },
        {
          id: 18,
          name: "Nintendo Switch Pro Controller",
          price: 69,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://www.psegameshop.com/wp-content/uploads/2022/06/Nintendo-Switch-Pro-Controller-Monster-Hunter-Rise-Sunbreak-Edition-1.jpg",
          specs: ["Wireless Controller", "HD Rumble", "Motion Controls"],
          stock: "Ready",
        },
        {
          id: 19,
          name: "Nintendo Wii U",
          price: 299,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://images.tokopedia.net/img/cache/700/OJWluG/2022/6/24/6986517e-9687-4a69-bb5a-440c418f2f23.jpg?ect=4g",
          specs: ["Dual-screen gameplay", "Wii U GamePad", "HD Graphics"],
          stock: "Kosong",
        },
        {
          id: 20,
          name: "Nintendo Wii U Pro Controller",
          price: 49,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://down-id.img.susercontent.com/file/d2acba54d7bac4439c5b914bf9a8f991",
          specs: ["Wireless Controller", "Ergonomic Design", "HD Rumble"],
          stock: "Ready",
        },
        {
          id: 21,
          name: "GPD Win 3",
          price: 799,
          brand: "GPD",
          category: "💻 Handheld PC Heroes",
          image: "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2021/4/24/4ef5f38a-5679-486c-9217-e7d331552ae1.jpg",
          specs: ["Intel i5-1135G7", "8GB RAM", "512GB SSD", "5.5-inch Touchscreen"],
          stock: "Ready",
        },
        {
          id: 22,
          name: "GPD Win 2",
          price: 649,
          brand: "GPD",
          category: "💻 Handheld PC Heroes",
          image: "https://nwzimg.wezhan.hk/contents/sitefiles3601/18006016/images/451210.png",
          specs: ["Intel Core m3-7Y30", "8GB RAM", "128GB SSD", "6-inch Touchscreen"],
          stock: "Kosong",
        },
        {
          id: 23,
          name: "Ayaneo Next",
          price: 899,
          brand: "Ayaneo",
          category: "💻 Handheld PC Heroes",
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXenkCzYTH1OY_bNMRRaoh13FmdeT_BMohg0gS-rl8RQ&s&ec=72940545",
          specs: ["AMD Ryzen 5 3500U", "16GB RAM", "512GB SSD", "7-inch Touchscreen"],
          stock: "Ready",
        },
        {
          id: 24,
          name: "OneXPlayer",
          price: 999,
          brand: "One-Netbook",
          category: "💻 Handheld PC Heroes",
          image: "https://onexplayerstore.com/cdn/shop/files/4_4ea280a7-79dc-4f9d-ab9d-6d1ba4b168ca.png?v=1716797081",
          specs: ["Intel Core i7-1165G7", "16GB RAM", "1TB SSD", "8.4-inch Touchscreen"],
          stock: "Ready",
        },
        {
          id: 25,
          name: "GPD Win Max",
          price: 899,
          brand: "GPD",
          category: "💻 Handheld PC Heroes",
          image: "https://gpdstore.net/wp-content/uploads/2024/12/GPD-WIN-MAX-2-2025-INFOGRAPHIC-NEW-GENERIC-01.png",
          specs: ["Intel i7-1165G7", "16GB RAM", "512GB SSD", "8-inch Touchscreen"],
          stock: "Ready",
        },
        {
          id: 26,
          name: "Atari 2600",
          price: 199,
          brand: "Atari",
          category: "✨ Explore More Consoles",
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShsvsuHl9YWwTHsuK0yWafyIW6v4WVBQza_v7CsVZogQ&s&ec=72940545",
          specs: ["2600 Games Library", "Joystick Controllers", "Woodgrain Finish"],
          stock: "Kosong",
        },
        {
          id: 27,
          name: "Sega Genesis",
          price: 149,
          brand: "Sega",
          category: "✨ Explore More Consoles",
          image: "https://upload.wikimedia.org/wikipedia/commons/a/a1/Sega-Mega-Drive-JP-Mk1-Console-Set.jpg",
          specs: ["16-bit Console", "Iconic Games Library", "Classic Controllers"],
          stock: "Kosong",
        },
        {
          id: 28,
          name: "Super Nintendo Entertainment System (SNES)",
          price: 179,
          brand: "Nintendo",
          category: "✨ Explore More Consoles",
          image: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Wikipedia_SNES_PAL.jpg/250px-Wikipedia_SNES_PAL.jpg",
          specs: ["16-bit Console", "Super Mario World", "Two Controllers"],
          stock: "Ready",
        },
        {
          id: 29,
          name: "Neo Geo",
          price: 399,
          brand: "SNK",
          category: "✨ Explore More Consoles",
          image: "https://neogeomuseum.snk-corp.co.jp/english/whats/img/p_whats02_01.jpg",
          specs: ["AES System", "Arcade Quality", "Iconic Games Library"],
          stock: "Kosong",
        },
        {
          id: 30,
          name: "Dreamcast",
          price: 299, 
          brand: "Sega",
          category: "✨ Explore More Consoles",
          image: "https://upload.wikimedia.org/wikipedia/commons/8/81/Dreamcast-Console-Set.jpg",
          specs: ["128-bit System", "VGA Output", "Virtual Fighter 3"],
          stock: "Kosong",
        },
        {
          id: 31,
          name: "Xbox Series X (Carbon Black)",
          price: 499,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://down-id.img.susercontent.com/file/sg-11134201-7rbmb-ln2utcc0bol1c4",
          specs: ["12 TFLOPS GPU", "1TB SSD", "4K Gaming"],
          stock: "Ready",
        },
        {
          id: 32,
          name: "Xbox Series S (White)",
          price: 299,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://xboxwire.thesourcemediaassets.com/sites/2/2020/09/XboxSeriesS_HERO.jpg",
          specs: ["4 TFLOPS GPU", "512GB SSD", "1440p Gaming"],
          stock: "Ready",
        },
        {
          id: 33,
          name: "PS Vita Slim",
          price: 229,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://www.cnet.com/a/img/resize/88d0ac012d8023385c3064e754cf09d2afc08c0f/hub/2014/01/30/f371d294-a5c4-11e3-a24e-d4ae52e62bcc/sony-ps-vita-slim-14.jpg?auto=webp&width=1200",
          specs: ["5-inch LCD", "Slim Design", "Wi-Fi + 3G Model"],
          stock: "Kosong",
        },
        {
          id: 34,
          name: "Razer Edge 5G",
          price: 599,
          brand: "Razer",
          category: "💻 Handheld PC Heroes",
          image: "https://i.ebayimg.com/images/g/g18AAOSwZq5m0guO/s-l400.png",
          specs: ["Snapdragon G3X", "5G Connectivity", "6.8-inch AMOLED"],
          stock: "Ready",
        },
        {
          id: 35,
          name: "GPD Pocket 2",
          price: 699,
          brand: "GPD",
          category: "💻 Handheld PC Heroes",
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrPEAFC5S8qJZ6BJlTieMxm999DST6IWnlHHS-vQOYEw&s&ec=72940545",
          specs: ["Intel Atom x7", "8GB RAM", "128GB SSD", "7-inch Display"],
          stock: "Kosong",
        },
        {
          id: 36,
          name: "Alienware Concept UFO",
          price: 899,
          brand: "Alienware",
          category: "💻 Handheld PC Heroes",
          image: "https://www.cnet.com/a/img/resize/972706c237fada8f3a0f4bed22e7789858d414b7/hub/2020/01/02/ee0faff3-0d1b-45fb-8ec9-171a5c9acd2a/08-alienware-concept-ufo-gaming-device.jpg?auto=webp&fit=crop&height=900&width=1200",
          specs: ["Intel Core i7", "16GB RAM", "512GB SSD", "8-inch Display"],
          stock: "Kosong",
        },
        {
          id: 37,
          name: "Ayn Odin Base",
          price: 199,
          brand: "Ayn",
          category: "💻 Handheld PC Heroes",
          image: "https://cdn.mos.cms.futurecdn.net/bmu2ZY5FDLU4ayVe5eg5yc.jpg",
          specs: ["Snapdragon 845", "4GB RAM", "32GB Storage", "5.98-inch Display"],
          stock: "Ready",
        },
        {
          id: 38,
          name: "Ayn Odin Pro",
          price: 299,
          brand: "Ayn",
          category: "💻 Handheld PC Heroes",
          image: "https://droix.net/wp-content/uploads/2023/09/AYN-ODIN-CLEAR_WHITE-DONE-LISTING-IMAGE-1.png",
          specs: ["Snapdragon 865", "8GB RAM", "128GB Storage", "6-inch Display"],
          stock: "Ready",
        },
        {
          id: 39,
          name: "Atari Jaguar",
          price: 199,
          brand: "Atari",
          category: "✨ Explore More Consoles",
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzRjN4iXeOUrtUOGX3mCJoOEYAjls96Np5gck5-5YtcA&s&ec=72940545",
          specs: ["64-bit Console", "Alien vs. Predator", "Jaguar Controller"],
          stock: "Kosong",
        },
        {
          id: 40,
          name: "ColecoVision",
          price: 129,
          brand: "Coleco",
          category: "✨ Explore More Consoles",
          image: "https://images.computerhistory.org/revonline/images/102626599p-03-05.jpg?w=600",
          specs: ["8-bit Console", "Classic Games", "Expansion Modules"],
          stock: "Kosong",
        },
        {
          id: 41,
          name: "Neo Geo CD",
          price: 399,
          brand: "SNK",
          category: "✨ Explore More Consoles",
          image: "https://upload.wikimedia.org/wikipedia/commons/a/a2/Neo-Geo-CD-TopLoader-wController-FL.jpg",
          specs: ["CD-based Games", "128-bit Graphics", "Dual Joysticks"],
          stock: "Kosong",
        },
        {
          id: 42,
          name: "Sega Saturn",
          price: 249,
          brand: "Sega",
          category: "✨ Explore More Consoles",
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpyuDuyR7dgwRx_R7wEBrNOHY4lngVgpkha8ahtGyoZQ&s&ec=72940545",
          specs: ["32-bit Console", "2D/3D Capabilities", "Iconic Games"],
          stock: "Kosong",
        },
        {
          id: 43,
          name: "PlayStation Classic",
          price: 99,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://jagatplay.com/wp-content/uploads/2018/09/playstation-classic2-600x400.jpg",
          specs: ["20 Pre-installed Games", "Mini Design", "HDMI Output"],
          stock: "Ready",
        },
        {
          id: 44,
          name: "Game Boy Advance",
          price: 129,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://i.guim.co.uk/img/media/96a7a0b6779452c2e29ecb1b1d7bb8ae8b37fd88/63_0_1489_894/master/1489.jpg?width=620&dpr=2&s=none&crop=none",
          specs: ["2.9-inch Display", "Backlit Screen", "Link Cable Support"],
          stock: "Ready",
        },
        {
          id: 45,
          name: "Game Boy Color",
          price: 89,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://images-cdn.ubuy.qa/635d16472e74682cd7382b12-game-boy-color-kiwi-renewed.jpg",
          specs: ["Color Screen", "Backward Compatibility", "Link Cable Support"],
          stock: "Kosong",
        },
        {
          id: 46,
          name: "PlayStation TV",
          price: 99,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/61/PlayStation-TV-BL.jpg/330px-PlayStation-TV-BL.jpg",
          specs: ["PlayStation Vita Games", "Remote Play", "HDMI Output"],
          stock: "Kosong",
        },
        {
          id: 47,
          name: "Super Nintendo Entertainment System Classic",
          price: 79,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://m.media-amazon.com/images/I/71itkDwgyyL._AC_UF1000,1000_QL80_.jpg",
          specs: ["21 Pre-installed Games", "Mini Design", "HDMI Output"],
          stock: "Ready",
        },
        {
          id: 48,
          name: "Sega Genesis Mini",
          price: 79,
          brand: "Sega",
          category: "✨ Explore More Consoles",
          image: "https://sm.pcmag.com/t/pcmag_au/review/s/sega-genes/sega-genesis-mini-2_7mbp.1920.jpg",
          specs: ["42 Pre-installed Games", "Mini Design", "HDMI Output"],
          stock: "Ready",
        },
        {
          id: 49,
          name: "Nintendo 64",
          price: 249,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://m.media-amazon.com/images/I/61xoifvahFL.jpg",
          specs: ["64-bit System", "4 Controller Ports", "Iconic Games"],
          stock: "Kosong",
        },
        {
          id: 50,
          name: "Nintendo 64 Controller",
          price: 49,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://assets.nintendo.com/image/upload/q_auto:best/f_auto/dpr_2.0/ncom/en_US/products/accessories/nintendo-switch/controllers/other-controllers/n64-controller/114294-switch-nso-n64-controller-front-view-1200x675",
          specs: ["Analog Stick", "Z Button", "Iconic Design"],
          stock: "Ready",
        },
        {
          id: 51,
          name: "GPD Win 4",
          price: 899,
          brand: "GPD",
          category: "💻 Handheld PC Heroes",
          image: "https://gpdstore.net/wp-content/uploads/2024/12/GPD-WIN-4-2025-LISTING-GENERIC-01.png",
          specs: ["AMD Ryzen 7 6800U", "16GB RAM", "512GB SSD", "6-inch Touchscreen"],
          stock: "Ready",
        },
        {
          id: 52,
          name: "OneXPlayer Mini Pro",
          price: 899,
          brand: "One-Netbook",
          category: "💻 Handheld PC Heroes",
          image: "https://static1.xdaimages.com/wordpress/wp-content/uploads/2022/11/one-xplayer-mini-pro.jpg",
          specs: ["Intel Core i7", "16GB RAM", "512GB SSD", "7-inch Display"],
          stock: "Ready",
        },
        {
          id: 53,
          name: "Ayn Odin Base 2",
          price: 249,
          brand: "Ayn",
          category: "💻 Handheld PC Heroes",
          image: "https://down-id.img.susercontent.com/file/id-11134207-7r98p-lo6hqyj6sp4432",
          specs: ["Snapdragon 865", "6GB RAM", "64GB Storage", "5.98-inch Display"],
          stock: "Ready",
        },
        {
          id: 54,
          name: "RetroFlag GPI Case",
          price: 99,
          brand: "RetroFlag",
          category: "✨ Explore More Consoles",
          image: "https://thepihut.com/cdn/shop/products/gpi-case-2-for-cm4-deluxe-edition-with-dock-retroflag-104830-31588494704835_grande.jpg?v=1646517796",
          specs: ["Retro Design", "Raspberry Pi Compatible", "Portable Gaming"],
          stock: "Kosong",
        },
        {
          id: 55,
          name: "PlayStation Portal Remote Player",
          price: 199,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://cdn.sotel.de/images/1001095242/sony-playstation-portal-remote-player-weiss-002.jpg",
          specs: ["8-inch LCD Screen", "Remote Play for PS5", "Wi-Fi Streaming"],
          stock: "Ready",
        },
        {
          id: 56,
          name: "PSP Go",
          price: 179,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://ae01.alicdn.com/kf/S09d1b6d3e8cd4eb19e9933d46addc08cN.jpg",
          specs: ["Sliding 3.8-inch Screen", "16GB Internal Storage", "Digital Only"],
          stock: "Kosong",
        },
        {
          id: 57,
          name: "Original Xbox",
          price: 149,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Xbox-console.jpg/800px-Xbox-console.jpg",
          specs: ["Built-in HDD", "Xbox Live (Original)", "Halo: Combat Evolved"],
          stock: "Kosong",
        },
        {
          id: 58,
          name: "New Nintendo 3DS XL",
          price: 199,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://images-cdn.ubuy.co.id/6813408f3fa3e16c8e0be2f2-new-nintendo-3ds-xl-red-renewed.jpg",
          specs: ["Stereoscopic 3D", "C-Stick", "Amiibo Support"],
          stock: "Ready",
        },
        {
          id: 59,
          name: "Nintendo GameCube",
          price: 129,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://upload.wikimedia.org/wikipedia/commons/d/d1/GameCube-Set.jpg",
          specs: ["MiniDVD Format", "4 Controller Ports", "GBA Connectivity"],
          stock: "Kosong",
        },
        {
          id: 60,
          name: "Nintendo Wii",
          price: 99,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Wii_console.png/800px-Wii_console.png",
          specs: ["Motion Controls (Wii Remote)", "Virtual Console", "GameCube Compatible"],
          stock: "Ready",
        },
        {
          id: 61,
          name: "Lenovo Legion Go",
          price: 699,
          brand: "Lenovo",
          category: "💻 Handheld PC Heroes",
          image: "https://yangcanggih.com/wp-content/uploads/2025/01/Lenovo-Legion-Go-S-1.webp",
          specs: ["AMD Ryzen Z1 Extreme", "8.8-inch QHD+ Display", "Detachable Controllers"],
          stock: "Ready",
        },
        {
          id: 62,
          name: "MSI Claw A1M",
          price: 699,
          brand: "MSI",
          category: "💻 Handheld PC Heroes",
          image: "https://editor.pasundanekspres.id/storage/uploads/conten/1730264023.jpg",
          specs: ["Intel Core Ultra Processor", "7-inch FHD Display", "Windows 11"],
          stock: "Ready",
        },
        {
          id: 63,
          name: "Sega Master System",
          price: 89,
          brand: "Sega",
          category: "✨ Explore More Consoles",
          image: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Sega-Master-System-Set.jpg/1200px-Sega-Master-System-Set.jpg",
          specs: ["8-bit Console", "Card & Cartridge Slots", "Alex Kidd in Miracle World"],
          stock: "Kosong",
        },
        {
          id: 64,
          name: "TurboGrafx-16",
          price: 179,
          brand: "NEC",
          category: "✨ Explore More Consoles",
          image: "https://upload.wikimedia.org/wikipedia/commons/d/d4/TurboGrafx-16-Console.jpg",
          specs: ["HuCard Games", "16-bit Graphics (Partial)", "CD-ROM Add-on"],
          stock: "Kosong",
        },
        {
          id: 65,
          name: "Neo Geo Pocket Color",
          price: 129,
          brand: "SNK",
          category: "✨ Explore More Consoles",
          image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/SNK_New_NEOGEOPOCKET_Color.jpg/250px-SNK_New_NEOGEOPOCKET_Color.jpg",
          specs: ["Color Handheld", "Clicky Joystick", "SNK Arcade Ports"],
          stock: "Kosong",
        },
      ],
    };
  },
  mounted() {
    const modalElement = this.$refs.consoleModalRef;
    if (modalElement) {
      this.bootstrapModalInstance = new Modal(modalElement);
      modalElement.addEventListener('hidden.bs.modal', () => {
        this.selectedProduct = null;
        document.body.style.overflow = '';
      });
      modalElement.addEventListener('shown.bs.modal', () => {
        document.body.style.overflow = 'hidden';
      });
    }

    if (this.cards && this.cards.length > 0) {
      this.selectCategory(this.cards[0]);
    }
  },
  computed: {
    brands() {
      if (!this.selectedCategory) return [];
      const consolesInCategory = this.consoles.filter(c => c.category === this.selectedCategory.title);
      return [...new Set(consolesInCategory.map(c => c.brand))].sort();
    },
    minSliderBoundIDR() {
      return 0; 
    },
    maxSliderBoundIDR() {
      if (!this.consoles || this.consoles.length === 0) {
        // Ensure the slider can always reach defaultMaxPriceIDR or a bit higher
        return Math.max(this.defaultMaxPriceIDR, this.priceStepIDR * 20); 
      }
      const maxProductPriceUSD = Math.max(0, ...this.consoles.map(c => c.price));
      const maxProductPriceIDR = maxProductPriceUSD * this.usdToIdrRate;
      const practicalMax = Math.max(maxProductPriceIDR, this.defaultMaxPriceIDR);
      return Math.ceil(practicalMax / this.priceStepIDR) * this.priceStepIDR;
    },
    filteredConsoles() {
      if (!this.selectedCategory) return [];
      let filtered = this.consoles.filter(
        c => c.category === this.selectedCategory.title
      );
      if (this.searchQuery) {
        filtered = filtered.filter(c =>
          c.name.toLowerCase().includes(this.searchQuery.toLowerCase())
        );
      }
      if (this.selectedBrand) {
        filtered = filtered.filter(c => c.brand === this.selectedBrand);
      }
      filtered = filtered.filter(c => {
        const priceIDR = c.price * this.usdToIdrRate;
        return priceIDR >= this.minPriceIDR && priceIDR <= this.maxPriceIDR;
      });
      return filtered;
    },
  },
  methods: {
    selectCategory(category) {
      this.selectedCategory = category;
      this.searchQuery = "";
      this.selectedBrand = "";
      this.minPriceIDR = this.defaultMinPriceIDR;
      this.maxPriceIDR = this.defaultMaxPriceIDR;
    },
    formatPrice(price) {
      if (typeof price !== 'number' || isNaN(price)) {
        return 'Rp 0';
      }
      return new Intl.NumberFormat("id-ID", {
        style: "currency",
        currency: "IDR",
        minimumFractionDigits: 0,
        maximumFractionDigits: 0,
      }).format(price);
    },
    showDetails(consoleItem) {
      this.selectedProduct = consoleItem;
      if (this.bootstrapModalInstance) {
        this.bootstrapModalInstance.show();
      }
    },
    closeDetails() {
      if (this.bootstrapModalInstance) {
        this.bootstrapModalInstance.hide();
      }
    },
    getStockClass(stockStatus) {
      if (stockStatus === "Ready") {
        return 'text-success fw-bold';
      } else if (stockStatus === "Kosong") {
        return 'text-danger fw-bold';
      }
      return '';
    }
  },
  watch: {
    minPriceIDR(newValue) {
      const newMin = Number(newValue);
      const currentMax = Number(this.maxPriceIDR);
      if (newMin < this.minSliderBoundIDR) {
        this.minPriceIDR = this.minSliderBoundIDR;
      } else if (newMin > this.maxSliderBoundIDR) { // cap at max possible slider value
        this.minPriceIDR = this.maxSliderBoundIDR;
      } else if (newMin > currentMax) {
        this.maxPriceIDR = newMin; 
      }
    },
    maxPriceIDR(newValue) {
      const newMax = Number(newValue);
      const currentMin = Number(this.minPriceIDR);
      if (newMax > this.maxSliderBoundIDR) {
        this.maxPriceIDR = this.maxSliderBoundIDR;
      } else if (newMax < this.minSliderBoundIDR) { // cap at min possible slider value
        this.maxPriceIDR = this.minSliderBoundIDR;
      } else if (newMax < currentMin) {
        this.minPriceIDR = newMax; 
      }
    },
  }
};
</script>
