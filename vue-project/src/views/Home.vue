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
    // Ganti dengan placeholder atau path lokal jika CORS menjadi masalah
    imageSrc: "https://dlcdnwebimgs.asus.com/files/media/d3b46fd8-035f-41c1-a995-2dca5a228e9b/v1/img/gallery/2.jpg", // Placeholder
    // imageSrc: "/images/rog-ryuo-iv.jpg", // Contoh path lokal jika gambar ada di public/images/
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
    imageSrc: "https://dlcdnwebimgs.asus.com/gain/49bac8ff-76c9-45b5-846c-057f79c30c8b/asus-tuf-gaming-a15-fa507uv-product-photo.png", // Placeholder
    // imageSrc: "/images/tuf-gaming-a15.png", // Contoh path lokal
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
    imageSrc: "https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Gaming-Keyboards/CH-9109012-NA/Gallery/K70_RGB_MK2_02.webp", // Placeholder
    // imageSrc: "/images/corsair-k70.webp", // Contoh path lokal
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

  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Roboto:wght@300;400;700&display=swap');

/* General Page Styles */
.page-wrapper {
  background-color: #000000; /* Deep black base */
  overflow-x: hidden;
}

.container {
  width: 100%;
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 20px;
  box-sizing: border-box;
}


/* Video Hero Section - Enhanced Gradients */
.video-hero-section {
  position: relative;
  height: 100vh;
  width: 100%;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  justify-content: flex-end; /* Align content to bottom */
  align-items: center;
  text-align: center;
  background-color: #000000; /* Fallback: Pure black */
  padding-bottom: 10vh; /* Space for content above bottom gradient */
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
  filter: brightness(0.5) grayscale(0.2); /* Further darken and slightly desaturate video */
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
  height: 20vh;
  background: linear-gradient(to top, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 0.8) 70%, #000000 100%);
}

.video-overlay.bottom-gradient {
  bottom: 0;
  height: 30vh;
  background: linear-gradient(to bottom, rgba(0, 0, 0, 0) 0%, #000000 90%);
}

.hero-content-overlay {
  position: relative;
  z-index: 3;
  padding: 20px;
  width: 100%;
  max-width: 800px; /* Max width for text content */
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


/* Product Hero Slider - Black/Gray Theme */
.product-hero-slider {
  width: 100%;
  height: 100vh; /* Full viewport height */
  min-height: 600px; /* Minimum height for smaller screens */
  font-family: 'Roboto', sans-serif;
  background-color: #000000;
  position: relative; /* For positioning navigation/pagination absolutely if needed */
  display: flex; /* To help center carousel if it's not full height by default */
  align-items: center; /* Vertical centering of carousel content */
}

.carousel__item {
  min-height: 100vh; /* Ensure slides take full height */
  width: 100%;
  color: #D1D5DB;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative; /* For absolute positioning of elements within a slide if needed */
}

.product-slide-content {
  display: grid;
  grid-template-columns: 1fr 1.2fr; /* Text on left, image slightly larger on right */
  grid-template-rows: auto 1fr auto; /* Brand/Name, Slogan/Features, Badges */
  grid-template-areas:
    "text image"
    "text image"
    "badges badges";
  align-items: center; /* Vertically align content in grid areas */
  gap: 20px 40px; /* Row gap, Column gap */
  height: 100%;
  max-height: 90vh; /* Prevent content from touching viewport edges */
  box-sizing: border-box;
  padding: 40px 20px; /* Add some padding around the content */
}

.product-text-info {
  grid-area: text;
  text-align: left;
  padding-right: 30px; /* Space between text and image column */
  animation: fadeInFromLeft 0.8s ease-out forwards;
  display: flex;
  flex-direction: column;
  justify-content: center; /* Center text content vertically */
}

@keyframes fadeInFromLeft {
  from { opacity: 0; transform: translateX(-30px); }
  to { opacity: 1; transform: translateX(0); }
}
@keyframes fadeInFromRight {
  from { opacity: 0; transform: translateX(30px); }
  to { opacity: 1; transform: translateX(0); }
}
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: translateY(0); }
}


.product-brand {
  font-family: 'Orbitron', sans-serif;
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 5px;
  letter-spacing: 1px;
  text-transform: uppercase;
  /* color is set by :style binding */
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
  /* color is set by :style binding */
}

.product-image-container {
  grid-area: image;
  display: flex;
  justify-content: center;
  align-items: center;
  animation: fadeInFromRight 0.8s 0.2s ease-out forwards;
  opacity: 0; /* Start hidden for animation */
}

.product-image {
  max-width: 100%;
  max-height: 65vh; /* Adjust based on typical image aspect ratios */
  object-fit: contain;
  filter: drop-shadow(0 10px 25px rgba(0,0,0,0.4));
}

.product-badges-container {
  grid-area: badges;
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 15px;
  padding-top: 20px;
  margin-top: 20px; /* Space above badges */
  border-top: 1px solid #374151;
  animation: fadeInUp 0.8s 0.4s ease-out forwards;
  opacity: 0; /* Start hidden for animation */
  width: 100%; /* Ensure it takes full width of its grid area */
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
  bottom: 20px; /* Position pagination at the bottom */
  left: 50%;
  transform: translateX(-50%);
  z-index: 5; /* Ensure it's above other elements */
}

:deep(.carousel__pagination-button) {
  background-color: rgba(107, 114, 128, 0.4) !important;
  padding: 5px; /* This effectively sets the size of the non-active dot */
  width: 10px;
  height: 10px;
  border-radius: 50%;
  margin: 0 4px;
  transition: background-color 0.3s ease, transform 0.3s ease;
  border: none; /* Remove default border if any */
}
:deep(.carousel__pagination-button--active) {
  background-color: var(--slide-accent-color, #9CA3AF) !important;
  transform: scale(1.3);
}


/* Store Information Section - Black/Gray Theme */
/* Using text for icons, consider SVGs for better scalability and styling */
.icon-store::before { content: "🏢 "; }
.icon-pin::before { content: "📍 "; }
.icon-clock::before { content: "🕒 "; }
.icon-services::before { content: "🛠️ "; }
.icon-map::before { content: "🗺️ "; }
.icon-connect::before { content: "🔗 "; }
.icon-facebook::before { content: "📘 "; font-size: 1em; /* Adjusted for better alignment */ }
.icon-twitter::before { content: "🐦 "; font-size: 1em; }
.icon-instagram::before { content: "📸 "; font-size: 1em; }
.icon-discord::before { content: "💬 "; font-size: 1em; }

.store-info-section {
  padding: 80px 0;
  background: linear-gradient(180deg, #000000 0%, #111827 100%);
  color: #D1D5DB;
  font-family: 'Roboto', sans-serif;
}

/* .store-info-container class definition itself is not problematic.
   Its styles come from the .container class and potentially specific overrides.
   If it's marked red in your IDE, check for syntax errors *above* this rule in your CSS,
   or ensure the class name in your HTML matches exactly.
   The CSS provided is syntactically correct. */
.store-info-container {
  /* This class is used in conjunction with .container: <div class="container store-info-container">
     It can be used to add specific styles to this container if needed,
     beyond what .container provides. Currently, it has no specific styles of its own here. */
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
.info-block h3 i { /* Styles for icon pseudo-elements */
  font-size: 1em; /* Adjust if using actual icon font/SVG */
  color: #9CA3AF;
  font-style: normal; /* Prevent italics if i tag is used for semantic grouping */
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
    grid-template-columns: 2fr 1fr; /* Map takes more space */
    gap: 30px;
    align-items: flex-start; /* Align items to the top of their grid cell */
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
    font-size: 1.8rem; /* Base size for the container of the icon */
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
.social-links a i { /* Styles for icon pseudo-elements if used within <a> */
  font-size: 1em; /* Makes the icon text inherit the 1.8rem from <a> */
  font-style: normal;
}


/* Responsive Adjustments */
@media (max-width: 992px) {
  .product-slide-content {
    grid-template-columns: 1fr; /* Stack text, image, badges */
    grid-template-rows: auto auto auto; /* Adjust rows for stacked layout */
    grid-template-areas:
      "text"
      "image"
      "badges";
    text-align: center;
    gap: 30px; /* Consistent gap */
    padding: 60px 20px 80px; /* Adjust padding, more bottom for pagination */
    max-height: none; /* Allow content to flow */
  }
  .product-text-info {
    padding-right: 0;
    text-align: center;
    align-items: center; /* Center text items like slogan if max-width is set */
  }
  .product-features {
    justify-content: center; /* Center list items container if it's flex */
    align-items: center; /* Center items if they are block */
  }
  .product-features li {
    /* justify-content: flex-start; Remove if text-align:center on parent works */
    /* text-align: left; Keep for readability if list is centered */
    margin-left: auto; /* Center the list items block */
    margin-right: auto;
    max-width: 350px; /* Control width of feature text lines */
  }
  .product-image {
    max-height: 40vh;
  }
  .product-badges-container {
    margin-top: 10px; /* Reduce space when stacked */
  }

  .map-social-container {
      grid-template-columns: 1fr; /* Stack map and social links */
  }
}

@media (max-width: 576px) {
  .video-hero-section {
    padding-bottom: 8vh;
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
    padding: 40px 15px 70px; /* Further adjust padding for small screens */
    gap: 20px;
  }
  .product-name {
    font-size: clamp(2rem, 6vw, 2.8rem);
  }
  .product-slogan {
    font-size: clamp(1rem, 3vw, 1.2rem);
  }
  .product-features li {
    font-size: 0.9rem;
    max-width: 90%;
  }
  .product-features {
    margin-bottom: 20px;
  }
  .product-image {
    max-height: 35vh;
  }

  .badge-main-text {
    font-size: 1rem;
  }
  .badge-subtext, .badge-detail {
    font-size: 0.7rem;
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
  :deep(.carousel__pagination) {
    bottom: 15px; /* Adjust pagination position */
  }
  :deep(.carousel__pagination-button) {
    padding: 4px;
    width: 8px;
    height: 8px;
  }

  .section-title.store-section-title {
    font-size: clamp(1.8rem, 6vw, 2.2rem);
  }
  .section-subtitle.store-section-subtitle {
    font-size: clamp(0.9rem, 3.5vw, 1.1rem);
  }
  .info-block h3 {
    font-size: 1.3rem;
  }
  .info-block {
    padding: 20px;
  }
  .info-block p, .info-block li {
    font-size: 0.9rem;
  }
  .social-links a {
    font-size: 1.6rem; /* Slightly smaller social icons */
    margin-right: 10px;
  }
}

html {
  scroll-behavior: smooth;
}

/* Animation keyframes (ensure they are defined if not already) */
@keyframes fadeInFromLeft {
  from { opacity: 0; transform: translateX(-30px); }
  to { opacity: 1; transform: translateX(0); }
}
@keyframes fadeInFromRight {
  from { opacity: 0; transform: translateX(30px); }
  to { opacity: 1; transform: translateX(0); }
}
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>