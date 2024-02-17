<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PemesananKaos extends Model
{
    use HasFactory;

    protected $table = 'pemesanan_kaos';

    protected $fillable = [
        'user_id',
        'ukuran',
        'metode_pembayaran',
        'harga',
        'status_pembayaran',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
