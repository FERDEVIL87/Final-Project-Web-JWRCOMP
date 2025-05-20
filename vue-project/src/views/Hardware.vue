//DIDIT//
<template>
  <section class="container py-5">
    <h2
      class="text-center fw-bold mb-4"
      style="font-family: 'Orbitron', sans-serif; text-shadow: 0 0 8px #00eaff, 0 0 18px #00eaff; color: #fff;"
    >
      HARDWARE
    </h2>
    <!-- Kategori -->
    <div class="d-flex flex-wrap justify-content-center gap-3 mb-4">
      <button
        v-for="(card, index) in cards"
        :key="index"
        class="btn btn-outline-info px-4 py-2 fw-bold"
        :class="{
          active: selectedCategory && selectedCategory.title === card.title,
          'bg-info border-info': selectedCategory && selectedCategory.title === card.title,
          'text-white': selectedCategory && selectedCategory.title === card.title
        }"
        :style="{
          fontFamily: '\'Orbitron\', sans-serif',
          letterSpacing: '0.04em',
          color: selectedCategory && selectedCategory.title === card.title ? '#fff' : ''
        }"
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
      <div class="row g-2 align-items-center mb-3">
        <div class="col-12 col-md-4 mb-2 mb-md-0">
        <input
         type="text"
         v-model="searchQuery"
         placeholder="Search Component"
         class="form-control bg-secondary bg-opacity-25 border-info text-white"
         style="background: #222; color: #fff;"
       />
     </div>
     <div class="col-12 col-md-4 mb-2 mb-md-0">
       <select
         v-model="selectedBrand"
         class="form-select bg-secondary bg-opacity-25 border-info text-white"
         :class="{'text-white': selectedBrand === '', 'text-light': selectedBrand !== ''}"
         style="background: #222; color: #fff;"
         >
            <option value=""class="text-white"style="background: #222; color: #fff;">All Brands</option>
  <option v-for="brand in filteredBrands":key="brand":value="brand"class="text-white"style="background: #222; color: #fff;">{{ brand }}</option>
</select>
        </div>
        <div class="col-md-4">
          <select v-model="sortBy" class="form-select mb-2" style="background-color: #23272b; color: #fff; border-color: #17a2b8;">
    <option disabled value="">Urutkan</option>
    <option v-for="opt in sortOptions" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
  </select>
        </div>
      </div>
      <div class="row align-items-center mb-3">
  <div class="col-12">
    <label class="form-label text-white">Rentang Harga</label>
    <input
      type="range"
      class="form-range"
      min="0"
      :max="maxPriceInCategory"
      v-model="priceRangeUSD"
      step="50"
      style="accent-color: #00eaff;"
      @input="
        if (priceRangeUSD < minPriceInCategory) {
          priceRangeUSD = minPriceInCategory;
        } else if (priceRangeUSD > maxPriceInCategory) {
          priceRangeUSD = maxPriceInCategory;
        }
      "
    />
    <div class="d-flex justify-content-between text-white">
      <span>{{ formatPrice(minPriceInCategory) }}</span>
      <span>{{ formatPrice(maxPriceInCategory) }}</span>
    </div>
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
              <p class="fw-bold mb-0">{{ formatPrice(consoleItem.price) }}</p>
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
    <!-- Bagian ini (modal) sudah ada di dalam kodingan yang Anda berikan, jadi saya akan menggunakan yang sudah ada -->
    <!-- dan memastikan tag <section> terluar adalah yang baru -->
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
              <p class="mb-1"><strong>Price:</strong> <span>{{ formatPrice(selectedProduct?.price) }}</span></p>
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
      searchQuery: "",
      selectedBrand: "",
      priceRangeUSD: 1500,
      usdToIdrRate: 15000,
      selectedProduct: null,
      bootstrapModalInstance: null,
      hover: null,
      isModalOpen: false,

      sortBy: 'lowToHigh', // default
    sortOptions: [
      { value: 'lowToHigh', label: 'Harga Termurah' },
      { value: 'highToLow', label: 'Harga Termahal' },
      { value: 'populer', label: 'Paling Populer' },
      { value: 'tidakPopuler', label: 'Paling Tidak Populer' }
    ],

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
          name: "Intel Processor Core I5 12400F (LGA 1700) - I5 12400F",
          price: 1500000,
          brand: "Intel",
          category: "PROCESSOR INTEL",
          image: "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2022/3/14/04b612d5-3502-44d7-832f-6f461a359cef.jpg",
          specs: ["6 Cores", "12 Threads", "4.40 GHz Base Clock"],
          stock: "Kosong",
        },
        {
          id: 3,
          name: "Intel Processor Core i5-6500",
          price: 500000,
          brand: "Intel",
          category: "PROCESSOR INTEL",
          image: "https://images.tokopedia.net/img/cache/700/product-1/2018/12/15/230251/230251_97590488-d48e-406d-b7a0-f697ad0a3d9d_700_700.jpg",
          specs: ["6 Cores", "Cache 6 MB Intel Smart Cache", " 3.20 GHz Base Clock"],
          stock: "Ready",
        },
        {
          id: 4,
          name: "INTEL CORE i7 10700KF 3.8GHZ 8C/16T LGA- 1200 CL",
          price: 5000000,
          brand: "Intel",
          category: "PROCESSOR INTEL",
          image: "https://images.tokopedia.net/img/cache/700/product-1/2020/6/17/1489178/1489178_0b76eaa2-b349-4912-b2ad-b06c1e716229_640_640",
          specs: ["8 Cores", "16Threads", "5.10 GHz Base Clock"],
          stock: "Kosong",
        },
        {
          id: 5,
          name: "Intel Processor Core  i9-13900K LGA 1700",
          price: 10000000,
          brand: "Intel",
          category: "PROCESSOR INTEL",
          image: "https://kkomputer.com/7074-thickbox_default/intel-core-i9-13900k-58-ghz-24c32t-lga-1700-rl.jpg",
          specs: ["24 Cores", "32 Threads", " 5.80 GHz Base Clock"],
          stock: "Kosong",
        },
        {
          id: 6,
          name: "AMD Ryzen 5 5600X",
          price: 1500000,
          brand: "AMD",
          category: "PROCESSOR AMD",
          image: "https://btgcom.id/wp-content/uploads/2024/12/e13cd2f1-2743-4e57-ace6-afd8261a243f.jpg",
          specs: ["6 Cores", "12 Threads", "4.6 GHz Boost Clock"],
          stock: "Kosong",
        },
        {
          id: 7,
          name: "AMD Ryzen 7 5800X",
          price: 5000000,
          brand: "AMD",
          category: "PROCESSOR AMD",
          image: "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2021/12/3/5de7735d-07e1-4ab6-9b42-11eea646af5c.jpg",
          specs: ["8 Cores", "16 Threads", "4.7 GHz Boost Clock"],
          stock: "Ready",
        },
        {
          id: 8,
          name: "AMD Ryzen 9 5900X",
          price: 5000000,
          brand: "AMD",
          category: "PROCESSOR AMD",
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2023/5/10/caf83550-cdf4-4a71-9595-90c947af9d20.jpg",
          specs: ["12 Cores", "24 Threads", "4.8 GHz Boost Clock"],
          stock: "Kosong",
        },
        {
          id: 9,
          name: "AMD Ryzen 9 5950X",
          price: 7500000,
          brand: "AMD",
          category: "PROCESSOR AMD",
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2020/11/12/e509478a-9cdd-43fb-8b84-3a2abb66d9c8.jpg",
          specs: ["16 Cores", "32 Threads", "4.9 GHz Boost Clock"],
          stock: "Ready",
        },
        {
          id: 10,
          name: "AMD Ryzen Threadripper 3990X",
          price: 80000000,
          brand: "AMD",
          category: "PROCESSOR AMD",
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/6/26/88468293-d270-4ef4-8050-3e5cfb4953e1.jpg",
          specs: ["64 Cores", "128 Threads", "4.3 GHz Boost Clock"],
          stock: "Kosong",
        },
       {
          id: 11,
          name: "ASUS ROG Strix B550-F",
          price: 3500000,
          brand: "ASUS",
          category: "MAINBOARD",
          image: "https://images.tokopedia.net/img/cache/1500/VqbcmM/2022/12/10/828edbdb-4a8f-4aed-a883-d5279c056123.jpg",
          specs: ["ATX Form Factor", "PCIe 4.0", "Wi-Fi 6"],
          stock: "Ready",
        },
        {
          id: 12,
          name: "MSI MPG B550 Gaming Edge",
          price: 3500000,
          brand: "MSI",
          category: "MAINBOARD",
          image: "https://images-cdn.ubuy.co.id/63400f8cb0421f18270a1ee9-msi-mpg-b550-gaming-edge-wifi-gaming.jpg",
          specs: ["ATX Form Factor", "PCIe 4.0", "Mystic Light RGB"],
          stock: "Kosong",
        },
        {
          id: 13,
          name: "Gigabyte AORUS X570 Master",
          price: 7500000,
          brand: "Gigabyte",
          category: "MAINBOARD",
          image: "https://images.tokopedia.net/img/cache/200-square/VqbcmM/2020/10/23/ce2cbca5-605f-4f3a-b37e-19e232a8a3dc.png?ect=4g",
          specs: ["ATX Form Factor", "PCIe 4.0", "Triple M.2 Slots"],
          stock: "Kosong",
        },
        {
          id: 14,
          name: "ASRock B450M Steel Legend",
          price: 1500000,
          brand: "ASRock",
          category: "MAINBOARD",
          image: "https://images.tokopedia.net/img/cache/700/OJWluG/2022/5/25/a85d4514-73f2-4530-b03d-c3217ce83bb8.jpg",
          specs: ["Micro-ATX Form Factor", "RGB Lighting", "Dual M.2 Slots"],
          stock: "Ready",
        },
        {
          id: 15,
          name: "ASUS TUF Gaming X570-Plus",
          price: 4200000,
          brand: "ASUS",
          category: "MAINBOARD",
          image: "https://images.tokopedia.net/img/cache/1500/VqbcmM/2021/4/21/c8218740-e6d0-4776-8573-614027d09912.jpg",
          specs: ["ATX Form Factor", "PCIe 4.0", "Military-Grade Components"],
          stock: "Ready",
        },
        {
          id: 16,
          name: "Corsair Vengeance LPX 16GB",
          price: 750000,
          brand: "Corsair",
          category: "MEMORY",
          image: "https://down-id.img.susercontent.com/file/id-11134207-7r98z-lx3jjv6bua31df",
          specs: ["16GB DDR4", "3200 MHz", "CL16"],
          stock: "Kosong",
        },
        {
          id: 17,
          name: "G.Skill Trident Z RGB 32GB",
          price: 1200000,
          brand: "G.Skill",
          category: "MEMORY",
          image: "https://images-cdn.ubuy.co.id/633b290c4b62ce5d7b4599e9-g-skill-trident-z-rgb-series-32gb-2-x.jpg",
          specs: ["32GB DDR4", "3600 MHz", "RGB Lighting"],
          stock: "Kosong",
        },
        {
          id: 18,
          name: "Kingston Fury Beast 16GB",
          price: 800000,
          brand: "Kingston",
          category: "MEMORY",
          image: "https://media.kingston.com/kingston/product/FURY_Beast_Black_DDR5_1-lg.jpg",
          specs: ["16GB DDR4", "2666 MHz", "Low Profile"],
          stock: "Ready",
        },
        {
          id: 19,
          name: "TeamGroup T-Force Delta RGB 16GB",
          price: 900000,
          brand: "TeamGroup",
          category: "MEMORY",
          image: "https://images.teamgroupinc.com/products/memory/u-dimm/ddr4/delta-rgb/black/02.jpg",
          specs: ["16GB DDR4", "3200 MHz", "RGB Lighting"],
          stock: "Kosong",
        },
        {
          id: 20,
          name: "Crucial Ballistix 32GB",
          price: 7000000,
          brand: "Crucial",
          category: "MEMORY",
          image: "https://images.tokopedia.net/img/cache/700/product-1/2019/6/30/883182/883182_b487d7cb-b66a-44f6-8a65-5a7ee0422a5c_1190_1190",
          specs: ["32GB DDR4", "3600 MHz", "CL16"],
          stock: "Kosong",
        },
        {
          id: 21,
          name: "NVIDIA GeForce RTX 3080",
          price: 7000000,
          brand: "NVIDIA",
          category: "VGA",
          image: "https://images.tokopedia.net/img/cache/700/OJWluG/2022/4/5/a7dab2e5-a3e3-4885-8fd0-dce50b7c62b1.jpg",
          specs: ["10GB GDDR6X", "PCIe 4.0", "Ray Tracing"],
          stock: "Ready",
        },
        {
          id: 22,
          name: "AMD Radeon RX 6800 XT",
          price: 5600000,
          brand: "AMD",
          category: "VGA",
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/4/19/0c09209e-81bf-4f34-b466-681948976891.jpg",
          specs: ["16GB GDDR6", "PCIe 4.0", "Ray Tracing"],
          stock: "Ready",
        },
        {
          id: 23,
          name: "ASUS ROG Strix GeForce RTX 3090",
          price: 25000000,
          brand: "ASUS",
          category: "VGA",
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/1/24/64d8970a-af49-4cf5-8f36-0e55fe150ad5.jpg",
          specs: ["24GB GDDR6X", "PCIe 4.0", "RGB Lighting"],
          stock: "Kosong",
        },
        {
          id: 24,
          name: "MSI Gaming Radeon RX 6700 XT",
          price: 15500000,
          brand: "MSI",
          category: "VGA",
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgdtnfhSHu_zvuGkKXu3ay_0o6UKLPbRcW7A&s",
          specs: ["12GB GDDR6", "PCIe 4.0", "Ray Tracing"],
          stock: "Ready",
        },
        {
          id: 25,
          name: "Gigabyte AORUS GeForce RTX 3070",
          price: 5000000,
          brand: "Gigabyte",
          category: "VGA",
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/5/8/62fc76d0-bcc2-4e52-9de7-2c03f6a3f2a5.jpg",
          specs: ["8GB GDDR6", "PCIe 4.0", "RGB Lighting"],
          stock: "Kosong",
        },
       {
          id: 26,
          name: "Seagate Barracuda 2TB",
          price: 1000000,
          brand: "Seagate",
          category: "HDD",
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2021/10/6/9752c93a-00d5-4b2d-bdfe-e3711e2df674.jpg",
          specs: ["2TB", "7200 RPM", "SATA III"],
          stock: "Ready",
        },
        {
          id: 27,
          name: "Western Digital Blue 1TB",
          price: 750000, 
          brand: "Western Digital",
          category: "HDD",
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-p_F6YGp5s0wiB91yXZKs1-AN8sF9tpEKYw&s",
          specs: ["1TB", "7200 RPM", "SATA III"],
          stock: "Ready",
        },
        {
          id: 28,
          name: "Toshiba X300 4TB",
          price: 1000000,
          brand: "Toshiba",
          category: "HDD",
          image: "https://vibegaming.com.bd/wp-content/uploads/2022/05/x300-2-500x500-1.jpg.webp",
          specs: ["4TB", "7200 RPM", "SATA III"],
          stock: "Ready",
        },
        {
          id: 29,
          name: "Seagate IronWolf 8TB",
          price: 5000000,
          brand: "Seagate",
          category: "HDD",
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/6/17/5eb662b7-9fc4-433c-ae24-47e9f704b6cb.jpg",
          specs: ["8TB", "7200 RPM", "SATA III"],
          stock: "Kosong",
        },
        {
          id: 30,
          name: "Western Digital Black 6TB",
          price: 3000000,
          brand: "Western Digital",
          category: "HDD",
          image: "https://m.media-amazon.com/images/I/51L20dWXH1L._AC_UF894,1000_QL80_.jpg",
          specs: ["6TB", "7200 RPM", "SATA III"],
          stock: "Ready",
        },
        {
          id: 31,
          name: "Kingston A2000 1TB SSD",
          price: 1000000,
          brand: "Kingston",
          category: "SSD", 
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2020/11/27/0fce28a1-0f46-4058-a2f6-372b1eba830c.jpg",
          specs: ["1TB NVMe M.2", "2200 MB/s Read", "2000 MB/s Write"],
          stock: "Kosong",
        },
        {
          id: 32,
          name: "Corsair MP600 2TB SSD",
          price: 2500000,
          brand: "Corsair",
          category: "SSD", 
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2023/4/12/e3b978db-88f5-4bd0-b2cb-52eec450aec4.jpg",
          specs: ["2TB NVMe M.2", "4950 MB/s Read", "4250 MB/s Write"],
          stock: "Ready",
        },
        {
          id: 33,
          name: "Samsung 970 EVO Plus 1TB SSD",
          price: 1500000,
          brand: "Samsung",
          category: "SSD", 
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCmRvGDSBpHDJUg8sbP5lJkg2E8wgkAwllZw&s",
          specs: ["1TB NVMe M.2", "3500 MB/s Read", "3300 MB/s Write"],
          stock: "Ready",
        },
        {
          id: 34,
          name: "Crucial MX500 500GB SSD",
          price: 1500000,
          brand: "Crucial",
          category: "SSD", 
          image: "https://images.tokopedia.net/img/cache/700/product-1/2018/9/30/230251/230251_b069a363-42ac-40ab-94b7-e36b161d5a99_700_700.jpg",
          specs: ["500GB SATA III", "560 MB/s Read", "510 MB/s Write"],
          stock: "Ready",
        },
        {
          id: 35,
          name: "Western Digital Black SN850 1TB SSD",
          price: 4000000,
          brand: "Western Digital",
          category: "SSD", 
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2021/5/24/f818b5fa-860e-4701-a83e-8159e192cfe4.jpg",
          specs: ["1TB NVMe M.2", "7000 MB/s Read", "5300 MB/s Write"],
          stock: "Kosong",
        },
       {
          id: 36,
          name: "Thermaltake Toughpower GF1 750W PSU",
          price: 1500000,
          brand: "Thermaltake",
          category: "PSU",
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2023/10/20/52d45aa8-9a0a-4352-a355-e3f7510213a6.jpg",
          specs: ["750W", "80+ Gold", "Fully Modular"],
          stock: "Ready",
        },
        {
          id: 37,
          name: "Corsair RM850x PSU",
          price: 2500000,
          brand: "Corsair",
          category: "PSU",
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/8/13/cd36c7aa-62ea-459e-ad54-a69f575b2b9e.jpg",
          specs: ["850W", "80+ Gold", "Fully Modular"],
          stock: "Kosong",
        },
        {
          id: 38,
          name: "EVGA SuperNOVA 750 G5 PSU",
          price: 2000000,
          brand: "EVGA",
          category: "PSU",
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRg9vLODcfIS8ghW44La7gUXfKZ-hyaxy79g&s",
          specs: ["750W", "80+ Gold", "Fully Modular"],
          stock: "Ready",
        },
        {
          id: 39,
          name: "Seasonic Focus GX-650 PSU",
          price: 1500000,
          brand: "Seasonic",
          category: "PSU",
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/12/26/3bc4e6fb-11c0-4cf5-a774-7f08e5766016.jpg",
          specs: ["650W", "80+ Gold", "Fully Modular"],
          stock: "Kosong",
        },
        {
          id: 40,
          name: "Cooler Master MWE Gold 750 PSU",
          price: 1700000,
          brand: "Cooler Master",
          category: "PSU",
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHKSn5mY6OWL5RcKdtaOWFdgph3d8EnRXfgw&s",
          specs: ["750W", "80+ Gold", "Semi Modular"],
          stock: "Ready",
        },
        {
          id: 41,
          name: "Cooler Master MasterBox Q300L",
          price: 600000, 
          brand: "Cooler Master",
          category: "CASE",
          image: "https://images.tokopedia.net/img/cache/250-square/VqbcmM/2023/11/22/dca8903a-4514-4dc8-b186-22d233cbd952.jpg",
          specs: ["Micro-ATX", "Tempered Glass", "RGB Fans"],
          stock: "Kosong",
        },
        {
          id: 42,
          name: "NZXT H510",
          price: 700000,
          brand: "NZXT",
          category: "CASE",
          image: "https://images.tokopedia.net/img/cache/1500/VqbcmM/2022/5/3/6b555178-8136-467c-998a-c3a63648ae3e.png",
          specs: ["Mid Tower", "Tempered Glass", "Cable Management"],
          stock: "Ready",
        },
        {
          id: 43,
          name: "Fractal Design Meshify C",
          price: 1500000,
          brand: "Fractal Design",
          category: "CASE",
          image: "https://tonixcomputer.co.id/wp-content/uploads/sites/3/2020/05/Fractal-Design-Meshify-C-Dark-TG-Black.jpg",
          specs: ["Mid Tower", "Mesh Front Panel", "Good Airflow"],
          stock: "Ready",
        },
        {
          id: 44,
          name: "Lian Li PC-O11 Dynamic",
          price: 3000000,
          brand: "Lian Li",
          category: "CASE",
          image: "https://lian-li.com/wp-content/uploads/2020/11/O11D-black-side.jpg",
          specs: ["Mid Tower", "Tempered Glass", "Excellent Cooling"],
          stock: "Kosong",
        },
        {
          id: 45,
          name: "Corsair 4000D Airflow",
          price: 1500000,
          brand: "Corsair",
          category: "CASE",
          image: "https://images.tokopedia.net/img/cache/250-square/VqbcmM/2020/12/15/d2b405e9-17ae-4078-9b61-025b1b574efc.png",
          specs: ["Mid Tower", "High Airflow", "Cable Management"],
          stock: "Ready",
        },
        {
          id: 46,
          name: "LG UltraGear 27GN950-B",
          price: 10000000,
          brand: "LG",
          category: "LED MONITOR",
          image: "https://images.tokopedia.net/img/cache/700/OJWluG/2022/4/25/0cd831fc-010a-4217-a006-beb817c1491b.jpg",
          specs: ["27 inch", "4K UHD", "144Hz"],
          stock: "Kosong",
        },
        {
          id: 47,
          name: "Samsung Odyssey G7",
          price: 11000000,
          brand: "Samsung",
          category: "LED MONITOR",
          image: "https://images.tokopedia.net/img/cache/700/OJWluG/2022/4/25/546a7076-5306-45a0-aef1-818e2548a3b3.jpg",
          specs: ["27 inch", "QHD", "240Hz"],
          stock: "Ready",
        },
        {
          id: 48,
          name: "ASUS ROG Swift PG32UQX",
          price: 50000000,
          brand: "ASUS",
          category: "LED MONITOR",
          image: "https://asset-a.grid.id/crop/0x0:0x0/x/photo/2021/05/24/asus-rog-swift-pg32uqx-2jpg-20210524074323.jpg",
          specs: ["32 inch", "4K UHD", "144Hz"],
          stock: "Kosong",
        },
        {
          id: 49,
          name: "Dell Alienware AW2521H",
          price: 7870000, 
          brand: "Dell",
          category: "LED MONITOR",
          image: "https://down-id.img.susercontent.com/file/966fe424dcfdbb044ba295dc8ac53efc",
          specs: ["25 inch", "QHD", "360Hz"],
          stock: "Kosong",
        },
        {
          id: 50,
          name: "Acer Predator X27",
          price: 3000000,
          brand: "Acer",
          category: "LED MONITOR",
          image: "https://www.taiwanexcellence.org/upload/product/old/107147CA-A011.jpg",
          specs: ["27 inch", "4K UHD", "144Hz"],
          stock: "Kosong",
        },
        {
          id: 51,
          name: "Logitech G502 HERO",
          price: 1000000,
          brand: "Logitech",
          category: "MOUSE",
          image: "https://images.tokopedia.net/img/cache/700/OJWluG/2022/10/3/3ab50504-719c-4c7f-9f05-f49a473c784c.png?ect=4g",
          specs: ["16,000 DPI", "RGB Lighting", "11 Programmable Buttons"],
          stock: "Ready",
        },
        {
          id: 52,
          name: "Razer DeathAdder V2",
          price: 1500000,
          brand: "Razer",
          category: "MOUSE",
          image: "https://down-id.img.susercontent.com/file/id-11134207-7qul0-liihg5bzdj80bc",
          specs: ["20,000 DPI", "Ergonomic Design", "Razer Optical Switches"],
          stock: "Kosong",
        },
        {
          id: 53,
          name: "SteelSeries Rival 600",
          price: 2000000,
          brand: "SteelSeries",
          category: "MOUSE",
          image: "https://down-id.img.susercontent.com/file/a361dcd0991ee888080cb71fa656af47",
          specs: ["12,000 DPI", "Dual Sensor System", "Customizable Weight"],
          stock: "Ready",
        },
        {
          id: 54,
          name: "Corsair Scimitar RGB Elite",
          price: 2500000,
          brand: "Corsair",
          category: "MOUSE",
          image: "https://m.media-amazon.com/images/I/71W3rE1QjZL.jpg",
          specs: ["16,000 DPI", "12 Programmable Buttons", "RGB Lighting"],
          stock: "Kosong",
        },
        {
          id: 55,
          name: "HyperX Pulsefire FPS Pro",
          price: 1500000,
          brand: "HyperX",
          category: "MOUSE",
          image: "https://row.hyperx.com/cdn/shop/products/hyperx_pulsefire_fps_pro_1_top_down.jpg?v=1662449658",
          specs: ["16,000 DPI", "RGB Lighting", "Omron Switches"],
          stock: "Ready",
        },
        {
          id: 56,
          name: "Logitech G Pro X Keyboard",
          price: 2000000,
          brand: "Logitech",
          category: "KEYBOARD",
          image: "https://images.tokopedia.net/img/cache/700/OJWluG/2022/10/25/293c72e4-a4a3-45e7-8bf3-be487280f621.jpg",
          specs: ["Mechanical", "RGB Lighting", "Customizable Switches"],
          stock: "Ready",
        },
        {
          id: 57,
          name: "Razer Huntsman Elite",
          price: 2500000,
          brand: "Razer",
          category: "KEYBOARD",
          image: "https://down-id.img.susercontent.com/file/0309416d7621dcf00228de8e1203c38f",
          specs: ["Opto-Mechanical", "RGB Lighting", "Wrist Rest"],
          stock: "Kosong",
        },
        {
          id: 58,
          name: "Corsair K95 RGB Platinum",
          price: 3000000,
          brand: "Corsair",
          category: "KEYBOARD",
          image: "https://images.tokopedia.net/img/cache/700/hDjmkQ/2024/3/5/16cc70bf-81f3-4372-9ba4-6134911894b2.jpg",
          specs: ["Mechanical", "RGB Lighting", "Macro Keys"],
          stock: "Ready",
        },
        {
          id: 59,
          name: "SteelSeries Apex Pro TKL",
          price: 2000000,
          brand: "SteelSeries",
          category: "KEYBOARD",
          image: "https://images.tokopedia.net/img/cache/700/OJWluG/2022/10/25/2eddc0ff-fa41-4b03-b0d0-0d6804ee4b74.jpg?ect=4g",
          specs: ["Mechanical", "RGB Lighting", "Adjustable Actuation"],
          stock: "Kosong",
        },
          {
          id: 60,
          name: "Fantech MAXFIT61",
          price: 2000000,
          brand: "Fantech",
          category: "KEYBOARD",
          image: "https://images.tokopedia.net/img/cache/700/OJWluG/2022/10/25/e01c9a3c-d0aa-46b2-8159-6bb975287fa9.jpg",
          specs: ["Mechanical", "RGB Lighting", "Adjustable Actuation"],
          stock: "Kosong",
        },
          {
          id: 61,
          name: "SteelSeries QcK Medium",
          price: 200000, 
          brand: "SteelSeries",
          category: "MOUSEPAD",
          image: "https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//93/MTA-21976221/steelseries_steelseries_qck_black_medium_full01_sy82ne0t.jpg",
          specs: [" Kain mikrotenun (micro-woven cloth)", "Karet anti-slip", "2 mm"],
          stock: "Kosong",
        },
          {
          id: 62,
          name: "Rexus Kvlar T10",
          price: 150000, 
          brand: "Rexus",
          category: "MOUSEPAD",
          image: "https://rexus.id/cdn/shop/files/KVLAR_T10_2_6ecb76c5-2820-4aba-915e-59da7af3cded.png?v=1706094061",
          specs: ["300 x 250 mm", "Tekstur speed control", "3 mm"],
          stock: "Kosong",
        },
          {
          id: 63,
          name: "Razer Goliathus Extended Chroma",
          price: 700000, 
          brand: "Razer",
          category: "MOUSEPAD",
          image: "https://down-id.img.susercontent.com/file/5f5a3cec064cf9e5088f820bac340c4e",
          specs: ["920 x 294 mm (Extended)", "Soft micro-textured cloth", "Rubber anti-slip"],
          stock: "Kosong",
        },
          {
          id: 64,
          name: "Fantech MP80 Sakura Edition",
          price: 120000, 
          brand: "Fantech",
          category: "MOUSEPAD",
          image: "https://www.radiancecomputer.com/wp-content/uploads/2021/07/FIREFLY-MPR800s-SAKURA-EDITION.png",
          specs: ["800 x 300 mm", "Smooth surface (speed-type)", "Anti-slip rubber base"],
          stock: "Kosong",
        },
          {
          id: 65,
          name: "Logitech G640",
          price: 400000, 
          brand: "Logitech",
          category: "MOUSEPAD",
          image: "https://down-id.img.susercontent.com/file/ff24ec78f56dfd7696e2f0fc53aaa8ea",
          specs: ["460 x 400 mm", "Karet natural", "3 mm"],
          stock: "Kosong",
        },
          {
          id: 66,
          name: "Logitech C920 HD Pro",
          price: 800000, 
          brand: "Logitech",
          category: "WEBCAM",
          image: "https://images.tokopedia.net/img/cache/700/OJWluG/2022/9/21/15f7411b-c9c0-4563-b9af-2bfbae5cb7bc.jpg",
          specs: ["Full HD 1080p @ 30 fps", "Glass lens", "FOV (Field of View) 78°"],
          stock: "Kosong",
        },
          {
          id: 67,
          name: "Rexus RCX-999",
          price: 250000, 
          brand: "Rexus",
          category: "WEBCAM",
          image: "https://cdn.shopify.com/s/files/1/0601/6784/7989/files/WhatsApp-Image-2020-06-05-at-19.00.52-1-1080x630_480x480.jpg?v=1709367955",
          specs: ["1080p @ 30 fps", "Fixed focus", "Plug & Play, built-in mic, tripod stand"],
          stock: "Kosong",
        },
          {
          id: 68,
          name: "AverMedia PW313 Live Streamer CAM",
          price: 900000, 
          brand: "AverMedia",
          category: "WEBCAM",
          image: "https://plazakamera.com/wp-content/uploads/2019/09/Jual-AVerMedia-PW313-Live-Streamer-CAM-313-Harga-Terbaik-dan-Spesifikasi.jpg",
          specs: ["Full HD 1080p @ 30 fps", "Fixed focus", "FOV: 65°"],
          stock: "Kosong",
        },
          {
          id: 69,
          name: "Xiaomi IMILAB 1080p Webcam W88S",
          price: 300000, 
          brand: "Xiaomi", 
          category: "WEBCAM",
          image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcqEHoxGUUGfZHCaBUwhIQcUS9alkvDpkBmw&s",
          specs: ["1080p @ 30 fps", "Fixed focus", "FOV: 90°"],
          stock: "Kosong",
        },
          {
          id: 70,
          name: "Logitech Brio 4K",
          price: 3500000, 
          brand: "Logitech", 
          category: "WEBCAM",
          image: "https://aputure.co.id/image/cache/Abc/Logitech/Logitech%20Brio%204k%20Ultra%20HD%20Business%20Webcam-600x600.jpg",
          specs: ["Up to 4K @ 30 fps, 1080p @ 60 fps", "Glass lens, autofocus", "FOV: 65°, 78°, atau 90° (adjustable)"],
          stock: "Kosong",
        },
          {
          id: 71,
          name: "UGREEN USB-C to USB-C PD 100W Cable",
          price: 150000, 
          brand: "UGREEN",
          category: "CABLE",
          image: "https://down-id.img.susercontent.com/file/id-11134207-7r98z-lsfofqet913h90",
          specs: ["USB Type-C to Type-C", "1 meter", "Up to 480 Mbps (USB 2.0)"],
          stock: "Kosong",
        },
          {
          id: 72,
          name: "Vention HDMI 2.0 Cable 4K 60Hz",
          price: 80000, 
          brand: "Vention",
          category: "CABLE",
          image: "https://www.vention.id/wp-content/uploads/2021/11/%E7%99%BD%E5%BA%95-9.jpg",
          specs: ["HDMI Male to Male", "2 meter", "4K @ 60Hz"],
          stock: "Kosong",
        },
          {
          id: 73,
          name: "Anker PowerLine Micro USB Cable",
          price: 120000, 
          brand: "Anker",
          category: "CABLE",
          image: "https://down-id.img.susercontent.com/file/57ece4f020fda8ad41210f25346323a0",
          specs: ["USB-A to Micro USB", "0.9 meter", "Tahan lebih dari 10.000x tekukan, fast charge"],
          stock: "Kosong",
        },
          {
          id: 74,
          name: "Orico CAT6 Ethernet LAN Cable",
          price: 50000, 
          brand: "Orico",
          category: "CABLE",
          image: "https://media.dinomarket.com/docs/imgTD/2020-06/_SMine_1591166906725_030620130627_ll.jpg.jpg",
          specs: ["RJ45 to RJ45 (CAT6)", "3 meter", "Up to 1 Gbps"],
          stock: "Kosong",
        },
          {
          id: 75,
          name: "Baseus 3-in-1 Cable (USB-A to Micro/Type-C/Lightning)",
          price: 180000, 
          brand: "Baseus", 
          category: "CABLE",
          image: "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2023/3/7/4669bcf7-2170-410b-aee3-1e56c6267014.jpg",
          specs: ["Multi-charging cable", "1.2 meter", "3.5A (total)"],
          stock: "Kosong",
        },
          {
          id: 76,
          name: "Razer BlackShark V2 X",
          price: 800000, 
          brand: "Razer",
          category: "HEADSET",
          image: "https://cdnpro.eraspace.com/media/catalog/product/r/a/razer_headset_blackshark_v2_x_usb_black1.jpg",
          specs: ["Wired Gaming Headset", "50mm Razer TriForce", "3.5mm jack"],
          stock: "Kosong",
        },
          {
          id: 77,
          name: "Fantech HG23 Octane",
          price: 350000, 
          brand: "Fantech",
          category: "HEADSET",
          image: "https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//88/MTA-41624006/fantech_headset-gaming-fantech-octane-7-1-hg23-rgb_full01.jpg",
          specs: ["Wired Gaming Headset", "50mm", "Flexible omnidirectional mic"],
          stock: "Kosong",
        },
          {
          id: 78,
          name: "Logitech H390",
          price: 400000, 
          brand: "Logitech",
          category: "HEADSET",
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2020/10/9/d33a7db3-0216-465a-a7f6-94cce9bd9443.jpg",
          specs: ["Wired Office Headset", "Standard digital audio", "USB-A"],
          stock: "Kosong",
        },
          {
          id: 79,
          name: "JBL Quantum 100",
          price: 500000, 
          brand: "JBL",
          category: "HEADSET",
          image: "https://jblstore.co.id/wp-content/uploads/2024/02/JBL2520Quantum2520100_Black_mhln7ty3j.jpg",
          specs: ["Wired Gaming Headset", "40mm", "3.5mm jack"],
          stock: "Kosong",
        },
          {
          id: 80,
          name: "Sony WH-CH520",
          price: 700000, 
          brand: "Sony",
          category: "HEADSET",
          image: "https://main.mobile.doss.co.id/storage/uploads/2023/03/sony-wh-ch520-wireless-on-ear-headphones-with-microphone-beige12.webp",
          specs: ["Wireless Bluetooth Headset (On-ear)", "30mm", "Bluetooth 5.2"],
          stock: "Kosong",
        },
          {
          id: 81,
          name: "Logitech Z313 Speaker System",
          price: 500000, 
          brand: "Logitech",
          category: "SPEAKER",
          image: "https://images.tokopedia.net/img/cache/700/product-1/2018/4/25/27492617/27492617_f14a28ce-bc7c-4e1e-a47a-8e7ff400e5a8_800_800.jpeg",
          specs: ["2.1 Speaker (2 satelit + 1 subwoofer)", "25W RMS", "3.5mm jack"],
          stock: "Kosong",
        },
          {
          id: 82,
          name: "Anker Soundcore 3",
          price: 700000, 
          brand: "Anker",
          category: "SPEAKER",
          image: "https://images-cdn.ubuy.co.id/642487afecd1de5e20472ad8-soundcore-3-by-anker-bluetooth-speaker.jpg",
          specs: ["Portable Bluetooth Speaker", "16W", "Bluetooth 5.0, AUX-in"],
          stock: "Kosong",
        },
          {
          id: 83,
          name: "Advance M180BT",
          price: 250000, 
          brand: "Advance",
          category: "SPEAKER",
          image: "https://datascripmall.id/media/webp_image/catalog/product/cache/95a5307f46190cd7a50cf0819ebeb220/m/1/m180bt_1.webp",
          specs: ["2.1 Multimedia Speaker", "±20W total", "Bluetooth, USB, SD card, AUX, FM"],
          stock: "Kosong",
        },
          {
          id: 84,
          name: "Xiaomi Mi Portable Bluetooth Speaker (16W)",
          price: 600000, 
          brand: "Xiaomi",
          category: "SPEAKER",
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2021/6/10/81245696-4665-45e6-bddc-0ed49fc20a17.jpg",
          specs: ["Bluetooth Speaker", "16W", "Bluetooth 5.0, AUX"],
          stock: "Kosong",
        },
          {
          id: 85,
          name: "Sony SRS-XB13",
          price: 750000, 
          brand: "Sony",
          category: "SPEAKER",
          image: "https://www.sony.co.id/image/719c2a02e7e884e3fa1421195a8193d2?fmt=jpeg&wid=960&qlt=43",
          specs: ["Portable Bluetooth Speaker", "Daya Output: Sekitar 5W", "Bluetooth 5.0, USB-C charging"],
          stock: "Kosong",
        },
          {
          id: 86,
          name: "SanDisk Ultra Flair USB 3.0",
          price: 120000, 
          brand: "SanDisk",
          category: "USB FLASHDISK",
          image: "https://media.dinomarket.com/docs/imgTD/2019-02/CZ7364GB_110219150238_ll.jpg.jpg",
          specs: ["64GB", "USB 3.0 (kompatibel USB 2.0)", "Baca: Hingga 150 MB/s"],
          stock: "Kosong",
        },
          {
          id: 87,
          name: "Kingston DataTraveler Exodia",
          price: 150000, 
          brand: "Kingston",
          category: "USB FLASHDISK",
          image: "https://media.kingston.com/kingston/product/ktc-product-usb-dtxon-128gb-3-zm-lg.jpg",
          specs: ["128GB", "USB 3.2 Gen 1", "±100 MB/s baca"],
          stock: "Kosong",
        },
          {
          id: 88,
          name: "Toshiba TransMemory U202",
          price: 70000, 
          brand: "Toshiba",
          category: "USB FLASHDISK",
          image: "https://plazait.co.id/wp-content/uploads/2024/04/UFD-Toshiba-Hayabusa-32GB-U202-Trans-Memory-White-2.0-1-jpg.webp",
          specs: ["32GB", "USB 2.0", "±18 MB/s baca"],
          stock: "Kosong",
        },
          {
          id: 89,
          name: "VIVAN Dual OTG USB",
          price: 130000, 
          brand: "VIVAN",
          category: "USB FLASHDISK",
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2023/8/26/cdcd2847-d0bd-4303-9397-97f8aebc0ce1.jpg",
          specs: ["64GB", "USB 3.0 (Type-A) & USB-C", "Dual konektor, cocok untuk HP dan laptop"],
          stock: "Kosong",
        },
          {
          id: 90,
          name: "HP x796w USB 3.1",
          price: 250000, 
          brand: "HP",
          category: "USB FLASHDISK",
          image: "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2022/6/9/45da5336-104a-46a5-bbe5-ce21739cae8e.jpg",
          specs: ["256GB", "USB 3.1", "Hingga 200 MB/s"],
          stock: "Kosong",
        },
           {
          id: 91,
          name: "Canon PIXMA G2020",
          price: 1800000, 
          brand: "Canon",
          category: "PRINTER",
          image: "https://down-id.img.susercontent.com/file/3635968d44a5e4e8c622a67e9d751a50",
          specs: ["Ink Tank All-in-One (Print, Scan, Copy)", "Inkjet", "Resolusi Cetak Hingga 4800 x 1200 dpi"],
          stock: "Kosong",
        },
           {
          id: 92,
          name: "Epson L3250",
          price: 2500000, 
          brand: "Epson",
          category: "PRINTER",
          image: "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/11/2/3e513464-ae91-43e6-9923-d9c1de986ae1.jpg",
          specs: ["Tipe Wireless Ink Tank All-in-One", "Teknologi Inkjet", "Resolusi Cetak Hingga 5760 x 1440 dpi"],
          stock: "Kosong",
        },
           {
          id: 93,
          name: "HP LaserJet Pro M15w",
          price: 1500000, 
          brand: "HP",
          category: "PRINTER",
          image: "https://manuals.plus/wp-content/uploads/2023/07/HP-M15w-LaserJet-Pro-Wireless-Monochrome-Printer-Featured-1-scaled.jpg",
          specs: ["Tipe Monochrome Laser Printer (Print Only)", "Kecepatan Cetak Hingga 19 ppm", "Resolusi 600 x 600 dpi"],
          stock: "Kosong",
        },
           {
          id: 94,
          name: "Brother DCP-T420W",
          price: 2200000, 
          brand: "Brother",
          category: "PRINTER",
          image: "https://els.id/wp-content/uploads/2023/09/Brother-DCP-T420W-3.jpg",
          specs: ["Tipe Ink Tank All-in-One (Print, Scan, Copy)", "Teknologi Inkjet", "Resolusi 1200 x 6000 dpi"],
          stock: "Kosong",
        },
           {
          id: 95,
          name: "Canon PIXMA MG2570S",
          price: 700000, 
          brand: "Canon",
          category: "PRINTER",
          image: "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2021/7/21/76b548a3-d621-4f5b-966b-b057729ade33.jpg",
          specs: ["Tipe Inkjet All-in-One (Print, Scan, Copy)", "Resolusi Hingga 4800 x 600 dpi", "Fitur Ukuran compact, hemat untuk pemakaian ringan"],
          stock: "Kosong",
        },
      ],
    };
  },
  computed: {
    consoles() {
      // Gunakan data dari components agar tetap konsisten
      return this.components;
    },
    brands() {
      if (!this.selectedCategory) return [];
      const consolesInCategory = this.consoles.filter(c => c.category === this.selectedCategory.title);
      return [...new Set(consolesInCategory.map(c => c.brand))].sort();
    },
    filteredBrands() {
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
      if (this.sortBy === 'highToLow') {
        filtered.sort((a, b) => b.price - a.price);
      } else if (this.sortBy === 'populer') {
        // Implementasi logika untuk menyortir berdasarkan popularitas
        // Misalnya, berdasarkan jumlah terjual atau rating
        // Untuk saat ini, kita anggap semua item memiliki tingkat popularitas yang sama
        filtered.sort(() => Math.random() - 0.5); // Acak urutan sebagai placeholder
      } else if (this.sortBy === 'tidakPopuler') {
        // Implementasi logika untuk menyortir berdasarkan tidak populernya
        // Misalnya, berdasarkan jumlah stok atau tanggal ditambahkan
        // Untuk saat ini, kita anggap semua item memiliki tingkat tidak populer yang sama
        filtered.sort(() => Math.random() - 0.5); // Acak urutan sebagai placeholder
      }
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
    },
    minPriceInCategory() {
  if (!this.selectedCategory) return 50;
  const consolesInCategory = this.consoles.filter(
    c => c.category === this.selectedCategory.title
  );
  if (consolesInCategory.length === 0) return 50;
  const minPrice = Math.min(...consolesInCategory.map(c => c.price));
  return minPrice > 0 ? Math.floor(minPrice / 50) * 50 : 50;
},
  },
  methods: {
    selectCategory(category) {
      this.selectedCategory = category;
      this.searchQuery = "";
      this.selectedBrand = "";
      this.$nextTick(() => {
        this.priceRangeUSD = this.maxPriceInCategory;
      });
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
    this.isModalOpen = true;
    if (this.bootstrapModalInstance) this.bootstrapModalInstance.show();
  },
    closeDetails() {
    this.isModalOpen = false;
    if (this.bootstrapModalInstance) this.bootstrapModalInstance.hide();
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
  // ...existing code...
watch: {
  selectedCategory(newCategory, oldCategory) {
    if (newCategory !== oldCategory) {
      this.$nextTick(() => {
        this.priceRangeUSD = this.maxPriceInCategory;
      });
    }
  },
  minPriceInCategory(val) {
    if (this.priceRangeUSD < val) {
      this.priceRangeUSD = val;
    }
  },
  maxPriceInCategory(val) {
    if (this.priceRangeUSD > val) {
      this.priceRangeUSD = val;
    }
  },
  priceRangeUSD(val) {
    // Batasi agar tidak keluar dari range min-max
    if (val < this.minPriceInCategory) {
      this.priceRangeUSD = this.minPriceInCategory;
    } else if (val > this.maxPriceInCategory) {
      this.priceRangeUSD = this.maxPriceInCategory;
    }
  }
},
};
</script>

<style>
/* Blur hanya pada backdrop modal Bootstrap */
.modal-backdrop.show {
  backdrop-filter: blur(150px);
  background: rgba(16, 24, 41, 0.25) !important;
  transition: backdrop-filter 0.3s;
}


input::placeholder,
input.text-white::placeholder {
  color: #fff !important;
  opacity: 1;
}
</style>
