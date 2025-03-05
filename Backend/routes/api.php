<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ItemController;

Route::middleware('api')->group(function () {
    Route::get('/items', [ItemController::class, 'index']);
    Route::post('/items', [ItemController::class, 'store']);
    Route::get('/items/{id}', [ItemController::class, 'show']);
    Route::put('/items/{id}', [ItemController::class, 'update']);
    Route::delete('/items/{id}', [ItemController::class, 'destroy']);
    Route::put('/items/{id}', [ItemController::class, 'update']);
});
