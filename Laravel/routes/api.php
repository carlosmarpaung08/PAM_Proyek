<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\IzinKeluarController;
use App\Http\Controllers\IzinKeluarBaakController;
use App\Http\Controllers\IzinBermalamController;
use App\Http\Controllers\BookingRuanganController;
use App\Http\Controllers\PemesananKaosController;


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

Route::post('/register',[AuthController::class,'register']);
Route::post('/login',[AuthController::class,'login']);
Route::get('/login',[AuthController::class,'login']);


Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::middleware('auth:sanctum')->post('/logout', [AuthController::class, 'logout']);



Route::middleware('auth:sanctum')->group(function () {
    Route::get('/izinkeluar',[IzinKeluarController::class, 'index']);
    Route::post('/izinkeluar',[IzinKeluarController::class, 'store']);
    Route::put('/izinkeluar/{id}',[IzinKeluarController::class, 'update']);
    Route::get('/izinkeluar/{id}',[IzinKeluarController::class, 'show']);
    Route::delete('/izinkeluar/{id}',[IzinKeluarController::class, 'destroy']);  


    Route::get('/izin-keluar/all', [IzinKeluarController::class, 'viewAllRequestsForBaak']);
    Route::put('/izin-keluar/{id}/approve', [IzinKeluarController::class, 'approveIzinKeluar']);


    Route::get('/izinbermalam', [IzinBermalamController::class, 'index']);
    Route::post('/izinbermalam', [IzinBermalamController::class, 'store']);
    Route::put('/izinbermalam/{id}', [IzinBermalamController::class, 'update']);
    Route::get('/izinbermalam/{id}', [IzinBermalamController::class, 'show']);
    Route::delete('/izinbermalam/{id}', [IzinBermalamController::class, 'destroy']);

    // Additional routes for Baak to view and approve Izin Bermalam requests
    Route::get('/izin-bermalam/all', [IzinBermalamController::class, 'viewAllRequestsForBaak']);
    Route::put('/izin-bermalam/{id}/approve', [IzinBermalamController::class, 'approveIzinBermalam']);

     // Routes for BookingRuangan
     Route::get('/booking-ruangan', [BookingRuanganController::class, 'index']);
     Route::post('/booking-ruangan', [BookingRuanganController::class, 'store']);
     Route::get('/booking-ruangan/{id}', [BookingRuanganController::class, 'show']);
     Route::put('/booking-ruangan/{id}', [BookingRuanganController::class, 'update']);
     Route::delete('/booking-ruangan/{id}', [BookingRuanganController::class, 'destroy']);
 
     // Additional route for Baak to view all booking requests
     Route::get('/booking-ruangan-all', [BookingRuanganController::class, 'viewAllRequestsForBaak']);
 
     // Additional route for Baak to approve a booking request
     Route::put('/booking-ruangan/{id}/approve', [BookingRuanganController::class, 'approveBooking']);

    // Routes for PemesananKaos
    Route::get('/pemesanan-kaos', [PemesananKaosController::class, 'index']);
    Route::post('/pemesanan-kaos', [PemesananKaosController::class, 'store']);
    Route::get('/pemesanan-kaos/{id}', [PemesananKaosController::class, 'show']);
    Route::put('/pemesanan-kaos/{id}', [PemesananKaosController::class, 'update']);
    Route::delete('/pemesanan-kaos/{id}', [PemesananKaosController::class, 'destroy']);

    // Additional route for Baak to view all PemesananKaos requests
    Route::get('/pemesanan-kaos-all', [PemesananKaosController::class, 'viewAllRequestsForBaak']);

    // Additional route for Baak to approve a PemesananKaos request
    Route::put('/pemesanan-kaos/{id}/approve', [PemesananKaosController::class, 'approvePemesanan']);
});

