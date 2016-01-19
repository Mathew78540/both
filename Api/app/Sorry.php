<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Sorry extends Model
{
  protected $fillable = array('user_id', 'room_id', 'message');
}
