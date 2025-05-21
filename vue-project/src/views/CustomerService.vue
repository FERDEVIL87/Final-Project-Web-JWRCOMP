<template>
  <section class="py-5 bg-black min-vh-100 d-flex align-items-center justify-content-center">
    <div class="container text-white text-center" style="max-width: 500px;">

      <h1 style="font-size: 2rem; font-weight: 600;">Hubungi Kami</h1>

      <p class="mb-3" style="font-size: 0.95rem; font-weight: 300;">
        Kirim pertanyaan atau pesan lewat formulir ini.
      </p>

      <form>
        <div class="mb-2">
          <input type="text" class="form-control" placeholder="Nama Anda" required autocomplete="name">
        </div>
        <div class="mb-2">
          <input type="email" class="form-control" placeholder="Email Anda" required autocomplete="email">
        </div>
        <div class="mb-3">
          <textarea class="form-control" placeholder="Pesan Anda" rows="4" required></textarea>
        </div>
        <button type="submit" class="btn btn-primary w-100">Kirim</button>
      </form>
    </div>
  </section>
</template>
