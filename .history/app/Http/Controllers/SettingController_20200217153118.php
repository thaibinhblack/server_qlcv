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
                $P_ID_DU_AN = $request->has('P_ID_DU_AN') == true ? $request->get('P_ID_DU_AN'): 0;
                $P_VALUE_CD_DA = $request->has('P_VALUE_CD_DA') == true ? $request->get('P_VALUE_CD_DA') : '[]';

            }
        }
    }
}
