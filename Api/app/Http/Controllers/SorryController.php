<?php

namespace App\Http\Controllers;

use App\Badge;
use App\Category;
use App\Progression;
use App\Room;
use App\Sorry;
use App\Task;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Response;
use Illuminate\Support\Facades\Validator;
class SorryController extends Controller
{

  /**
   * TaskController constructor.
   */
  public function __construct()
  {
    $this->middleware('token');
  }

  /**
   * POST /api/sorry
   */
  public function post(Request $request)
  {
    // Get all data send in post
    $data = $request->all();

    $user = User::where('id', '=', $data['user_id'])->first();

    // Create the sorry
    $sorry = Sorry::create([
      'user_id' => $data['user_id'],
      'room_id' => $user->room_id,
      'message' => $data['message']
    ]);

    if ($sorry){
      // Success
      return Response::json([
        'status_code' => 200,
        'success'     => 'Sorry added'
      ]);
    }

  }

  /**
   * GET /api/sorry
   */
  public function get($userId)
  {
    $sorry = Sorry::where('user_id', '=', $userId)->first();

    if(!$sorry) {
      return Response::json([
        'status_code' => 404,
        'errors' => 'No sorry, you are the best partner'
      ]);
    }

    // Success
    return Response::json([
      'status_code' => 200,
      'success' => $sorry
    ]);

  }

  public function delete($userId, $accepted, Request $request)
  {
    $user = User::where('id', '=', $userId)->first();

    // Elle accepte donc on reset les tâches
    if($accepted == 1){
      Progression::where('room_id', '=', $user->room_id)->delete();
    }

    Sorry::where('room_id', '=', $user->room_id)->delete();

    // Success
    return Response::json([
      'status_code' => 200,
      'success' => 'Done ....'
    ]);

  }

}