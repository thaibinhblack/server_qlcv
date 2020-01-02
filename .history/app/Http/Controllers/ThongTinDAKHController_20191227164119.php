<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ThongTinDAKHController extends Controller
{
    public function CallFunction($id_thongtin, $id_du_an_kh, $ten_thongtin, $noi_dung_thongtin,$action)
    {
        $sql = "DECLARE
            P_ID_THONGTIN NUMBER;
            P_ID_DU_AN_KH NUMBER;
            P_TEN_THONGTIN VARCHAR2;
            P_NOI_DUNG_THONGTIN VARCHAR2;
            P_ACTION NUMBER;
        BEGIN
            :result := THEM_CAPNHAT_THONGTIN_DUAN_KH(:P_ID_THONGTIN,:P_ID_DU_AN_KH,:P_TEN_THONGTIN, :P_NOI_DUNG_THONGTIN, :P_ACTION);
        END;";
    
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_THONGTIN',$P_ID_THONGTIN, PDO::PARAM_INT);
        $stmt->bindParam(':P_ID_DU_AN_KH',$P_ID_DU_AN_KH,  PDO::PARAM_INT);
        $stmt->bindParam(':P_TEN_THONGTIN',$P_TEN_THONGTIN);
        $stmt->bindParam(':P_NOI_DUNG_THONGTIN',$P_NOI_DUNG_THONGTIN);
        $stmt->bindParam(':P_ACTION',$P_ACTION);
        $stmt->bindParam(':result',$result, PDO::PARAM_INT);
        // return response()->json($stmt, 200);
        $stmt->execute();
        return $result;
    }

    // THÊM
    public function store(Request $request)
    {
        if($request->has('api_token'))
        {
            //check token
            $token = $request->get('api_token');
            $user = DB::select("SELECT id_rule from TB_NGUOI_DUNG where TOKEN_ND = '$token'");
            if($user[0])
            {
                $P_ID_THONGTIN = 0;
                $P_ID_DU_AN_KH = $request->get("P_ID_DU_AN_KH");
                $P_TEN_THONGTIN = $request->get("P_TEN_THONGTIN");
                $P_NOI_DUNG_THONGTIN = $request->get("P_NOI_DUNG_THONGTIN");
                $P_ACTION = 1;
                $result = $this->CallFunction($P_ID_THONGTIN, $P_ID_DU_AN_KH, $P_TEN_THONGTIN, $P_NOI_DUNG_THONGTIN, $P_ACTION);
            }
        }
    }
}
