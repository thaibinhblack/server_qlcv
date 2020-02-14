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
                $arr_params["P_ARRAY_ID_CV_DA"] = $request->get('ARR_CV_DA');
                $arr_params["P_ARRAY_ID_CV_DA"] = $request->get('P_ACTION_TD');
                $tham_dinh = $cong_viec_model->GUI_THAM_DINH($arr_params);
                return response()->json($tham_dinh, 200);
            }
        }
    }
}
