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
    backgroundColor: "linear-gradient(135deg, #18181b 0%, #27272a 50%, #3f3f46 100%)",
    accentColor: "#a3a3a3",
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
    backgroundColor: "linear-gradient(135deg, #1f2937 0%, #374151 50%, #4b5563 100%)",
    accentColor: "#9ca3af"
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
    backgroundColor: "linear-gradient(135deg, #000000 0%, #1c1c1c 50%, #2d2d2d 100%)",
    accentColor: "#d1d5db"
  }
]);

const carouselSettings = {
  itemsToShow: 1,
  snapAlign: 'center',
  transition: 500, // Durasi transisi slide
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
  if (products.value[data.currentSlideIndex]) {
    currentSlideAccentColor.value = products.value[data.currentSlideIndex].accentColor;
  }
};

// Placeholder data for news items
const techNews = ref([
  {
    id: 1,
    title: "CPU Prices Experiencing Upward Trend",
    excerpt: "Analysts report a noticeable increase in CPU prices across various manufacturers, citing supply chain issues and heightened demand. Gamers and PC builders should anticipate these changes when planning their next upgrades.",
    date: "October 26, 2023",
    source: "TechWire Daily",
    imageUrl: "https://placehold.co/600x350/1F2937/9CA3AF/png?text=CPU+Market+Update",
    readMoreUrl: "#"
  },
  {
    id: 2,
    title: "Next-Gen Graphics Cards: What to Expect",
    excerpt: "Rumors and official teasers point towards a significant leap in performance for the upcoming generation of GPUs. Expect advancements in ray tracing, AI-powered features, and higher VRAM capacities.",
    date: "October 24, 2023",
    source: "PixelPushers News",
    imageUrl: "https://placehold.co/600x350/1F2937/9CA3AF/png?text=GPU+Advancements",
    readMoreUrl: "#"
  },
  {
    id: 3,
    title: "The Future of RAM: DDR6 on the Horizon",
    excerpt: "Industry insiders suggest that the DDR6 memory standard is nearing finalization, promising substantial bandwidth improvements over current DDR5 technology. Early adoption is expected in high-end systems.",
    date: "October 22, 2023",
    source: "ComponentChronicle",
    imageUrl: "https://placehold.co/600x350/1F2937/9CA3AF/png?text=RAM+Evolution",
    readMoreUrl: "#"
  }
]);

</script>

<template>
  <div class="page-wrapper">

    <section class="video-hero-section">
      <div class="video-overlay top-gradient"></div>
      <video autoplay muted loop playsinline class="hero-background-video" poster="data:image/gif;base64,R0lGODlhAQABAIAAAAAAABAAACwAAAAAAQABAAACAkQBADs=">
        <source src="https://assets.corsair.com/video/upload/f_auto,ac_none/q_75/Homepage%20Assets/Hero-Banners/doom-crop.mp4" type="video/mp4">
        Your browser does not support the video tag.
      </video>
      <div class="video-overlay bottom-gradient"></div>
      <div class="hero-content-overlay">
        <div class="hero-text-container">
          <h1>ENTER THE DARK AGES</h1>
          <p>OFFICIAL LICENSED GAMING AND STREAMING HARDWARE</p>
          <a href="#product-carousel-starts" class="shop-now-button">SHOP NOW</a>
        </div>
      </div>
    </section>

    <section class="product-hero-slider" id="product-carousel-starts">
      <Carousel
        :settings="carouselSettings"
        :breakpoints="carouselBreakpoints"
        :wrap-around="true"
        :autoplay="5000"
        :pause-autoplay-on-hover="true"
        @slide-start="onSlideChange"
        :style="{'--slide-accent-color': currentSlideAccentColor }"
      >
        <Slide v-for="product in products" :key="product.id">
          <div class="carousel__item" :style="{ background: product.backgroundColor }">
            <div class="product-slide-content">
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

    <!-- Tech News Section -->
    <section class="tech-news-section">
      <div class="tech-news-container">
        <h2 class="section-title tech-news-title">Tech Bytes & Insights</h2>
        <p class="section-subtitle tech-news-subtitle">
          Catch up on the latest trends, announcements, and shifts in the world of computer hardware.
        </p>
        <div class="news-grid">
          <article v-for="news in techNews" :key="news.id" class="news-item">
            <img :src="news.imageUrl" :alt="news.title" class="news-image">
            <div class="news-content">
              <h3 class="news-item-title">{{ news.title }}</h3>
              <p class="news-item-excerpt">{{ news.excerpt }}</p>
              <div class="news-item-footer">
                <span class="news-item-meta">{{ news.date }} | {{ news.source }}</span>
                <a :href="news.readMoreUrl" class="news-read-more" target="_blank" rel="noopener noreferrer">Read More »</a>
              </div>
            </div>
          </article>
        </div>
      </div>
    </section>
    <!-- End of Tech News Section -->

    <section class="store-info-section">
      <div class="store-info-container">
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

  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Roboto:wght@300;400;700&display=swap');

/* General Page Styles */
.page-wrapper {
  background-color: #000000;
  overflow-x: hidden;
  width: 100%;
}

html {
  scroll-behavior: smooth;
}

/* Video Hero Section */
.video-hero-section {
  position: relative;
  height: 100vh; /* Fallback */
  height: 100dvh;
  width: 100%;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  align-items: center;
  text-align: center;
  background-color: #000000;
  padding-bottom: 10vh; /* Fallback */
  padding-bottom: 10dvh;
}

.hero-background-video {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transform: translate(-50%, -50%);
  z-index: 1;
  filter: brightness(0.5) grayscale(0.2);
}

.video-overlay {
  position: absolute;
  left: 0;
  width: 100%;
  z-index: 2;
  pointer-events: none;
}

.video-overlay.top-gradient {
  top: 0;
  height: 20vh; /* Fallback */
  height: 20dvh;
  background: linear-gradient(to top, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 0.8) 70%, #000000 100%);
}

.video-overlay.bottom-gradient {
  bottom: 0;
  height: 30vh; /* Fallback */
  height: 30dvh;
  background: linear-gradient(to bottom, rgba(0, 0, 0, 0) 0%, #000000 90%);
}

.hero-content-overlay {
  position: relative;
  z-index: 3;
  padding: 20px;
  width: 100%;
  max-width: 800px;
}

.hero-text-container h1 {
  font-family: 'Orbitron', sans-serif;
  font-size: clamp(2.8rem, 7vw, 4.5rem);
  font-weight: 900;
  color: #E5E7EB;
  text-transform: uppercase;
  margin-bottom: 15px;
  letter-spacing: 2px;
  text-shadow: 2px 2px 10px rgba(0,0,0,0.9), 0 0 15px rgba(0,0,0,0.7);
}

.hero-text-container p {
  font-family: 'Roboto', sans-serif;
  font-size: clamp(0.8rem, 2vw, 1.1rem);
  color: #B0B0B8;
  margin-bottom: 35px;
  text-transform: uppercase;
  letter-spacing: 1px;
  font-weight: 400;
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
  text-shadow: 1px 1px 8px rgba(0,0,0,0.8), 0 0 6px rgba(0,0,0,0.6);
}

.shop-now-button {
  display: inline-block;
  background-color: #4B5563;
  color: #F3F4F6;
  padding: 14px 35px;
  font-family: 'Orbitron', sans-serif;
  font-weight: 700;
  font-size: clamp(0.9rem, 1.8vw, 1.1rem);
  text-decoration: none;
  text-transform: uppercase;
  border-radius: 4px;
  border: 1px solid #6B7280;
  transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
  box-shadow: 0 4px 15px rgba(0,0,0,0.3);
  letter-spacing: 1px;
  cursor: pointer;
}

.shop-now-button:hover, .shop-now-button:focus {
  background-color: #374151;
  color: #FFFFFF;
  border-color: #9CA3AF;
  transform: translateY(-3px) scale(1.03);
  box-shadow: 0 6px 20px rgba(107, 114, 128, 0.3), 0 0 15px rgba(55, 65, 81, 0.2);
  outline: none;
}


/* Product Hero Slider */
.product-hero-slider {
  width: 100%;
  box-sizing: border-box;
  height: 100vh; /* Fallback */
  height: 100dvh;
  font-family: 'Roboto', sans-serif;
  background-color: #000000;
  position: relative;
  display: flex;
  align-items: center;
  overflow: hidden;
}

:deep(.carousel),
:deep(.carousel__viewport),
:deep(.carousel__track) {
  width: 100%;
  height: 100%;
}

.carousel__item {
  height: 100%;
  width: 100%;
  box-sizing: border-box;
  color: #D1D5DB;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
  overflow: hidden;
}

.product-slide-content { /* Assuming .container class was removed from its div in HTML */
  display: grid;
  grid-template-columns: 1fr 1.2fr;
  grid-template-rows: auto 1fr auto;
  grid-template-areas:
    "text image"
    "text image"
    "badges badges";
  align-items: center;
  gap: 20px 40px;
  height: 100%;
  max-height: 90vh; /* Fallback */
  max-height: 90dvh;
  box-sizing: border-box;
  width: 100%;
  max-width: 1400px;
  margin-left: auto;
  margin-right: auto;
  padding: clamp(20px, 4dvh, 40px) clamp(15px, 3vw, 40px);
}

.product-text-info,
.product-image-container,
.product-badges-container {
  opacity: 0;
  box-sizing: border-box;
}

:deep(.carousel__slide--active) .product-text-info {
  animation: fadeInFromLeft 0.8s 0.1s ease-out forwards;
}
:deep(.carousel__slide--active) .product-image-container {
  animation: fadeInFromRight 0.8s 0.3s ease-out forwards;
}
:deep(.carousel__slide--active) .product-badges-container {
  animation: fadeInUp 0.8s 0.5s ease-out forwards;
}

.product-text-info {
  grid-area: text;
  text-align: left;
  padding-right: 30px; /* Only on desktop grid */
  display: flex;
  flex-direction: column;
  justify-content: center;
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
  color: #F3F4F6;
}

.product-slogan {
  font-size: clamp(1.1rem, 2.5vw, 1.4rem);
  font-weight: 300;
  color: #9CA3AF;
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
  color: #D1D5DB;
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
  width: 100%;
}

.product-image {
  max-width: 100%;
  max-height: clamp(40dvh, 45vw, 60dvh);
  object-fit: contain;
  filter: drop-shadow(0 10px 25px rgba(0,0,0,0.4));
  display: block;
}

.product-badges-container {
  grid-area: badges;
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 15px;
  padding-top: 20px;
  margin-top: 20px;
  border-top: 1px solid #374151;
  width: 100%;
}

.product-badge {
  background-color: rgba(31, 41, 55, 0.5);
  border: 1px solid #4B5563;
  border-radius: 4px;
  padding: 8px 12px;
  text-align: center;
  min-width: 100px;
  color: #D1D5DB;
  font-size: 0.8rem;
  box-shadow: 0 2px 5px rgba(0,0,0,0.2);
}
.badge-icon-fan {
  margin-bottom: 4px;
}
.badge-icon-fan svg {
  width: 20px;
  height: 20px;
  fill: #9CA3AF;
}

.badge-main-text {
  display: block;
  font-size: 1.1rem;
  font-weight: 700;
  font-family: 'Orbitron', sans-serif;
  color: #E5E7EB;
}

.badge-subtext {
  display: block;
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  color: #9CA3AF;
}
.badge-detail {
  display: block;
  font-size: 0.7rem;
  color: #6B7280;
}

:deep(.carousel__prev),
:deep(.carousel__next) {
  background-color: rgba(17, 24, 39, 0.6) !important;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  color: #D1D5DB !important;
  transition: background-color 0.3s ease;
  box-shadow: 0 2px 8px rgba(0,0,0,0.3);
}
:deep(.carousel__prev:hover),
:deep(.carousel__next:hover) {
  background-color: rgba(17, 24, 39, 0.9) !important;
}
:deep(.carousel__prev) { left: 20px !important; }
:deep(.carousel__next) { right: 20px !important; }

:deep(.carousel__pagination) {
  position: absolute;
  bottom: clamp(15px, 3dvh, 20px);
  left: 50%;
  transform: translateX(-50%);
  z-index: 5;
}

:deep(.carousel__pagination-button) {
  background-color: rgba(107, 114, 128, 0.4) !important;
  padding: 5px;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  margin: 0 4px;
  transition: background-color 0.3s ease, transform 0.3s ease;
  border: none;
}
:deep(.carousel__pagination-button--active) {
  background-color: var(--slide-accent-color, #9CA3AF) !important;
  transform: scale(1.3);
}

/* Tech News Section */
.tech-news-section {
  padding: 70px 0;
  background-color: #0f0f11; /* Slightly different dark shade from product slider */
  color: #D1D5DB;
  font-family: 'Roboto', sans-serif;
  border-top: 1px solid #1f2937;
  border-bottom: 1px solid #1f2937;
}

.tech-news-container {
  width: 100%;
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 20px;
  box-sizing: border-box;
}

.tech-news-title { /* Uses .section-title for some base styles if defined globally */
  text-align: center;
  font-family: 'Orbitron', sans-serif;
  font-size: clamp(1.8rem, 4vw, 2.8rem);
  color: #E5E7EB;
  margin-bottom: 10px;
  font-weight: 700;
}

.tech-news-subtitle { /* Uses .section-subtitle for some base styles */
  text-align: center;
  font-size: clamp(0.9rem, 2vw, 1.15rem);
  color: #9CA3AF;
  margin-bottom: 50px;
  max-width: 650px;
  margin-left: auto;
  margin-right: auto;
  line-height: 1.5;
}

.news-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 30px;
}

.news-item {
  background-color: #18181b;
  border-radius: 8px;
  overflow: hidden;
  border: 1px solid #27272a;
  box-shadow: 0 5px 15px rgba(0,0,0,0.4);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  display: flex;
  flex-direction: column;
}

.news-item:hover {
  transform: translateY(-5px) scale(1.02);
  box-shadow: 0 8px 25px rgba(0,0,0,0.5);
}

.news-image {
  width: 100%;
  height: 200px;
  object-fit: cover;
  /* border-bottom: 3px solid #4B5563; */ /* Optional border for accent */
}

.news-content {
  padding: 20px 25px;
  display: flex;
  flex-direction: column;
  flex-grow: 1;
}

.news-item-title {
  font-family: 'Orbitron', sans-serif;
  font-size: 1.3rem;
  color: #E5E7EB;
  margin-bottom: 12px;
  font-weight: 700;
  line-height: 1.3;
}

.news-item-excerpt {
  font-size: 0.9rem;
  line-height: 1.6;
  color: #B0BCC8;
  margin-bottom: 15px;
  flex-grow: 1;
}

.news-item-footer {
  margin-top: auto; /* Pushes footer to the bottom of the card */
  padding-top: 10px;
  border-top: 1px solid #2a2a2e; /* Subtle separator */
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.news-item-meta {
  font-size: 0.75rem;
  color: #6B7280;
}

.news-read-more {
  font-size: 0.85rem;
  font-weight: 700;
  color: #9CA3AF;
  text-decoration: none;
  transition: color 0.3s ease;
}

.news-read-more:hover {
  color: #E5E7EB;
  text-decoration: underline;
}


/* Store Information Section */
.icon-store::before { content: "🏢 "; }
.icon-pin::before { content: "📍 "; }
.icon-clock::before { content: "🕒 "; }
.icon-services::before { content: "🛠️ "; }
.icon-map::before { content: "🗺️ "; }
.icon-connect::before { content: "🔗 "; }
.icon-facebook::before { content: "📘 "; font-size: 1em; }
.icon-twitter::before { content: "🐦 "; font-size: 1em; }
.icon-instagram::before { content: "📸 "; font-size: 1em; }
.icon-discord::before { content: "💬 "; font-size: 1em; }

.store-info-section {
  padding: 80px 0;
  background: linear-gradient(180deg, #111827 0%, #000000 100%); /* Reversed gradient for transition */
  color: #D1D5DB;
  font-family: 'Roboto', sans-serif;
}

.store-info-container {
  width: 100%;
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 20px;
  box-sizing: border-box;
}

.section-title.store-section-title {
  text-align: center;
  font-family: 'Orbitron', sans-serif;
  font-size: clamp(2rem, 5vw, 3rem);
  color: #E5E7EB;
  margin-bottom: 15px;
  font-weight: 700;
}

.section-subtitle.store-section-subtitle {
  text-align: center;
  font-size: clamp(1rem, 2.5vw, 1.25rem);
  color: #9CA3AF;
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
  background-color: #1F2937;
  padding: 25px 30px;
  border-radius: 12px;
  border: 1px solid #374151;
  box-shadow: 0 4px 20px rgba(0,0,0,0.3);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.info-block:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 30px rgba(55, 65, 81, 0.3);
}

.info-block h3 {
  font-family: 'Orbitron', sans-serif;
  font-size: 1.5rem;
  color: #D1D5DB;
  margin-bottom: 15px;
  display: flex;
  align-items: center;
  gap: 10px;
}
.info-block h3 i {
  font-size: 1em;
  color: #9CA3AF;
  font-style: normal;
}

.info-block p, .info-block li {
  font-size: 0.95rem;
  line-height: 1.7;
  color: #B0BCC8;
  margin-bottom: 10px;
}

.info-block p strong {
  color: #E5E7EB;
  font-weight: 500;
}

.info-block a {
  color: #9CA3AF;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.3s ease;
}
.info-block a:hover {
  text-decoration: underline;
  color: #D1D5DB;
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
  color: #9CA3AF;
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
    background-color: #1F2937;
    padding: 25px;
    border-radius: 12px;
    border: 1px solid #374151;
    box-shadow: 0 4px 15px rgba(0,0,0,0.2);
}

.map-placeholder h4, .social-links h4 {
    font-family: 'Orbitron', sans-serif;
    font-size: 1.3rem;
    color: #D1D5DB;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 10px;
}
.map-placeholder h4 i, .social-links h4 i {
    font-size: 1em;
    color: #9CA3AF;
    font-style: normal;
}

.map-embed-placeholder {
    background-color: #111827;
    border: 1px dashed #374151;
    height: 250px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
    border-radius: 8px;
    color: #9CA3AF;
}
.map-embed-placeholder span {
    font-size: 1.2rem;
    font-weight: 500;
    margin-bottom: 10px;
}

.social-links a {
    display: inline-block;
    margin-right: 15px;
    color: #9CA3AF;
    font-size: 1.8rem;
    transition: color 0.3s ease, transform 0.3s ease;
    text-decoration: none;
}
.social-links a:last-child {
    margin-right: 0;
}
.social-links a:hover {
    color: #D1D5DB;
    transform: scale(1.1);
}
.social-links a i {
  font-size: 1em;
  font-style: normal;
}


/* Responsive Adjustments */
@media (max-width: 992px) {
  .product-slide-content {
    grid-template-columns: 1fr;
    grid-template-rows: auto auto auto;
    grid-template-areas:
      "text"
      "image"
      "badges";
    text-align: center;
    gap: 20px;
    padding: clamp(30px, 5dvh, 50px) 15px clamp(60px, 8dvh, 70px); /* Adjusted mobile padding */
    max-width: 100%;
    margin-left: 0;
    margin-right: 0;
    max-height: none;
  }
  .product-text-info {
    padding-right: 0; /* No right padding when stacked */
    text-align: center;
    align-items: center;
  }

  .product-features li {
    margin-left: auto;
    margin-right: auto;
    max-width: 350px; /* Max width for feature text */
    text-align: left; /* Keep text aligned left within the centered block */
  }
  .product-image {
    max-height: clamp(30dvh, 45vw, 40dvh);
  }
  .product-badges-container {
    margin-top: 10px;
  }
  .map-social-container {
      grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .news-grid {
    grid-template-columns: 1fr; /* Stack news items on smaller screens */
  }
  .tech-news-title {
    font-size: clamp(1.6rem, 5vw, 2.2rem);
  }
  .tech-news-subtitle {
    font-size: clamp(0.85rem, 2.5vw, 1rem);
    margin-bottom: 30px;
  }
  .news-item-title {
    font-size: 1.15rem;
  }
  .news-item-excerpt {
    font-size: 0.88rem;
  }
}


@media (max-width: 576px) {
  .video-hero-section {
    padding-bottom: 8vh; /* fallback */
    padding-bottom: 8dvh;
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

  .product-slide-content {
    gap: 15px;
    padding: clamp(20px, 4dvh, 40px) 10px clamp(50px, 7dvh, 60px);
  }
  .product-name {
    font-size: clamp(1.8rem, 6vw, 2.5rem);
  }
  .product-slogan {
    font-size: clamp(0.9rem, 3vw, 1.1rem);
  }
  .product-features li {
    font-size: 0.85rem;
    max-width: 100%;
  }
  .product-features {
    margin-bottom: 15px;
  }
  .product-image {
    max-height: clamp(25dvh, 50vw, 35dvh);
  }

  .badge-main-text {
    font-size: 0.9rem;
  }
  .badge-subtext, .badge-detail {
    font-size: 0.65rem;
  }

  :deep(.carousel__prev) {
    left: 5px !important;
    width: 30px;
    height: 30px;
  }
  :deep(.carousel__next) {
    right: 5px !important;
    width: 30px;
    height: 30px;
  }
  :deep(.carousel__pagination) {
    bottom: clamp(8px, 1.5dvh, 10px);
  }
  :deep(.carousel__pagination-button) {
    padding: 3px;
    width: 7px;
    height: 7px;
  }

  .tech-news-section {
    padding: 50px 0 40px;
  }
  .tech-news-title {
    font-size: clamp(1.5rem, 6vw, 2rem);
  }
  .tech-news-subtitle {
    font-size: clamp(0.8rem, 3vw, 0.9rem);
  }
  .news-item-title {
    font-size: 1.05rem;
  }
  .news-item-excerpt {
    font-size: 0.82rem;
  }
  .news-content {
    padding: 15px 20px;
  }
  .news-item-footer {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }


  .section-title.store-section-title {
    font-size: clamp(1.6rem, 6vw, 2rem);
  }
  .section-subtitle.store-section-subtitle {
    font-size: clamp(0.8rem, 3.5vw, 1rem);
  }
  .info-block h3 {
    font-size: 1.2rem;
  }
  .info-block {
    padding: 15px;
  }
  .info-block p, .info-block li {
    font-size: 0.85rem;
  }
  .social-links a {
    font-size: 1.5rem;
    margin-right: 8px;
  }
}

/* Keyframes */
@keyframes fadeInFromLeft {
  from { opacity: 0; transform: translateX(-20px); }
  to { opacity: 1; transform: translateX(0); }
}
@keyframes fadeInFromRight {
  from { opacity: 0; transform: translateX(20px); }
  to { opacity: 1; transform: translateX(0); }
}
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>