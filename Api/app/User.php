<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class User extends Model
{

  /**
   * The attributes excluded mass assign on create
   *
   * @var array
   */
  protected $guarded = ['id'];

  /**
   * The attributes excluded from the model's JSON form.
   *
   * @var array
   */
  protected $hidden = ['room_id', 'password', 'created_at', 'updated_at', 'activated', 'activation_token', 'is_partner'];

  /**
   * The attributes that sould be casted to native types
   *
   * @var array
   */
  protected $casts = [
    'is_partner' => 'boolean'
  ];

  /**
   * Return room of the user
   */
  public function room()
  {
    return $this->belongsTo('App\Room');
  }

}
