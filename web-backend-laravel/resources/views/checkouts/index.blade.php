@extends('layouts.admin')

@section('title', 'Daftar Pesanan Masuk')

@section('content')
    <h2 class="section-title-bs">Daftar Pesanan Masuk</h2>

    @php
        $sort = request('sort', 'purchase_date');
        $dir = request('dir', 'desc');
        $sortOptions = [
            'purchase_date' => 'Tanggal',
            'customer_name' => 'Nama Pelanggan',
            'customer_phone' => 'No. HP',
            'customer_address' => 'Alamat',
            'status_order' => 'Status',
            'transaction_id' => 'ID Transaksi',
        ];
        // Gabungkan semua transaksi jadi satu collection untuk sorting global
        $allTransactions = $groupedByName->flatten(1);
        // Filter by search
        if(request('search')) {
            $q = strtolower(request('search'));
            $allTransactions = $allTransactions->filter(function($item) use ($q) {
                return str_contains(strtolower($item->customer_name), $q)
                    || str_contains(strtolower($item->product_name), $q)
                    || str_contains(strtolower($item->customer_phone), $q)
                    || str_contains(strtolower($item->customer_address), $q)
                    || str_contains(strtolower($item->transaction_id), $q);
            });
        }
        // Sort
        $sortedTransactions = $allTransactions->sortBy(function($item) use ($sort) {
            return $item->{$sort};
        }, SORT_REGULAR, $dir === 'desc');
        // Pagination (manual)
        $perPage = 10;
        $page = max(1, intval(request('page', 1)));
        $total = $sortedTransactions->count();
        $paged = $sortedTransactions->slice(($page-1)*$perPage, $perPage);
        // Group kembali setelah sorting dan paging
        $groupedSorted = $paged->groupBy('customer_name');
    @endphp

    {{-- Total Data --}}
    <div class="mb-2" style="color:#00d9ff;font-weight:bold;">
        Total Pesanan Masuk: {{ $allTransactions->count() }}
    </div>

    {{-- Menu search --}}
    <form method="get" class="row g-2 align-items-center mb-3" style="max-width: 600px;">
        <div class="col-auto">
            <input type="text" name="search" class="form-control form-control-sm" placeholder="Cari nama pelanggan/produk..." value="{{ request('search') }}">
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-info btn-sm">Search</button>
        </div>
        {{-- Keep sort and dir params --}}
        <input type="hidden" name="sort" value="{{ request('sort', 'purchase_date') }}">
        <input type="hidden" name="dir" value="{{ request('dir', 'desc') }}">
    </form>

    {{-- Dropdown Sorting Responsive --}}
    <form method="get" class="mb-4">
        <div class="row g-2 align-items-center justify-content-start flex-wrap" style="max-width: 600px;">
            <div class="col-12 col-md-5">
                <label for="sort" class="form-label mb-1" style="color:#00d9ff;font-weight:bold;">Urutkan Berdasarkan</label>
                <select name="sort" id="sort" class="form-select form-select-sm">
                    @foreach($sortOptions as $key => $label)
                        <option value="{{ $key }}" @if($sort == $key) selected @endif>{{ $label }}</option>
                    @endforeach
                </select>
            </div>
            <div class="col-8 col-md-4">
                <label for="dir" class="form-label mb-1" style="color:#00d9ff;font-weight:bold;">Arah</label>
                <select name="dir" id="dir" class="form-select form-select-sm">
                    <option value="asc" @if($dir == 'asc') selected @endif>Ascending</option>
                    <option value="desc" @if($dir == 'desc') selected @endif>Descending</option>
                </select>
            </div>
            <div class="col-4 col-md-3 d-flex align-items-end">
                <button type="submit" class="btn btn-info w-100" style="min-width:100px;">Sort</button>
            </div>
            {{-- Keep search param --}}
            <input type="hidden" name="search" value="{{ request('search') }}">
        </div>
    </form>

    @if(session('success'))
        <div class="success" style="margin-bottom: 20px;"><p>{{ session('success') }}</p></div>
    @endif

    @if($paged->isEmpty())
        <div class="alert alert-info" style="background-color: #1f2937; border-color: #00d9ff; color: #e8eff5;">
            Belum ada pesanan yang masuk.
        </div>
    @else
        {{-- Loop untuk setiap nama pelanggan dengan variabel $loop --}}
        @foreach($groupedSorted as $customerName => $transactions)
            @php
                $groupedTransactions = $transactions->groupBy('transaction_id');
            @endphp
            <div class="admin-card-bs p-4 mb-4">
                <h4 style="color: #00d9ff; margin-bottom: 15px;">
                    Pelanggan: {{ $customerName }}
                </h4>
                @foreach($groupedTransactions as $transaction_id => $items)
                    @php $order = $items->first(); @endphp
                    <div class="transaction-group p-3 mb-3" style="border: 1px solid #2d3748; border-radius: 8px; background-color: #11192b;">
                        <div class="d-flex justify-content-between align-items-start mb-3 border-bottom pb-3 border-secondary">
                            <div>
                                <h5 style="color: #e8eff5; margin-bottom: 8px;">ID Transaksi: {{ $transaction_id }}</h5>
                                <small style="color: #adb5bd; display: block;">
                                    Tanggal: {{ \Carbon\Carbon::parse($order->purchase_date)->format('d M Y, H:i') }}
                                </small>
                            </div>
                            <div>
                                <form action="{{ route('checkouts.destroy', $transaction_id) }}" method="POST" onsubmit="return confirm('Yakin hapus transaksi ini?');">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="btn-delete">Hapus Transaksi</button>
                                </form>
                            </div>
                        </div>
                        <div class="mb-3">
                            <p style="margin: 0;"><strong>No. HP:</strong> {{ $order->customer_phone }}</p>
                            <p style="margin: 0;"><strong>Alamat Pengiriman:</strong><br>{{ $order->customer_address }}</p>
                        </div>
                        <div class="mb-3">
                            <p><strong>Status Saat Ini:</strong> {{ $order->status_order }}</p>
                            {{-- FORM UNTUK UPDATE STATUS --}}
                            <form action="{{ route('checkouts.updateStatus', $transaction_id) }}" method="POST" class="d-flex align-items-center gap-2 mb-3">
                                @csrf
                                @method('PATCH')
                                <select name="status" class="form-select form-select-sm" style="width: 200px;">
                                    <option value="Sudah Dikonfirmasi">Konfirmasi Pesanan</option>
                                    <option value="Sudah Dikirim">Kirim Pesanan</option>
                                    <option value="Selesai">Selesaikan Pesanan</option>
                                    <option value="Dibatalkan">Batalkan Pesanan</option>
                                </select>
                                <button type="submit" class="btn btn-sm btn-info">Update Status</button>
                            </form>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-dark table-sm">
                                <thead>
                                    <tr>
                                        <th>Nama Produk</th>
                                        <th>Harga Satuan</th>
                                        <th>Jumlah</th>
                                        <th>Total Harga</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @php $grandTotal = 0; @endphp
                                    @foreach($items as $item)
                                        <tr>
                                            <td>{{ $item->product_name }}</td>
                                            <td>Rp {{ number_format($item->unit_price, 0, ',', '.') }}</td>
                                            <td>{{ $item->quantity }}</td>
                                            <td>Rp {{ number_format($item->total_price, 0, ',', '.') }}</td>
                                        </tr>
                                        @php $grandTotal += $item->total_price; @endphp
                                    @endforeach
                                </tbody>
                                <tfoot>
                                    <tr style="background-color: #1f2937;">
                                        <td colspan="3" class="text-end fw-bold">Total Transaksi</td>
                                        <td class="fw-bold">Rp {{ number_format($grandTotal, 0, ',', '.') }}</td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                @endforeach
            </div>
        @endforeach

        {{-- Pagination links --}}
        @php
            $lastPage = ceil($total / $perPage);
            $query = request()->except('page');
        @endphp
        @if($lastPage > 1)
            <nav>
                <ul class="pagination pagination-sm">
                    @for($i = 1; $i <= $lastPage; $i++)
                        <li class="page-item @if($i == $page) active @endif">
                            <a class="page-link" href="{{ url()->current() . '?' . http_build_query(array_merge($query, ['page' => $i])) }}">{{ $i }}</a>
                        </li>
                    @endfor
                </ul>
            </nav>
        @endif
    @endif
@endsection