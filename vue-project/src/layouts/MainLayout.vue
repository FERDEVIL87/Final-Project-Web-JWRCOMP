<script setup>
import { RouterLink, RouterView } from 'vue-router'
import { ref } from 'vue'

// Data untuk menu navbar
const items = [
  { to: '/',          name: 'Tentang' },
  { to: '/education', name: 'Pendidikan' },
  { to: '/experience',name: 'Pengalaman' },
  { to: '/portfolio', name: 'Portofolio' },
  { to: '/skills',    name: 'Keahlian' },
  { to: '/contact',   name: 'Kontak' }
]

// State untuk toggle navbar
const isNavCollapsed = ref(true)

// Fungsi untuk toggle navbar
const toggleNavbar = () => {
  isNavCollapsed.value = !isNavCollapsed.value
}

// Fungsi untuk menangani posisi kursor
const handleMouseMove = (event) => {
  const navbar = document.querySelector('.navbar')
  const rect = navbar.getBoundingClientRect()
  const x = event.clientX - rect.left
  const y = event.clientY - rect.top
  navbar.style.setProperty('--x', `${x}px`)
  navbar.style.setProperty('--y', `${y}px`)
}
</script>

<template>
  <!-- Navbar -->
  <nav 
    class="navbar navbar-expand-lg navbar-dark sticky-top navbar-gradient" 
    @mousemove="handleMouseMove"
  >
    <div class="container">
      <RouterLink class="navbar-brand" to="/">FERDEVIL87</RouterLink>
      <button 
        class="navbar-toggler" 
        type="button" 
        @click="toggleNavbar" 
        aria-controls="nav" 
        :aria-expanded="!isNavCollapsed" 
        aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div 
        id="nav" 
        class="collapse navbar-collapse" 
        :class="{ show: !isNavCollapsed }">
        <ul class="navbar-nav ms-auto">
          <li v-for="i in items" :key="i.to" class="nav-item">
            <RouterLink 
              class="nav-link btn" 
              :to="i.to"
            >
              <button>
                <span>{{ i.name }}</span>
                <i></i>
              </button>
            </RouterLink>
          </li>
        </ul>
      </div>
    </div>
  </nav>

  <!-- Transisi halaman -->
  <transition name="fade-page" mode="out-in">
    <RouterView />
  </transition>

  <!-- Footer -->
  <footer class="bg-primary text-center text-white py-3">
    © 2025 FERDEVIL87
  </footer>
</template>

<style scoped>
/* Navbar brand */
.navbar-brand {
  font-size: 1.8rem; /* Ukuran teks diperbesar */
  font-weight: bold;
  color: #fff;
  text-transform: uppercase;
}

/* Navbar Gradient Background */
.navbar-gradient {
  background: radial-gradient(circle at var(--x, 50%) var(--y, 50%), #adadad, #292929);
  transition: background 0.2s ease;
}

/* Button styles for Navbar Links */
button {
  position: relative;
  background: #444;
  color: #fff;
  text-decoration: none;
  text-transform: uppercase;
  border: none;
  letter-spacing: 0.1rem;
  font-size: 0.8rem; /* Ukuran teks tombol diperkecil */
  padding: 0.5rem 1.5rem; /* Padding tombol diperkecil */
  transition: 0.2s;
}

button:hover {
  letter-spacing: 0.15rem; /* Hover spacing lebih kecil */
  padding: 0.6rem 1.6rem; /* Hover padding lebih kecil */
  background: var(--clr);
  color: var(--clr);
  animation: box 3s infinite;
}

button::before {
  content: "";
  position: absolute;
  inset: 2px;
  background: #272822;
}

button span {
  position: relative;
  z-index: 1;
}

button i {
  position: absolute;
  inset: 0;
  display: block;
}

button i::before {
  content: "";
  position: absolute;
  width: 8px; /* Lebar garis diperkecil */
  height: 2px;
  left: 80%;
  top: -2px;
  border: 2px solid var(--clr);
  background: #272822;
  transition: 0.2s;
}

button:hover i::before {
  width: 12px; /* Hover lebar garis lebih kecil */
  left: 20%;
  animation: move 3s infinite;
}

button i::after {
  content: "";
  position: absolute;
  width: 8px; /* Lebar garis diperkecil */
  height: 2px;
  left: 20%;
  bottom: -2px;
  border: 2px solid var(--clr);
  background: #272822;
  transition: 0.2s;
}

button:hover i::after {
  width: 12px; /* Hover lebar garis lebih kecil */
  left: 80%;
  animation: move 3s infinite;
}

@keyframes move {
  0% {
    transform: translateX(0);
  }
  50% {
    transform: translateX(5px);
  }
  100% {
    transform: translateX(0);
  }
}

@keyframes box {
  0% {
    box-shadow: #27272c;
  }
  50% {
    box-shadow: 0 0 25px var(--clr);
  }
  100% {
    box-shadow: #27272c;
  }
}
</style>