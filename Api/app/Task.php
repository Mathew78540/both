<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Task extends Model
{
  protected $guarded = array('id');
  public $timestamps = false;

  public function category(){
    return $this->belongsTo('App\Category');
  }
}
