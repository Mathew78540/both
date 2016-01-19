<?php

namespace App\Http\Middleware;

use App\Room;
use Closure;
use Illuminate\Support\Facades\Response;

class Token {
  
  /**
   * Handle an incoming request.
   *
   * @param  \Illuminate\Http\Request  $request
   * @param  \Closure  $next
   * @return mixed
   */
  public function handle($request, Closure $next)
  {
    $token = $request->header('token');
    $room  = Room::where('token', '=', $token)->first();

    if (!$token) { // If there is not a token
      return Response::json([
        'status_code'   => 404,
        'errors'        => "You must have token on the header"
      ], 404);
    }
    else if (!$room) { // If token is not link to a room
      return Response::json([
        'status_code'   => 404,
        'errors'        => "Token wrong"
      ], 404);
    }

    $request->token = $token;
    $request->room  = $room;

    return $next($request);
  }
}