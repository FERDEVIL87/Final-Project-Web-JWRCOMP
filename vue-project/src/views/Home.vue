<script setup>
import { ref, computed } from 'vue';
import 'vue3-carousel/dist/carousel.css';
import { Carousel, Slide, Pagination, Navigation } from 'vue3-carousel';

const products = ref([
  {
    id: 1,
    brand: "ROG RYUO IV",
    name: "SLC 360 ARGB",
    slogan: "A NEW VISION OF COOLING",
    imageSrc: "https://dlcdnwebimgs.asus.com/files/media/d3b46fd8-035f-41c1-a995-2dca5a228e9b/v1/img/gallery/2.jpg",
    features: [
      "High-Performance Pump",
      "Extraordinary Visuals",
      "Attention to Detail",
    ],
    badges: [
      { text: "6", subtext: "YEAR WARRANTY" },
      { text: "Intel", subtext: "LGA 1851", detail: "Compatible" },
      { text: "AMD", subtext: "AM5", detail: "Compatible" },
      { text: "Curve", subtext: "6.5\"", detail: "" },
      { text: "AMOLED", subtext: "2K 60HZ", detail: "" },
      { text: "Daisy Chainable Fan", subtext: "", icon: 'fan' },
    ],
    backgroundColor: "linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%)",
    accentColor: "#e94560",
  },
  {
  id: 2,
  brand: "ASUS TUF Gaming",
  name: "TUF Gaming A15 (2024)",
  slogan: "GEARED FOR SERIOUS GAMING AND REAL-WORLD DURABILITY",
  imageSrc: "https://dlcdnwebimgs.asus.com/gain/49bac8ff-76c9-45b5-846c-057f79c30c8b/asus-tuf-gaming-a15-fa507uv-product-photo.png",
  features: [
    "Latest AMD Ryzen CPU & NVIDIA GPU",
    "Blazing-Fast NVMe SSD",
    "Customizable RGB Keyboard",
    "Self-Cleaning Cooling 2.0",
    "MIL-STD-810H Durability"
  ],
  badges: [
    { text: "2", subtext: "YEAR WARRANTY" },
    { text: "NVIDIA", subtext: "RTX 4060" },
    { text: "AMD", subtext: "Ryzen 7 8000 Series" },
    { text: "16GB", subtext: "DDR5 RAM" },
    { text: "1TB", subtext: "NVMe SSD" },
    { text: "15.6\"", subtext: "FHD 144Hz" }
  ],
  backgroundColor: "linear-gradient(135deg, #1e272e 0%, #2c3a47 50%, #1e272e 100%)",
  accentColor: "#FFC107"
  },
  {
  id: 3,
  brand: "Corsair",
  name: "K70 RGB MK.2",
  slogan: "BUILT TO LAST. PERFORM LIKE A LEGEND.",
  imageSrc: "https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Gaming-Keyboards/CH-9109012-NA/Gallery/K70_RGB_MK2_02.webp",
  features: [
    "Genuine Cherry MX Switches",
    "Dynamic Per-Key RGB Backlighting",
    "Aircraft-Grade Aluminum Frame",
    "8MB Profile Storage",
    "Dedicated Multimedia Controls"
  ],
  badges: [
    { text: "2", subtext: "YEAR WARRANTY" },
    { text: "Cherry MX", subtext: "Red Switches" },
    { text: "iCUE", subtext: "Software Control" },
    { text: "100%", subtext: "Anti-Ghosting" },
    { text: "USB", subtext: "Passthrough Port" }
  ],
  backgroundColor: "linear-gradient(135deg, #0A0A0A 0%, #1A1A1A 50%, #0A0A0A 100%)",
  accentColor: "#FFD700"
}
]);

const carouselSettings = {
  itemsToShow: 1,
  snapAlign: 'center',
};
const carouselBreakpoints = {
  700: {
    itemsToShow: 1,
    snapAlign: 'center',
  },
  1024: {
    itemsToShow: 1,
    snapAlign: 'start',
  },
};

const currentSlideAccentColor = ref(products.value[0].accentColor);
const onSlideChange = (data) => {
  currentSlideAccentColor.value = products.value[data.currentSlideIndex].accentColor;
};
</script>

<template>
  <div> <!-- Main wrapper for the entire page content -->

    <!-- NEW Video Hero Section -->
    <section class="video-hero-section">
      <video autoplay muted loop playsinline class="hero-background-video" poster="data:image/gif;base64,R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="> <!-- Simple black poster -->
        <source src="https://assets.corsair.com/video/upload/f_auto,ac_none/q_75/Homepage%20Assets/Hero-Banners/doom-crop.mp4" type="video/mp4">
        Your browser does not support the video tag.
      </video>
      <div class="hero-content-overlay">
        <div class="hero-text-container">
          <h1>ENTER THE DARK AGES</h1>
          <p>OFFICIAL LICENSED GAMING AND STREAMING HARDWARE</p>
          <a href="#product-carousel-starts" class="shop-now-button">SHOP NOW</a>
        </div>
      </div>
    </section>
    <!-- END NEW Video Hero Section -->

    <section class="product-hero-slider" id="product-carousel-starts">
      <Carousel
        :settings="carouselSettings"
        :breakpoints="carouselBreakpoints"
        :wrap-around="true"
        :autoplay="5000"
        @slide-start="onSlideChange"
        :style="{'--slide-accent-color': currentSlideAccentColor }"
      >
        <Slide v-for="product in products" :key="product.id">
          <div class="carousel__item" :style="{ background: product.backgroundColor }">
            <div class="product-slide-content container">
              <div class="product-text-info">
                <h3 class="product-brand" :style="{ color: product.accentColor }">{{ product.brand }}</h3>
                <h1 class="product-name">{{ product.name }}</h1>
                <p class="product-slogan">{{ product.slogan }}</p>
                <ul class="product-features">
                  <li v-for="feature in product.features" :key="feature">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-lg" viewBox="0 0 16 16" :style="{ color: product.accentColor }">
                      <path d="M12.736 3.97a.733.733 0 0 1 1.047 0c.286.289.29.756.01 1.05L7.88 12.01a.733.733 0 0 1-1.065.02L3.217 8.384a.757.757 0 0 1 0-1.06.733.733 0 0 1 1.047 0l3.052 3.093 5.4-6.425z"/>
                    </svg>
                    {{ feature }}
                  </li>
                </ul>
              </div>

              <div class="product-image-container">
                <img :src="product.imageSrc" :alt="product.name" class="product-image" />
              </div>

              <div class="product-badges-container">
                <div v-for="badge in product.badges" :key="badge.text + badge.subtext" class="product-badge">
                  <div v-if="badge.icon === 'fan'" class="badge-icon-fan">
                    <svg viewBox="0 0 24 24" fill="currentColor" width="24" height="24"><path d="M12 2c-5.52 0-10 4.48-10 10s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm-1-3.79V8.5c0-.28.22-.5.5-.5s.5.22.5.5v7.71c2.42-.95 4-3.27 4-5.96 0-.28-.22-.5-.5-.5s-.5.22-.5.5c0 2.21-1.79 4-4 4s-4-1.79-4-4c0-.28-.22-.5-.5-.5s-.5.22-.5.5c0 2.69 1.58 5.01 4 5.96zM8.75 12.5c.28 0 .5-.22.5-.5V8c0-2.21 1.79-4 4-4s4 1.79 4 4v4c0 .28-.22-.5-.5-.5s-.5-.22-.5-.5V8c0-1.65-1.35-3-3-3s-3 1.35-3 3v4c0 .28-.22-.5-.5-.5s-.5-.22-.5-.5z"/></svg>
                  </div>
                  <span class="badge-main-text">{{ badge.text }}</span>
                  <span class="badge-subtext">{{ badge.subtext }}</span>
                  <span v-if="badge.detail" class="badge-detail">{{ badge.detail }}</span>
                </div>
              </div>
            </div>
          </div>
        </Slide>

        <template #addons>
          <Navigation />
          <Pagination />
        </template>
      </Carousel>
    </section>

    <!-- Store Information Section STARTS HERE -->
    <section class="store-info-section">
      <div class="container store-info-container"> 
        <h2 class="section-title store-section-title">Welcome to YourTech Haven</h2>
        <p class="section-subtitle store-section-subtitle">
          Your premier destination for cutting-edge hardware, expert advice, and unparalleled gaming experiences.
        </p>

        <div class="info-grid">
          <div class="info-block">
            <h3><i class="icon-store"></i>About Us</h3>
            <p>We are a team of passionate tech enthusiasts and gamers dedicated to bringing you the best components, peripherals, and custom-built systems. Our mission is to empower your digital life, whether for gaming, creation, or professional work.</p>
          </div>

          <div class="info-block">
            <h3><i class="icon-pin"></i>Visit Our Store</h3>
            <p><strong>Address:</strong> 123 Tech Nebula Drive, Silicon City, TX 75001</p>
            <p><strong>Phone:</strong> <a href="tel:+1555TECHNOW">(555) 832-4669</a></p>
            <p><strong>Email:</strong> <a href="mailto:support@yourtechhaven.com">support@yourtechhaven.com</a></p>
          </div>

          <div class="info-block">
            <h3><i class="icon-clock"></i>Opening Hours</h3>
            <p><strong>Monday - Friday:</strong> 9:00 AM - 8:00 PM</p>
            <p><strong>Saturday:</strong> 10:00 AM - 7:00 PM</p>
            <p><strong>Sunday:</strong> 12:00 PM - 5:00 PM</p>
          </div>

          <div class="info-block">
            <h3><i class="icon-services"></i>Our Services</h3>
            <ul>
              <li>Custom PC Building</li>
              <li>Hardware Upgrades & Installation</li>
              <li>Diagnostics & Repair</li>
              <li>Expert Technical Support</li>
              <li>Gaming Lounges (Coming Soon!)</li>
            </ul>
          </div>
        </div>

        <div class="map-social-container">
          <div class="map-placeholder">
            <h4><i class="icon-map"></i>Our Location</h4>
            <div class="map-embed-placeholder">
              <span>Interactive Map (Placeholder)</span>
              <p>Find us easily in the heart of Silicon City!</p>
            </div>
          </div>
          <div class="social-links">
              <h4><i class="icon-connect"></i>Connect With Us</h4>
              <a href="#" aria-label="Facebook"><i class="icon-facebook"></i></a>
              <a href="#" aria-label="Twitter"><i class="icon-twitter"></i></a>
              <a href="#" aria-label="Instagram"><i class="icon-instagram"></i></a>
              <a href="#" aria-label="Discord"><i class="icon-discord"></i></a>
          </div>
        </div>

      </div>
    </section>
    <!-- Store Information Section ENDS HERE -->

  </div>
</template>

<style scoped>
/* Import Google Fonts */
@import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Roboto:wght@300;400;700&display=swap');

/* Styles for NEW Video Hero Section */
.video-hero-section {
  position: relative;
  height: 100vh; 
  width: 100%;
  overflow: hidden; 
  display: flex;
  flex-direction: column; /* Stack children vertically */
  justify-content: flex-end; /* Push content to the bottom */
  align-items: center; /* Keep content horizontally centered */
  text-align: center;
  background-color: #05050a; 
  padding-bottom: 12vh; /* ADJUSTED: Space from the very bottom */
}

.hero-background-video {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: cover; 
  z-index: 1; 
  filter: brightness(0.6); 
}

.hero-content-overlay {
  position: relative; 
  z-index: 2; 
  padding: 20px;
  width: 100%; /* Allow it to be centered */
  max-width: 800px; /* Optional: constrain width of text block */
}

.hero-text-container {
  /* margin-top: 8vh; REMOVED - positioning handled by parent flexbox */
}

.hero-text-container h1 {
  font-family: 'Orbitron', sans-serif;
  font-size: clamp(2.8rem, 7vw, 4.5rem);
  font-weight: 900;
  color: #FFFFFF;
  text-transform: uppercase;
  margin-bottom: 15px;
  letter-spacing: 2px;
  text-shadow: 2px 2px 8px rgba(0,0,0,0.8), 0 0 10px rgba(0,0,0,0.5); 
}

.hero-text-container p {
  font-family: 'Roboto', sans-serif;
  font-size: clamp(0.8rem, 2vw, 1.1rem);
  color: #E0E0E0;
  margin-bottom: 35px;
  text-transform: uppercase;
  letter-spacing: 1px;
  font-weight: 400;
  max-width: 600px; 
  margin-left: auto;
  margin-right: auto;
  text-shadow: 1px 1px 6px rgba(0,0,0,0.7), 0 0 5px rgba(0,0,0,0.4); 
}

.shop-now-button {
  display: inline-block;
  background-color: #FDE047; 
  color: #111827; 
  padding: 14px 35px;
  font-family: 'Orbitron', sans-serif; 
  font-weight: 700;
  font-size: clamp(0.9rem, 1.8vw, 1.1rem);
  text-decoration: none;
  text-transform: uppercase;
  border-radius: 4px;
  border: none;
  transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
  box-shadow: 0 4px 15px rgba(0,0,0,0.2);
  letter-spacing: 1px;
  cursor: pointer;
}

.shop-now-button:hover, .shop-now-button:focus {
  background-color: #FACC15; 
  color: #000000;
  transform: translateY(-3px) scale(1.03);
  box-shadow: 0 6px 20px rgba(253, 224, 71, 0.4), 0 0 15px rgba(250, 204, 21, 0.3);
  outline: none;
}


/* Styles for Product Hero Slider */
.product-hero-slider {
  width: 100%;
  height: 100vh; 
  font-family: 'Roboto', sans-serif;
  background-color: #0a0a12;
}

.carousel__item {
  min-height: 100vh;
  width: 100%;
  color: #fff;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
}

.product-slide-content { 
  display: grid;
  grid-template-columns: 1fr 1.2fr;
  grid-template-rows: auto 1fr auto;
  grid-template-areas:
    "text image"
    "text image"
    "badges badges";
  align-items: center;
  gap: 20px;
  padding: 40px 20px;
  width: 100%;
  max-width: 1400px;
  margin: 0 auto;
  height: 100%;
  box-sizing: border-box;
}

.product-text-info {
  grid-area: text;
  text-align: left;
  padding-right: 30px;
  animation: fadeInFromLeft 0.8s ease-out forwards;
}

@keyframes fadeInFromLeft {
  from { opacity: 0; transform: translateX(-50px); }
  to { opacity: 1; transform: translateX(0); }
}

.product-brand {
  font-family: 'Orbitron', sans-serif;
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 5px;
  letter-spacing: 1px;
  text-transform: uppercase;
}

.product-name {
  font-family: 'Orbitron', sans-serif;
  font-size: clamp(2.5rem, 5vw, 4rem);
  font-weight: 900;
  margin-bottom: 15px;
  line-height: 1.1;
  color: #f0f0f0;
}

.product-slogan {
  font-size: clamp(1.1rem, 2.5vw, 1.4rem);
  font-weight: 300;
  color: #cccccc;
  margin-bottom: 25px;
  max-width: 500px;
}

.product-features {
  list-style: none;
  padding-left: 0;
  margin-bottom: 30px;
}

.product-features li {
  font-size: 1rem;
  margin-bottom: 10px;
  display: flex;
  align-items: center;
  color: #e0e0e0;
}

.product-features li svg {
  margin-right: 10px;
  flex-shrink: 0;
}

.product-image-container {
  grid-area: image;
  display: flex;
  justify-content: center;
  align-items: center;
  animation: fadeInFromRight 0.8s 0.2s ease-out forwards;
  opacity: 0;
}

@keyframes fadeInFromRight {
  from { opacity: 0; transform: translateX(50px); }
  to { opacity: 1; transform: translateX(0); }
}

.product-image {
  max-width: 100%;
  max-height: 70vh;
  object-fit: contain;
  filter: drop-shadow(0 10px 20px rgba(0,0,0,0.3));
}

.product-badges-container {
  grid-area: badges;
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 15px;
  padding-top: 20px;
  margin-top: 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  animation: fadeInUp 0.8s 0.4s ease-out forwards;
  opacity: 0;
}

@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: translateY(0); }
}

.product-badge {
  background-color: rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 4px;
  padding: 8px 12px;
  text-align: center;
  min-width: 100px;
  color: #e0e0e0;
  font-size: 0.8rem;
}
.badge-icon-fan {
  margin-bottom: 4px;
}
.badge-icon-fan svg {
  width: 20px;
  height: 20px;
  fill: #e0e0e0;
}

.badge-main-text {
  display: block;
  font-size: 1.1rem;
  font-weight: 700;
  font-family: 'Orbitron', sans-serif;
}

.badge-subtext {
  display: block;
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  color: #b0b0b0;
}
.badge-detail {
  display: block;
  font-size: 0.7rem;
  color: #999;
}

:deep(.carousel__prev),
:deep(.carousel__next) {
  background-color: rgba(0, 0, 0, 0.5) !important;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  color: white !important;
  transition: background-color 0.3s ease;
}
:deep(.carousel__prev:hover),
:deep(.carousel__next:hover) {
  background-color: rgba(0, 0, 0, 0.8) !important;
}
:deep(.carousel__prev) {
  left: 20px !important;
}
:deep(.carousel__next) {
  right: 20px !important;
}

:deep(.carousel__pagination-button) {
  background-color: rgba(255, 255, 255, 0.3) !important;
  padding: 5px;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  margin: 0 4px;
  transition: background-color 0.3s ease, transform 0.3s ease;
}
:deep(.carousel__pagination-button--active) {
  background-color: var(--slide-accent-color, #fff) !important;
  transform: scale(1.3);
}

@media (max-width: 992px) {
  .product-slide-content {
    grid-template-columns: 1fr;
    grid-template-areas:
      "text"
      "image"
      "badges";
    text-align: center;
    gap: 30px;
    padding: 60px 20px 40px;
  }
  .product-text-info {
    padding-right: 0;
    text-align: center;
  }
  .product-features {
    justify-content: center;
  }
  .product-features li {
    justify-content: flex-start;
    text-align: left;
    margin-left: auto;
    margin-right: auto;
    max-width: 300px;
  }
  .product-image {
    max-height: 40vh;
  }
  .product-badges-container {
    justify-content: center;
    gap: 10px;
  }
  .product-badge {
    min-width: 80px;
    padding: 6px 10px;
  }
  .product-name {
    font-size: clamp(2rem, 6vw, 3rem);
  }
  .product-slogan {
    font-size: clamp(1rem, 3vw, 1.2rem);
  }
}

@media (max-width: 576px) {
  .video-hero-section {
    padding-bottom: 8vh; /* Adjust padding for smaller screens if needed */
  }
  .hero-text-container h1 {
    font-size: clamp(2rem, 10vw, 2.8rem); 
  }
  .hero-text-container p {
    font-size: clamp(0.75rem, 3vw, 0.9rem); 
  }
  .shop-now-button {
    padding: 12px 25px;
    font-size: clamp(0.8rem, 2.5vw, 1rem);
  }

  .product-features li {
    font-size: 0.9rem;
  }
  .product-features {
    margin-bottom: 20px;
  }
  .badge-main-text {
    font-size: 1rem;
  }
  :deep(.carousel__prev) {
    left: 10px !important;
    width: 35px;
    height: 35px;
  }
  :deep(.carousel__next) {
    right: 10px !important;
    width: 35px;
    height: 35px;
  }
  :deep(.carousel__pagination-button) {
    padding: 4px;
    width: 8px;
    height: 8px;
  }
}

/* Styles for Store Information Section */
.icon-store::before { content: "🏢 "; }
.icon-pin::before { content: "📍 "; }
.icon-clock::before { content: "🕒 "; }
.icon-services::before { content: "🛠️ "; }
.icon-map::before { content: "🗺️ "; }
.icon-connect::before { content: "🔗 "; }
.icon-facebook::before { content: "📘 "; font-size: 1.5em; } 
.icon-twitter::before { content: "🐦 "; font-size: 1.5em; }
.icon-instagram::before { content: "📸 "; font-size: 1.5em; }
.icon-discord::before { content: "💬 "; font-size: 1.5em; }


.store-info-section {
  padding: 80px 20px;
  background-color: #0f172a; 
  color: #e2e8f0; 
  font-family: 'Roboto', sans-serif;
}

.store-info-container {
  max-width: 1200px;
  margin: 0 auto;
}

.section-title.store-section-title { 
  text-align: center;
  font-family: 'Orbitron', sans-serif;
  font-size: clamp(2rem, 5vw, 3rem);
  color: #38bdf8; 
  margin-bottom: 15px;
  font-weight: 700;
}

.section-subtitle.store-section-subtitle { 
  text-align: center;
  font-size: clamp(1rem, 2.5vw, 1.25rem);
  color: #94a3b8; 
  margin-bottom: 50px;
  max-width: 700px;
  margin-left: auto;
  margin-right: auto;
  line-height: 1.6;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 30px;
  margin-bottom: 50px;
}

.info-block {
  background-color: #1e293b; 
  padding: 25px 30px;
  border-radius: 12px;
  border: 1px solid #334155;
  box-shadow: 0 4px 15px rgba(0,0,0,0.2);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.info-block:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(56, 189, 248, 0.3);
}

.info-block h3 {
  font-family: 'Orbitron', sans-serif;
  font-size: 1.5rem;
  color: #7dd3fc; 
  margin-bottom: 15px;
  display: flex;
  align-items: center;
  gap: 10px;
}
.info-block h3 i { 
  font-size: 1.2em;
  color: #38bdf8;
}

.info-block p, .info-block li {
  font-size: 0.95rem;
  line-height: 1.7;
  color: #cbd5e1; 
  margin-bottom: 10px;
}

.info-block p strong {
  color: #e2e8f0;
  font-weight: 500;
}

.info-block a {
  color: #38bdf8;
  text-decoration: none;
  font-weight: 500;
}
.info-block a:hover {
  text-decoration: underline;
  color: #7dd3fc;
}

.info-block ul {
  list-style: none;
  padding-left: 0;
}
.info-block ul li {
  padding-left: 25px;
  position: relative;
}
.info-block ul li::before {
  content: '✓';
  position: absolute;
  left: 0;
  color: #38bdf8; 
  font-weight: bold;
}

.map-social-container {
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 30px;
    align-items: flex-start;
    margin-top: 40px;
}

.map-placeholder, .social-links {
    background-color: #1e293b;
    padding: 25px;
    border-radius: 12px;
    border: 1px solid #334155;
}

.map-placeholder h4, .social-links h4 {
    font-family: 'Orbitron', sans-serif;
    font-size: 1.3rem;
    color: #7dd3fc;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 10px;
}
.map-placeholder h4 i, .social-links h4 i {
    font-size: 1.1em;
    color: #38bdf8;
}

.map-embed-placeholder {
    background-color: #0f172a;
    border: 1px dashed #334155;
    height: 250px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
    border-radius: 8px;
    color: #94a3b8;
}
.map-embed-placeholder span {
    font-size: 1.2rem;
    font-weight: 500;
    margin-bottom: 10px;
}

.social-links a {
    display: inline-block;
    margin-right: 15px;
    color: #94a3b8;
    font-size: 1.8rem; 
    transition: color 0.3s ease, transform 0.3s ease;
    text-decoration: none;
}
.social-links a:hover {
    color: #38bdf8;
    transform: scale(1.1);
}
.social-links a i { 
  font-size: 1.5em; 
  font-style: normal; 
}


@media (max-width: 992px) {
    .map-social-container {
        grid-template-columns: 1fr; 
    }
    .product-slide-content.container {
      padding: 60px 20px 40px; 
    }
}

@media (max-width: 768px) {
  .section-title.store-section-title {
    font-size: 1.8rem;
  }
  .section-subtitle.store-section-subtitle {
    font-size: 1rem;
  }
  .info-block h3 {
    font-size: 1.3rem;
  }
  .info-block {
    padding: 20px;
  }
}

html {
  scroll-behavior: smooth;
}
</style>