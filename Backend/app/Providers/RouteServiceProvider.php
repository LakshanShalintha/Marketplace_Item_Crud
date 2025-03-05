<?php

namespace App\Providers;

use Illuminate\Foundation\Support\Providers\RouteServiceProvider as ServiceProvider;
use Illuminate\Support\Facades\Route;

class RouteServiceProvider extends ServiceProvider
{
    /**
     * Define your route model bindings, pattern filters, etc.
     */
    public function boot()
    {
        parent::boot();

        $this->routes(function () {
            Route::prefix('api')
                ->middleware('api')
                ->namespace($this->namespace) // Ensures proper controller loading
                ->group(base_path('routes/api.php'));

            Route::middleware('web')
                ->namespace($this->namespace) // Ensures web routes are also loaded
                ->group(base_path('routes/web.php'));
        });
    }
}
