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
            P_MO_TA_DU_AN VARCHAR2(255);
            P_GHI_CHU_DU_AN VARCHAR2(255);
            P_TRANG_THAI_DU_AN NUMBER(1);
            P_ID_KHACH_HANG NUMBER(10);
            P_ACTION NUMBER(1);
            P_TRANG_THAI_LT NUMBER;
        BEGIN
            :n := THEM_UPDATE_DU_AN_KH(:P_ID_DU_AN_KH, :P_ID_DU_AN, :P_MO_TA_DU_AN, :P_GHI_CHU_DU_AN,:P_TRANG_THAI_DU_AN, :P_ID_KHACH_HANG, :P_ACTION, :P_TRANG_THAI_LT);
        END;";  
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_DU_AN_KH',$arr_params["P_ID_DU_AN_KH"]);
        $stmt->bindParam(':P_ID_DU_AN',$arr_params["P_ID_DU_AN"]);
        $stmt->bindParam(':P_MO_TA_DU_AN',$arr_params["P_MO_TA_DU_AN"]);
        $stmt->bindParam(':P_GHI_CHU_DU_AN',$arr_params["P_GHI_CHU_DU_AN"]);
        $stmt->bindParam(':P_TRANG_THAI_DU_AN',$arr_params["P_TRANG_THAI_DU_AN"]);
        $stmt->bindParam(':P_ID_KHACH_HANG',$arr_params["P_ID_KHACH_HANG"]);
        $stmt->bindParam(':P_ACTION',$arr_params["P_ACTION"]);
        $stmt->bindParam(':P_TRANG_THAI_LT',$arr_params["P_TRANG_THAI_LT"]);
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

    public function INSERT_DELETE_CONG_VIEC_DAKH($P_ID_CV_DA, $P_ID_DU_AN_KH, $P_ACTION)
    {
        $sql = "DECLARE
        P_ID_CV_DA NUMBER(10);
        P_ID_DU_AN_KH NUMBER(10);
        P_ACTION NUMBER;
    BEGIN
        :n := INSERT_DELETE_CONG_VIEC_DAKH(:P_ID_CV_DA, :P_ID_DU_AN_KH, :P_ACTION);
    END;";  
    $pdo = DB::getPdo();
    $stmt = $pdo->prepare($sql);
    $stmt->bindParam(':P_ID_CV_DA',$P_ID_CV_DA);
    $stmt->bindParam(':P_ID_DU_AN_KH',$P_ID_DU_AN_KH);
    $stmt->bindParam(':P_ACTION',$P_ACTION);
    $stmt->bindParam(':n',$result);
    $stmt->execute();
    return $result;
    }

    public function CAPNHAT_VALUE_ATTRIBUTE_DA_KH($P_ID_DU_AN_KH, $P_VALUE_SETTING)
    {
        $sql = "DECLARE
        P_ID_DU_AN_KH NUMBER(10);
            P_VALUE_SETTING VARCHAR2(4000);
        BEGIN
            :n := CAPNHAT_VALUE_ATTRIBUTE_DA_KH(:P_ID_DU_AN_KH, :P_VALUE_SETTING);
        END;";  
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_DU_AN_KH',$P_ID_DU_AN_KH);
        $stmt->bindParam(':P_VALUE_SETTING',$P_VALUE_SETTING);
        $stmt->bindParam(':n',$result);
        $stmt->execute();
        return $result;
    }
}
