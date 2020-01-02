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
        $stmt->bindParam(':P_ID_LOAI_CV',$ID_LOAI_CV, PDO::PARAM_INT);
        $stmt->bindParam(':P_TEN_LOAI_CV',$TEN_LOAI_CV);
        $stmt->bindParam(':P_TRANG_THAI',$TRANG_THAI);
        $stmt->bindParam(':P_MO_TA',$P_MO_TA);
        $stmt->bindParam(':P_ACTION',$P_ACTION);
        $stmt->bindParam(':P_PARENT',$P_PARENT);
        $stmt->bindParam(':result',$result, PDO::PARAM_INT);
        // return response()->json($stmt, 200);
        $stmt->execute();
        return $result;
    }
}
