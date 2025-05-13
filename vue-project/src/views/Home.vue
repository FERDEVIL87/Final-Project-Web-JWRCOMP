<script setup>
import { ref } from 'vue';
import 'vue3-carousel/dist/carousel.css'; // Import carousel styles
import { Carousel, Slide, Pagination, Navigation } from 'vue3-carousel';

const products = ref([
  {
    id: 1,
    brand: "ROG RYUO IV", // Or just keep it in name
    name: "SLC 360 ARGB",
    slogan: "A NEW VISION OF COOLING",
    imageSrc: "https://dlcdnwebimgs.asus.com/files/media/d3b46fd8-035f-41c1-a995-2dca5a228e9b/v1/img/gallery/2.jpg", // **IMPORTANT: Replace with your actual image path**
                                       // If your image is in public/images/rog-ryuo-cooler.png
    features: [
      "High-Performance Pump",
      "Extraordinary Visuals",
      "Attention to Detail",
    ],
    badges: [
      { text: "6", subtext: "YEAR WARRANTY" },
      { text: "Intel", subtext: "LGA 1851", detail: "Compatible" },
      { text: "AMD", subtext: "AM5", detail: "Compatible" },
      { text: "Curve", subtext: "6.5\"", detail: "" }, // Assuming this is a screen spec for the pump
      { text: "AMOLED", subtext: "2K 60HZ", detail: "" },
      { text: "Daisy Chainable Fan", subtext: "", icon: 'fan' }, // Special case for icon
    ],
    backgroundColor: "linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%)", // Dark blue/purple
    accentColor: "#e94560", // A contrasting accent
  },
  {
  "id": 2,
  "brand": "ASUS TUF Gaming",
  "name": "TUF Gaming A15 (2024)",
  "slogan": "GEARED FOR SERIOUS GAMING AND REAL-WORLD DURABILITY",
  "imageSrc": "https://dlcdnwebimgs.asus.com/gain/49bac8ff-76c9-45b5-846c-057f79c30c8b/", // Placeholder
  "features": [
    "Latest AMD Ryzen CPU & NVIDIA GPU",
    "Blazing-Fast NVMe SSD",
    "Customizable RGB Keyboard",
    "Self-Cleaning Cooling 2.0",
    "MIL-STD-810H Durability"
  ],
  "badges": [
    { "text": "2", "subtext": "YEAR WARRANTY" },
    { "text": "NVIDIA", "subtext": "RTX 4060" }, // Atau RTX 4070 tergantung model
    { "text": "AMD", "subtext": "Ryzen 7 8000 Series" }, // Atau Ryzen 9
    { "text": "16GB", "subtext": "DDR5 RAM" },
    { "text": "1TB", "subtext": "NVMe SSD" },
    { "text": "15.6\"", "subtext": "FHD 144Hz" } // Atau QHD 165Hz
  ],
  "backgroundColor": "linear-gradient(135deg, #1e272e 0%, #2c3a47 50%, #1e272e 100%)", // Dark grey/graphite
  "accentColor": "#FFC107" // TUF Yellow/Amber accent
  },
  {
  "id": 3,
  "brand": "Corsair",
  "name": "K70 RGB MK.2 Mechanical Keyboard",
  "slogan": "BUILT TO LAST. PERFORM LIKE A LEGEND.",
  "imageSrc": "https://res.cloudinary.com/corsair-pwa/image/upload/f_auto,q_auto/akamai/pdp/keyboards/k70-rgb-pro/assets/images/k70-legend.png", // Placeholder
  "features": [
    "Genuine Cherry MX Switches",
    "Dynamic Per-Key RGB Backlighting",
    "Aircraft-Grade Anodized Brushed Aluminum Frame",
    "8MB Profile Storage with Hardware Playback",
    "Dedicated Multimedia Controls & Volume Roller"
  ],
  "badges": [
    { "text": "2", "subtext": "YEAR WARRANTY" },
    { "text": "Cherry MX", "subtext": "Red Switches" }, // Bisa diganti (Blue, Brown, Speed, etc.)
    { "text": "iCUE", "subtext": "Software Control" },
    { "text": "100%", "subtext": "Anti-Ghosting" },
    { "text": "USB", "subtext": "Passthrough Port" }
  ],
  "backgroundColor": "linear-gradient(135deg, #0A0A0A 0%, #1A1A1A 50%, #0A0A0A 100%)", // Very dark grey / black
  "accentColor": "#FFD700" // Corsair Yellow (Gold-ish)
}
]);

// Carousel settings (optional, vue3-carousel has good defaults)
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
    snapAlign: 'start', // or 'center'
  },
};

</script>

<template>
  <section class="product-hero-slider">
    <Carousel :settings="carouselSettings" :breakpoints="carouselBreakpoints" :wrap-around="true" :autoplay="5000">
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
              <!-- LEARN MORE BUTTON REMOVED -->
            </div>

            <div class="product-image-container">
              <img :src="product.imageSrc" :alt="product.name" class="product-image" />
            </div>

            <div class="product-badges-container">
              <div v-for="badge in product.badges" :key="badge.text + badge.subtext" class="product-badge">
                <div v-if="badge.icon === 'fan'" class="badge-icon-fan">
                  <!-- Simple SVG Fan Icon -->
                  <svg viewBox="0 0 24 24" fill="currentColor" width="24" height="24"><path d="M12 2c-5.52 0-10 4.48-10 10s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm-1-3.79V8.5c0-.28.22-.5.5-.5s.5.22.5.5v7.71c2.42-.95 4-3.27 4-5.96 0-.28-.22-.5-.5-.5s-.5.22-.5.5c0 2.21-1.79 4-4 4s-4-1.79-4-4c0-.28-.22-.5-.5-.5s-.5.22-.5.5c0 2.69 1.58 5.01 4 5.96zM8.75 12.5c.28 0 .5-.22.5-.5V8c0-2.21 1.79-4 4-4s4 1.79 4 4v4c0 .28-.22.5-.5.5s-.5-.22-.5-.5V8c0-1.65-1.35-3-3-3s-3 1.35-3 3v4c0 .28-.22.5-.5.5s-.5-.22-.5-.5z"/></svg>
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
</template>

<style scoped>
/* Import a cool font from Google Fonts */
@import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Roboto:wght@300;400;700&display=swap');

.product-hero-slider {
  width: 100%;
  height: 100vh; /* Full viewport height */
  overflow: hidden;
  font-family: 'Roboto', sans-serif;
}

.carousel__item {
  min-height: 100vh;
  width: 100%;
  color: #fff;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative; /* For badge positioning */
}

.product-slide-content {
  display: grid;
  grid-template-columns: 1fr 1.2fr; /* Text | Image */
  grid-template-rows: auto 1fr auto; /* Header, Content, Badges */
  grid-template-areas:
    "text image"
    "text image"
    "badges badges";
  align-items: center;
  gap: 20px;
  padding: 40px 20px;
  width: 100%;
  max-width: 1400px; /* Max width for content */
  margin: 0 auto;
  height: 100%;
  box-sizing: border-box;
}

.product-text-info {
  grid-area: text;
  text-align: left;
  padding-right: 30px; /* Space between text and image */
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
  font-size: clamp(2.5rem, 5vw, 4rem); /* Responsive font size */
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
  margin-bottom: 30px; /* Adjusted margin as button is removed */
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

/* CTA Button CSS Removed */

.product-image-container {
  grid-area: image;
  display: flex;
  justify-content: center;
  align-items: center;
  animation: fadeInFromRight 0.8s 0.2s ease-out forwards; /* Delay animation */
  opacity: 0; /* Start hidden for animation */
}

@keyframes fadeInFromRight {
  from { opacity: 0; transform: translateX(50px); }
  to { opacity: 1; transform: translateX(0); }
}

.product-image {
  max-width: 100%;
  max-height: 70vh; /* Limit image height */
  object-fit: contain;
  filter: drop-shadow(0 10px 20px rgba(0,0,0,0.3));
}

.product-badges-container {
  grid-area: badges;
  display: flex;
  flex-wrap: wrap;
  justify-content: center; /* Center badges for smaller screens */
  gap: 15px;
  padding-top: 20px;
  margin-top: 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  animation: fadeInUp 0.8s 0.4s ease-out forwards; /* Delay animation */
  opacity: 0; /* Start hidden for animation */
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
  fill: #e0e0e0; /* Or product.accentColor */
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

/* Carousel Navigation/Pagination Styling */
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
  border-radius: 50%;
  margin: 0 4px;
}
:deep(.carousel__pagination-button--active) {
  background-color: var(--slide-accent-color, #fff) !important; /* Use accent color if possible */
  transform: scale(1.2);
}

/* Responsive adjustments */
@media (max-width: 992px) {
  .product-slide-content {
    grid-template-columns: 1fr; /* Stack text and image */
    grid-template-areas:
      "text"
      "image"
      "badges";
    text-align: center;
    gap: 30px;
    padding: 60px 20px 40px; /* More top padding for nav */
  }
  .product-text-info {
    padding-right: 0;
    text-align: center;
  }
  .product-features {
    justify-content: center; /* Center list items if they wrap */
  }
  .product-features li {
    justify-content: flex-start; /* Align items to start in list */
    text-align: left; /* Keep text left aligned */
    margin-left: auto; /* For centering block */
    margin-right: auto; /* For centering block */
    max-width: 300px; /* Prevent wide feature text */
  }
   /* CTA button CSS removed from media query */
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
  .product-features li {
    font-size: 0.9rem;
  }
  .product-features {
    margin-bottom: 20px; /* Adjust spacing if needed */
  }
  .badge-main-text {
    font-size: 1rem;
  }
  :deep(.carousel__prev) {
    left: 10px !important;
  }
  :deep(.carousel__next) {
    right: 10px !important;
  }
}
</style>