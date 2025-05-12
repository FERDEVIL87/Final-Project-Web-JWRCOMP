<template>
  <section
    class="locations-section"
    aria-label="Lokasi Toko"
  >
    <div class="content">
      <h2 class="title">Lokasi Cabang Kami</h2>
      <div class="branches-container">
        <div
          v-for="branch in branches"
          :key="branch.name"
          class="branch-card"
        >
          <h3 class="branch-name">{{ branch.name }}</h3>
          <img
            :src="`https://maps.googleapis.com/maps/api/staticmap?center=${branch.lat},${branch.lng}&zoom=15&size=600x300&maptype=roadmap&markers=color:red%7C${branch.lat},${branch.lng}&key=YOUR_GOOGLE_MAPS_API_KEY`"
            :alt="`Peta lokasi ${branch.name}`"
            class="branch-map"
          />
          <p class="branch-address">{{ branch.address }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: "StoreLocation",
  data() {
    return {
      branches: [
        {
          name: "Cabang Jakarta",
          address: "Jl. Sudirman No. 123, Jakarta, Indonesia",
          lat: -6.2088,
          lng: 106.8456,
        },
        {
          name: "Cabang Bandung",
          address: "Jl. Asia Afrika No. 45, Bandung, Indonesia",
          lat: -6.9175,
          lng: 107.6191,
        },
        {
          name: "Cabang Surabaya",
          address: "Jl. Tunjungan No. 10, Surabaya, Indonesia",
          lat: -7.2575,
          lng: 112.7521,
        },
      ],
    };
  },
};
</script>

<style scoped>
.locations-section {
  height: auto;
  display: flex;
  flex-direction: column;
  align-items: center;
  background: linear-gradient(135deg, #e0f7fa, #e1bee7);
  color: #333;
  text-align: center;
  padding: 40px 20px;
  box-sizing: border-box;
  border-radius: 12px;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
  position: relative;
  overflow: hidden;
  animation: fadeInBackground 2s ease-in-out;
}

@keyframes fadeInBackground {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.title {
  font-size: 2.5rem;
  margin-bottom: 30px;
  color: #006476;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
  animation: textGlow 2s infinite alternate;
}

@keyframes textGlow {
  from {
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2), 0 0 10px #006476, 0 0 20px #006476;
  }
  to {
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2), 0 0 15px #00bcd4, 0 0 30px #00bcd4;
  }
}

.branches-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.branch-card {
  background: #fff;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  text-align: center;
  animation: slideIn 1s ease-in-out;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.branch-card:hover {
  transform: translateY(-5px) scale(1.05);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
}

.branch-name {
  font-size: 1.5rem;
  margin-bottom: 10px;
  color: #333;
  font-weight: bold;
  animation: bounceText 1.5s infinite;
}

@keyframes bounceText {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-5px);
  }
}

.branch-map {
  width: 100%;
  border-radius: 8px;
  margin-bottom: 10px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
}

.branch-map:hover {
  transform: scale(1.1);
}

.branch-address {
  font-size: 1.2rem;
  color: #555;
  font-style: italic;
  animation: fadeInText 1.5s ease-in-out;
}

@keyframes fadeInText {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}
</style>
