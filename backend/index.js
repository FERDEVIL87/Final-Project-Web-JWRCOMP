require("dotenv").config();
const express = require("express");
const cors = require("cors");
const path = require("path");
const methodOverride = require("method-override");
const session = require("express-session");
const flash = require("connect-flash");
const sequelize = require("./config/database");

// Import rute master
const apiRoutes = require("./routes/apiRoutes");
const adminRoutes = require("./routes/adminRoutes");

const app = express();

// --- Konfigurasi Middleware ---

const allowedOrigins = [
  "http://localhost:5176",
  "http://localhost:4173",
  "http://localhost:3001",
  "https://fp-web-with-react.vercel.app/",
  "https://raven-thorough-marginally.ngrok-free.app",
  "https://wolf-supreme-grouse.ngrok-free.app",
  "https://antelope-balanced-ferret.ngrok-free.app",
];

const corsOptions = {
  origin: function (origin, callback) {
    // Izinkan requests tanpa origin (mobile apps, postman, dll)
    if (!origin) return callback(null, true);
    
    // Izinkan localhost dengan port apapun
    if (origin.match(/^http:\/\/localhost:\d+$/)) {
      return callback(null, true);
    }
    
    // Izinkan semua subdomain ngrok
    if (origin.match(/^https:\/\/.*\.ngrok-free\.app$/)) {
      return callback(null, true);
    }
    
    // Izinkan origins yang ada di allowedOrigins
    if (allowedOrigins.indexOf(origin) !== -1) {
      callback(null, true);
    } else {
      console.log('CORS blocked origin:', origin);
      callback(new Error("Akses diblokir oleh kebijakan CORS"));
    }
  },
  methods: "GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS",
  credentials: true,
  optionsSuccessStatus: 204,
};

app.use(cors(corsOptions));

// Middleware untuk menangani ngrok headers
app.use((req, res, next) => {
  // Menangani ngrok-skip-browser-warning header
  res.header('ngrok-skip-browser-warning', 'true');
  
  // Menambahkan headers tambahan untuk kompatibilitas ngrok
  res.header('Access-Control-Allow-Origin', req.headers.origin || '*');
  res.header('Access-Control-Allow-Methods', 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization, ngrok-skip-browser-warning');
  res.header('Access-Control-Allow-Credentials', 'true');
  
  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    res.sendStatus(200);
  } else {
    next();
  }
});

app.use(
  session({
    secret:
      process.env.JWT_SECRET || "ganti_dengan_kunci_rahasia_yang_sangat_aman",
    resave: false,
    saveUninitialized: true,
    cookie: { secure: process.env.NODE_ENV === "production" },
  })
);
app.use(flash());
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(methodOverride("_method"));
app.use("/public", express.static(path.join(__dirname, "public")));
app.use("/uploads", express.static(path.join(__dirname, "uploads")));
app.use((req, res, next) => {
  res.locals.success = req.flash("success");
  res.locals.error = req.flash("error");
  res.locals.errors = req.flash("errors");
  res.locals.currentPath = req.path;
  next();
});

// --- Koneksi Database ---
sequelize
  .authenticate()
  .then(() => console.log("Database connected successfully."))
  .catch((err) => console.error("Unable to connect to the database:", err));

// --- Definisi Rute ---
app.get("/", (req, res) => res.redirect("/admin/users"));
app.use("/api", apiRoutes);
app.use("/admin", adminRoutes);

// --- Menjalankan Server ---
const PORT = process.env.PORT || 3001;
// PERUBAHAN KRUSIAL ADA DI BARIS DI BAWAH INI
app.listen(PORT, "0.0.0.0", () =>
  console.log(`Server running on port ${PORT} and listening on all interfaces`)
);

module.exports = app;
