<template>
  <section class="container">
    <h2 class="main-title">🎮 ULTIMATE GAME CONSOLES HUB 🚀</h2>
    <!-- Kategori -->
    <div class="category-grid">
      <button
        v-for="(card, index) in cards"
        :key="index"
        class="category-button"
        @click="selectCategory(card)"
        :class="{ active: selectedCategory && selectedCategory.title === card.title }"
      >
        {{ card.title }}
      </button>
    </div>

    <div v-if="selectedCategory" class="filters">
      <h3 class="category-filter-title">{{ selectedCategory.title }}</h3>
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
        <div class="price-range-container">
          <input
            type="range"
            v-model="priceRangeUSD"
            min="0"
            :max="maxPriceInCategory"
            step="50"
            class="form-range"
          />
          <span class="price-label-display">Max: {{ formatPrice(priceRangeUSD) }}</span>
        </div>
      </div>

      <div v-if="filteredConsoles.length > 0" class="console-grid">
        <div
          v-for="consoleItem in filteredConsoles"
          :key="consoleItem.id"
          class="console-card"
          @click="showDetails(consoleItem)"
          tabindex="0"
        >
          <img :src="consoleItem.image" :alt="consoleItem.name" class="console-image" />
          <div class="console-info">
            <h4 class="console-name">{{ consoleItem.name }}</h4>
            <p class="console-brand">Brand: {{ consoleItem.brand }}</p>
            <p class="console-stock">Stock: <span :class="getStockClass(consoleItem.stock)">{{ consoleItem.stock }}</span></p>
            <p class="console-price">{{ formatPrice(consoleItem.price) }}</p>
          </div>
        </div>
      </div>
      <div v-else class="no-results">
        <p>No consoles match your current filters.</p>
      </div>
    </div>
    <div v-else class="no-category-selected">
      <p>✨ Please select a category above to explore our awesome consoles! ✨</p>
    </div>

    <!-- MODAL -->
    <teleport to="body">
      <div v-if="isModalVisible" class="modal-overlay" @click.self="closeDetails">
        <div class="modal-content">
          <button class="modal-close-button" @click="closeDetails" aria-label="Close modal">×</button>
          <div v-if="selectedProduct">
            <h3 class="modal-product-title">{{ selectedProduct.name }}</h3>
            <img :src="selectedProduct.image" :alt="selectedProduct.name" class="product-image" />
            <div class="modal-details-grid">
              <p><strong>Price:</strong> <span>{{ formatPrice(selectedProduct.price) }}</span></p>
              <p><strong>Brand:</strong> <span>{{ selectedProduct.brand }}</span></p>
              <p><strong>Stock:</strong> <span :class="getStockClass(selectedProduct.stock)">{{ selectedProduct.stock }}</span></p>
            </div>
            <div v-if="selectedProduct.specs && selectedProduct.specs.length > 0" class="features-section">
              <p class="features-title"><strong>Features:</strong></p>
              <ul>
                <li v-for="(feature, index) in selectedProduct.specs" :key="index">{{ feature }}</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </teleport>
  </section>
</template>

<script>
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
      priceRangeUSD: 1500,
      usdToIdrRate: 15000,
      selectedProduct: null,
      isModalVisible: false,
      consoles: [
        {
          id: 1,
          name: "PlayStation 5",
          price: 499,
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
          price: 299,brand: "Sega",
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
      ],
    };
  },
  mounted() {
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
      filtered = filtered.filter(c => c.price <= Number(this.priceRangeUSD));
      return filtered;
    },
    maxPriceInCategory() {
      if (!this.selectedCategory) return 1500;
      const consolesInCategory = this.consoles.filter(
        c => c.category === this.selectedCategory.title
      );
      if (consolesInCategory.length === 0) return 1500;
      const maxPrice = Math.max(...consolesInCategory.map(c => c.price), 0);
      return Math.ceil(maxPrice / 50) * 50 || 50;
    }
  },
  methods: {
    selectCategory(category) {
      this.selectedCategory = category;
      this.searchQuery = "";
      this.selectedBrand = "";
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
    showDetails(consoleItem) {
      this.selectedProduct = consoleItem;
      this.isModalVisible = true;
    },
    closeDetails() {
      this.isModalVisible = false;
      this.selectedProduct = null;
    },
    getStockClass(stockStatus) {
      if (stockStatus === "Ready") {
        return 'stock-ready';
      } else if (stockStatus === "Kosong") {
        return 'stock-kosong';
      }
      return '';
    }
  },
  watch: {
    isModalVisible(newValue) {
      document.body.style.overflow = newValue ? 'hidden' : '';
    },
    selectedCategory(newCategory, oldCategory) {
      if (newCategory !== oldCategory) {
        this.priceRangeUSD = this.maxPriceInCategory;
      }
    }
  }
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&family=Orbitron:wght@700&display=swap');

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 60px 10px;
  min-height: 100vh;
  color: #fff;
  font-family: 'Montserrat', sans-serif;
  opacity: 0;
  animation: fadein 0.7s ease 0s forwards;
}

@keyframes fadein {
  from { opacity: 0; }
  to   { opacity: 1; }
}

.main-title {
  font-family: 'Orbitron', sans-serif;
  font-size: 2.2rem;
  text-align: center;
  margin-bottom: 2.2rem;
  color: #fff;
  text-shadow: 0 0 8px #00eaff, 0 0 18px #00eaff;
  letter-spacing: 0.08em;
  font-weight: 700;
}

.category-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 1.2rem;
  justify-content: center;
  margin-bottom: 2.5rem;
}
.category-button {
  font-family: 'Orbitron', sans-serif;
  padding: 1rem 1.2rem;
  background: #101829;
  color: #00eaff;
  border: 2px solid #00eaff44;
  border-radius: 8px;
  cursor: pointer;
  font-size: 1rem;
  transition: all 0.2s;
  box-shadow: 0 2px 8px #00eaff22;
}
.category-button.active,
.category-button:hover {
  background: #00eaff;
  color: #050a13;
  border-color: #00eaff;
  box-shadow: 0 0 12px #00eaff88;
}

.filters {
  background: #101829cc;
  border-radius: 10px;
  padding: 1.5rem 1rem;
  margin-bottom: 2rem;
  box-shadow: 0 2px 12px #00eaff22;
}
.category-filter-title {
  font-family: 'Orbitron', sans-serif;
  font-size: 1.2rem;
  color: #fff;
  text-shadow: 0 0 8px #00eaff;
  text-align: center;
  margin-bottom: 1.2rem;
  font-weight: 700;
  letter-spacing: 0.06em;
}
.filter-controls {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  margin-bottom: 1rem;
}
.form-control {
  flex: 1 1 160px;
  padding: 0.7rem 1rem;
  border-radius: 6px;
  border: 1px solid #00eaff44;
  background: #18223d;
  color: #fff;
  font-size: 1rem;
}

.form-control::placeholder {
  color: #bbb; 
  opacity: 1; 
}
.form-control:-ms-input-placeholder { 
 color: #bbb;
}
.form-control::-ms-input-placeholder { 
 color: #bbb;
}

.form-control:focus {
  background-color: #18223d; 
  color: #fff;             
  border-color: #00eaff;    
  outline: 0;               
  box-shadow: 0 0 0 0.2rem rgba(0, 234, 255, 0.25); 
}


.price-range-container {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
.form-range {
  width: 120px;
  accent-color: #00eaff;
}
.price-label-display {
  color: #00eaff;
  font-size: 0.95rem;
  font-weight: 500;
}

.console-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 1.2rem;
  margin-top: 1.5rem;
}
.console-card {
  background: #18223d;
  border-radius: 10px;
  box-shadow: 0 2px 12px #00eaff22;
  cursor: pointer;
  overflow: hidden;
  transition: transform 0.18s, box-shadow 0.18s;
  border: 1px solid #00eaff22;
  display: flex;
  flex-direction: column;
}
.console-card:hover {
  transform: translateY(-4px) scale(1.03);
  box-shadow: 0 6px 24px #00eaff44;
  border-color: #00eaff;
}
.console-image {
  width: 100%;
  height: 140px;
  object-fit: cover;
  background: #101829;
}
.console-info {
  padding: 1rem;
  text-align: left;
}
.console-name {
  font-family: 'Orbitron', sans-serif;
  color: #fff;
  font-size: 1.08rem;
  font-weight: 700;
  margin-bottom: 0.3rem;
  text-shadow: 0 0 6px #00eaff, 0 0 12px #00eaff;
}
.console-brand,
.console-price{
  color: #fff;
  font-size: 0.97rem;
  margin-bottom: 0.2rem;
  text-shadow: 0 0 4px #00eaff;
}

.console-stock {
  color: #fff;
  font-size: 0.97rem;
  margin-bottom: 0.2rem;
}

.console-price {
  font-weight: bold;
}

.stock-ready {
  color: #28a745; /* Green */
  font-weight: bold;
}

.stock-kosong {
  color: #dc3545; /* Red */
  font-weight: bold;
}

.no-results,
.no-category-selected {
  text-align: center;
  color: #00eaff;
  padding: 2rem 0;
  font-family: 'Orbitron', sans-serif;
  font-size: 1.1rem;
}

.modal-overlay {
  position: fixed;
  top: 0; left: 0; width: 100vw; height: 100vh;
  background: rgba(5, 10, 19, 0.93);
  display: flex; justify-content: center; align-items: center;
  z-index: 1000;
}
.modal-content {
  background: #1a1a24;
  padding: 20px 16px 18px 16px; /* Adjusted top padding */
  border-radius: 10px;
  box-shadow: 0 4px 24px #00eaff33;
  max-width: 380px; 
  width: 90%;
  color: #fff;
  position: relative;
  text-align: left;
}

.modal-product-title {
  font-family: 'Orbitron', sans-serif;
  color: #fff;
  font-size: 1.25rem; 
  font-weight: 700;
  margin-bottom: 1.2rem; 
  text-align: center;
  text-shadow: 0 0 8px #00eaff;
  padding-left: 20px;  /* Space for left side (balance) */
  padding-right: 50px; /* Space for the close button on the right */
  box-sizing: border-box; 
  width: 100%; 
  word-wrap: break-word;
  overflow-wrap: break-word; 
}

.modal-close-button {
  position: absolute;
  top: 12px; 
  right: 12px; 
  background: transparent;
  color: #aaa;
  border: none;
  font-family: Arial, Helvetica, sans-serif; 
  font-size: 2.2rem;  
  font-weight: normal; 
  line-height: 1;     
  cursor: pointer;
  padding: 5px; 
  transition: color 0.2s ease, transform 0.2s ease;
  z-index: 1001; 
}

.modal-close-button:hover {
  color: #fff;
  transform: scale(1.1);
}

.product-image {
  width: 100%;
  max-width: 280px; 
  max-height: 180px; 
  object-fit: contain;
  margin: 0 auto 1.5rem auto; 
  display: block;
  border-radius: 8px;
  background: #101829;
}
.modal-details-grid {
  font-size: 0.98rem;
  margin-bottom: 0.8rem;
}
.modal-details-grid p {
  margin-bottom: 0.5rem;
}
.features-section {
  margin-top: 1rem;
  border-top: 1px solid #00eaff33;
  padding-top: 0.7rem;
}
.features-title strong {
  color: #00eaff;
  font-size: 1rem;
}
.modal-content ul {
  padding-left: 1.2em;
}
.modal-content ul li {
  margin-bottom: 0.4rem;
  color: #fff;
  font-size: 0.95rem;
  text-shadow: 0 0 4px #00eaff;
}
@media (max-width: 700px) {
  .container { padding: 10px 2px; }
  .main-title { font-size: 1.3rem; }
  .console-grid { grid-template-columns: 1fr; }
  .console-image { height: 110px; }
  .modal-content { 
    max-width: 95vw; 
    padding-top: 15px; /* Adjust for smaller screens */
  } 
  .product-image {
    max-width: 240px;
    max-height: 150px;
  }
  .modal-product-title {
    font-size: 1.1rem;
    padding-left: 15px;
    padding-right: 45px; /* Adjust for smaller screens if needed */
  }
  .modal-close-button {
    top: 8px;
    right: 8px;
    font-size: 2rem;
  }
}
</style>
