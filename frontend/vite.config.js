import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'

export default defineConfig({
  plugins: [vue(), vueDevTools()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  server: {
    port: 5176, // ganti port dev server (jika ingin seragam)
    host: '0.0.0.0', // Allow external connections
    allowedHosts: ["antelope-balanced-ferret.ngrok-free.app", "alpaca-neat-treefrog.ngrok-free.app"], // Explicitly allow ngrok domains
    proxy: {
      '/api': {
        target: 'http://localhost:3001',
        changeOrigin: true,
        secure: false,
        rewrite: path => path.replace(/^\/api/, ''),
      }
    }
  },
  preview: {
    port: 4176,              // Mengatur port untuk preview
    host: '0.0.0.0',         // Allow external connections
    strictPort: true,        // Pastikan tidak auto pindah ke port lain
    allowedHosts: ["antelope-balanced-ferret.ngrok-free.app", "alpaca-neat-treefrog.ngrok-free.app"], // Explicitly allow ngrok domains
    proxy: {
      '/api': {
        target: 'http://localhost:3001',
        changeOrigin: true,
        secure: false,
        rewrite: path => path.replace(/^\/api/, ''),
      }
    }
  }
})
