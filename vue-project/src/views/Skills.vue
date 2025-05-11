<template>
  <section class="skills-section" :style="{ backgroundPosition: backgroundPosition }">
    <div class="content">
      <h2 class="h3 mb-4 text-primary">Keterampilan Saya</h2>
      <ul class="skills-list">
        <li v-for="skill in skills" :key="skill" class="skill-item">
          {{ skill }}
        </li>
      </ul>
    </div>
  </section>
</template>

<script>
export default {
  data() {
    return {
      skills: [
        "Pemrograman (JavaScript, Python, C++)",
        "Pengembangan Web (Vue.js, React, HTML, CSS)",
        "Desain UI/UX",
        "Bermain Game Kompetitif",
        "Analisis Data",
        "Manajemen Proyek",
      ],
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
.skills-section {
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(120deg, #1e1e2f, #828282, #006476);
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

.content h2 {
  font-size: 2.5rem;
  margin-bottom: 20px;
  text-shadow: 0 0 10px #7d1eff, 0 0 20px #c300ff;
}

/* Daftar keterampilan */
.skills-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.skill-item {
  font-size: 1.2rem;
  margin-bottom: 10px;
  padding: 10px;
  background: rgba(125, 30, 255, 0.1);
  border-radius: 5px;
  box-shadow: 0 0 5px rgba(125, 30, 255, 0.5);
  transition: transform 0.3s ease, background 0.3s ease;
}

.skill-item:hover {
  transform: translateY(-5px);
  background: rgba(125, 30, 255, 0.2);
  box-shadow: 0 5px 15px rgba(125, 30, 255, 0.7);
}
</style>