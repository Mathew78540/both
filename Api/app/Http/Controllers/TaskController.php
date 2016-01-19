<?php

namespace App\Http\Controllers;

use App\Category;
use App\Progression;
use App\Room;
use App\Task;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Response;
use Illuminate\Support\Facades\Validator;

class TaskController extends Controller
{

  /**
   * TaskController constructor.
   */
  public function __construct()
  {
    $this->middleware('token');
  }

  /**
   *  PUT api/task/{taskId}/{userId}
   *
   * @param $taskId
   * @param $userId
   * @param Request $request
   */
  public function updateTask($taskId, $userId, Request $request)
  {

    // Get current room
    $room = $request->room;

    // If no room
    if(!$room) {
      return Response::json([
        'status_code' => 404,
        'errors'      => 'No room find'
      ], 404);
    }

    Progression::where('task_id', '=', $taskId)->
                 where('user_id', '=', $userId)->
                 where('room_id', '=', $room->id)->
                 increment('count');

    // Success message
    return Response::json([
      'status_code' => 200,
      'success'     => 'Task updated'
    ]);

  }

  /**
   * POST api/task
   *
   * @param Request $request
   */
  public function addTask(Request $request)
  {

    // Get current room
    $room = $request->room;

    // If no room
    if(!$room) {
      return Response::json([
        'status_code' => 404,
        'errors'      => 'No room find'
      ], 404);
    }

    // Get all data send in post
    $data = $request->all();

    // Create rules for the validator
    $validator = Validator::make($data, [
      'category_id' => 'required',
      'name'        => 'required'
    ]);

    // If validator fails return a 404 response
    if ($validator->fails()) {
      return Response::json([
        'status_code'	=> 404,
        'errors' 		  => $validator->messages()
      ], 404);
    }

    $task = Task::create([
      'category_id' => $data['category_id'],
      'name' => $data['name']
    ]);

    // Init lines
    Progression::init($room->id, $task->id, $room->user_id, $room->partner_id);

    return Response::json([
      'status_code'	=> 200,
      'success'     => 'Task added'
    ]);

  }

  /**
   * DELETE /tasks/{taskId}
   *
   * @param Request $request
   */
  public function deleteTask(Request $request)
  {
    // Get all data send in post
    $data = $request->all();

    // Create rules for the validator
    $validator = Validator::make($data, [
      'task_id' => 'required'
    ]);

    // If validator fails return a 404 response
    if ($validator->fails()) {
      return Response::json([
        'status_code'	=> 404,
        'errors' 		  => $validator->errors()->all()
      ], 404);
    }

    Progression::where('task_id', '=', $data['task_id'])->delete();
    Task::where('id', '=', $data['task_id'])->delete();

    // Success
    return Response::json([
      'status_code' => 200,
      'success'     => 'Task deleted'
    ]);

  }

  /**
   * Get profiles information
   *
   * @param  int  $userId
   * @param  int  $partnerId
   * @param  Request $request
   */
  public function profiles($userId, $partnerId, Request $request)
  {
    $user     = User::find($userId);
    $partner  = User::find($partnerId);

    return Response::json([
      'status_code' => 200,
      'me'          => $user,
      'partner'     => $partner,
    ]);

  }

  /**
   * Get tasks history for profiles page
   *
   * @param  int  $userId
   * @param  int  $partnerId
   * @param  Request $request
   */
  public function tasksProfiles($userId, $partnerId, Request $request)
  {

    $user    = User::where('id', '=', $userId)->with('room')->first();
    $partner = User::where('id', '=', $partnerId)->first();
    $roomId = $user->room->id;
    $tasks  = [];

    foreach (Category::all() as $category) {
      $tasks[] = [
        'category'     => $category->category,
        'name'         => $category->name,
        'me'           => 0,
        'partner'      => 0,
        'me_name'      => $user->name,
        'partner_name' => $partner->name
      ];
    }

    $progressions = Progression::with('task')->where('room_id', '=', $roomId)->get();

    foreach ($progressions as $pro) {
      $task       = Task::where('id', '=', $pro->task_id)->first();
      $category   = Category::where('id', '=', $task->category_id)->first();

      if($pro->user_id == $userId){
        for($i = 0; $i < count($tasks); $i++){
          if ($tasks[$i]['category'] == $category->category){
            $tasks[$i]['me'] += $pro->count;
          }
        }
      }

      if($pro->user_id == $partnerId){
        for($i = 0; $i < count($tasks); $i++){
          if ($tasks[$i]['category'] == $category->category){
            $tasks[$i]['partner'] += $pro->count;
          }
        }
      }

    }

    // Success
    return Response::json([
      'status_code' => 200,
      'data'        => $tasks
    ]);

  }

}