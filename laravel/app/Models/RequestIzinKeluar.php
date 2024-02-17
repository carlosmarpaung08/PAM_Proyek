<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RequestIzinKeluar extends Model
{
    use HasFactory;
    protected $table ="requestizinkeluar";
    protected $fillable = ['user_id', 'reason', 'start_date', 'end_date', 'status'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

}
