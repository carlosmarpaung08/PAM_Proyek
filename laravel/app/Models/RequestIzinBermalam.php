<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RequestIzinBermalam extends Model
{
    use HasFactory;
    
    // Adjust the table name as per your database schema
    protected $table = "requestizinbermalam"; 

    // Update the fillable attributes as per your table's columns
    protected $fillable = ['user_id', 'reason', 'start_date', 'end_date', 'status'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // Add any additional relationships or methods specific to RequestIzinBermalam here
}
