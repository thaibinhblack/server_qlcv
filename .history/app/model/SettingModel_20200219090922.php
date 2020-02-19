<?php

namespace App\model;

use Illuminate\Database\Eloquent\Model;
use DB;
use PDO;
class SettingModel extends Model
{
    public function SETTING_THUOC_TIH_DA($P_ID_DU_AN, $P_VALUE_CD_DA)
    {
        $sql = "DECLARE
            P_ID_DU_AN NUMBER;
            P_VALUE_CD_DA VARCHAR2(4000);
        BEGIN
            :result :=SETTING_THUOC_TIH_DA(:P_ID_DU_AN, :P_VALUE_CD_DA);
        END;";
   
    $pdo = DB::getPdo();
    $stmt = $pdo->prepare($sql);
    $stmt->bindParam(':P_ID_DU_AN',$P_ID_DU_AN,PDO::PARAM_INT);
    $stmt->bindParam(':P_VALUE_CD_DA',$P_VALUE_CD_DA);
    $stmt->bindParam(':result',$result,PDO::PARAM_INT);
    $stmt->execute();
    return $result;
    }

    public function SELECT_THUOCTINH_DUAN($ID_DU_AN)
    {
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare("SELECT SELECT_THUOCTINH_DUAN($ID_DU_AN) FROM dual");
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    }


    public function CAPNHAT_SETTING($P_ID_SETTING, $P_ID_ND, $P_VALUE_SETTING)
    {
        $sql = "DECLARE
            P_ID_SETTING NUMBER;
            P_VALUE_SETTING VARCHAR2(2000);
            BEGIN
                :RESULT_CV := CAPNHAT_SETTING(:P_ID_SETTING, :P_ID_ND, :P_VALUE_SETTING);
            END;"; 
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_SETTING',$P_ID_SETTING, PDO::PARAM_INT);
        $stmt->bindParam(':P_ID_ND',$P_ID_ND, PDO::PARAM_INT);
        $stmt->bindParam(':P_VALUE_SETTING',$P_VALUE_SETTING);
        $stmt->bindParam(':RESULT_CV',$RESULT_CV, PDO::PARAM_INT);
        $stmt->execute();
        return $RESULT_CV;
    }

}
