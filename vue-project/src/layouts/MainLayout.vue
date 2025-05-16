<script setup>
import { RouterLink, RouterView } from 'vue-router';
import { ref, onMounted, onUnmounted } from 'vue';
import { Offcanvas } from 'bootstrap'; // Import Offcanvas

const items = [
  { to: '/', name: 'Tentang', color: '#00bcd4' },
  { to: '/paketrakitan', name: 'Paket Rakitan PC', color: '#00bcd4' },
  { to: '/laptop', name: 'Laptop', color: '#00bcd4' },
  { to: '/consolehh', name: 'Console and Handheld PC', color: '#00bcd4' },
  { to: '/hardware', name: 'PC Parts', color: '#00bcd4' },
  { to: '/cs', name: 'Customer Service', color: '#00bcd4' }
];

const sidebarOffcanvasRef = ref(null); // Ref untuk elemen offcanvas
let bsOffcanvas = null; // Variabel untuk menyimpan instance Offcanvas Bootstrap

onMounted(() => {
  if (sidebarOffcanvasRef.value) {
    bsOffcanvas = new Offcanvas(sidebarOffcanvasRef.value, {
      backdrop: true, // Anda bisa set ke false jika tidak mau backdrop gelap
      scroll: false // Body tidak bisa di-scroll saat offcanvas terbuka
    });
  }
});

onUnmounted(() => {
  if (bsOffcanvas) {
    bsOffcanvas.dispose(); // Hancurkan instance saat komponen di-unmount
  }
});

const toggleSidebar = () => {
  if (bsOffcanvas) {
    bsOffcanvas.toggle();
  }
};

const closeSidebar = () => {
  if (bsOffcanvas) {
    bsOffcanvas.hide();
  }
};
</script>

<template>
  <div class="layout-bs d-flex flex-column min-vh-100">
    <!-- Navbar Bootstrap -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-black fixed-top shadow-sm">
      <div class="container-fluid">
        <RouterLink class="navbar-brand logo-bs" to="/">
          <img src="/logo.png" alt="JWR Comp Logo" />
        </RouterLink>
        <button
          class="navbar-toggler"
          type="button"
          @click="toggleSidebar"
          aria-controls="sidebarNav"
          aria-expanded="false"
          aria-label="Toggle navigation"
        >
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end">
          <ul class="navbar-nav">
            <li v-for="i in items" :key="i.to" class="nav-item-bs">
              <RouterLink
                class="nav-link animated-btn-bs"
                :to="i.to"
                :style="{ '--clr': i.color }"
                active-class="active-animated-bs"
              >
                <span>{{ i.name }}</span>
                <i></i>
              </RouterLink>
            </li>
          </ul>
        </div>
      </div>
    </nav>

    <!-- Sidebar Bootstrap (Offcanvas) -->
    <div
      class="offcanvas offcanvas-start bg-black text-white sidebar-bs"
      tabindex="-1"
      id="sidebarNav"
      aria-labelledby="sidebarNavLabel"
      ref="sidebarOffcanvasRef"
    >
      <div class="offcanvas-header">
        <h5 class="offcanvas-title logo-bs-sidebar" id="sidebarNavLabel">
            <img src="/logo.png" alt="JWR Comp Logo Sidebar" />
        </h5>
        <button
          type="button"
          class="btn-close btn-close-white"
          @click="closeSidebar"
          aria-label="Close"
        ></button>
      </div>
      <div class="offcanvas-body">
        <ul class="nav flex-column">
          <li v-for="i in items" :key="i.to" class="nav-item-bs w-100">
            <RouterLink
              class="nav-link sidebar-btn-bs"
              :to="i.to"
              :style="{ '--clr': i.color }"
              active-class="active-sidebar-bs"
              @click="closeSidebar"
            >
              <span>{{ i.name }}</span>
              <i></i>
            </RouterLink>
          </li>
        </ul>
      </div>
    </div>

    <!-- Main Content -->
    <main class="content-bs flex-grow-1">
      <div class="container py-4">
        <transition name="fade-page" mode="out-in">
          <RouterView />
        </transition>
      </div>
    </main>

    <!-- Footer -->
    <footer class="footer-bs bg-black text-white text-center py-3 mt-auto shadow-top-sm">
      © 2025 JWR Comp. All rights reserved.
    </footer>
  </div>
</template>

<style scoped>
/* --- GLOBAL & LAYOUT --- */
.layout-bs {
  background-color: black; /* Pastikan background utama adalah hitam */
}

.content-bs {
  padding-top: 70px; /* Sesuaikan dengan tinggi navbar Anda; navbar fixed-top Bootstrap sekitar 56px */
  color: white;
}

.shadow-sm { /* Untuk navbar */
  box-shadow: 0 0.125rem 0.25rem rgba(200, 200, 200, 0.15) !important;
}
.shadow-top-sm { /* Untuk footer */
  box-shadow: 0 -0.125rem 0.25rem rgba(200, 200, 200, 0.15) !important;
}


/* --- NAVBAR --- */
.navbar-dark .navbar-brand {
  color: white;
}
.logo-bs img {
  max-height: 40px;
  width: auto;
}
.logo-bs-sidebar img {
  max-height: 35px; /* Logo di sidebar bisa sedikit lebih kecil */
  width: auto;
}


/* Override default navbar-nav behavior if needed for spacing */
.navbar-nav {
  gap: 0.3rem; /* Jarak antar tombol di navbar desktop */
}
.nav-item-bs {
  list-style: none; /* Bootstrap biasanya sudah menangani ini */
}

/* --- ANIMATED BUTTONS (NAVBAR & SIDEBAR) --- */
/* Base style untuk kedua jenis tombol animasi */
.animated-btn-bs, .sidebar-btn-bs {
  position: relative;
  background: #444; /* Sama seperti original */
  color: #fff !important; /* Penting untuk override warna default .nav-link */
  text-transform: uppercase;
  border: none;
  letter-spacing: 0.1rem;
  padding: 0.5rem 1rem; /* Padding disesuaikan agar pas dengan .nav-link */
  transition: 0.2s;
  display: inline-block; /* Atau block jika di sidebar ingin full width */
  cursor: pointer;
  text-decoration: none !important; /* Override Bootstrap */
  border-radius: 0.25rem; /* Sedikit radius agar lebih modern */
  font-weight: 500;
}

.animated-btn-bs:hover,
.sidebar-btn-bs:hover,
.animated-btn-bs.active-animated-bs, /* Menggunakan active-class dari RouterLink */
.sidebar-btn-bs.active-sidebar-bs {
  background: var(--clr);
  color: var(--clr) !important;
  animation: box-bs 3s infinite;
}

.animated-btn-bs::before,
.sidebar-btn-bs::before {
  content: "";
  position: absolute;
  inset: 2px;
  background: black; /* Sesuai original */
  z-index: 0; /* Di bawah span dan i */
  border-radius: calc(0.25rem - 2px); /* Match parent's radius */
}

.animated-btn-bs span,
.sidebar-btn-bs span {
  position: relative;
  z-index: 1;
}

.animated-btn-bs i,
.sidebar-btn-bs i {
  position: absolute;
  inset: 0;
  display: block;
  z-index: 1; /* Pastikan di atas pseudo-element ::before */
}

.animated-btn-bs i::before, .animated-btn-bs i::after,
.sidebar-btn-bs i::before, .sidebar-btn-bs i::after {
  content: "";
  position: absolute;
  width: 10px;
  height: 2px;
  background: black; /* Sesuai original */
  border: 2px solid var(--clr);
  transition: 0.3s;
  z-index: 2; /* Di atas ::before tombol utama */
}

/* Posisi i::before & i::after untuk NAVBAR buttons */
.animated-btn-bs i::before { left: 80%; top: -2px; }
.animated-btn-bs i::after { left: 20%; bottom: -2px; }

.animated-btn-bs:hover i::before,
.animated-btn-bs.active-animated-bs i::before {
  width: 15px; left: 20%; animation: move-bs 3s infinite;
}
.animated-btn-bs:hover i::after,
.animated-btn-bs.active-animated-bs i::after {
  width: 15px; left: 80%; animation: move-bs 3s infinite;
}

/* Penyesuaian untuk tombol di Navbar Desktop */
.navbar .nav-link.animated-btn-bs {
  font-size: 0.8rem; /* Ukuran font navbar desktop */
  padding: 0.4rem 0.8rem; /* Padding lebih kecil untuk navbar */
}

/* --- SIDEBAR (OFFCANVAS) --- */
.sidebar-bs {
  width: 260px; /* Lebar sidebar */
  /* box-shadow: 3px 0 10px rgba(200,200,200,0.15); Tidak perlu jika menggunakan shadow Bootstrap */
}
.sidebar-bs .offcanvas-header {
  border-bottom: 1px solid rgba(255,255,255,0.1);
  padding: 1rem 1.25rem;
}
.sidebar-bs .offcanvas-body {
  padding: 1rem;
}
.sidebar-bs .nav-item-bs {
  margin-bottom: 0.5rem; /* Jarak antar item sidebar */
}

/* Penyesuaian untuk tombol di Sidebar */
.nav-link.sidebar-btn-bs {
  font-size: 0.9rem; /* Ukuran font sidebar */
  padding: 0.6rem 1rem; /* Padding lebih besar untuk sidebar */
  width: 100%;
  text-align: center;
}

/* Posisi i::before & i::after untuk SIDEBAR buttons */
.sidebar-btn-bs i::before { left: 80%; top: -2px; }
.sidebar-btn-bs i::after { left: 20%; bottom: -2px; }

.sidebar-btn-bs:hover i::before,
.sidebar-btn-bs.active-sidebar-bs i::before {
  width: 20px; left: 15%; animation: move-bs 3s infinite;
}
.sidebar-btn-bs:hover i::after,
.sidebar-btn-bs.active-sidebar-bs i::after {
  width: 20px; left: 75%; animation: move-bs 3s infinite;
}


/* --- ANIMATIONS --- */
@keyframes move-bs {
  0% { transform: translateX(0); }
  50% { transform: translateX(5px); }
  100% { transform: translateX(0); }
}

@keyframes box-bs {
  0% { box-shadow: 0 0 5px var(--clr), 0 0 10px var(--clr); }
  50% { box-shadow: 0 0 15px var(--clr), 0 0 30px var(--clr); }
  100% { box-shadow: 0 0 5px var(--clr), 0 0 10px var(--clr); }
}

/* --- PAGE TRANSITIONS --- */
.fade-page-enter-active,
.fade-page-leave-active {
  transition: opacity 0.3s ease;
}
.fade-page-enter-from,
.fade-page-leave-to {
  opacity: 0;
}

/* --- RESPONSIVE OVERRIDES (jika diperlukan) --- */
@media (max-width: 991.98px) { /* lg breakpoint (kapan navbar collapse) */
  .navbar .navbar-collapse .navbar-nav {
    display: none; /* Sembunyikan menu navbar desktop saat di mobile, karena akan ada di sidebar */
  }
  .navbar .navbar-toggler {
    border-color: rgba(255,255,255,0.1);
  }
  .navbar-dark .navbar-toggler-icon {
    background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%28255, 255, 255, 0.8%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
  }
  .content-bs {
    padding-top: 60px; /* Sedikit penyesuaian untuk tinggi navbar di mobile */
  }
}
</style>