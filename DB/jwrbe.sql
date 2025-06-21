-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 21 Jun 2025 pada 13.22
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jwrbe`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `banners`
--

CREATE TABLE `banners` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `brand` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `slogan` varchar(255) NOT NULL,
  `imageSrc` varchar(2048) NOT NULL,
  `features` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`features`)),
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `order_column` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `banners`
--

INSERT INTO `banners` (`id`, `brand`, `name`, `slogan`, `imageSrc`, `features`, `is_active`, `order_column`, `created_at`, `updated_at`) VALUES
(1, 'Nvidia', 'Death', 'Bajingan Jaya', '/storage/banners/BRszHUkCIVMczYRlKm7LiYppfMkrloz4yf3ph42x.jpg', '[\"dfafdgsdfgsery\",\"dfghdfgudu\"]', 1, 3, '2025-06-21 00:56:16', '2025-06-21 00:56:16'),
(2, 'Razer', 'sreyser', 'asd', 'https://sm.pcmag.com/pcmag_me/review/c/chatgpt-4o/chatgpt-4o_9w63.jpg', '[\"vfdhdfgh\"]', 1, 1, '2025-06-21 01:08:42', '2025-06-21 01:08:42');

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `checkouts`
--

CREATE TABLE `checkouts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `transaction_id` varchar(255) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(15,2) NOT NULL,
  `total_price` decimal(15,2) NOT NULL,
  `customer_name` varchar(255) NOT NULL,
  `customer_address` text NOT NULL,
  `customer_phone` varchar(20) NOT NULL,
  `purchase_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `status_order` enum('Belum Dikonfirmasi','Sudah Dikonfirmasi','Sudah Dikirim','Selesai','Dibatalkan') NOT NULL DEFAULT 'Belum Dikonfirmasi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `console_and_handhelds`
--

CREATE TABLE `console_and_handhelds` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(15,2) NOT NULL,
  `brand` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `specs` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`specs`)),
  `stock` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `customer_services`
--

CREATE TABLE `customer_services` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `pesan` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `laptops`
--

CREATE TABLE `laptops` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `price` decimal(15,2) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `stock` int(11) NOT NULL,
  `brand` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `laptops`
--

INSERT INTO `laptops` (`id`, `name`, `category`, `price`, `image`, `description`, `stock`, `brand`, `created_at`, `updated_at`) VALUES
(1, 'RTX gtxx', 'High-End', 12000.00, 'https://static.jakmall.id/2021/01/images/products/851a60/detail/rexus-keyboard-gaming-mechanical-legionare-mx9-tkl-rgb.jpg', 'asdsdfwer', 5, 'Sony', '2025-06-20 23:34:07', '2025-06-20 23:34:07'),
(2, 'Asuwasuwa', 'Low-End', 2355.00, '/storage/laptops/VFteQi536MGBiSnRkx22dve1L4kAQm9C6DXuFXns.jpg', 'dfgsfg', 23, 'Asu Bajingan', '2025-06-21 02:07:01', '2025-06-21 02:07:01');

-- --------------------------------------------------------

--
-- Struktur dari tabel `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_06_14_152257_create_pc_parts_table', 1),
(5, '2025_06_14_152310_create_laptops_table', 1),
(6, '2025_06_14_152315_create_pc_rakitans_table', 1),
(7, '2025_06_14_152334_create_console_and_handhelds_table', 1),
(8, '2025_06_14_152338_create_customer_services_table', 1),
(9, '2025_06_15_075259_create_checkouts_table', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `password_reset_tokens`
--

INSERT INTO `password_reset_tokens` (`email`, `token`, `created_at`) VALUES
('Wandaba@asdf.gh', '$2y$12$qTeWPJaRczQU/7vTiyPMzu3IavuKtK1JQAxwHRIXIlOM6T7xQQv6m', '2025-06-21 04:18:12');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pc_parts`
--

CREATE TABLE `pc_parts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `brand` varchar(100) NOT NULL,
  `category` varchar(100) NOT NULL,
  `image` text DEFAULT NULL,
  `specs` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`specs`)),
  `stock` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pc_rakitans`
--

CREATE TABLE `pc_rakitans` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `category` varchar(100) NOT NULL,
  `price` decimal(12,2) NOT NULL,
  `image` text NOT NULL,
  `description` text NOT NULL,
  `specs` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`specs`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pc_rakitans`
--

INSERT INTO `pc_rakitans` (`id`, `name`, `category`, `price`, `image`, `description`, `specs`, `created_at`, `updated_at`) VALUES
(1, 'sdgsdfv', 'Streaming', 123.00, 'https://rexus.id/cdn/shop/files/K65M_2.png?v=1716865044', 'adftar', '{\"CPU\":\"sdf\",\"GPU\":\"sfg\",\"RAM\":\"sfg\",\"Storage\":\"sfg\",\"PSU\":\"ert\",\"Casing\":\"dfg\"}', '2025-06-21 01:38:32', '2025-06-21 01:38:32'),
(2, 'Asuwasuwa', 'Office', 23434.00, '/storage/pc-rakitans/WGBIrVqz0v64vtDbdgHL0LztXnivL7cyNF91SHxF.jpg', 'sdfasdg', '{\"CPU\":\"\",\"GPU\":\"\",\"RAM\":\"\",\"Storage\":\"\",\"PSU\":\"\",\"Casing\":\"\"}', '2025-06-21 01:50:13', '2025-06-21 01:50:13');

-- --------------------------------------------------------

--
-- Struktur dari tabel `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(3, 'App\\Models\\User', 3, 'auth_token', '3aa5d9ffb8adff505da4a44b0cab3f7053697692f3e236c21c9c67694d0b041e', '[\"*\"]', NULL, NULL, '2025-06-20 23:32:23', '2025-06-20 23:32:23'),
(5, 'App\\Models\\User', 3, 'auth_token', 'e20774ba22cb34dc17044459828cb83537d9f4474322fcce43c525d66438f7a1', '[\"*\"]', NULL, NULL, '2025-06-21 04:18:52', '2025-06-21 04:18:52');

-- --------------------------------------------------------

--
-- Struktur dari tabel `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('ZNeTh0FKkM7baYy30nbb7OpLTSLuMr5G9SjFrL0E', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoibklYUTFpQ3lMbzNsUVRtc0hCd1ZlSG5PN1VlMjhDcUZiRkFHVTdOSSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mzg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9jdXN0b21lci1zZXJ2aWNlIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MTt9', 1750504685);

-- --------------------------------------------------------

--
-- Struktur dari tabel `tech_news`
--

CREATE TABLE `tech_news` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `excerpt` text NOT NULL,
  `date` date NOT NULL,
  `source` varchar(255) NOT NULL,
  `imageUrl` varchar(2048) DEFAULT NULL,
  `readMoreUrl` varchar(2048) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `tech_news`
--

INSERT INTO `tech_news` (`id`, `title`, `excerpt`, `date`, `source`, `imageUrl`, `readMoreUrl`, `created_at`, `updated_at`) VALUES
(1, 'sdrawegdvg', 'sdfasdf', '2020-06-16', 'asdfscvary5u', '/storage/tech-news/gVHk6HW4DgY2RpaTN34IDylmz3xM4cATaFyuOYLX.jpg', 'https://www.youtube.com/watch?v=iTl7pzW9Bio', '2025-06-21 01:33:08', '2025-06-21 01:33:08');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','user') NOT NULL DEFAULT 'user',
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `email_verified_at`, `password`, `role`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'taianjing', 'taianjing@gmail.com', NULL, '$2y$12$VcKk3GB2dzv5JGTFz346MOUXsJt0T6R2zhYF3Qk3wR4KBQWf1lXLi', 'admin', NULL, '2025-06-20 09:08:57', '2025-06-20 09:08:57'),
(2, 'bajingan', 'bajingan@dfsdf.com', NULL, '$2y$12$1582M0x6A1993BgKzu793uHztSQ.1SY34j7JoLtlvImENn9HkbHma', 'user', NULL, '2025-06-20 09:10:35', '2025-06-20 09:10:35'),
(3, 'Wandaba', 'Wandaba@asdf.gh', NULL, '$2y$12$nazK86.ZsjYXgolKswZNfegu0CKr26NEViL7Jwr4ekXKjjxt/Rnni', 'user', NULL, '2025-06-20 09:18:00', '2025-06-20 09:18:00');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `banners`
--
ALTER TABLE `banners`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indeks untuk tabel `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indeks untuk tabel `checkouts`
--
ALTER TABLE `checkouts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `checkouts_transaction_id_index` (`transaction_id`);

--
-- Indeks untuk tabel `console_and_handhelds`
--
ALTER TABLE `console_and_handhelds`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `customer_services`
--
ALTER TABLE `customer_services`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indeks untuk tabel `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indeks untuk tabel `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `laptops`
--
ALTER TABLE `laptops`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indeks untuk tabel `pc_parts`
--
ALTER TABLE `pc_parts`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `pc_rakitans`
--
ALTER TABLE `pc_rakitans`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `personal_access_tokens_tokenable_index` (`tokenable_type`,`tokenable_id`);

--
-- Indeks untuk tabel `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indeks untuk tabel `tech_news`
--
ALTER TABLE `tech_news`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_username_unique` (`username`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `banners`
--
ALTER TABLE `banners`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `checkouts`
--
ALTER TABLE `checkouts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `console_and_handhelds`
--
ALTER TABLE `console_and_handhelds`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `customer_services`
--
ALTER TABLE `customer_services`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `laptops`
--
ALTER TABLE `laptops`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `pc_parts`
--
ALTER TABLE `pc_parts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pc_rakitans`
--
ALTER TABLE `pc_rakitans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `tech_news`
--
ALTER TABLE `tech_news`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
