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
            if($user)
            {
                $lich_cong_tac_model = new LichCTModel();
                $lich_cong_tac = $lich_cong_tac_model->SELECT_LICH_CONG_TAC();
                return response()->json($lich_cong_tac, 200);
            }
        }
    }

    public function store(Request $request)
    {
        if($request->has('api_token'))
        {
            $user_model = new UserModel();
            $user = $user_model->SELECT_INFO_USER($request->get('api_token'));
            // return response()->json($user[0], 200);
            if($user[0])
            {
                $lich_cong_tac_model = new LichCTModel();
                $arr_params = [
                    "P_ID_LICH_CT" => $request->has('P_ID_LICH_CT') == true ? $request->get('P_ID_LICH_CT'): 0,
                    "P_TEN_LICH_CT" => $request->get('P_TEN_LICH_CT'),
                    "P_NOI_DUNG_LICH_CT" => $request->get('P_NOI_DUNG_LICH_CT'),
                    "P_TIME_START" => $request->get("P_TIME_START"),
                    "P_DATE_START" => $request->get("P_DATE_START"),
                    "P_TIME_END" => $request->get("P_TIME_END"),
                    "P_DATE_END" => $request->get("P_DATE_END"),
                    "P_NHAN_VIEN_CT" => $request->get("P_NHAN_VIEN_CT"),
                    "P_ACTION" => 1
                ];
                $lich_cong_tac = $lich_cong_tac_model->THEM_CAPNHAT_LICH_CT($arr_params);
                if($lich_cong_tac == 1)
                {
                    return response()->json([
                        "success" => true,
                        "message" => "Thêm lịch công tác mới thành công",
                        "result" => $lich_cong_tac,
                        "status" => 200
                    ], 200);
                }
                return response()->json([
                    "success" => false,
                    "message" => "Thêm lịch công tác mới thất bại",
                    "result" => $lich_cong_tac,
                    "status" => 500
                ], 200);
            }
            return response()->json([
                "success" => false,
                "message" => "Không thực hiện được chức năng này!",
                "result" => null,
                "status" => 404
            ], 200);
        }
        return response()->json([
            "success" => false,
            "message" => "Authorizon",
            "result" => null,
            "status" => 401 
        ], 200);
    }

    public function update(Request $request,$id)
    {
        if($request->has('api_token'))
        {
            $user_model = new UserModel();
            $user = $user_model->SELECT_INFO_USER($request->get('api_token'));
            if($user)
            {
                $arr_params = [
                    "P_ID_LICH_CT" => $id,
                    "P_TEN_LICH_CT" => $request->get('P_TEN_LICH_CT'),
                    "P_NOI_DUNG_LICH_CT" => $request->get('P_NOI_DUNG_LICH_CT'),
                    "P_TIME_START" => $request->get("P_TIME_START"),
                    "P_DATE_START" => $request->get("P_DATE_START"),
                    "P_TIME_END" => $request->get("P_TIME_END"),
                    "P_DATE_END" => $request->get("P_DATE_END"),
                    "P_NHAN_VIEN_CT" => $request->get("P_NHAN_VIEN_CT"),
                    "P_ACTION" => 2
                ];

                $lich_cong_tac_model = new LichCTModel();

                $lich_cong = $lich_cong_tac->THEM_CAPNHAT_LICH_CT($arr_params);

            }
        }
    }
}
