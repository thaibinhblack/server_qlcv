<?php

namespace App\model;
use DB;
use PDO;
use Illuminate\Database\Eloquent\Model;

class DuAnKHModel extends Model
{

    public function THEM_UPDATE_DU_AN_KH($arr_params){
        $sql = "DECLARE
            P_ID_DU_AN_KH NUMBER(10);
            P_ID_DU_AN NUMBER(10);
            P_TEN_DU_AN_KH VARCHAR2(50);
            P_MO_TA_DU_AN VARCHAR2(255);
            P_GHI_CHU_DU_AN VARCHAR2(255);
            P_TRANG_THAI_DU_AN NUMBER(1);
            P_ID_KHACH_HANG NUMBER(10);
            P_ACTION NUMBER(1);
        BEGIN
            :n := THEM_UPDATE_DU_AN_KH(:P_ID_DU_AN_KH, :P_ID_DU_AN, :P_TEN_DU_AN_KH, :P_MO_TA_DU_AN, :P_GHI_CHU_DU_AN,:P_TRANG_THAI_DU_AN, :P_ID_KHACH_HANG, :P_ACTION);
        END;";  
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_DU_AN_KH',$arr_params["P_ID_DU_AN_KH"]);
        $stmt->bindParam(':P_ID_DU_AN',$arr_params["P_ID_DU_AN"]);
        $stmt->bindParam(':P_TEN_DU_AN_KH',$arr_params["P_TEN_DU_AN_KH"]);
        $stmt->bindParam(':P_MO_TA_DU_AN',$arr_params["P_MO_TA_DU_AN"]);
        $stmt->bindParam(':P_GHI_CHU_DU_AN',$arr_params["P_GHI_CHU_DU_AN"]);
        $stmt->bindParam(':P_TRANG_THAI_DU_AN',$arr_params["P_TRANG_THAI_DU_AN"]);
        $stmt->bindParam(':P_ID_KHACH_HANG',$arr_params["P_ID_KHACH_HANG"]);
        $stmt->bindParam(':P_ACTION',$arr_params["P_ACTION"]);
        $stmt->bindParam(':n',$result);
        $stmt->execute();
        return $result;
    }
    public function SELECT_DU_AN_KH($P_ID_DU_AN)
    {
        $pdo = DB::getPdo();
        // $P_ID_DU_AN = $arr_params["P_ID_DU_AN"];
        $stmt = $pdo->prepare("SELECT SELECT_DU_AN_KH('$P_ID_DU_AN') FROM dual");
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    }
}
