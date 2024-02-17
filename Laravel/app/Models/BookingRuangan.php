<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BookingRuangan extends Model
{
    use HasFactory;

    // Specify the table name if different from the model's plural form
    protected $table = 'booking_ruangan';

    // Define which attributes can be mass-assignable
    protected $fillable = [
        'user_id',
        'approver_role',
        'ruangan',
        'reason',
        'start_date',
        'end_date',
        'status'
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
    
}
