
<template>
  <section class="container my-5" data-aos="fade-up">
    <h2 class="h3 mb-4 text-primary text-center futuristic-title">Pendidikan</h2>
    <div class="row g-4">
      <!-- Card 1 -->
      <div class="col-md-6">
        <div class="card futuristic-card h-100 shadow-sm">
          <div class="card-body">
            <h5 class="card-title">Seorang Tolol yang Tolol Abiez</h5>
            <p class="card-text">
              Jinguk i
            </p>
          </div>
        </div>
      </div>

      <!-- Card 2 -->
      <div class="col-md-6">
        <div class="card futuristic-card h-100 shadow-sm">
          <div class="card-body">
            <h5 class="card-title">SMA ABC</h5>
            <p class="card-text">
              Menyelesaikan pendidikan dengan nilai yang memuaskan dan pengalaman luar biasa.
            </p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* Judul futuristik */
.futuristic-title {
  font-size: 2.5rem;
  font-weight: bold;
  color: #7d1eff;
  text-transform: uppercase;
  letter-spacing: 3px;
  position: relative;
  overflow: hidden;
  text-shadow: 0 0 5px #7d1eff, 0 0 20px #c300ff;
  animation: glow 2s infinite alternate;
}

.futuristic-title::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  width: 10;
  height: 4px;
  background: linear-gradient(90deg, #ff0000, #00ffea);
  transition: width 0.4s ease, left 0.4s ease;
}

.futuristic-title:hover::after {
  width: 100%;
  left: 0;
}

@keyframes glow {
  from {
    text-shadow: 0 0 10px #7d1eff, 0 0 20px #c300ff;
  }
  to {
    text-shadow: 0 0 20px #c300ff, 0 0 30px #ff00ff;
  }
}

/* Kartu futuristik */
.futuristic-card {
  background: linear-gradient(145deg, #1e1e2f, #2a2a3f);
  border: none;
  border-radius: 15px;
  color: #fff;
  transition: transform 0.3s ease, box-shadow 0.3s ease, background 0.3s ease;
  position: relative;
  overflow: hidden;
}

.futuristic-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 10px 30px rgba(125, 30, 255, 0.7);
  background: linear-gradient(145deg, #2a2a3f, #3a3a4f);
}

.futuristic-card::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(125, 30, 255, 0.2), transparent);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.futuristic-card:hover::before {
  opacity: 1;
}

.futuristic-card .card-title {
  font-size: 1.8rem;
  font-weight: bold;
  color: #c300ff;
  text-shadow: 0 0 5px #c300ff, 0 0 10px #ff00ff;
}

/* Teks kartu futuristik */
.futuristic-card .card-text {
  font-size: 1.1rem;
  color: #d3b3ff;
  line-height: 1.8;
  text-shadow: 0 0 5px rgba(211, 179, 255, 0.5);
  opacity: 0; /* Awalnya disembunyikan */
  transform: translateY(10px); /* Geser sedikit ke bawah */
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.futuristic-card:hover .card-text {
  opacity: 1; /* Tampilkan saat hover */
  transform: translateY(0); /* Geser ke posisi semula */
}
</style>