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
        <span class="price-label">Max Price: {{ formatPrice(priceRangeUSD) }}</span>
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
      priceRangeUSD: 1500,
      usdToIdrRate: 15000,
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
      return [...new Set(this.consoles.map((console) => console.brand))];
    },
    filteredConsoles() {
      let filtered = this.consoles.filter(
        (console) => console.category === this.selectedCategory.title
      );

      if (this.searchQuery) {
        filtered = filtered.filter((console) =>
          console.name.toLowerCase().includes(this.searchQuery.toLowerCase())
        );
      }

      if (this.selectedBrand) {
        filtered = filtered.filter((console) => console.brand === this.selectedBrand);
      }

      filtered = filtered.filter((console) => console.price <= this.priceRangeUSD);

      return filtered;
    },
  },
  methods: {
    selectCategory(category) {
      this.selectedCategory = category;
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
/* Import Google Font */
@import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap');

/* General Styles */
body {
    background: linear-gradient(to bottom, #050a13, #171e2e);
    color: #f0f0f0;
    font-family: 'Montserrat', sans-serif;
    line-height: 1.6;
    margin: 0;
    padding: 0;
    overflow-x: hidden;
    animation: background-gradient 5s ease infinite alternate;
    background-size: 200% 200%;
    scroll-behavior: smooth; /* Smooth scrolling */
}

.container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 1rem;
}

/* Animated Background Gradient */
@keyframes background-gradient {
    0% {
        background-position: 0% 50%;
    }
    100% {
        background-position: 100% 50%;
    }
}

/* Parallax Effect (Subtle - Add to specific elements) */
.parallax {
    background-attachment: fixed;
    background-position: center;
    background-repeat: no-repeat;
    background-size: cover;
}

/* Neon Title */
.neon-title {
    font-size: 2.5rem;
    font-weight: 700;
    color: #f9feff !important;
    text-shadow: 0 0 0.3125rem #00eaff, 0 0 0.625rem #00eaff, 0 0 1.25rem #00eaff, 0 0 2.5rem #00a3cc, 0 0 5rem #00a3cc;
    animation: neon-glow 1.5s infinite alternate;
    text-align: center;
    margin-bottom: 2rem;
    letter-spacing: 0.1rem;
}

@keyframes neon-glow {
    from {
        text-shadow: 0 0 0.3125rem #00eaff, 0 0 0.625rem #00eaff, 0 0 1.25rem #00eaff, 0 0 2.5rem #00a3cc, 0 0 5rem #00a3cc;
    }
    to {
        text-shadow: 0 0 0.625rem #00eaff, 0 0 1.25rem #00eaff, 0 0 2.5rem #00a3cc, 0 0 5rem #00a3cc, 0 0 7.5rem #00a3cc;
    }
}

/* Category Grid */
.category-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
    gap: 1.5rem;
    margin-bottom: 2.5rem;
}

.category-button {
    padding: 1.25rem 1.5rem;
    background: linear-gradient(145deg, #121c33, #202b47);
    color: #00eaff;
    border: none;
    border-radius: 0.8rem;
    text-align: center;
    cursor: pointer;
    transition: transform 0.3s ease, box-shadow 0.3s ease, background 0.3s ease;
    margin-bottom: 0.5rem;
    box-shadow: 0 0.2rem 0.6rem rgba(0, 0, 0, 0.3);
    position: relative;
    overflow: hidden;
}

.category-button:hover {
    transform: translateY(-0.4rem);
    box-shadow: 0 0.5rem 1.2rem rgba(0, 234, 255, 0.4);
    background: linear-gradient(145deg, #202b47, #121c33);
}

/* Category Button Glow Effect */
.category-button::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 234, 255, 0.2);
    opacity: 0;
    transition: opacity 0.3s ease;
    border-radius: inherit;
}

.category-button:hover::before {
    opacity: 1;
    animation: glow 1s ease infinite alternate;
}

@keyframes glow {
    0% {
        opacity: 0.2;
        transform: scale(0.95);
    }
    100% {
        opacity: 0.8;
        transform: scale(1.05);
    }
}

/* Filters */
.filters {
    margin-top: 2rem;
    background: rgba(13, 27, 42, 0.8);
    backdrop-filter: blur(10px);
    padding: 1.75rem;
    border-radius: 0.8rem;
    border: 1px solid rgba(0, 234, 255, 0.1);
    color: #00eaff;
    box-shadow: 0 0.4rem 1rem rgba(0, 0, 0, 0.4);
}

.filters h3 {
    text-align: center;
    margin-bottom: 1.75rem;
    font-weight: 600;
    font-size: 1.6rem;
}

.filter-controls {
    display: flex;
    flex-wrap: wrap;
    gap: 1.25rem;
    margin-bottom: 1.25rem;
    align-items: center;
}

/* Search Bar */
.form-control {
    flex: 1;
    min-width: 150px;
    padding: 0.6rem 0.8rem;
    border: 1px solid rgba(0, 234, 255, 0.3);
    border-radius: 0.3rem;
    background: rgba(27, 38, 59, 0.6); /* Dark background */
    color: #00eaff;
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
    /* Add search icon (replace with your icon styling) */
    background-image: url("search-icon.png"); /* Replace with your icon */
    background-repeat: no-repeat;
    background-position: 0.5rem center;
    padding-left: 2.5rem; /* Adjust padding for icon */
}

.form-control:focus {
    border-color: #00c4ff;
    box-shadow: 0 0 0 0.15rem rgba(0, 196, 255, 0.25);
    outline: none;
    animation: search-focus 0.5s ease-in-out;
    background: rgba(27, 38, 59, 0.6); /* Keep dark background on focus */
    color: #00eaff; /* Keep text color on focus */
}

@keyframes search-focus {
    0% {
        box-shadow: 0 0 0 0.15rem rgba(0, 196, 255, 0.25);
    }
    100% {
        box-shadow: 0 0 0 0.25rem rgba(0, 196, 255, 0.25), 0 0 0.5rem rgba(0, 196, 255, 0.1);
    }
}


.form-control::placeholder {
    color: #00eaff;
    opacity: 0.7;
}


/* Range Input */
.form-range {
    flex: 1;
    min-width: 150px;
    background: rgba(27, 38, 59, 0.6);
    color: #00eaff;
    border: 1px solid rgba(0, 234, 255, 0.3);
    border-radius: 0.35rem;
    padding: 0.6rem;
    -webkit-appearance: none;
    height: 1.2rem;
    cursor: pointer;
}

.form-range::-webkit-slider-thumb {
    -webkit-appearance: none;
    appearance: none;
    width: 1.1rem;
    height: 1.1rem;
    background: #00c4ff;
    cursor: pointer;
    border-radius: 50%;
    border: 2px solid #fff;
    box-shadow: 0 0.15rem 0.3rem rgba(0, 0, 0, 0.2);
    transition: transform 0.2s ease;
}

.form-range::-webkit-slider-thumb:hover {
    transform: scale(1.1);
}

.price-label {
    margin-left: 0.75rem;
    color: #00eaff;
    font-weight: 500;
}

/* Console Grid */
.console-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
    gap: 1.75rem;
    margin-top: 1.75rem;
}

/* Console Card */
.console-card {
    background: linear-gradient(to bottom, #18223d, #243054);
    border-radius: 0.8rem;
    overflow: hidden;
    box-shadow: 0 0.4rem 1rem rgba(0, 0, 0, 0.4);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    transform-style: preserve-3d; /* Enable 3D transforms for perspective */
    position: relative; /* For border animation */
}

.console-card:hover {
    transform: translateY(-0.5rem) perspective(600px) rotateX(5deg) rotateY(5deg); /* Perspective tilt */
    box-shadow: 0 0.8rem 1.6rem rgba(0, 0, 0, 0.5);
}

.console-image {
    width: 100%;
    height: 14rem;
    object-fit: cover;
    opacity: 0.95;
    transition: opacity 0.2s ease-in-out;
}

.console-card:hover .console-image {
    opacity: 1;
}

.console-info {
    padding: 1.25rem;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    align-items: flex-start;
    flex-grow: 1;
}

.console-name {
    color: #00eaff;
    margin-bottom: 0.4rem;
    text-align: left;
    font-size: 1.4rem;
    font-weight: 600;
}

select.form-control { /* Target select elements with form-control class */
    appearance: none; /* Remove default select styling */
    -webkit-appearance: none; /* For Safari */
    -moz-appearance: none; /* For Firefox */
    background-image: url("dropdown-icon.png"); /* Replace with your dropdown icon */
    background-repeat: no-repeat;
    background-position: right 0.5rem center;
    padding-right: 2rem; /* Space for the icon */
}

select.form-control:focus {
    border-color: #00c4ff;
    box-shadow: 0 0 0 0.15rem rgba(0, 196, 255, 0.25);
    outline: none;
    animation: search-focus 0.5s ease-in-out;
    background: rgba(27, 38, 59, 0.6); /* Keep dark background on focus */
    color: #00eaff; /* Keep text color on focus */
}

.console-brand,
.console-price {
    color: #e0e0e0;
    margin-bottom: 0.4rem;
    font-size: 1.1rem;
    transition: color 0.3s ease; /* Price animation */
}

.console-card:hover .console-price {
    color: #fff; /* Highlight price on hover */
    animation: price-pulse 0.5s ease-in-out;
}

@keyframes price-pulse {
    0% {
        transform: scale(1);
    }
    50% {
        transform: scale(1.05);
    }
    100% {
        transform: scale(1);
    }
}

/* Console Card Border Animation */
.console-card::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    border: 2px solid transparent;
    border-radius: inherit;
    transition: border-color 0.4s ease;
    pointer-events: none; /* Don't interfere with hover */
}

.console-card:hover::after {
    border-color: rgba(0, 234, 255, 0.3); /* Animated border */
}


/* Modal Overlay */
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.95);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
    padding: 1rem;
    backdrop-filter: blur(15px);
}

/* Modal Content */
.modal-content {
    background: linear-gradient(to bottom, #18223d, #243054);
    color: #00eaff;
    padding: 1.5rem 2rem; /* Reduced padding */
    border-radius: 0.8rem;
    max-width: 450px; /* Significantly smaller width */
    width: 95%;
    text-align: center;
    border: 1px solid rgba(0, 234, 255, 0.1);
    animation: modalIn 0.5s ease-out forwards;
    box-shadow: 0 0.5rem 1.5rem rgba(0, 234, 255, 0.2),
                0 0.8rem 2.2rem rgba(0, 0, 0, 0.4);
    overflow-y: auto;
    max-height: 70vh; /* Potentially smaller height */
}

/* More Dramatic Modal Entrance */
@keyframes modalIn {
    from {
        opacity: 0;
        transform: translateY(-60px) scale(0.9);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

.modal-content h3 {
    font-size: 1.5rem; /* Slightly smaller title */
    font-weight: 700;
    margin-bottom: 1rem; /* Less bottom margin */
    text-align: center; /* Explicitly center the title */
}

.modal-content p,
.modal-content ul {
    text-align: left; /* Align details to the left */
    margin-bottom: 0.5rem; /* Reduced bottom margin */
    color: #e0e0e0;
    font-size: 0.95rem; /* Slightly smaller details text */
}

.modal-content p strong {
    font-weight: 600;
    color: #fff;
}

.modal-content ul {
    list-style: disc;
    margin-left: 1.25rem;
}

.product-image {
    max-width: 100%;
    height: auto;
    margin-bottom: 1rem; /* Reduced bottom margin */
    border: 2px solid rgba(0, 234, 255, 0.2);
    border-radius: 0.4rem;
    box-shadow: 0 0.2rem 0.5rem rgba(0, 0, 0, 0.2);
}

.close-button {
    background: linear-gradient(to right, #00c4ff, #00a3cc);
    color: #fff;
    border: none;
    padding: 0.4rem 0.8rem; /* Smaller button */
    border-radius: 0.4rem;
    cursor: pointer;
    margin-top: 0.75rem; /* Reduced top margin */
    transition: background 0.3s ease, transform 0.3s ease, box-shadow 0.3s ease;
    box-shadow: 0 0.2rem 0.4rem rgba(0, 0, 0, 0.2);
    font-size: 0.9rem; /* Smaller button text */
}

.close-button:hover {
    background: linear-gradient(to right, #00a3cc, #00c4ff);
    transform: scale(1.05);
    box-shadow: 0 0.3rem 0.6rem rgba(0, 0, 0, 0.3);
}

/* Category Highlight (Example for "Low-End") */
.category-highlight {
    background: rgba(0, 234, 255, 0.1);
    border-radius: 0.8rem;
    padding: 1.5rem;
    margin-bottom: 2rem;
    text-align: center;
    box-shadow: 0 0.4rem 1rem rgba(0, 234, 255, 0.1);
    transition: opacity 0.3s ease, transform 0.3s ease; /* Smooth transition */
}

.category-highlight h2 {
    font-size: 2rem;
    font-weight: 700;
    color: #00eaff;
    text-shadow: 0 0 0.2rem #00eaff;
    margin-bottom: 0.5rem;
}

.category-highlight p {
    color: #e0e0e0;
    font-size: 1.1rem;
}

/* Responsive Adjustments */
@media (min-width: 768px) {
    .neon-title {
        font-size: 3.5rem;
    }
}

@media (min-width: 1200px) {
    .neon-title {
        font-size: 4rem;
    }
}

/* Optional: Particle Effect (Requires JavaScript Library) */
/* This is just CSS styling; the actual particle effect requires a JavaScript library like Particles.js */
#particle-container {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: -1; /* Behind other content */
    pointer-events: none; /* Don't interfere with clicks */
    opacity: 0.1; /* Very subtle */
}

</style>
