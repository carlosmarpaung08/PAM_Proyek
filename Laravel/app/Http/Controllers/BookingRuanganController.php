<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\BookingRuangan;
use App\Http\Resources\BookingRuanganResource;

class BookingRuanganController extends Controller
{
    public function index()
    {
        $bookings = BookingRuangan::all();
        return BookingRuanganResource::collection($bookings);
    }

    public function show($id)
    {
        $booking = BookingRuangan::findOrFail($id);
        return new BookingRuanganResource($booking);
    }

    public function store(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'keperluan' => 'required',
            'waktu_booking' => 'required|date',
        ]);

        $booking = BookingRuangan::create($request->all());

        return new BookingRuanganResource($booking);
    }

    public function update(Request $request, $id)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'keperluan' => 'required',
            'waktu_booking' => 'required|date',
        ]);

        $booking = BookingRuangan::findOrFail($id);
        $booking->update($request->all());

        return new BookingRuanganResource($booking);
    }

    public function destroy($id)
    {
        $booking = BookingRuangan::findOrFail($id);
        $booking->delete();

        return response()->json(['message' => 'Booking deleted successfully']);
    }
}
