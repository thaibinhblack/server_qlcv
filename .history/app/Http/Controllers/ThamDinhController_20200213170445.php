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
            if($user && $user[0]->id_rule > 0)
            {
                $cong_viec_model = new CongViecModel();
                $arr_id_cv_da = $request->get('ARR_CV_DA');
                return response()->json($arr_id_cv_da, 200);
            }
        }
    }
}
