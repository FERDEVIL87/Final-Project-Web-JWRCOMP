import axios from 'axios';

// 1. Tentukan baseURL default untuk lingkungan development
let devBaseURL = 'http://localhost:3001/api';

// 2. Cek apakah ada variabel environment khusus untuk Ngrok
//    Nama variabelnya adalah VITE_NGROK_API_URL
if (import.meta.env.VITE_NGROK_API_URL) {
  console.log(`%c[API] Menggunakan Ngrok URL: ${import.meta.env.VITE_NGROK_API_URL}`, 'color: #7c3aed; font-weight: bold;');
  devBaseURL = import.meta.env.VITE_NGROK_API_URL;
}

// 3. Tentukan baseURL akhir secara dinamis
const baseURL = import.meta.env.PROD
  ? '/api' // Gunakan relative path untuk production (Vercel)
  : devBaseURL; // Gunakan URL dev (bisa dari localhost atau Ngrok)

// 4. Buat instance apiClient
const apiClient = axios.create({
    baseURL: baseURL,
    withCredentials: true, // Penting untuk CORS dengan credentials
    headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true' // Header untuk ngrok
    }
});

// 5. Interceptor (tidak berubah)
apiClient.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem('authToken');
        if (token) {
            config.headers['Authorization'] = `Bearer ${token}`;
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

export default apiClient;