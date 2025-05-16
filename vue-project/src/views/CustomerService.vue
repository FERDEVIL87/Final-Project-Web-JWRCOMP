<template>
  <section class="contact-section" :style="{ backgroundPosition: backgroundPosition }">
    <div class="content">
      <h1>Hubungi Kami</h1>
      <p>
        Jika Anda memiliki pertanyaan atau membutuhkan bantuan, jangan ragu untuk menghubungi kami melalui formulir di bawah ini.
      </p>
      <form class="contact-form">
        <input type="text" placeholder="Nama Anda" required />
        <input type="email" placeholder="Email Anda" required />
        <textarea placeholder="Pesan Anda" rows="5" required></textarea>
        <button type="submit">Kirim</button>
      </form>
    </div>
  </section>
</template>

<script>
export default {
  data() {
    return {
      backgroundPosition: "0% 50%", // Posisi awal background
    };
  },
  mounted() {
    window.addEventListener("scroll", this.handleScroll);
  },
  beforeUnmount() {
    window.removeEventListener("scroll", this.handleScroll);
  },
  methods: {
    handleScroll() {
      // Hitung posisi scroll
      const scrollTop = window.scrollY;
      const scrollHeight = document.documentElement.scrollHeight - window.innerHeight;

      // Ubah posisi background berdasarkan posisi scroll
      const scrollPercentage = (scrollTop / scrollHeight) * 100;
      this.backgroundPosition = `${scrollPercentage}% 50%`;
    },
  },
};
</script>

<style scoped>
/* Animasi latar belakang */
.contact-section {
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(120deg, #1e1e2f, #0f2572, #004cff);
  background-size: 200% 200%;
  color: #fff;
  text-align: center;
  padding: 20px;
  box-sizing: border-box;
  transition: background-position 0.1s ease-out;
}

/* Konten */
.content {
  max-width: 600px;
}

.content h1 {
  font-size: 2.5rem;
  margin-bottom: 20px;
  text-shadow: 0 0 10px #1f2b85, 0 0 20px #2858af;
}

.content p {
  font-size: 1.2rem;
  margin-bottom: 30px;
  line-height: 1.6;
}

.contact-form {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.contact-form input,
.contact-form textarea {
  width: 100%;
  padding: 10px;
  border: none;
  border-radius: 5px;
  font-size: 1rem;
  box-shadow: 0 0 5px rgba(0, 151, 201, 0.5);
}

.contact-form button {
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  background: linear-gradient(90deg, #09198f, #0054b4);
  color: #fff;
  font-size: 1rem;
  cursor: pointer;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.contact-form button:hover {
  transform: translateY(-3px);
  box-shadow: 0 5px 15px rgba(0, 29, 191, 0.7);
}
</style>