<?php
use App\Http\Controllers\UserController;
use App\Http\Controllers\BookingRuanganController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::post('register', [UserController::class, 'register']);
Route::post('login', [UserController::class, 'login']);

Route::prefix('v1')->group(function () {
    Route::apiResource('booking_ruangan', BookingRuanganController::class);
});
