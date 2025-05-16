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
/* Global Resets & Scrollbar Styling */
:global(html),
:global(body) {
  margin: 0;
  padding: 0;
  width: 100%;
  height: 100%;
  background-color: black; /* Ensures no white flashes or borders */
  overflow-x: hidden; /* Prevents accidental horizontal scrollbars */

  /* For Firefox */
  scrollbar-width: thin; /* 'auto', 'thin', 'none' */
  scrollbar-color: #555555 #1e1e1e; /* thumb track */
}

/* For Webkit-based browsers (Chrome, Safari, Edge, Opera) */
:global(html::-webkit-scrollbar),
:global(body::-webkit-scrollbar) {
  width: 8px; /* Lebar scrollbar vertikal */
  height: 8px; /* Tinggi scrollbar horizontal */
}

:global(html::-webkit-scrollbar-track),
:global(body::-webkit-scrollbar-track) {
  background: #1e1e1e; /* Warna latar belakang track */
}

:global(html::-webkit-scrollbar-thumb),
:global(body::-webkit-scrollbar-thumb) {
  background-color: #555555; /* Warna thumb (batang scroll) */
  border-radius: 4px;    /* Membuat sudut thumb melengkung */
  border: 1px solid #333333; /* Opsional: border tipis di sekitar thumb */
}

:global(html::-webkit-scrollbar-thumb:hover),
:global(body::-webkit-scrollbar-thumb:hover) {
  background-color: #777777; /* Warna thumb saat di-hover */
}

/* Universal Box Sizing & Reset */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.layout {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background: black;
  width: 100%;
}

/* Navbar */
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: black;
  padding: 1rem; /* Vertical padding for navbar */
  flex-wrap: wrap;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  z-index: 1100;
  box-shadow: 0 2px 8px rgba(0,0,0,0.3);
}

.logo {
  color: white; /* For alt text */
  display: flex;
  align-items: center;
}

.logo img {
  max-height: 40px; /* Adjust as needed to fit navbar */
  width: auto;
  display: block;
}

.toggle-btn {
  background: none;
  border: none;
  font-size: 1.5rem;
  color: white;
  cursor: pointer;
  display: none; /* Shown in media query */
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
  background: black;
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
  background: black;
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
  background: black;
  padding: 1rem; /* Side padding for sidebar content */
  /* This padding-top must be at least navbar height */
  padding-top: calc(2rem + 40px + 1rem); /* (navbar padding-v*2) + logo height + extra space */
  transform: translateX(-100%);
  transition: transform 0.3s ease;
  z-index: 1000;
  box-shadow: 3px 0 10px rgba(0,0,0,0.3);
  overflow-y: auto; /* Allow sidebar to scroll if content is too long */
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
  top: 1rem; /* Relative to sidebar padding */
  right: 1rem; /* Relative to sidebar padding */
}

/* Main Content */
.content {
  /* This margin-top must be at least navbar height */
  margin-top: calc(2rem + 40px); /* (navbar padding-v*2) + logo height */
  padding: 1rem 0; /* Vertical padding, no horizontal padding for full width content */
  flex-grow: 1;
  color: white;
}

/* Footer */
.footer {
  background: black;
  color: white;
  text-align: center;
  padding: 1rem 0; /* Vertical padding, no horizontal padding */
  margin-top: auto;
  box-shadow: 0 -2px 8px rgba(0,0,0,0.3);
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

/* Responsive */
@media (max-width: 768px) {
  .toggle-btn {
    display: block;
  }

  .navbar .menu {
    display: none; /* Hide desktop menu on small screens */
  }

  /* Adjust top margin/padding for content and sidebar if navbar height changes on mobile */
  /* Assuming navbar height is consistent: (padding-v*2) + logo height */
  .content {
    margin-top: calc(2rem + 40px);
    /* Optional: Add side padding to content on mobile if desired */
    /* padding: 1rem 0.5rem; */
  }
  .sidebar {
    padding-top: calc(2rem + 40px + 1rem); /* Keep consistent with desktop or adjust */
  }
  .sidebar .close-btn {
    top: 1rem; /* Ensure it's positioned well relative to sidebar's top padding */
    right: 1rem;
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