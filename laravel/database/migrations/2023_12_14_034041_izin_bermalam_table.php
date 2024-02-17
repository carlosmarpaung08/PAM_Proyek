<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('requestizinbermalam', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users','id');
            $table->enum('approver_role', ['mahasiswa', 'baak']);
            $table->string('reason');
            $table->datetime('start_date');
            $table->datetime('end_date');
            $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending');
            // Add any additional columns specific to izin_bermalam here
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('izin_bermalam');
    }
};
