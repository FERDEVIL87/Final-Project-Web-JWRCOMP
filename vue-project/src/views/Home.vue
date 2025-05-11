<script setup>
import { onMounted } from 'vue'
import lottie from 'lottie-web'

onMounted(() => {
  lottie.loadAnimation({
    container: document.getElementById('lottie'),
    renderer: 'svg',
    loop: true,
    autoplay: true,
    path: 'https://assets7.lottiefiles.com/packages/lf20_jcikwtux.json'
  })
})
</script>

<template>
  <header class="hero-section">
    <div class="container">
      <div class="row align-items-center g-4">
        <!-- Kolom teks -->
        <div class="col-md-6 text-center text-md-start">
          <h1 class="glowing-text" data-aos="fade-down">
            Selamat Datang di Dunia Saya!
          </h1>
          <p class="lead text-secondary" data-aos="fade-up">
            Saya <b>Ferdy</b>, seorang profesional di bidang <em>[Programming]</em> dan teknologi modern.
          </p>
          <button class="cta-button" data-aos="zoom-in">Pelajari Lebih Lanjut</button>
        </div>
        <!-- Kolom animasi -->
        <div class="col-md-6 text-center">
          <div id="lottie" style="max-width:400px;margin:auto"></div>
        </div>
      </div>
    </div>
  </header>
</template>

<style scoped>
/* Hero Section */
.hero-section {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(120deg, #1e1e2f, #2a2a3f, #000000);
  color: #fff;
  text-align: center;
  padding: 20px;
  box-sizing: border-box;
  overflow: hidden;
}

/* Glowing Text */
.glowing-text {
  font-size: 2.5rem;
  font-weight: bold;
  color: #fff;
  position: relative;
  text-transform: uppercase;
  animation: glow-animation 3s infinite;
}

.glowing-text::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(90deg, #ff0000, #404040, #0000ff, #ff0000);
  background-size: 300% 300%;
  z-index: -1;
  filter: blur(8px);
  animation: background-shift 4s infinite;
}

.glowing-text:hover {
  color: #ff0000;
  text-shadow: 0 0 5px #ff0000, 0 0 10px #404040, 0 0 15px #0000ff;
}

@keyframes glow-animation {
  0% {
    text-shadow: 0 0 2px #ff0000, 0 0 5px #404040, 0 0 8px #0000ff;
  }
  50% {
    text-shadow: 0 0 5px #ff0000, 0 0 10px #404040, 0 0 15px #0000ff;
  }
  100% {
    text-shadow: 0 0 2px #ff0000, 0 0 5px #404040, 0 0 8px #0000ff;
  }
}

@keyframes background-shift {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

/* CTA Button */
.cta-button {
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  background: linear-gradient(90deg, #ff0000, #494949, #0000ff);
  color: #fff;
  font-size: 1.2rem;
  font-weight: bold;
  cursor: pointer;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.cta-button:hover {
  transform: translateY(-3px);
  box-shadow: 0 5px 15px rgba(255, 0, 0, 0.7);
}
</style>