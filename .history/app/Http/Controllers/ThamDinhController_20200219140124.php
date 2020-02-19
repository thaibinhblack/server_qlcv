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
            
            $cong_viec_model = new CongViecModel();
            $arr_params["P_ARRAY_ID_CV_DA"] = $request->get('ARR_CV_DA');
            $arr_params["P_ACTION_TD"] = $request->get('P_ACTION_TD');
            $tham_dinh = $cong_viec_model->GUI_THAM_DINH($arr_params);
            return response()->json($tham_dinh, 200);
        }
    }

    public function tham_dinh_cv(Request $request)
    {
        if($request->has('api_token'))
        {
            $arr_list = explode(',', $request->get("ARRAY_LIST"));
            $arr_tgian = explode(',', $request->get("ARRAY_TG_TD"));
            $length = count($arr_list);
            $user_model = new UserModel();
            $user = $user_model->SELECT_INFO_USER($request->get('api_token'));
            if($user && $user[0]->id_rule > 0)
            {
                for($i=0;$i<$length;$i++)
                {
                    $cong_viec_model = new CongViecModel();
                    // $cong_viec = $cong_viec_model->THAM_DINH_CONG_VIEC_DA([
                    //     "P_ID_CV_DA" => $arr_list[$i],
                    //     "P_THAM_DINH_TGIAN" => $arr_tgian[$i],
                    //     "P_THAM_DINH_CHAT_LUONG" => null,
                    //     "P_THAM_DINH_KHOI_LUONG" => null,
                    //     "P_NGUOI_THAM_DINH" => $user->id_nd
                    // ]);
                    echo $arr_list[$i].'<br />';
                }
                return response()->json($length, 200);
            }
        }
    }
}
