<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\model\CongViecModel;
use App\model\UserModel;
class ThamDinhController extends Controller
{
    public function gui_tham_dinh(Request $request)
    {
        if($request->has('api_token'))
        {
            $user_model = new UserModel();
            $user = $user_model->SELECT_INFO_USER($request->get('api_token'));
            if($user && $user[0]->rule_nd > 0)
            {

            }
        }
    }
}
