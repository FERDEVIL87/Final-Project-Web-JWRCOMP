// src/router/index.js - INI SUDAH BENAR UNTUK PATH /checkout
import { createRouter, createWebHistory } from 'vue-router'

import Home from '@/views/Home.vue'
import ConsoleHandheld from '@/views/ConsoleHandheld.vue'
import Laptop from '@/views/Laptop.vue'
import Hardware from '@/views/Hardware.vue'
import PaketRakitan from '@/views/PaketRakitan.vue'
import CustomerService from '@/views/CustomerService.vue'

const routes = [
  { path: '/', name: 'Home', component: Home },
  { path: '/laptop', name: 'Laptop', component: Laptop },
  { path: '/consolehh',name: 'ConsoleHandheldpc', component: ConsoleHandheld },
  { path: '/hardware', name: 'Hardware', component: Hardware },
  { path: '/paketrakitan',    name: 'PaketRakitan',   component: PaketRakitan },
  { path: '/cs',   name: 'CS',     component: CustomerService },
  { path: '/checkout', name: 'Checkout', component: () => import('@/views/Checkout.vue')} // Path sudah benar '/checkout'
]

export default createRouter({
  history: createWebHistory(import.meta.env.BASE_URL), // Tambahkan import.meta.env.BASE_URL jika menggunakan Vite
  // history: createWebHistory(process.env.BASE_URL), // Jika menggunakan Vue CLI
  // history: createWebHistory(), // Jika base URL adalah '/' dan tidak ada prefix khusus
  routes,
  scrollBehavior: () => ({ top: 0 })
})