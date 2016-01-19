<?php

namespace App\Http\Controllers;

use App\Progression;
use App\Room;
use App\Task;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Response;

class DashboardController extends Controller
{

  /**
   * Dashboard constructor.
   */
  public function __construct()
  {
    $this->middleware('token');
  }

  /**
   * GET /api/dashboard
   *
   * @param $userId
   * @param $partnerId
   * @param Request $request
   *
   * @return
   */
  public function get($userId, $partnerId, Request $request)
  {
    // Get current room
    $room = $request->room;

    $progressions = Progression::where('room_id', '=', $room->id)->get();
    $tasksIds     = [];
    $tasks        = [];

    // Get all tasks use in the room
    foreach ($progressions as $value){
      if(!in_array($value->task_id, $tasksIds)){

        $tasksIds[] = $value->task_id;
        $task       = Task::with('category')->where('id', '=', $value->task_id)->first();

        $userProgression = Progression::where('room_id', '=', $room->id)->
                                        where('user_id', '=', $userId)->
                                        where('task_id', '=', $task->id)->
                                        first(['count']);

        $partnerProgression = Progression::where('room_id', '=', $room->id)->
                                           where('user_id', '=', $partnerId)->
                                           where('task_id', '=', $task->id)->
                                           first(['count']);

        $tasks[] = [
          'id'          => $task->id,
          'category'    => $task->category,
          'name'        => $task->name,
          'difference'  => $userProgression->count - $partnerProgression->count
        ];

      }
    }

    // Return response
    return Response::json([
      'status_code' => 200,
      'tasks'       => $tasks
    ]);

  }

}