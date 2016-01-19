<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    /**
     * Get tasks from a category
     */
    public function tasks(){
      return $this->hasMany('App\Task');
    }
}
