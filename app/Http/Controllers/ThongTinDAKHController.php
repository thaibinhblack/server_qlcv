<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use PDO;
class ThongTinDAKHController extends Controller
{
    public function CallFunction($id_thongtin, $id_du_an_kh, $ten_thongtin, $noi_dung_thongtin,$action)
    {
        $sql = "DECLARE
            P_ID_THONGTIN NUMBER;
            P_ID_DU_AN_KH NUMBER;
            P_TEN_THONGTIN VARCHAR2(100);
            P_NOI_DUNG_THONGTIN VARCHAR2(255);
            P_ACTION NUMBER;
        BEGIN
            :result := THEM_CAPNHAT_THONGTIN_DUAN_KH(:P_ID_THONGTIN,:P_ID_DU_AN_KH,:P_TEN_THONGTIN, :P_NOI_DUNG_THONGTIN, :P_ACTION);
        END;";
    
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_THONGTIN',$id_thongtin, PDO::PARAM_INT);
        $stmt->bindParam(':P_ID_DU_AN_KH',$id_du_an_kh,  PDO::PARAM_INT);
        $stmt->bindParam(':P_TEN_THONGTIN',$ten_thongtin);
        $stmt->bindParam(':P_NOI_DUNG_THONGTIN',$noi_dung_thongtin);
        $stmt->bindParam(':P_ACTION',$action);
        $stmt->bindParam(':result',$result, PDO::PARAM_INT);
        // return response()->json($stmt, 200);
        $stmt->execute();
        return $result;
    }

    // show thông tin dự án

    public function show($id_du_an_kh)
    {
        $thongtins = DB::SELECT("SELECT * FROM TB_THONGTIN_DU_AN WHERE ID_DU_AN_KH = $id_du_an_kh");
        return response()->json($thongtins, 200);
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
                return response()->json($result, 200);
            }
        }
    }

    //UPDATE

    public function update(Request $request, $id_thongtin)
    {
        if($request->has('api_token'))
        {
            //check token
            $token = $request->get('api_token');
            $user = DB::select("SELECT id_rule from TB_NGUOI_DUNG where TOKEN_ND = '$token'");
            if($user[0])
            {
                $P_ID_THONGTIN = $id_thongtin;
                $P_ID_DU_AN_KH = $request->get("P_ID_DU_AN_KH");
                $P_TEN_THONGTIN = $request->get("P_TEN_THONGTIN");
                $P_NOI_DUNG_THONGTIN = $request->get("P_NOI_DUNG_THONGTIN");
                $P_ACTION = 2;
                $result = $this->CallFunction($P_ID_THONGTIN, $P_ID_DU_AN_KH, $P_TEN_THONGTIN, $P_NOI_DUNG_THONGTIN, $P_ACTION);
                return response()->json($result, 200);
            }
        }
    }

    //DELETE 

    public function destroy(Request $request,$id_thongtin)
    {
        $token = $request->get('api_token');
        $user = DB::select("SELECT id_rule from TB_NGUOI_DUNG where TOKEN_ND = '$token'");
        if($user[0])
        {
            $P_ID_THONGTIN = $id_thongtin;
            $P_ID_DU_AN_KH = null;
            $P_TEN_THONGTIN = null;
            $P_NOI_DUNG_THONGTIN = null;
            $P_ACTION = 3;
            $result = $this->CallFunction($P_ID_THONGTIN, $P_ID_DU_AN_KH, $P_TEN_THONGTIN, $P_NOI_DUNG_THONGTIN, $P_ACTION);
            return response()->json($result, 200);
        }
    }
}
