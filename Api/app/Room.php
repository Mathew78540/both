<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Carbon\Carbon;

class Room extends Model
{

  /**
   * The attributes accept mass assign on create
   *
   * @var array
   */
  protected $fillable = ['id', 'token', 'user_id', 'partner_id'];

  /**
   * The attributes excluded from the model's JSON form.
   *
   * @var array
   */
  protected $hidden = ['user_id', 'partner_id', 'updated_at'];

  /**
   * Get the user from the room
   */
  public function user()
  {
    return $this->belongsTo('App\User');
  }

  /**
   * Get the partner from the room
   */
  public function partner()
  {
    return $this->belongsTo('App\User', 'partner_id', 'id');
  }

  /**
   * Get the created at formated
   *
   * @param $value
   */
  public function getCreatedAtAttribute($value)
  {
    return Carbon::parse($value)->toDateTimeString();
  }

  /**
   * Generate token for the room
   */
  public static function generateToken()
  {
    return 'KEY_'.uniqid();
  }

}
