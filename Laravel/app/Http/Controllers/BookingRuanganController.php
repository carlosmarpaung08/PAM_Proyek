<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\BookingRuangan;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class BookingRuanganController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $bookingData = BookingRuangan::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();
    
        return response([
            'BookingRuangan' => $bookingData
        ], 200);
    }

    public function store(Request $request)
    {
        $rules = [
            'ruangan' => 'required|in:GD 5,GD 7,GD 9',
            'reason' => 'required|string',
            'start_date' => 'required|date',
            'end_date' => 'required|date',
        ];
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }
      
        $booking = BookingRuangan::create([
            'user_id' => auth()->user()->id,
            'ruangan' => $request->input('ruangan'),
            'reason' => $request->input('reason'),
            'start_date' => $request->input('start_date'),
            'end_date' => $request->input('end_date'),
        ]);
        return response([
            'message' => 'Booking ruangan berhasil dibuat',
            'BookingRuangan' => $booking
        ], 200);
    }

    public function show($id)
    {
        $booking = BookingRuangan::find($id);
        if (!$booking) {
            return response(['message' => 'Booking Ruangan Tidak Ditemukan'], 404);
        }

        return response(['BookingRuangan' => $booking], 200);
    }

    public function update(Request $request, $id)
    {
        $booking = BookingRuangan::find($id);
        if (!$booking) {
            return response(['message' => 'Booking Ruangan Tidak Ditemukan'], 404);
        }

        $rules = [
            'ruangan' => 'required|in:GD 5,GD 7,GD 9',
            'reason' => 'required|string',
            'start_date' => 'required|date',
            'end_date' => 'required|date',
            'status' => 'required|in:pending,approved,rejected'
        ];
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        $booking->update($request->all());
        return response(['message' => 'Booking Ruangan Telah Diupdate', 'BookingRuangan' => $booking], 200);
    }

    public function destroy($id)
    {
        $booking = BookingRuangan::find($id);
        if (!$booking) {
            return response(['message' => 'Booking Ruangan Tidak Ditemukan'], 404);
        }

        $booking->delete();
        return response(['message' => 'Booking Ruangan Telah Dihapus'], 200);
    }

    public function viewAllRequestsForBaak()
    {
        if (auth()->user()->role !== 'baak') {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $bookingData = BookingRuangan::orderBy('created_at', 'desc')->get();
        return response(['BookingRuangan' => $bookingData], 200);
    }

    public function approveBooking($id)
    {
        if (auth()->user()->role !== 'baak') {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $booking = BookingRuangan::find($id);
        if (!$booking) {
            return response()->json(['message' => 'Booking Ruangan Tidak Ditemukan'], 404);
        }

        $booking->status = 'approved';
        $booking->approver_role = 'baak';
        $booking->save();

        return response()->json(['message' => 'Permintaan Booking Ruangan Telah Disetujui'], 200);
    }
}
