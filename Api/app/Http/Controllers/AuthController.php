<?php

namespace App\Http\Controllers;

use App\Events\UserHasRegistered;
use App\Room;
use App\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Request;
use Illuminate\Support\Facades\Response;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{

  /**
   * POST /api/create-room
   */
  public function createRoom()
  {

    // Get all data send in post
    $subscribeFormData = Request::all();

    // Create rules for the validator
    $validator = Validator::make($subscribeFormData, [
      'user_name'         => 'required',
      'user_email'        => 'required|email|unique:users,email',
      'user_password'     => 'required',
      'partner_name'      => 'required',
      'partner_email'     => 'required|email|unique:users,email',
      'partner_password'  => 'required'
    ]);

    // If validator fails return a 404 response
    if ($validator->fails()) {
      return Response::json([
        'status_code'	=> 404,
        'errors' 		  => $validator->errors()->all()
      ], 404);
    }

    // If user use same email for user/partner ...
    if($subscribeFormData['user_email'] == $subscribeFormData['partner_email']){
      return Response::json([
        'status_code'	=> 404,
        'errors' 		  => ["Votre email doit être différent de celui de votre partenaire."]
      ], 404);
    }

    // Create user
    $user = User::create([
      'name'             => ucfirst($subscribeFormData['user_name']),
      'email'            => $subscribeFormData['user_email'],
      'password'         => Hash::make($subscribeFormData['user_password']),
      'activation_token' => uniqid()
    ]);

    // Create partner
    $partner = User::create([
      'name'              => ucfirst($subscribeFormData['partner_name']),
      'email'             => $subscribeFormData['partner_email'],
      'password'          => Hash::make($subscribeFormData['partner_password']),
      'is_partner'        => true,
      'activation_token'  => uniqid()
    ]);

    // Create room
    $room = Room::create([
      'token'       => Room::generateToken(),
      'user_id'     => $user->id,
      'partner_id'  => $partner->id,
    ]);

    if($user && $partner && $room){

      // Add room ID
      User::where('id', '=', $user->id)->update(['room_id' => $room->id]);
      User::where('id', '=', $partner->id)->update(['room_id' => $room->id]);

      // Send email registration
      event(new UserHasRegistered(User::find($user->id), false));
      event(new UserHasRegistered(User::find($partner->id), true));

      // Return response
      return Response::json([
        'status_code' => 200,
        'success'     => "Merci de valider vos adresses email pour activer vos comptes."
      ]);

    }

  }

  /**
   * POST /api/login
   */
  public function login()
  {
    // Get all data send in post
    $loginFormData = Request::all();

    // Create rules for the validator
    $validator = Validator::make($loginFormData, [
      'user_email'     => 'required|email',
      'user_password'  => 'required',
    ]);

    // If validator fails return a 404 response
    if ($validator->fails()) {
      return Response::json([
        'status_code'	=> 404,
        'errors' 		  => $validator->errors()->all()
      ], 404);
    }

    $user    = User::where('email', '=', strtolower($loginFormData['user_email']))->first();

    if(!$user){
      return Response::json([
        'status_code'	=> 404,
        'errors' 		  => ['Votre compte est introuvable dans notre base de donnée.']
      ], 404);
    }
    else if($user->activated == 0){
      return Response::json([
        'status_code'	=> 404,
        'errors' 		  => ["Merci d'activer votre compte."]
      ], 404);
    }
    else if(!Hash::check($loginFormData['user_password'], $user->password)){
      return Response::json([
        'status_code'	=> 404,
        'errors' 		  => ["Votre mot de passe est incorrect."]
      ], 404);
    }

    $room    = Room::find($user->room_id);
    $partner = User::find(($user->is_partner) ? $room->user_id : $room->partner_id);

    if($partner->activated == 0){
      return Response::json([
        'status_code' => 404,
        'errors'      => ["Le compte de votre partenaire n'a pas été activé."]
      ], 404);
    }

    // Success
    return Response::json([
      'status_code'	 => 200,
      'success'		   => "Login success",
      'data'         => [
        'me'       => $user,
        'partner'  => $partner,
        'room'     => $room
      ]
    ]);

  }

  /**
   * GET /api/activation
   *
   * @param $id
   * @param $activationToken
   */
  public function activation($id, $activationToken)
  {
    $user = User::where('id', '=', $id)->where('activation_token', '=', $activationToken)->first();

    if($user) {
      $user->update([
        'activated'         => true,
        'activation_token'  => null
      ]);
    }
  }

}