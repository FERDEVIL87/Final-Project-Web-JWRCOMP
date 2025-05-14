<template>
  <section
    class="packages-section"
    aria-label="Pilihan Paket PC Kami"
  >
    <div class="content">
      <h2 class="title">Pilihan Paket PC Kami</h2>
      <div class="packages-container">
        <div
          v-for="pkg in packages"
          :key="pkg.name"
          class="package-card"
          @click="openPackageDetails(pkg)"
        >
          <h3 class="package-name">{{ pkg.name }}</h3>
          <img
            :src="pkg.imageUrl"
            :alt="`Ilustrasi untuk ${pkg.name}`"
            class="package-image"
          />
          <p class="package-description">{{ pkg.description }}</p>
        </div>
      </div>
    </div>
  </section>
  <div v-if="selectedPackage" class="package-details-modal">
    <div class="modal-content">
      <button class="close-button" @click="closePackageDetails">&times;</button>
      <h2>{{ selectedPackage.name }}</h2>
      <input
        type="text"
        v-model="searchQuery"
        placeholder="Cari rakitan..."
        class="search-box"
        aria-label="Cari rakitan"
      />
      <select v-model="selectedCategoryFilter" class="filter-button" aria-label="Pilih kategori rakitan">
        <option value="">Semua Kategori</option>
        <option value="Low Budget">Low Budget</option>
        <option value="Mid Range">Mid Range</option>
        <option value="High End">High End</option>
      </select>
      <div v-if="filteredBuilds.length > 0" class="builds-container">
        <div v-for="build in filteredBuilds" :key="build.id" class="build-card">
          <h3>{{ build.name }}</h3>
          <img :src="build.image" :alt="build.name" class="build-image" />
          <ul>
            <li v-for="spec in build.specs" :key="spec">{{ spec }}</li>
          </ul>
          <p class="build-price">{{ formatPrice(build.price) }}</p>
        </div>
      </div>
      <p v-else>Tidak ada rakitan yang cocok dengan pencarian Anda.</p>
    </div>
  </div>
</template>

<script>
export default {
  name: "PcPackages", // Changed component name
  data() {
    return {
      packages: [ // Renamed 'branches' to 'packages' and updated content
        {
          name: "Rakitan PC Gaming",
          description: "Performa maksimal untuk pengalaman gaming immersive dengan grafis memukau.",
          imageUrl: "https://placehold.co/600x300/E91E63/FFFFFF?text=Gaming+PC", // Example placeholder
        },
        {
          name: "Paket Editing",
          description: "Ideal untuk editing video, desain grafis, dan rendering 3D dengan kecepatan tinggi.",
          imageUrl: "https://placehold.co/600x300/4CAF50/FFFFFF?text=Editing+Suite", // Example placeholder
        },
        {
          name: "Paket Office",
          description: "Solusi handal dan efisien untuk kebutuhan pekerjaan kantor dan produktivitas sehari-hari.",
          imageUrl: "https://placehold.co/600x300/2196F3/FFFFFF?text=Office+Workstation", // Example placeholder
        },
        {
          name: "Paket Programming",
          description: "Dirancang untuk developer, mendukung multitasking dan kompilasi kode yang cepat.",
          imageUrl: "https://placehold.co/600x300/FFC107/333333?text=Dev+Machine", // Example placeholder
        },
        {
          name: "Paket Mini PC",
          description: "Kompak dan hemat daya, cocok untuk ruang terbatas tanpa mengorbankan performa esensial.",
          imageUrl: "https://placehold.co/600x300/795548/FFFFFF?text=Mini+PC", // Example placeholder
        },
      ],
      selectedPackage: null,
      searchQuery: "",
      selectedCategoryFilter: "",
      builds: [
        {
          id: 1,
          name: "Rakitan Low Budget",
          category: "Low Budget",
          price: 5000000,
          image: "https://placehold.co/600x300/E91E63/FFFFFF?text=Low+Budget",
          specs: ["Intel Core i3", "8GB RAM", "256GB SSD", "GTX 1050 Ti"],
        },
        {
          id: 2,
          name: "Rakitan Mid Range",
          category: "Mid Range",
          price: 10000000,
          image: "https://placehold.co/600x300/4CAF50/FFFFFF?text=Mid+Range",
          specs: ["Intel Core i5", "16GB RAM", "512GB SSD", "RTX 2060"],
        },
        {
          id: 3,
          name: "Rakitan High End",
          category: "High End",
          price: 20000000,
          image: "https://placehold.co/600x300/FFC107/333333?text=High+End",
          specs: ["Intel Core i7", "32GB RAM", "1TB SSD", "RTX 3080"],
        },
      ],
    };
  },
  computed: {
    filteredBuilds() {
      return this.builds.filter((build) => {
        const matchesSearch = build.name.toLowerCase().includes(this.searchQuery.toLowerCase());
        const matchesCategory = this.selectedCategoryFilter ? build.category === this.selectedCategoryFilter : true;
        return matchesSearch && matchesCategory;
      });
    },
  },
  methods: {
    openPackageDetails(pkg) {
      this.selectedPackage = pkg;
    },
    closePackageDetails() {
      this.selectedPackage = null;
    },
    formatPrice(value) {
      if (typeof value !== "number") {
        return value;
      }
      return `Rp ${new Intl.NumberFormat('id-ID').format(value)}`;
    },
  },
};
</script>

<style scoped>
/* Renamed .locations-section to .packages-section for clarity */
/* Updated background to match Education.vue */
.packages-section {
  background: linear-gradient(120deg, var(--background-dark1) 0%, var(--background-dark2) 50%, var(--primary-color) 100%);
  background-size: 200% 200%;
  height: auto;
  display: flex;
  flex-direction: column;
  align-items: center;
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
  color: #05d8fe;
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

/* Renamed .branches-container to .packages-container */
.packages-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
  width: 100%;
  max-width: 1200px; /* Added max-width for better layout on wider screens */
}

/* Enhanced package-card design for a modern look */
.package-card {
  background: var(--background-dark3);
  border-radius: 15px; /* Increased border radius for a smoother look */
  padding: 25px; /* Slightly increased padding for better spacing */
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3); /* Enhanced shadow for depth */
  text-align: center;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  overflow: hidden; /* Ensures content stays within the card */
  position: relative;
}

.package-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.1), rgba(0, 0, 0, 0.1));
  z-index: 0;
  pointer-events: none; /* Prevents interaction with the overlay */
}

.package-card:hover {
  transform: translateY(-10px) scale(1.05); /* Increased hover effect */
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.4); /* More pronounced shadow on hover */
}

.package-card .package-name {
  font-size: 1.8rem; /* Slightly larger font size */
  margin-bottom: 20px;
  color: var(--primary-color);
  font-weight: bold;
  z-index: 1; /* Ensures text is above the overlay */
}

.package-card .package-image {
  width: 100%;
  height: auto;
  max-height: 250px; /* Increased max height for better visuals */
  object-fit: cover;
  border-radius: 10px;
  margin-bottom: 20px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
  z-index: 1;
}

.package-card .package-description {
  font-size: 1.2rem; /* Slightly larger font size for readability */
  color: #ccc; /* Softer text color */
  line-height: 1.8; /* Improved line spacing */
  z-index: 1;
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

@keyframes bounceText {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-5px);
  }
}

/* Renamed .branch-map to .package-image */
.package-image {
  width: 100%;
  height: auto; /* Maintain aspect ratio */
  max-height: 200px; /* Added max-height to keep images reasonably sized */
  object-fit: cover; /* Ensure image covers the area well */
  border-radius: 8px;
  margin-bottom: 15px; /* Adjusted margin */
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
}

.package-image:hover {
  transform: scale(1.05); /* Slightly reduced scale effect from 1.1 to 1.05 */
}

/* Renamed .branch-address to .package-description */
.package-description {
  font-size: 1.1rem; /* Slightly adjusted font size */
  color: #555;
  font-style: normal; /* Removed italic, can be added back if preferred */
  animation: fadeInText 1.5s ease-in-out;
  flex-grow: 1; /* Allows description to take available space if card heights vary */
  line-height: 1.6; /* Improved readability */
}

@keyframes fadeInText {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.package-details-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.8);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background: #fff;
  padding: 20px;
  border-radius: 10px;
  width: 80%;
  max-width: 800px;
  position: relative;
}

.close-button {
  position: absolute;
  top: 10px;
  right: 10px;
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
}

.builds-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
  margin-top: 20px;
}

.build-card {
  background: var(--background-dark3);
  border-radius: 10px;
  padding: 15px;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
  text-align: center;
}

.build-image {
  width: 100%;
  height: auto;
  max-height: 200px;
  object-fit: cover;
  border-radius: 8px;
  margin-bottom: 10px;
}

.build-price {
  font-size: 1.2rem;
  color: var(--primary-color);
  font-weight: bold;
  margin-top: 10px;
}
</style>
