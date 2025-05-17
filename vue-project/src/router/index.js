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
  { path: '/checkout', name: 'Checkout', component: () => import('@/views/Checkout.vue')}
]

export default createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior: () => ({ top: 0 })
})