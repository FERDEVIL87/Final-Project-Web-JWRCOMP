<template>
  <section class="container my-5" data-aos="fade-up">
    <h2 class="h3 mb-4 text-primary text-center futuristic-title neon-title">  🎮 ULTIMATE GAME CONSOLES HUB 🚀</h2>
    <!-- Kategori Grid -->
    <div class="category-grid">
      <button
        v-for="(card, index) in cards"
        :key="index"
        class="category-button"
        @click="selectCategory(card)"
        :class="{ 'active': selectedCategory && selectedCategory.title === card.title }"
        :aria-pressed="selectedCategory && selectedCategory.title === card.title"
      >
        {{ card.title }}
      </button>
    </div>

    <div v-if="selectedCategory" class="filters">
      <h3 class="text-center category-filter-title">{{ selectedCategory.title }}</h3>
      <div class="filter-controls">
        <input
          type="text"
          v-model="searchQuery"
          placeholder="Search console..."
          class="form-control"
          aria-label="Search console in current category"
        />
        <select v-model="selectedBrand" class="form-control" aria-label="Filter by brand">
          <option value="">All Brands</option>
          <option v-for="brand in brands" :key="brand" :value="brand">
            {{ brand }}
          </option>
        </select>
        <div class="price-range-container">
          <label for="priceRangeSlider" class="price-label screen-reader-only">Max Price:</label>
          <input
            type="range"
            v-model="priceRangeUSD"
            min="0"
            :max="maxPriceInCategory"
            step="50"
            class="form-range"
            aria-label="Filter by maximum price"
            id="priceRangeSlider"
            aria-valuetext="`Maximum price ${formatPrice(priceRangeUSD)}`"
          />
          <span class="price-label-display" aria-hidden="true">Max Price: {{ formatPrice(priceRangeUSD) }}</span>
        </div>
      </div>

      <div v-if="filteredConsoles.length > 0" class="console-grid">
        <div
          v-for="consoleItem in filteredConsoles"
          :key="consoleItem.id"
          class="console-card"
          @click="showDetails(consoleItem)"
          role="button"
          tabindex="0"
          @keydown.enter="showDetails(consoleItem)"
          @keydown.space="showDetails(consoleItem)"
          :aria-label="`View details for ${consoleItem.name}`"
        >
          <img :src="consoleItem.image" :alt="`${consoleItem.name} console`" class="console-image" />
          <div class="console-info">
            <h4 class="console-name">{{ consoleItem.name }}</h4>
            <p class="console-brand">Brand: {{ consoleItem.brand }}</p>
            <p class="console-price">Price: {{ formatPrice(consoleItem.price) }}</p>
          </div>
        </div>
      </div>
      <div v-else class="no-results">
        <p>No consoles match your current filters in the "{{ selectedCategory.title }}" category.</p>
      </div>
    </div>
    <div v-else class="no-category-selected">
        <p>✨ Please select a category above to explore our awesome consoles! ✨</p>
    </div>
  </section>

  <!-- MODAL PRODUK MENGGUNAKAN TELEPORT -->
  <teleport to="body">
    <div v-if="isModalVisible" class="modal-overlay" @click.self="closeDetails" role="dialog" aria-modal="true" :aria-labelledby="selectedProduct ? 'modal-title-' + selectedProduct.id : ''" @keydown.esc="closeDetails">
      <div class="modal-content" ref="modalContent">
        <button class="modal-close-button" @click="closeDetails" aria-label="Close product details" ref="modalCloseButton">×</button>
        <div v-if="selectedProduct">
          <h3 :id="'modal-title-' + selectedProduct.id" class="modal-product-title">{{ selectedProduct.name }}</h3>
          <img :src="selectedProduct.image" :alt="`Image of ${selectedProduct.name}`" class="product-image" />
          <div class="modal-details-grid">
            <p><strong>Price:</strong> <span>{{ formatPrice(selectedProduct.price) }}</span></p>
            <p><strong>Brand:</strong> <span>{{ selectedProduct.brand }}</span></p>
          </div>
          <div v-if="selectedProduct.specs && selectedProduct.specs.length > 0" class="features-section">
            <p class="features-title"><strong>Features:</strong></p>
            <ul>
              <li v-for="(feature, index) in selectedProduct.specs" :key="index">
                {{ feature }}
              </li>
            </ul>
          </div>
          <!-- Tombol close lama di dalam modal-content ini bisa dihapus jika sudah menggunakan modal-close-button di atas -->
        </div>
      </div>
    </div>
  </teleport>
</template>

<script>
export default {
  name: "GameConsolesHub",
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
      priceRangeUSD: 1500, // Default max price
      usdToIdrRate: 15000,
      selectedProduct: null,
      isModalVisible: false, // Variabel untuk mengontrol visibilitas modal
      consoles: [
        // ... (data konsol Anda tetap sama)
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
          image: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Sony-PlayStation-4-PS4-wDualShock-4.jpg/330px-Sony-PlayStation-4-PS4-wDualShock-4.jpg",
          specs: ["8-core Jaguar CPU", "500GB/1TB HDD", "1080p Gaming"],
        },
        {
          id: 7,
          name: "PlayStation 4 Pro",
          price: 399,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://img.antaranews.com/cache/1200x800/2018/08/PS4-Pro.jpg.webp",
          specs: ["4.2 TFLOPS GPU", "1TB HDD", "4K Upscaling"],
        },
        {
          id: 8,
          name: "PlayStation 5 Digital Edition",
          price: 399,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://akcdn.detik.net.id/community/media/visual/2024/09/12/ps5_169.webp?w=700&q=90",
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
          image: "https://www.psegameshop.com/wp-content/uploads/2022/06/Nintendo-Switch-Pro-Controller-Monster-Hunter-Rise-Sunbreak-Edition-1.jpg",
          specs: ["Wireless Controller", "HD Rumble", "Motion Controls"]
        },
        {
          id: 19,
          name: "Nintendo Wii U",
          price: 299,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://images.tokopedia.net/img/cache/700/OJWluG/2022/6/24/6986517e-9687-4a69-bb5a-440c418f2f23.jpg?ect=4g",
          specs: ["Dual-screen gameplay", "Wii U GamePad", "HD Graphics"]
        },
        {
          id: 20,
          name: "Nintendo Wii U Pro Controller",
          price: 49,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://down-id.img.susercontent.com/file/d2acba54d7bac4439c5b914bf9a8f991",
          specs: ["Wireless Controller", "Ergonomic Design", "HD Rumble"]
        },
        {
          id: 21,
          name: "GPD Win 3",
          price: 799,
          brand: "GPD",
          category: "💻 Handheld PC Heroes",
          image: "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2021/4/24/4ef5f38a-5679-486c-9217-e7d331552ae1.jpg",
          specs: ["Intel i5-1135G7", "8GB RAM", "512GB SSD", "5.5-inch Touchscreen"]
        },
        {
          id: 22,
          name: "GPD Win 2",
          price: 649,
          brand: "GPD",
          category: "💻 Handheld PC Heroes",
          image: "https://nwzimg.wezhan.hk/contents/sitefiles3601/18006016/images/451210.png",
          specs: ["Intel Core m3-7Y30", "8GB RAM", "128GB SSD", "6-inch Touchscreen"]
        },
        {
          id: 23,
          name: "Ayaneo Next",
          price: 899,
          brand: "Ayaneo",
          category: "💻 Handheld PC Heroes",
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXenkCzYTH1OY_bNMRRaoh13FmdeT_BMohg0gS-rl8RQ&s&ec=72940545",
          specs: ["AMD Ryzen 5 3500U", "16GB RAM", "512GB SSD", "7-inch Touchscreen"]
        },
        {
          id: 24,
          name: "OneXPlayer",
          price: 999,
          brand: "One-Netbook",
          category: "💻 Handheld PC Heroes",
          image: "https://onexplayerstore.com/cdn/shop/files/4_4ea280a7-79dc-4f9d-ab9d-6d1ba4b168ca.png?v=1716797081",
          specs: ["Intel Core i7-1165G7", "16GB RAM", "1TB SSD", "8.4-inch Touchscreen"]
        },
        {
          id: 25,
          name: "GPD Win Max",
          price: 899,
          brand: "GPD",
          category: "💻 Handheld PC Heroes",
          image: "https://gpdstore.net/wp-content/uploads/2024/12/GPD-WIN-MAX-2-2025-INFOGRAPHIC-NEW-GENERIC-01.png",
          specs: ["Intel i7-1165G7", "16GB RAM", "512GB SSD", "8-inch Touchscreen"]
        },
        {
          id: 26,
          name: "Atari 2600",
          price: 199,
          brand: "Atari",
          category: "✨ Explore More Consoles",
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShsvsuHl9YWwTHsuK0yWafyIW6v4WVBQza_v7CsVZogQ&s&ec=72940545",
          specs: ["2600 Games Library", "Joystick Controllers", "Woodgrain Finish"],
        },
        {
          id: 27,
          name: "Sega Genesis",
          price: 149,
          brand: "Sega",
          category: "✨ Explore More Consoles",
          image: "https://upload.wikimedia.org/wikipedia/commons/a/a1/Sega-Mega-Drive-JP-Mk1-Console-Set.jpg",
          specs: ["16-bit Console", "Iconic Games Library", "Classic Controllers"],
        },
        {
          id: 28,
          name: "Super Nintendo Entertainment System (SNES)",
          price: 179,
          brand: "Nintendo",
          category: "✨ Explore More Consoles",
          image: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Wikipedia_SNES_PAL.jpg/250px-Wikipedia_SNES_PAL.jpg",
          specs: ["16-bit Console", "Super Mario World", "Two Controllers"],
        },
        {
          id: 29,
          name: "Neo Geo",
          price: 399,
          brand: "SNK",
          category: "✨ Explore More Consoles",
          image: "https://neogeomuseum.snk-corp.co.jp/english/whats/img/p_whats02_01.jpg",
          specs: ["AES System", "Arcade Quality", "Iconic Games Library"],
        },
        {
          id: 30,
          name: "Dreamcast",
          price: 299,brand: "Sega",
          category: "✨ Explore More Consoles",
          image: "https://upload.wikimedia.org/wikipedia/commons/8/81/Dreamcast-Console-Set.jpg",
          specs: ["128-bit System", "VGA Output", "Virtual Fighter 3"],
        },
        {
          id: 31,
          name: "Xbox Series X (Carbon Black)",
          price: 499,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://down-id.img.susercontent.com/file/sg-11134201-7rbmb-ln2utcc0bol1c4",
          specs: ["12 TFLOPS GPU", "1TB SSD", "4K Gaming"],
        },
        {
          id: 32,
          name: "Xbox Series S (White)",
          price: 299,
          brand: "Microsoft",
          category: "🟩 Xbox Universe",
          image: "https://xboxwire.thesourcemediaassets.com/sites/2/2020/09/XboxSeriesS_HERO.jpg",
          specs: ["4 TFLOPS GPU", "512GB SSD", "1440p Gaming"],
        },
        {
          id: 33,
          name: "PS Vita Slim",
          price: 229,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://www.cnet.com/a/img/resize/88d0ac012d8023385c3064e754cf09d2afc08c0f/hub/2014/01/30/f371d294-a5c4-11e3-a24e-d4ae52e62bcc/sony-ps-vita-slim-14.jpg?auto=webp&width=1200",
          specs: ["5-inch LCD", "Slim Design", "Wi-Fi + 3G Model"],
        },
        {
          id: 34,
          name: "Razer Edge 5G",
          price: 599,
          brand: "Razer",
          category: "💻 Handheld PC Heroes",
          image: "https://i.ebayimg.com/images/g/g18AAOSwZq5m0guO/s-l400.png",
          specs: ["Snapdragon G3X", "5G Connectivity", "6.8-inch AMOLED"],
        },
        {
          id: 35,
          name: "GPD Pocket 2",
          price: 699,
          brand: "GPD",
          category: "💻 Handheld PC Heroes",
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrPEAFC5S8qJZ6BJlTieMxm999DST6IWnlHHS-vQOYEw&s&ec=72940545",
          specs: ["Intel Atom x7", "8GB RAM", "128GB SSD", "7-inch Display"],
        },
        {
          id: 36,
          name: "Alienware Concept UFO",
          price: 899,
          brand: "Alienware",
          category: "💻 Handheld PC Heroes",
          image: "https://www.cnet.com/a/img/resize/972706c237fada8f3a0f4bed22e7789858d414b7/hub/2020/01/02/ee0faff3-0d1b-45fb-8ec9-171a5c9acd2a/08-alienware-concept-ufo-gaming-device.jpg?auto=webp&fit=crop&height=900&width=1200",
          specs: ["Intel Core i7", "16GB RAM", "512GB SSD", "8-inch Display"],
        },
        {
          id: 37,
          name: "Ayn Odin Base",
          price: 199,
          brand: "Ayn",
          category: "💻 Handheld PC Heroes",
          image: "https://cdn.mos.cms.futurecdn.net/bmu2ZY5FDLU4ayVe5eg5yc.jpg",
          specs: ["Snapdragon 845", "4GB RAM", "32GB Storage", "5.98-inch Display"],
        },
        {
          id: 38,
          name: "Ayn Odin Pro",
          price: 299,
          brand: "Ayn",
          category: "💻 Handheld PC Heroes",
          image: "https://droix.net/wp-content/uploads/2023/09/AYN-ODIN-CLEAR_WHITE-DONE-LISTING-IMAGE-1.png",
          specs: ["Snapdragon 865", "8GB RAM", "128GB Storage", "6-inch Display"],
        },
        {
          id: 39,
          name: "Atari Jaguar",
          price: 199,
          brand: "Atari",
          category: "✨ Explore More Consoles",
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzRjN4iXeOUrtUOGX3mCJoOEYAjls96Np5gck5-5YtcA&s&ec=72940545",
          specs: ["64-bit Console", "Alien vs. Predator", "Jaguar Controller"],
        },
        {
          id: 40,
          name: "ColecoVision",
          price: 129,
          brand: "Coleco",
          category: "✨ Explore More Consoles",
          image: "https://images.computerhistory.org/revonline/images/102626599p-03-05.jpg?w=600",
          specs: ["8-bit Console", "Classic Games", "Expansion Modules"],
        },
        {
          id: 41,
          name: "Neo Geo CD",
          price: 399,
          brand: "SNK",
          category: "✨ Explore More Consoles",
          image: "https://upload.wikimedia.org/wikipedia/commons/a/a2/Neo-Geo-CD-TopLoader-wController-FL.jpg",
          specs: ["CD-based Games", "128-bit Graphics", "Dual Joysticks"],
        },
        {
          id: 42,
          name: "Sega Saturn",
          price: 249,
          brand: "Sega",
          category: "✨ Explore More Consoles",
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpyuDuyR7dgwRx_R7wEBrNOHY4lngVgpkha8ahtGyoZQ&s&ec=72940545",
          specs: ["32-bit Console", "2D/3D Capabilities", "Iconic Games"],
        },
        {
          id: 43,
          name: "PlayStation Classic",
          price: 99,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://jagatplay.com/wp-content/uploads/2018/09/playstation-classic2-600x400.jpg",
          specs: ["20 Pre-installed Games", "Mini Design", "HDMI Output"],
        },
        {
          id: 44,
          name: "Game Boy Advance",
          price: 129,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://i.guim.co.uk/img/media/96a7a0b6779452c2e29ecb1b1d7bb8ae8b37fd88/63_0_1489_894/master/1489.jpg?width=620&dpr=2&s=none&crop=none",
          specs: ["2.9-inch Display", "Backlit Screen", "Link Cable Support"],
        },
        {
          id: 45,
          name: "Game Boy Color",
          price: 89,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://images-cdn.ubuy.qa/635d16472e74682cd7382b12-game-boy-color-kiwi-renewed.jpg",
          specs: ["Color Screen", "Backward Compatibility", "Link Cable Support"],
        },
        {
          id: 46,
          name: "PlayStation TV",
          price: 99,
          brand: "Sony",
          category: "🎮 PlayStation Powerhouse",
          image: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/61/PlayStation-TV-BL.jpg/330px-PlayStation-TV-BL.jpg",
          specs: ["PlayStation Vita Games", "Remote Play", "HDMI Output"],
        },
        {
          id: 47,
          name: "Super Nintendo Entertainment System Classic",
          price: 79,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://m.media-amazon.com/images/I/71itkDwgyyL._AC_UF1000,1000_QL80_.jpg",
          specs: ["21 Pre-installed Games", "Mini Design", "HDMI Output"],
        },
        {
          id: 48,
          name: "Sega Genesis Mini",
          price: 79,
          brand: "Sega",
          category: "✨ Explore More Consoles",
          image: "https://sm.pcmag.com/t/pcmag_au/review/s/sega-genes/sega-genesis-mini-2_7mbp.1920.jpg",
          specs: ["42 Pre-installed Games", "Mini Design", "HDMI Output"],
        },
        {
          id: 49,
          name: "Nintendo 64",
          price: 249,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://m.media-amazon.com/images/I/61xoifvahFL.jpg",
          specs: ["64-bit System", "4 Controller Ports", "Iconic Games"],
        },
        {
          id: 50,
          name: "Nintendo 64 Controller",
          price: 49,
          brand: "Nintendo",
          category: "🍄 Nintendo Magic",
          image: "https://assets.nintendo.com/image/upload/q_auto:best/f_auto/dpr_2.0/ncom/en_US/products/accessories/nintendo-switch/controllers/other-controllers/n64-controller/114294-switch-nso-n64-controller-front-view-1200x675",
          specs: ["Analog Stick", "Z Button", "Iconic Design"],
        },
        {
          id: 51,
          name: "GPD Win 4",
          price: 899,
          brand: "GPD",
          category: "💻 Handheld PC Heroes",
          image: "https://gpdstore.net/wp-content/uploads/2024/12/GPD-WIN-4-2025-LISTING-GENERIC-01.png",
          specs: ["AMD Ryzen 7 6800U", "16GB RAM", "512GB SSD", "6-inch Touchscreen"],
        },
        {
          id: 52,
          name: "OneXPlayer Mini Pro",
          price: 899,
          brand: "One-Netbook",
          category: "💻 Handheld PC Heroes",
          image: "https://s.alicdn.com/@sc04/kf/H7e01368670d045d395dcf773163afe35S.jpg_720x720q50.jpg",
          specs: ["Intel Core i7", "16GB RAM", "512GB SSD", "7-inch Display"],
        },
        {
          id: 53,
          name: "Ayn Odin Base 2",
          price: 249,
          brand: "Ayn",
          category: "💻 Handheld PC Heroes",
          image: "https://down-id.img.susercontent.com/file/id-11134207-7r98p-lo6hqyj6sp4432",
          specs: ["Snapdragon 865", "6GB RAM", "64GB Storage", "5.98-inch Display"],
        },
        {
          id: 54,
          name: "RetroFlag GPI Case",
          price: 99,
          brand: "RetroFlag",
          category: "✨ Explore More Consoles",
          image: "https://thepihut.com/cdn/shop/products/gpi-case-2-for-cm4-deluxe-edition-with-dock-retroflag-104830-31588494704835_grande.jpg?v=1646517796",
          specs: ["Retro Design", "Raspberry Pi Compatible", "Portable Gaming"],
        },
      ],
    };
  },
  computed: {
    brands() {
      if (!this.selectedCategory) return [];
      const consolesInCategory = this.consoles.filter(c => c.category === this.selectedCategory.title);
      const uniqueBrands = [...new Set(consolesInCategory.map((consoleItem) => consoleItem.brand))];
      return uniqueBrands.sort();
    },
    filteredConsoles() {
      if (!this.selectedCategory) return [];

      let filtered = this.consoles.filter(
        (consoleItem) => consoleItem.category === this.selectedCategory.title
      );

      if (this.searchQuery) {
        filtered = filtered.filter((consoleItem) =>
          consoleItem.name.toLowerCase().includes(this.searchQuery.toLowerCase())
        );
      }

      if (this.selectedBrand) {
        filtered = filtered.filter((consoleItem) => consoleItem.brand === this.selectedBrand);
      }

      // Pastikan priceRangeUSD adalah angka sebelum filter
      const currentPriceRange = Number(this.priceRangeUSD);
      filtered = filtered.filter((consoleItem) => consoleItem.price <= currentPriceRange);

      return filtered;
    },
    maxPriceInCategory() {
        if (!this.selectedCategory) return 1500;
        const consolesInCategory = this.consoles.filter(
            (c) => c.category === this.selectedCategory.title
        );
        if (consolesInCategory.length === 0) return 1500; // Default jika tidak ada konsol di kategori
        const maxPrice = Math.max(...consolesInCategory.map(c => c.price), 0); // Tambahkan 0 untuk kasus array kosong
        return Math.ceil(maxPrice / 50) * 50 || 50; // Bulatkan ke atas kelipatan 50, minimal 50
    }
  },
  methods: {
    selectCategory(category) {
      this.selectedCategory = category;
      this.searchQuery = "";
      this.selectedBrand = "";
      this.priceRangeUSD = this.maxPriceInCategory; // Set ke max price dari kategori baru
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
      this.isModalVisible = true; // Menggantikan this.selectedProduct untuk v-if modal
      this.$nextTick(() => {
        if (this.$refs.modalCloseButton) {
          this.$refs.modalCloseButton.focus();
        }
      });
    },
    closeDetails() {
      this.isModalVisible = false; // Menggantikan this.selectedProduct = null untuk v-if modal
      // Fokus kembali bisa ditambahkan di sini jika perlu
      this.selectedProduct = null; // Tetap reset selectedProduct
    },
  },
  watch: {
    isModalVisible(newValue) {
      if (newValue) {
        document.body.style.overflow = 'hidden';
      } else {
        setTimeout(() => {
            if (!this.isModalVisible) {
                 document.body.style.overflow = '';
            }
        }, 350); // Sesuaikan dengan durasi animasi
      }
    },
    selectedCategory() {
        this.priceRangeUSD = this.maxPriceInCategory;
    }
  }
};
</script>

<style scoped>
/* Import Google Font */
@import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&family=Orbitron:wght@400;500;700;900&display=swap');

/* General Styles */
.screen-reader-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}

body { /* Style ini akan lebih baik di CSS global */
    background: linear-gradient(to bottom, #050a13, #171e2e);
    color: #f0f0f0;
    font-family: 'Montserrat', sans-serif;
    line-height: 1.6;
    margin: 0;
    padding: 0;
    overflow-x: hidden;
    animation: background-gradient 10s ease infinite alternate;
    background-size: 200% 200%;
    scroll-behavior: smooth;
}

.container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 25px;
}

@keyframes background-gradient {
    0% { background-position: 0% 50%; }
    100% { background-position: 100% 50%; }
}

.futuristic-title.neon-title {
    font-family: 'Orbitron', sans-serif;
    font-weight: 900;
    font-size: clamp(2.4rem, 6vw, 4rem);
    color: #fff !important;
    text-shadow: 0 0 7px #00eaff,
                 0 0 15px #00eaff,
                 0 0 25px #00eaff,
                 0 0 50px #00a3cc,
                 0 0 80px #00a3cc,
                 0 0 100px #00a3cc,
                 0 0 150px #00a3cc;
    animation: neon-glow-intense 2s infinite alternate;
    text-align: center;
    margin-bottom: 3rem;
    letter-spacing: 0.12em;
    text-transform: uppercase;
}

@keyframes neon-glow-intense {
    from {
        text-shadow: 0 0 5px #00eaff, 0 0 10px #00eaff, 0 0 15px #00eaff, 0 0 20px #00a3cc, 0 0 30px #00a3cc, 0 0 40px #00a3cc, 0 0 50px #00a3cc;
    }
    to {
        text-shadow: 0 0 10px #00eaff, 0 0 20px #00eaff, 0 0 30px #00eaff, 0 0 50px #00a3cc, 0 0 80px #00a3cc, 0 0 100px #00a3cc, 0 0 150px #00a3cc;
    }
}

.category-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1.8rem;
    margin-bottom: 3.5rem;
}

.category-button {
    font-family: 'Orbitron', sans-serif;
    padding: 1.3rem 1.1rem;
    background: linear-gradient(145deg, #101829, #1c2a45);
    color: #00eaff;
    border: 2px solid rgba(0, 234, 255, 0.25);
    border-radius: 10px;
    text-align: center;
    cursor: pointer;
    transition: all 0.35s cubic-bezier(0.25, 0.8, 0.25, 1);
    box-shadow: 0 5px 12px rgba(0, 0, 0, 0.5);
    position: relative;
    overflow: hidden;
    font-weight: 500;
    font-size: 1.05rem;
    text-transform: uppercase;
    letter-spacing: 0.05em;
}
.category-button.active {
    background: linear-gradient(145deg, #00eaff, #008cbf);
    color: #050a13;
    box-shadow: 0 0 20px #00eaff, 0 0 35px #00a3cc, inset 0 0 10px rgba(255,255,255,0.2);
    border-color: #00eaff;
    transform: translateY(-3px) scale(1.03);
}
.category-button:not(.active):hover {
    transform: translateY(-6px) scale(1.05);
    box-shadow: 0 10px 25px rgba(0, 234, 255, 0.35);
    background: linear-gradient(145deg, #182742, #25365c);
    border-color: rgba(0, 234, 255, 0.6);
}

.filters {
    margin-top: 3rem;
    background: rgba(8, 15, 28, 0.9);
    backdrop-filter: blur(15px);
    padding: 2.2rem;
    border-radius: 15px;
    border: 1px solid rgba(0, 234, 255, 0.2);
    color: #00eaff;
    box-shadow: 0 6px 18px rgba(0, 0, 0, 0.6);
}

.category-filter-title { /* Mengganti .filters h3 */
    font-family: 'Orbitron', sans-serif;
    font-weight: 700;
    text-align: center;
    margin-bottom: 2.2rem;
    font-size: 2rem;
    color: #f0f0f0;
    text-shadow: 0 0 10px #00eaff;
    text-transform: uppercase;
}

.filter-controls {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 1.8rem;
    margin-bottom: 1.8rem;
    align-items: end;
}

.form-control {
    padding: 0.85rem 1.1rem;
    border: 1px solid rgba(0, 234, 255, 0.35);
    border-radius: 8px;
    background: rgba(15, 25, 45, 0.75);
    color: #00eaff;
    font-family: 'Montserrat', sans-serif;
    font-size: 1rem;
    transition: all 0.3s ease;
}
.form-control::placeholder {
    color: rgba(0, 234, 255, 0.65);
}
.form-control:focus {
    border-color: #00eaff;
    box-shadow: 0 0 0 4px rgba(0, 234, 255, 0.25);
    outline: none;
    background: rgba(20, 30, 50, 0.85);
}
input.form-control[type="text"] {
    padding-left: 1.1rem; /* Hapus padding icon jika tidak ada icon */
    background-image: none; /* Hapus gambar jika tidak ada */
}
select.form-control {
    appearance: none;
    -webkit-appearance: none;
    -moz-appearance: none;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%2300eaff'%3E%3Cpath d='M8 11.293l-4.646-4.647a.5.5 0 0 1 .708-.708L8 9.879l4.03-4.03a.5.5 0 0 1 .707.707L8 11.293z'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: right 0.85rem center;
    background-size: 18px 18px;
    padding-right: 2.8rem;
}

.price-range-container {
    display: flex;
    flex-direction: column;
    gap: 0.6rem;
    grid-column: 1 / -1;
}

.form-range {
    width: 100%;
    background: transparent;
    -webkit-appearance: none;
    appearance: none;
    height: 10px;
    cursor: pointer;
}
.form-range::-webkit-slider-runnable-track {
    width: 100%;
    height: 10px;
    background: rgba(0, 234, 255, 0.35);
    border-radius: 5px;
}
.form-range::-moz-range-track {
    width: 100%;
    height: 10px;
    background: rgba(0, 234, 255, 0.35);
    border-radius: 5px;
}
.form-range::-webkit-slider-thumb {
    -webkit-appearance: none;
    appearance: none;
    width: 22px;
    height: 22px;
    background: #00eaff;
    border-radius: 50%;
    border: 3px solid #0a1424;
    margin-top: -6px;
    box-shadow: 0 0 8px #00eaff, 0 0 12px #00a3cc;
    transition: transform 0.2s ease, box-shadow 0.2s ease; /* Tambahkan transisi box-shadow */
}
.form-range::-moz-range-thumb {
    width: 22px;
    height: 22px;
    background: #00eaff;
    border-radius: 50%;
    border: 3px solid #0a1424;
    box-shadow: 0 0 8px #00eaff, 0 0 12px #00a3cc;
    transition: transform 0.2s ease, box-shadow 0.2s ease; /* Tambahkan transisi box-shadow */
}
.form-range:active::-webkit-slider-thumb, .form-range:focus::-webkit-slider-thumb { /* Efek fokus/aktif lebih jelas */
    transform: scale(1.15);
    box-shadow: 0 0 0 5px rgba(0, 234, 255, 0.3), 0 0 10px #00eaff, 0 0 15px #00a3cc;
}
.form-range:active::-moz-range-thumb, .form-range:focus::-moz-range-thumb { /* Efek fokus/aktif lebih jelas */
    transform: scale(1.15);
    box-shadow: 0 0 0 5px rgba(0, 234, 255, 0.3), 0 0 10px #00eaff, 0 0 15px #00a3cc;
}

.price-label-display {
    color: #00eaff;
    font-weight: 500;
    font-size: 0.95rem;
    white-space: nowrap;
}
@media (min-width: 768px) {
    .filter-controls {
         grid-template-columns: 1fr 1fr 2fr;
    }
    .price-range-container {
        flex-direction: row;
        align-items: center;
        gap: 1rem;
    }
    .price-label-display {
         margin-left: 0.5rem;
    }
}


.console-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 2.2rem;
    margin-top: 3rem;
}

.console-card {
    background: linear-gradient(160deg, #18223d, #28355e 70%, #304070);
    border-radius: 15px;
    overflow: hidden;
    box-shadow: 0 8px 20px rgba(0,0,0,0.6), inset 0 1px 0 rgba(255,255,255,0.05);
    transition: transform 0.35s ease, box-shadow 0.4s ease, border-color 0.35s ease;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    position: relative;
    border: 1px solid transparent;
}
.console-card:hover, .console-card:focus-visible {
    transform: translateY(-10px) scale(1.03);
    box-shadow: 0 12px 35px rgba(0, 234, 255, 0.4), 0 0 20px rgba(0, 234, 255, 0.25), inset 0 1px 0 rgba(255,255,255,0.1);
    border-color: rgba(0, 234, 255, 0.5);
    outline: none;
}

.console-image {
    width: 100%;
    height: 220px;
    object-fit: contain;
    background-color: rgba(5,10,19,0.7);
    transition: transform 0.4s ease, opacity 0.4s ease;
    opacity: 0.9;
}
.console-card:hover .console-image {
    transform: scale(1.08);
    opacity: 1;
}

.console-info {
    padding: 1.8rem;
    flex-grow: 1;
    text-align: left;
}

.console-name {
    font-family: 'Orbitron', sans-serif;
    color: #00eaff;
    margin: 0 0 0.6rem 0;
    font-size: 1.35rem;
    font-weight: 700;
    line-height: 1.3;
}

.console-brand,
.console-price {
    color: #e0e0e0;
    margin-bottom: 0.4rem;
    font-size: 1rem;
}
.console-price {
    font-weight: bold;
    color: #f0f0f0;
    font-size: 1.1rem;
}
.console-card:hover .console-price {
    color: #00eaff;
    animation: price-pulse-strong 0.6s ease-in-out;
}

@keyframes price-pulse-strong {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.08); text-shadow: 0 0 5px #00eaff; }
}

.no-results, .no-category-selected {
    text-align: center;
    color: #00eaff;
    padding: 3rem;
    background: rgba(8, 15, 28, 0.8);
    border-radius: 15px;
    margin-top: 3rem;
    font-size: 1.3rem;
    font-family: 'Orbitron', sans-serif;
    border: 1px dashed rgba(0,234,255,0.3);
}

/* Modal Overlay */
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(5, 10, 19, 0.92);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000; /* Pastikan di atas AOS jika AOS punya z-index tinggi */
    padding: 20px;
    backdrop-filter: blur(12px);
    opacity: 0;
    animation: fadeInModal 0.3s ease-out forwards;
}
@keyframes fadeInModal {
  from { opacity: 0; }
  to { opacity: 1; }
}

/* MODAL CONTENT: Dirombak Sesuai Permintaan */
.modal-content {
  background: #1a1a24; /* Warna solid gelap, sesuai var --background-modal contoh */
  padding: 30px;
  border-radius: 12px;
  box-shadow: 0 10px 40px rgba(0, 234, 255, 0.25); /* Shadow warna neon dengan alpha rendah */
  position: relative; /* Penting untuk tombol close absolut */
  width: 100%; /* Akan dibatasi oleh max-width */
  max-width: 650px;
  max-height: 90vh; /* Batasi tinggi modal */
  overflow-y: auto; /* Scrollbar jika konten > max-height */
  border: 1px solid rgba(0, 234, 255, 0.35); /* Border warna neon */
  color: #e0e0e0; /* Warna teks medium */
  transform: scale(0.95); /* State awal untuk animasi */
  animation: scaleUpModal 0.3s cubic-bezier(0.34, 1.56, 0.64, 1) 0.1s forwards; /* Animasi muncul */
  text-align: left; /* Default alignment teks */
}

@keyframes scaleUpModal {
  0% { transform: scale(0.9) translateY(10px); opacity: 0.6; }
  100% { transform: scale(1) translateY(0px); opacity: 1; }
}
/* --- Akhir dari MODAL CONTENT --- */


.modal-close-button {
  position: absolute;
  top: 18px;
  right: 18px;
  background: rgba(0, 234, 255, 0.1);
  border: 1px solid rgba(0, 234, 255, 0.3);
  border-radius: 50%;
  width: 40px;
  height: 40px;
  font-size: 1.8rem;
  font-weight: bold;
  color: #00eaff;
  cursor: pointer;
  line-height: 38px; /* Penyesuaian line-height agar X di tengah */
  text-align: center;
  transition: all 0.25s ease;
  z-index: 10; /* Pastikan di atas konten modal lain */
}
.modal-close-button:hover, .modal-close-button:focus {
  background: rgba(0, 234, 255, 0.2);
  color: #ffffff;
  transform: scale(1.15) rotate(180deg);
  box-shadow: 0 0 10px rgba(0,234,255,0.5);
  outline: none;
}

.modal-product-title {
    font-family: 'Orbitron', sans-serif;
    font-weight: 700;
    color: #00eaff;
    font-size: clamp(1.6rem, 5vw, 2rem);
    margin-top: 0;
    margin-bottom: 1.8rem;
    text-align: center;
    text-shadow: 0 0 10px #00eaff, 0 0 15px #00a3cc;
    padding-right: 40px; /* Ruang untuk tombol close jika judul panjang */
}

.modal-details-grid {
    display: grid;
    grid-template-columns: auto 1fr;
    gap: 0.5rem 1rem;
    margin-bottom: 1.2rem;
}
.modal-details-grid p {
    margin-bottom: 0;
    display: contents;
}
.modal-details-grid p strong {
    color: #f0f0f0;
    font-weight: 600;
}
.modal-details-grid p span {
    color: #e0e0e0;
}


.features-section {
    margin-top: 1.8rem;
    padding-top: 1.2rem;
    border-top: 1px solid rgba(0, 234, 255, 0.25);
}
.features-title strong { /* Mengganti .features-section p strong */
    font-family: 'Orbitron', sans-serif;
    font-size: 1.1rem;
    color: #f0f0f0;
    margin-bottom: 0.8rem;
    display: block;
}
.modal-content ul {
    list-style: none;
    padding-left: 0;
}
.modal-content ul li {
    padding-left: 1.8em;
    text-indent: -1.8em;
    margin-bottom: 0.6rem;
    position: relative;
    color: #e0e0e0;
    font-size: 0.95rem;
}
.modal-content ul li::before {
    content: "▹";
    color: #00eaff;
    font-size: 1.3em;
    margin-right: 0.6em;
    position: absolute;
    left: 0;
    top: -0.08em;
}


.product-image {
    width: auto;
    max-width: 80%;
    max-height: 320px;
    object-fit: contain;
    border-radius: 10px;
    margin: 0 auto 1.8rem auto;
    background-color: rgba(5,10,19,0.5);
    border: 1px solid rgba(0, 234, 255, 0.2);
    display: block;
    box-shadow: 0 5px 15px rgba(0,0,0,0.3);
}

/* Responsive Adjustments */
@media (max-width: 768px) {
    .container {
        padding: 15px;
    }
    .futuristic-title.neon-title {
        margin-bottom: 2.5rem;
        letter-spacing: 0.08em;
    }
    .filter-controls {
        grid-template-columns: 1fr;
    }
    .price-range-container {
        flex-direction: column;
        align-items: stretch;
    }
    .price-label-display {
        align-self: flex-start;
        margin-left: 0;
        margin-top: 0.5rem;
    }
    .console-grid {
        grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
        gap: 1.5rem;
    }
    .modal-content {
        padding: 25px;
        max-width: 90%; /* Memastikan tidak terlalu lebar di layar kecil */
    }
    .modal-product-title {
        padding-right: 30px;
    }
}

@media (max-width: 480px) {
    .futuristic-title.neon-title {
        font-size: clamp(2rem, 7vw, 2.8rem);
    }
    .category-grid {
        grid-template-columns: 1fr;
        gap: 1rem;
    }
    .category-button {
        font-size: 0.95rem;
        padding: 1.1rem 0.8rem;
    }
    .console-grid {
        grid-template-columns: 1fr;
    }
    .modal-content {
        max-height: 85vh;
        padding: 20px; /* Padding lebih kecil lagi */
    }
    .modal-product-title {
        font-size: clamp(1.4rem, 4.5vw, 1.7rem);
    }
    .product-image {
        max-height: 250px;
    }
    .modal-close-button {
        top: 12px;
        right: 12px;
        width: 35px;
        height: 35px;
        font-size: 1.6rem;
        line-height: 33px;
    }
}

</style>