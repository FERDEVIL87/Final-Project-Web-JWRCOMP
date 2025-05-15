<script setup>
import { RouterLink, RouterView } from 'vue-router'
import { ref } from 'vue'

const items = [
  { to: '/', name: 'Tentang', color: '#00bcd4' },
  { to: '/education', name: 'Laptop', color: '#ffc107' },
  { to: '/experience', name: 'Console and Handheld PC', color: '#4caf50' },
  { to: '/portfolio', name: 'PC Parts', color: '#ff5722' },
  { to: '/skills', name: 'Paket Rakitan PC', color: '#e91e63' },
  { to: '/contact', name: 'Customer Service', color: '#9c27b0' }
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
      <div class="logo">JWR Comp</div>
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
  background: #1c1c1c;
}

/* Navbar */
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #1c1c1c;
  padding: 1rem;
  flex-wrap: wrap;
  position: fixed;         /* Tambahkan ini */
  top: 0;                  /* Tambahkan ini */
  left: 0;                 /* Tambahkan ini */
  width: 100%;             /* Tambahkan ini */
  z-index: 1100;           /* Tambahkan ini agar di atas sidebar */
  box-shadow: 0 2px 8px rgba(0,0,0,0.2);
}

.content {
  margin-top: 2rem; /* Tambahkan margin untuk menghindari navbar */
  padding: 1rem;
  flex-grow: 1;
}

.logo {
  font-size: 1.4rem;
  font-weight: bold;
  color: white;
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
  background: #1c1c1c;
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
  background: #1c1c1c;
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
  background: #1c1c1c;
  padding: 1rem;
  transform: translateX(-100%);
  transition: transform 0.3s ease;
  z-index: 1000;
}

.sidebar.open {
  transform: translateX(0);
}

.sidebar .menu {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-top: 10%;
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
  background: #272822;
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
  background: #272822;
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
  background: #272822;
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
  align-self: flex-end;
  margin-bottom: 1rem;
}

/* Animations */
@keyframes move {
  0% { transform: translateX(0); }
  50% { transform: translateX(5px); }
  100% { transform: translateX(0); }
}

@keyframes box {
  0% { box-shadow: #27272c; }
  50% { box-shadow: 0 0 25px var(--clr); }
  100% { box-shadow: #27272c; }
}

.content {
  padding: 1rem;
}

.footer {
  background: #1c1c1c;
  color: white;
  text-align: center;
  padding: 1rem;
  margin-top: auto;
}

/* Responsive */
@media (max-width: 768px) {
  .toggle-btn {
    display: block;
  }

  .menu {
    display: none;
  }
}
</style>
