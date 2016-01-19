<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Progression extends Model
{
  
  /**
   * The attributes excluded mass assign on create
   *
   * @var array
   */
  protected $guarded = ['id'];

  /**
   * Get the task link to the progression
   */
  public function task()
  {
    return $this->belongsTo('App\Task');
  }

  /**
   * Init Progression
   *
   * @param int $roomId
   * @param int $taskId
   * @param int $userId
   * @param int $partnerId
   */
  public static function init($roomId, $taskId, $userId, $partnerId)
  {
    // Create Progression for the user
    Progression::create([
      'room_id' => $roomId,
      'task_id' => $taskId,
      'user_id' => $userId
    ]);

    // Create Progression for the partner
    Progression::create([
      'room_id' => $roomId,
      'task_id' => $taskId,
      'user_id' => $partnerId
    ]);
  }
}
