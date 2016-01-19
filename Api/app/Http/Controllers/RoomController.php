<?php

namespace App\Http\Controllers;

use App\Progression;
use App\Room;

class RoomController extends Controller
{

  /**
   * TaskController constructor.
   */
  public function __construct()
  {
    $this->middleware('token');
  }

  /**
   * DELETE /rooms/{roomId}
   *
   * @param $roomId
   *
   */
  public function deleteRoom($roomId)
  {

    Room::where('id', '=', $roomId)->delete();
    Progression::where('id', '=', $roomId)->delete();

  }

}