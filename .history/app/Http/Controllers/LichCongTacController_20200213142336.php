<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\model\LichCTModel;
use App\model\UserModel;
class LichCongTacController extends Controller
{
    
    public function index(Request $request)
    {
        if($request->has('api_token'))
        {
            $user_model = new UserModel();
            $user = $user_model->SELECT_INFO_USER($request->get('api_token'));
            return response()->json($user, 200);
        }
    }

    public function store(Request $request)
    {
        if($request->has('api_token'))
        {
            $user_model = new UserModel();

            $user = $user_model->SELECT_INFO_USER($request->get('api_token'));

        }
    }
}
