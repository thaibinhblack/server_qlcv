<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\model\LichCTModel;
use App\model\UserModel;
class LichCongTacController extends Controller
{
    

    public function store(Request $request)
    {
        if($request->has('api_token'))
        {
            $user_model = new UserModel();

            $user = $user_model->SELECT_INFO_USER();
            
        }
    }
}
