<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\model\SettingModel;
use App\model\UserModel;
class SettingController extends Controller
{
    public function store_du_an(Request $request)
    {
        if($request->has('api_token'))
        {
            $user_model = new UserModel();
            $user = $user_model->SELECT_INFO_USER($request->get('api_token'));
            if($user)
            {
                $setting_model = new SettingModel();
                
            }
        }
    }
}
