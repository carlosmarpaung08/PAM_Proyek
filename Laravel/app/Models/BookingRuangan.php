<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BookingRuangan extends Model
{
    use HasFactory;

    protected $table = 'booking_ruangan';

    protected $fillable = [
        'user_id',
        'keperluan',
        'waktu_booking',
        'status',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
