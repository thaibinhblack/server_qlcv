<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\model\SettingModel;
use App\model\UserModel;
use App\model\DuAnKHModel;
class SettingController extends Controller
{

    public function show_du_an(Request $request,$id)
    {
        if($request->has('api_token'))
        {
            $user_model = new UserModel();
            $user = $user_model->SELECT_INFO_USER($request->get('api_token'));
            if($user)
            {
                $setting_model = new SettingModel();
                $setting = $setting_model->SELECT_THUOCTINH_DUAN($id);
                if($setting)
                {
                    return response()->json($setting[0], 200);
                }
                return response()->json($setting, 200);
            }
        }
        return response()->json('Authorizon', 200);
    }

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
                $setting = $setting_model->SETTING_THUOC_TIH_DA($P_ID_DU_AN, $P_VALUE_CD_DA);
                return response()->json($setting, 200);
            }
        }
    }

    public function update_du_an(Request $request,$id)
    {
        if($request->has('api_token'))
        {
            $user_model = new UserModel();
            $user = $user_model->SELECT_INFO_USER($request->get('api_token'));
            if($user)
            {
               $du_an_kh_model = new DuAnKHModel();
               $P_VALUE_SETTING = $request->has("P_VALUE_ATTRIBUTE") == true ? $request->get("P_VALUE_ATTRIBUTE") : '[]';
               $du_an_kh = $du_an_kh_model->CAPNHAT_VALUE_ATTRIBUTE_DA_KH($id, $P_VALUE_SETTING);
               return response()->json($du_an_kh, 200);
            }
        }
    }

    //SETTING DATA LIST CÔNG VIỆC

    public function update_list_cv(Request $request)
    {
        if($request->has('api_token'))
        {
            $user_model = new UserModel();
            $user = $user_model->SELECT_INFO_USER($request->get('api_token'));
            if($user)
            {

                $P_VALUE_SETTING = $request->has('P_VALUE_SETTING') == true ? $request->get('P_VALUE_SETTING') : '[]';
                $setting_model = new SettingModel();
                $setting = $setting_model->CAPNHAT_CAI_DAT($user[0]->id_nd, 'CAI_DAT_LIST_CV', $P_VALUE_SETTING);
                return response()->json($setting, 200);
            }
        }
    }
}
