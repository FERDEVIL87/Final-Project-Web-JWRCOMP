<!-- Education.vue -->
<script>
export default {
  name: "EducationSection",
  data() {
    return {
      educations: [
        {
          id: 1,
          title: "Universitas Amikom Yogyakarta",
          details: "<strong>Gelar:</strong> S.T. [Informatika]<br><strong>Tahun:</strong> 2023 – 2027",
          icon: "🎓",
        },
        {
          id: 2,
          title: "SMK Negeri 1 Godean",
          details: "<strong>Program:</strong> Multimedia<br><strong>Tahun:</strong> 2020 – 2023",
          icon: "🏫",
        },
        {
          id: 3,
          title: "SMP Negeri 2 Sleman",
          details: "<strong>Tahun:</strong> 2017 – 2020",
          icon: "📚",
        },
        {
          id: 4,
          title: "SD Negeri 1 Sleman",
          details: "<strong>Tahun:</strong> 2011 – 2017",
          icon: "✏️",
        },
        {
          id: 5,
          title: "Kursus Bahasa Inggris",
          details: "<strong>Institusi:</strong> English First<br><strong>Tahun:</strong> 2019 – 2020",
          icon: "🌐",
        },
        {
          id: 6,
          title: "Pelatihan Desain Grafis",
          details: "<strong>Institusi:</strong> Adobe Academy<br><strong>Tahun:</strong> 2021",
          icon: "🎨",
        },
        {
          id: 7,
          title: "Workshop Pemrograman",
          details: "<strong>Institusi:</strong> CodePolitan<br><strong>Tahun:</strong> 2022",
          icon: "💻",
        },
        {
          id: 8,
          title: "Kursus Public Speaking",
          details: "<strong>Institusi:</strong> Toastmasters<br><strong>Tahun:</strong> 2020",
          icon: "🎤",
        },
      ],
    };
  },
};
</script>

<template>
  <section class="education-section">
    <h2 class="section-title">
      Riwayat Pendidikan
    </h2>
    <div class="cards-grid">
      <div
        v-for="(edu, index) in educations"
        :key="edu.id"
        class="card"
        :style="{ animationDelay: (index * 0.15 + 0.4) + 's' }"
      >
        <div class="card-header">
          <span v-if="edu.icon" class="card-icon" aria-hidden="true">{{ edu.icon }}</span>
          <h3 class="card-title">{{ edu.title }}</h3>
        </div>
        <p class="card-text" v-html="edu.details"></p>
      </div>
    </div>
  </section>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@400;500;700&family=Roboto:wght@300;400;700&display=swap');

/* --- KEYFRAMES UNTUK ANIMASI --- */
@keyframes fadeInSlideUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.education-section {
  --primary-color: #7d1eff; /* Ungu neon */
  --secondary-color: #00c6ff; /* Biru neon */
  --background-dark1: #12121a; /* Warna dasar gelap */
  --background-dark2: #1a1a24; /* Sedikit lebih terang */
  --background-dark3: #23232e; /* Untuk card */
  --text-section-title: #ffffff; /* Neon white untuk judul section */
  
  /* Warna Teks di Dalam Card (Box) */
  --text-card-title-color: #ffffff;
  --text-card-title-hover-color: #f0f0ff; /* Warna judul kartu saat hover (lebih terang/sedikit kebiruan) */
  
  --text-card-body-color: rgba(235, 235, 255, 0.85); /* Warna body kartu (sedikit lebih redup dari sebelumnya untuk kontras hover) */
  --text-card-body-hover-color: #ffffff; /* Warna body kartu saat hover (putih penuh) */
  
  --text-card-strong-color: #ffffff;
  --text-card-strong-hover-color: #f0f0ff; /* Warna strong saat hover */
  
  --border-futuristic: rgba(125, 30, 255, 0.3);

  font-family: 'Roboto', sans-serif;
  min-height: 100vh;
  background: linear-gradient(120deg, #1e1e2f, #2a2a3f, var(--primary-color));
  background-size: 200% 200%;
  color: #fff;
  text-align: center;
  padding: 60px 20px;
  box-sizing: border-box;
  transition: background-position 0.1s ease-out;
  display: flex;
  flex-direction: column;
  align-items: center;
  overflow-x: hidden; /* Mencegah scroll horizontal dari animasi */
}

.section-title {
  font-family: 'Orbitron', sans-serif;
  font-size: clamp(2rem, 5vw, 3.5rem);
  font-weight: 700;
  color: var(--text-section-title);
  text-shadow: 0 0 10px var(--text-section-title), 0 0 20px var(--primary-color);
  margin-bottom: 60px;
  position: relative;
  text-transform: uppercase;
  letter-spacing: 2px;

  /* Animasi untuk judul */
  opacity: 0;
  animation: fadeIn 0.8s ease-out 0.2s forwards;
}

.section-title::after {
  content: '';
  position: absolute;
  bottom: -20px;
  left: 50%;
  transform: translateX(-50%);
  width: 80px;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
  border-radius: 2px;
  box-shadow: 0 0 15px var(--primary-color), 0 0 10px var(--secondary-color);
}

.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 320px), 1fr));
  gap: 30px;
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
}

.card {
  background: var(--background-dark3);
  border-radius: 15px;
  padding: 25px;
  text-align: left;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
  /* Transisi untuk hover kartu dan hover teks di dalamnya */
  transition: transform 0.3s ease, box-shadow 0.3s ease, color 0.3s ease, text-shadow 0.3s ease;
  border: 1px solid var(--border-futuristic);
  display: flex;
  flex-direction: column;

  opacity: 0;
  animation: fadeInSlideUp 0.6s ease-out forwards;
}

.card:hover {
  transform: translateY(-10px) scale(1.02);
  box-shadow: 0 15px 35px rgba(125, 30, 255, 0.3),
              0 0 20px rgba(0, 198, 255, 0.2);
}

.card-header {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
}

.card-icon {
  font-size: 2rem;
  margin-right: 15px;
  color: var(--primary-color);
  transition: color 0.3s ease; /* Transisi untuk ikon juga */
}

.card:hover .card-icon {
  color: var(--secondary-color); /* Ubah warna ikon saat hover kartu */
}

.card-title {
  font-family: 'Orbitron', sans-serif;
  font-size: 1.5rem;
  font-weight: 500;
  color: var(--text-card-title-color);
  text-shadow: 0 0 8px var(--primary-color);
  margin-bottom: 0;
  transition: color 0.3s ease, text-shadow 0.3s ease; /* Transisi untuk judul */
}

.card:hover .card-title {
  color: var(--text-card-title-hover-color);
  text-shadow: 0 0 6px var(--text-card-title-hover-color), 0 0 12px var(--secondary-color); /* Glow lebih terang atau dengan warna sekunder */
}

.card-text {
  color: var(--text-card-body-color);
  text-shadow: 0 0 7px rgba(125, 30, 255, 0.35); /* Sedikit redup shadow awal */
  font-size: 0.95rem;
  line-height: 1.7;
  flex-grow: 1;
  transition: color 0.3s ease, text-shadow 0.3s ease; /* Transisi untuk teks body */
  opacity: 0; /* Initially hidden */
  transform: translateY(10px); /* Slightly shifted down */
  transition: opacity 0.3s ease, transform 0.3s ease; /* Smooth transition */
}

.card:hover .card-text {
  color: var(--text-card-body-hover-color);
  text-shadow: 0 0 5px rgba(255, 255, 255, 0.3), 0 0 10px var(--secondary-color); /* Glow putih lembut dan dari warna sekunder */
  opacity: 1; /* Fully visible on hover */
  transform: translateY(0); /* Move to original position */
}

.card-text strong {
  color: var(--text-card-strong-color);
  font-weight: 700;
  text-shadow: 0 0 5px var(--primary-color);
  transition: color 0.3s ease, text-shadow 0.3s ease; /* Transisi untuk strong */
}

.card:hover .card-text strong {
  color: var(--text-card-strong-hover-color);
  text-shadow: 0 0 6px var(--text-card-strong-hover-color), 0 0 10px var(--secondary-color);
}
</style>
