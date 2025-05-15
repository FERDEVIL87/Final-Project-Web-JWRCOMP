<script setup>
import { RouterLink, RouterView } from 'vue-router'
import { ref } from 'vue'

const items = [
  { to: '/', name: 'Tentang', color: '#00bcd4' },
  { to: '/paketrakitan', name: 'Paket Rakitan PC', color: '#e91e63' },
  { to: '/laptop', name: 'Laptop', color: '#ffc107' },
  { to: '/consolehh', name: 'Console and Handheld PC', color: '#4caf50' },
  { to: '/hardware', name: 'PC Parts', color: '#ff5722' },
  { to: '/cs', name: 'Customer Service', color: '#9c27b0' }
]

const isSidebarOpen = ref(false)
const toggleSidebar = () => {
  isSidebarOpen.value = !isSidebarOpen.value
}
</script>

<template>
  <div class="layout">
    <!-- Navbar -->
    <nav class="navbar">
      <div class="logo">
        <!-- MODIFIED: Image instead of text -->
        <img src="/logo.png" alt="JWR Comp Logo" />
      </div>
      <button class="toggle-btn" @click="toggleSidebar">☰</button>
      <ul class="menu">
        <li v-for="i in items" :key="i.to" class="menu-item">
          <RouterLink
            class="animated-btn"
            :to="i.to"
            :style="{ '--clr': i.color }"
          >
            <span>{{ i.name }}</span>
            <i></i>
          </RouterLink>
        </li>
      </ul>
    </nav>

    <!-- Sidebar -->
    <aside :class="{ open: isSidebarOpen }" class="sidebar">
      <button class="close-btn" @click="toggleSidebar">✖</button>
      <ul class="menu">
        <li v-for="i in items" :key="i.to" class="menu-item">
          <RouterLink
            class="sidebar-btn"
            :to="i.to"
            :style="{ '--clr': i.color }"
            @click="toggleSidebar"
          >
            <span>{{ i.name }}</span>
            <i></i>
          </RouterLink>
        </li>
      </ul>
    </aside>

    <!-- Main Content -->
    <main class="content">
      <transition name="fade-page" mode="out-in">
        <RouterView />
      </transition>
    </main>

    <!-- Footer -->
    <footer class="footer">
      © 2025 JWR Comp. All rights reserved.
    </footer>
  </div>
</template>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.layout {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background: black; /* Diubah ke hitam */
}

/* Navbar */
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: black; /* Diubah ke hitam */
  padding: 1rem;
  flex-wrap: wrap;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  z-index: 1100; /* Di atas sidebar */
  box-shadow: 0 2px 8px rgba(0,0,0,0.3); /* Shadow sedikit lebih terlihat di background hitam */
}

.content {
  margin-top: 5rem; /* Margin untuk menghindari navbar. Sesuaikan dengan tinggi navbar jika perlu. */
  padding: 1rem;
  flex-grow: 1;
  color: white; /* Pastikan teks konten terlihat di background hitam */
}

.logo {
  /* font-size: 1.4rem; */ /* No longer needed for text size */
  /* font-weight: bold; */ /* No longer needed for text weight */
  color: white; /* Kept for alt text if image fails */
  display: flex; /* Helps align the image if needed */
  align-items: center; /* Vertically align image if its container has extra space */
}

.logo img {
  max-height: 40px; /* ADJUST THIS VALUE to fit your logo and navbar height */
  width: auto;      /* Maintain aspect ratio */
  display: block;   /* Ensures the image behaves like a block element */
}


.toggle-btn {
  background: none;
  border: none;
  font-size: 1.5rem;
  color: white;
  cursor: pointer;
  display: none;
}

.menu {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.menu-item {
  list-style: none;
}

.animated-btn {
  position: relative;
  background: #444;
  color: #fff;
  text-transform: uppercase;
  border: none;
  letter-spacing: 0.1rem;
  font-size: 0.85rem;
  padding: 0.4rem 2rem;
  transition: 0.2s;
  display: inline-block;
  cursor: pointer;
  text-decoration: none;
}

.animated-btn:hover {
  background: var(--clr);
  color: var(--clr);
  animation: box 3s infinite;
}

.animated-btn::before {
  content: "";
  position: absolute;
  inset: 2px;
  background: black; /* Diubah ke hitam */
}

.animated-btn span {
  position: relative;
  z-index: 1;
}

.animated-btn i {
  position: absolute;
  inset: 0;
  display: block;
}

.animated-btn i::before,
.animated-btn i::after {
  content: "";
  position: absolute;
  width: 10px;
  height: 2px;
  background: black; /* Diubah ke hitam */
  border: 2px solid var(--clr);
  transition: 0.3s;
}

.animated-btn i::before {
  left: 80%;
  top: -2px;
}

.animated-btn i::after {
  left: 20%;
  bottom: -2px;
}

.animated-btn:hover i::before {
  width: 15px;
  left: 20%;
  animation: move 3s infinite;
}

.animated-btn:hover i::after {
  width: 15px;
  left: 80%;
  animation: move 3s infinite;
}

.router-link-exact-active.animated-btn {
  background: var(--clr);
  color: var(--clr);
  animation: box 3s infinite;
}

/* Sidebar */
.sidebar {
  position: fixed;
  top: 0;
  left: 0;
  width: 250px;
  height: 100%;
  background: black; /* Diubah ke hitam */
  padding: 1rem;
  padding-top: 5rem; /* Tambahkan padding atas agar konten sidebar tidak tertutup navbar */
  transform: translateX(-100%);
  transition: transform 0.3s ease;
  z-index: 1000;
  box-shadow: 3px 0 10px rgba(0,0,0,0.3); /* Shadow untuk sidebar */
}

.sidebar.open {
  transform: translateX(0);
}

.sidebar .menu {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.sidebar .menu-item {
  list-style: none;
}

.sidebar-btn {
  position: relative;
  background: #444;
  color: #fff;
  text-transform: uppercase;
  text-decoration: none;
  border: none;
  letter-spacing: 0.1rem;
  font-size: 0.7rem;
  padding: 0.4rem 0.7rem;
  transition: 0.2s;
  display: inline-block;
  width: 100%;
  text-align: center;
}

.sidebar-btn:hover {
  letter-spacing: 0.2rem;
  padding: 0.4rem 0.7rem;
  background: var(--clr);
  color: var(--clr);
  animation: box 3s infinite;
}

.sidebar-btn::before {
  content: "";
  position: absolute;
  inset: 2px;
  background: black;
}

.sidebar-btn span {
  position: relative;
  z-index: 1;
}

.sidebar-btn i {
  position: absolute;
  inset: 0;
  display: block;
}

.sidebar-btn i::before {
  content: "";
  position: absolute;
  width: 10px;
  height: 2px;
  left: 80%;
  top: -2px;
  border: 2px solid var(--clr);
  background: black;
  transition: 0.2s;
}

.sidebar-btn:hover i::before {
  width: 15px;
  left: 20%;
  animation: move 3s infinite;
}

.sidebar-btn i::after {
  content: "";
  position: absolute;
  width: 10px;
  height: 2px;
  left: 20%;
  bottom: -2px;
  border: 2px solid var(--clr);
  background: black;
  transition: 0.2s;
}

.sidebar-btn:hover i::after {
  width: 15px;
  left: 80%;
  animation: move 3s infinite;
}

.router-link-exact-active.sidebar-btn {
  background: var(--clr);
  color: var(--clr);
  animation: box 3s infinite;
}

.sidebar .close-btn {
  background: none;
  color: white;
  font-size: 1.4rem;
  border: none;
  cursor: pointer;
  position: absolute;
  top: 1rem;
  right: 1rem;
}

/* Animations */
@keyframes move {
  0% { transform: translateX(0); }
  50% { transform: translateX(5px); }
  100% { transform: translateX(0); }
}

@keyframes box {
  0% { box-shadow: none; }
  50% { box-shadow: 0 0 25px var(--clr); }
  100% { box-shadow: none; }
}

.footer {
  background: black;
  color: white;
  text-align: center;
  padding: 1rem;
  margin-top: auto;
  box-shadow: 0 -2px 8px rgba(0,0,0,0.3);
}

/* Responsive */
@media (max-width: 768px) {
  .toggle-btn {
    display: block;
  }

  .navbar .menu {
    display: none;
  }

  .content {
    margin-top: 4.5rem;
  }
  .sidebar {
    padding-top: 4.5rem;
  }
  .sidebar .close-btn {
    top: 0.8rem;
  }
}

/* Page Transitions */
.fade-page-enter-active,
.fade-page-leave-active {
  transition: opacity 0.3s ease;
}

.fade-page-enter-from,
.fade-page-leave-to {
  opacity: 0;
}
</style>