<?php

namespace App\Http\Controllers;

use App\Category;
use Illuminate\Support\Facades\Response;

class CategoryController extends Controller
{

  /**
   * TaskController constructor.
   */
  public function __construct()
  {
    $this->middleware('token');
  }

  /**
   * GET /api/categories
   */
  public function get()
  {
    return Response::json([
      'status_code' => 200,
      'data'        => Category::all()
    ]);
  }

}