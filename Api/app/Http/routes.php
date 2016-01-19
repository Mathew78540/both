<?php

Route::get('/', function () {
    return view('welcome', ['appVersion' => env('APP_VERSION')]);
});

Route::group(['prefix' => 'api'], function () {

    // Auth
    Route::group(['prefix' => 'auth'], function() {
        Route::post('login', ['as' => 'login', 'uses' => 'AuthController@login']);
        Route::post('create-room', ['as' => 'createRoom', 'uses' => 'AuthController@createRoom']);
        Route::get('activation/{id}/{activationToken}', ['as' => 'activation', 'uses' => 'AuthController@activation']);
    });

    // Category
    Route::get('categories', ['as' => 'categories', 'uses' => 'CategoryController@get']);

    // Dashboard
    Route::get('dashboard/{userId}/{partnerId}', ['as' => 'dashboard', 'uses' => 'DashboardController@get']);

    // Tasks
    Route::post('add-task', ['as' => 'addTask', 'uses' => 'TaskController@addTask']);
    Route::put('task/{taskId}/{userId}', ['as' => 'updateTask', 'uses' => 'TaskController@updateTask']);
    Route::post('delete-task', ['as' => 'deleteTask', 'uses' => 'TaskController@deleteTask']);

    // Profiles
    Route::get('profiles/{userId}/{partnerId}', ['as' => 'profiles', 'uses' => 'TaskController@profiles']); // Profiles
    Route::get('tasks-profiles/{userId}/{partnerId}', ['as' => 'profiles', 'uses' => 'TaskController@tasksProfiles']); // Profiles

    // Room
    Route::delete('room/{roomId}', ['as' => 'deleteRoom', 'uses' => 'RoomController@deleteRoom']); // Delete a room

    // Sorry
    Route::post('sorry', ['as' => 'addSorry', 'uses' => 'SorryController@post']);
    Route::get('sorry/{userId}', ['as' => 'addSorry', 'uses' => 'SorryController@get']);
    Route::delete('sorry/{userId}/{accepted}', ['as' => 'addSorry', 'uses' => 'SorryController@delete']);

});
