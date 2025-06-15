<script setup>
import { ref, onMounted } from 'vue';
import 'vue3-carousel/dist/carousel.css';
import { Carousel, Slide, Pagination, Navigation } from 'vue3-carousel';
import apiClient from '@/services/api.js';

import doomVideoPoster from "/public/videos/doom.mp4";

// --- LOGIKA UNTUK BANNER (DINAMIS) ---
const banners = ref([]);
const isLoadingBanners = ref(true);
const bannerError = ref(null);

const fetchBanners = async () => {
  isLoadingBanners.value = true;
  bannerError.value = null;
  try {
    const response = await apiClient.get('/banners');
    banners.value = response.data.map(banner => ({
      ...banner, // Ambil semua data dari API
      imageWidth: 650,
      imageHeight: 400,
      badges: [],
      backgroundColor: "linear-gradient(135deg, #18181b 0%, #27272a 50%, #3f3f46 100%)",
      accentColor: "#a3a3a3",
    }));
    if (banners.value.length > 0) {
      currentSlideAccentColor.value = banners.value[0].accentColor;
    }
  } catch (error) {
    console.error("Gagal memuat banner:", error);
    bannerError.value = "Gagal memuat promosi.";
  } finally {
    isLoadingBanners.value = false;
  }
};

// Pengaturan Carousel
const carouselSettings = { itemsToShow: 1, snapAlign: 'center', transition: 500 };
const carouselBreakpoints = { 700: { itemsToShow: 1, snapAlign: 'center' }, 1024: { itemsToShow: 1, snapAlign: 'start' } };
const currentSlideAccentColor = ref('#a3a3a3');

const onSlideChange = (data) => {
  if (banners.value[data.currentSlideIndex]) {
    currentSlideAccentColor.value = banners.value[data.currentSlideIndex].accentColor;
  }
};

// --- LOGIKA UNTUK TECH NEWS (DINAMIS) ---
const techNews = ref([]);
const isLoadingNews = ref(true);
const newsError = ref(null);

const fetchTechNews = async () => {
  isLoadingNews.value = true;
  newsError.value = null;
  try {
    const response = await apiClient.get('/tech-news');
    techNews.value = response.data;
  } catch (error) {
    console.error("Gagal memuat berita dari API Laravel:", error);
    newsError.value = "Gagal memuat berita terkini. Pastikan server backend berjalan.";
  } finally {
    isLoadingNews.value = false;
  }
};

const formatDate = (dateString) => {
  if (!dateString) return '';
  const options = { year: 'numeric', month: 'long', day: 'numeric' };
  return new Date(dateString).toLocaleDateString('id-ID', options);
};

// --- DATA STATIS UNTUK TIM ---
const team = ref([
  { name: "Aldo Pratama", role: "Project Manager", photo: "https://randomuser.me/api/portraits/men/32.jpg" },
  { name: "Bella Salsabila", role: "Frontend Developer", photo: "https://randomuser.me/api/portraits/women/44.jpg" },
  { name: "Cahyo Nugroho", role: "Backend Developer", photo: "https://randomuser.me/api/portraits/men/45.jpg" },
  { name: "Dewi Lestari", role: "UI/UX Designer", photo: "https://randomuser.me/api/portraits/women/65.jpg" },
  { name: "Eka Saputra", role: "DevOps Engineer", photo: "https://randomuser.me/api/portraits/men/77.jpg" },
  { name: "Fani Rahmawati", role: "Quality Assurance", photo: "https://randomuser.me/api/portraits/women/12.jpg" },
  { name: "Gilang Ramadhan", role: "Fullstack Developer", photo: "https://randomuser.me/api/portraits/men/23.jpg" }
]);

// --- ONMOUNTED HOOK ---
onMounted(() => {
  fetchBanners();
  fetchTechNews();
});
</script>

<template>
  <div class="page-wrapper home-page-content">

    <section class="video-hero-section">
      <div class="video-overlay top-gradient"></div>
      <video
        autoplay
        muted
        loop
        playsinline
        class="hero-background-video"
        :poster="doomVideoPoster"
        preload="metadata"
      >
        <source src="/src/img home/video/doom.mp4" type="video/mp4">
        <track kind="captions" src="" srclang="en" label="English captions" default>
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
        <Slide v-for="(banner, index) in banners" :key="banner.id">
          <div class="carousel__item" :style="{ background: banner.backgroundColor }">
            <div class="product-slide-content">
              <div class="product-text-info">
                <h2 class="product-brand" :style="{ color: banner.accentColor }">{{ banner.brand }}</h2>
                <h1 class="product-name">{{ banner.name }}</h1>
                <p class="product-slogan">{{ banner.slogan }}</p>
                <ul class="product-features">
                  <li v-for="feature in banner.features" :key="feature">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-lg" viewBox="0 0 16 16" :style="{ color: banner.accentColor }">
                      <path d="M12.736 3.97a.733.733 0 0 1 1.047 0c.286.289.29.756.01 1.05L7.88 12.01a.733.733 0 0 1-1.065.02L3.217 8.384a.757.757 0 0 1 0-1.06.733.733 0 0 1 1.047 0l3.052 3.093 5.4-6.425z"/>
                    </svg>
                    {{ feature }}
                  </li>
                </ul>
              </div>

              <div class="product-image-container">
                <img
                  :src="banner.imageSrc"
                  :alt="banner.name"
                  class="product-image"
                  :loading="index === 0 ? 'eager' : 'lazy'"
                  :fetchpriority="index === 0 ? 'high' : 'auto'"
                  :width="banner.imageWidth"
                  :height="banner.imageHeight"
                />
              </div>

              <div class="product-badges-container">
                <div v-for="badge in banner.badges" :key="badge.text + badge.subtext" class="product-badge">
                  <div v-if="badge.icon === 'fan'" class="badge-icon-fan">
                    <svg viewBox="0 0 24 24" fill="currentColor" width="24" height="24"><path d="M12 2c-5.52 0-10 4.48-10 10s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm-1-3.79V8.5c0-.28.22-.5.5-.5s.5.22.5.5v7.71c2.42-.95 4-3.27 4-5.96 0-.28-.22-.5-.5-.5s-.5.22-.5.5c0 2.21-1.79 4-4 4s-4-1.79-4-4c0-.28-.22-.5-.5-.5s-.5.22-.5.5c0 2.69 1.58 5.01 4 5.96zM8.75 12.5c.28 0 .5-.22.5-.5V8c0-2.21 1.79-4 4-4s4 1.79 4 4v4c0 .28-.22-.5-.5-.5s-.5-.22-.5-.5V8c0-1.65-1.35-3-3-3s-3 1.35-3 3v4c0 .28-.22-.5-.5-.5s-.5.22-.5-.5z"/></svg>
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

    <section class="tech-news-section">
      <div class="tech-news-container">
        <h2 class="section-title tech-news-title">Tech Bytes & Insights</h2>
        <p class="section-subtitle tech-news-subtitle">
          Ikuti Perkembangan Terkini di Dunia Komputer.
        </p>
        <div class="news-grid">
          <article v-for="news in techNews" :key="news.id" class="news-item">
            <img
              :src="news.imageUrl"
              :alt="news.title"
              class="news-image"
              loading="lazy"
              width="600" height="350"
            >
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

    <section class="store-info-section">
      <div class="store-info-container">
        <h2 class="section-title store-section-title">Welcome to JWR Comp</h2>
        <p class="section-subtitle store-section-subtitle">
          Destinasi Utama untuk Perangkat Gaming Terkini, Konsultasi Ahli, dan Pengalaman Bermain Tanpa Tanding.
        </p>

        <div class="info-grid">
          <div class="info-block">
            <h3><i class="icon-store" role="img" aria-label="Store icon"></i>Tentang Kami</h3>
            <p>Kami adalah sekelompok penggila teknologi dan gamer yang berdedikasi untuk menghadirkan komponen terbaik, periferal canggih, dan sistem rakitan kustom berkualitas tinggi. Misi kami adalah memberdayakan kehidupan digital Anda—baik untuk gaming, kreasi konten, maupun pekerjaan profesional.</p>
          </div>

          <div class="info-block">
            <h3><i class="icon-pin" role="img" aria-label="Location pin icon"></i>Kunjungi toko kami</h3>
            <p><strong>Alamat:</strong> Jl. Ring Road Utara, Ngringin, Condongcatur, Kec. Depok, Kabupaten Sleman, Daerah Istimewa Yogyakarta 55281</p>
            <p><strong>Nomor WA:</strong> <a href="tel:+1555TECHNOW">(555) 832-4669</a></p>
            <p><strong>Email:</strong> <a href="mailto:jwrcomp@gmail.com">jwrcomp@gmail.com</a></p>
          </div>

          <div class="info-block">
            <h3><i class="icon-clock" role="img" aria-label="Clock icon"></i>Jam Operasional</h3>
            <p><strong>Senin - Jum'at:</strong> 9:00 AM - 8:00 PM</p>
            <p><strong>Sabtu:</strong> 9:00 AM - 7:00 PM</p>
            <p><strong>Minggu:</strong> 9:00 AM - 5:00 PM</p>
          </div>

          <div class="info-block">
            <h3><i class="icon-services" role="img" aria-label="Tools icon for services"></i>Melayani</h3>
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
            <h4><i class="icon-map" role="img" aria-label="Map icon"></i>Lokasi Kami</h4>
            <div class="map-embed-placeholder">
              <span>Map Interaktif (Placeholder)</span>
              <p>Temukan kami di Yogyakarta!</p>
            </div>
          </div>
          <div class="social-links">
              <h4><i class="icon-connect" role="img" aria-label="Connect icon"></i>Follow Kami di</h4>
              <a href="#" aria-label="Facebook"><i class="icon-facebook" role="img" aria-hidden="true"></i><span class="visually-hidden">Facebook</span></a>
              <a href="#" aria-label="Twitter"><i class="icon-twitter" role="img" aria-hidden="true"></i><span class="visually-hidden">Twitter</span></a>
              <a href="#" aria-label="Instagram"><i class="icon-instagram" role="img" aria-hidden="true"></i><span class="visually-hidden">Instagram</span></a>
              <a href="#" aria-label="Discord"><i class="icon-discord" role="img" aria-hidden="true"></i><span class="visually-hidden">Discord</span></a>
          </div>
        </div>

      </div>
    </section>

    <!-- Section Tim Kami -->
    <section class="team-section py-5 bg-black">
      <div class="container">
        <div class="text-center mb-5">
          <h2 class="fw-bold text-info" style="font-size:2rem; letter-spacing:1px;">Tim Kami</h2>
          <p class="text-muted" style="font-size:1.1rem;">7 orang kreatif di balik pengembangan website ini</p>
        </div>
        <div class="row justify-content-center g-4">
          <div
            v-for="member in team"
            :key="member.name"
            class="col-12 col-sm-6 col-md-4 col-lg-3 d-flex justify-content-center"
          >
            <div class="team-card text-center p-4">
              <img
                :src="member.photo"
                :alt="member.name"
                class="team-photo mb-3"
              />
              <h5 class="mb-1 text-info fw-semibold">{{ member.name }}</h5>
              <p class="mb-0 text-secondary" style="font-size:0.98rem;">{{ member.role }}</p>
            </div>
          </div>
        </div>
      </div>
    </section>

  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Roboto:wght@300;400;700&display=swap');

.visually-hidden {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: -1px;
  padding: 0;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
}

.page-wrapper.home-page-content {
  background-color: #000000;
  overflow-x: hidden;
  width: 100%;
}

.product-slide-content,
.news-item,
.info-block,
.shop-now-button,
.social-links a {
  will-change: transform, opacity;
}
:deep(.carousel__slide) {
  will-change: opacity, transform;
}

.hero-text-container h1,
.hero-text-container p,
.product-brand,
.product-name,
.product-slogan,
.news-item-title,
.section-title {
  text-rendering: optimizeLegibility;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.video-hero-section {
  position: relative;
  height: 100vh;
  height: 100dvh;
  width: 100%;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  align-items: center;
  text-align: center;
  background-color: #000000;
  padding-bottom: 10vh;
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
  height: 20vh;
  height: 20dvh;
  background: linear-gradient(to top, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 0.8) 70%, #000000 100%);
}

.video-overlay.bottom-gradient {
  bottom: 0;
  height: 30vh;
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

.product-hero-slider {
  width: 100%;
  box-sizing: border-box;
  height: 100vh;
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

.product-slide-content {
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
  max-height: 90vh;
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
  padding-right: 30px;
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
  display: block;
  max-width: 100%;
  height: auto;
  max-height: clamp(40dvh, 45vw, 60dvh);
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
  min-width: 32px;
  min-height: 32px;
  width: 32px;
  height: 32px;
  margin: 0 6px;
  border-radius: 50%;
  background-color: rgba(107, 114, 128, 0.4) !important;
  padding: 0;
  border: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}
:deep(.carousel__pagination-button--active) {
  background-color: var(--slide-accent-color, #9CA3AF) !important;
  transform: scale(1.15);
  outline: 2px solid #fff;
  outline-offset: 2px;
}

.tech-news-section {
  padding: 70px 0;
  background-color: #0f0f11;
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

.tech-news-title {
  text-align: center;
  font-family: 'Orbitron', sans-serif;
  font-size: clamp(1.8rem, 4vw, 2.8rem);
  color: #E5E7EB;
  margin-bottom: 10px;
  font-weight: 700;
}

.tech-news-subtitle {
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
  border: 1px solid #33374a;
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
  display: block;
  width: 100%;
  height: auto;
  max-height: 200px;
  object-fit: cover;
  background-color: #1F2937;
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
  margin-top: auto;
  padding-top: 10px;
  border-top: 1px solid #2a2a2e;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.news-item-meta {
  font-size: 0.75rem;
  color: #e0e0e0;
  background: #23263a;
  padding: 2px 8px;
  border-radius: 4px;
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

.icon-store::before { content: "🏢 "; }
.icon-pin::before { content: "📍 "; }
.icon-clock::before { content: "🕒 "; }
.icon-services::before { content: "🛠️ "; }
.icon-map::before { content: "🗺️ "; }
.icon-connect::before { content: "🔗 "; }
.icon-facebook::before { content: "📘"; }
.icon-twitter::before { content: "🐦"; }
.icon-instagram::before { content: "📸"; }
.icon-discord::before { content: "💬"; }

.store-info-section {
  padding: 80px 0;
  background: linear-gradient(180deg, #111827 0%, #000000 100%);
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
  display: inline-block;
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
    display: inline-block;
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
    display: inline-flex;
    align-items: center;
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
  line-height: 1;
}

.team-section {
  background: #10141a;
  border-top: 2px solid #00d9ff33;
  border-bottom: 2px solid #00d9ff33;
}

.team-card {
  background: linear-gradient(135deg, #181c22 80%, #00d9ff22 100%);
  border: 1.5px solid #00d9ff55;
  border-radius: 1.2rem;
  box-shadow: 0 4px 24px 0 #00d9ff22;
  transition: transform 0.2s, box-shadow 0.2s, border-color 0.2s;
  min-width: 220px;
  max-width: 260px;
  margin: 0 auto;
  position: relative;
  overflow: hidden;
}
.team-card:hover {
  transform: translateY(-8px) scale(1.04);
  box-shadow: 0 8px 32px 0 #00d9ff55;
  border-color: #00d9ff;
}
.team-photo {
  width: 82px;
  height: 82px;
  object-fit: cover;
  border-radius: 50%;
  border: 3px solid #00d9ff;
  box-shadow: 0 0 0 4px #23272f, 0 0 16px #00d9ff44;
  background: #23272f;
  margin-bottom: 1rem;
  transition: box-shadow 0.2s;
}
.team-card:hover .team-photo {
  box-shadow: 0 0 0 4px #23272f, 0 0 32px #00d9ff99;
}
.text-info {
  color: #00d9ff !important;
}
.text-secondary {
  color: #adb5bd !important;
}

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
    padding: clamp(30px, 5dvh, 50px) 15px clamp(60px, 8dvh, 70px);
    max-width: 100%;
    margin-left: 0;
    margin-right: 0;
    max-height: none;
  }
  .product-text-info {
    padding-right: 0;
    text-align: center;
    align-items: center;
  }

  .product-features li {
    margin-left: auto;
    margin-right: auto;
    max-width: 350px;
    text-align: left;
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
    grid-template-columns: 1fr;
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
    padding-bottom: 8vh;
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