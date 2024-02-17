<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\PemesananKaos;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class PemesananKaosController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $pemesananData = PemesananKaos::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();
    
        return response([
            'PemesananKaos' => $pemesananData
        ], 200);
    }

    public function store(Request $request)
    {
        $rules = [
            'ukuran' => 'required|in:S,M,L,XL,XXL',
            'metode_pembayaran' => 'required|in:bayar tunai,transfer bank',
            'harga' => 'required|numeric',
            'status_pembayaran' => 'required|in:pending,berhasil'
        ];
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }
      
        $pemesanan = PemesananKaos::create([
            'user_id' => auth()->user()->id,
            'ukuran' => $request->input('ukuran'),
            'metode_pembayaran' => $request->input('metode_pembayaran'),
            'harga' => $request->input('harga'),
            'status_pembayaran' => $request->input('status_pembayaran'),
        ]);
        return response([
            'message' => 'Pemesanan kaos berhasil dibuat',
            'PemesananKaos' => $pemesanan
        ], 200);
    }

    public function show($id)
    {
        $pemesanan = PemesananKaos::find($id);
        if (!$pemesanan) {
            return response(['message' => 'Pemesanan Kaos Tidak Ditemukan'], 404);
        }

        return response(['PemesananKaos' => $pemesanan], 200);
    }

    public function update(Request $request, $id)
    {
        $pemesanan = PemesananKaos::find($id);
        if (!$pemesanan) {
            return response(['message' => 'Pemesanan Kaos Tidak Ditemukan'], 404);
        }

        $rules = [
            'ukuran' => 'required|in:S,M,L,XL,XXL',
            'metode_pembayaran' => 'required|in:bayar tunai,transfer bank',
            'harga' => 'required|numeric',
            'status_pembayaran' => 'required|in:pending,berhasil'
        ];
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        $pemesanan->update($request->all());
        return response(['message' => 'Pemesanan Kaos Telah Diupdate', 'PemesananKaos' => $pemesanan], 200);
    }

    public function destroy($id)
    {
        $pemesanan = PemesananKaos::find($id);
        if (!$pemesanan) {
            return response(['message' => 'Pemesanan Kaos Tidak Ditemukan'], 404);
        }

        $pemesanan->delete();
        return response(['message' => 'Pemesanan Kaos Telah Dihapus'], 200);
    }

    public function viewAllRequestsForBaak()
    {
        if (auth()->user()->role !== 'baak') {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $pemesananData = PemesananKaos::orderBy('created_at', 'desc')->get();
        return response(['PemesananKaos' => $pemesananData], 200);
    }

    public function approvePemesanan($id)
    {
        if (auth()->user()->role !== 'baak') {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $pemesanan = PemesananKaos::find($id);
        if (!$pemesanan) {
            return response()->json(['message' => 'Pemesanan Kaos Tidak Ditemukan'], 404);
        }

        $pemesanan->status_pembayaran = 'berhasil';
        $pemesanan->save();

        return response()->json(['message' => 'Pemesanan Kaos Telah Disetujui'], 200);
    }
}
