<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::get('supervisor', function () {
   \Illuminate\Support\Facades\Mail::to('willians@4vconnect.com')
       ->queue(new \App\Mail\Report());
    return response()->json(['message' => 'supervisor'], 200);
});
