<?php

namespace App\model;

use Illuminate\Database\Eloquent\Model;

class SettingModel extends Model
{
    public function SETTING_THUOC_TIH_DA($P_ID_DU_AN, $P_VALUE_CD_DA)
    {
        $sql = "DECLARE
        P_ID_DU_AN NUMBER;
        P_VALUE_CD_DA VARCHAR2(5000);
    BEGIN
        :result :=SETTING_THUOC_TIH_DA(:P_ID_DU_AN, :P_VALUE_CD_DA);
    END;";
   
    $pdo = DB::getPdo();
    $stmt = $pdo->prepare($sql);
    $stmt->bindParam(':P_ID_DU_AN',$P_ID_DU_AN,PDO::PARAM_INT);
    $stmt->bindParam(':P_VALUE_CD_DA',$P_VALUE_CD_DA);
    $stmt->bindParam(':P_THAM_DINH_CHAT_LUONG',$arr_params["P_THAM_DINH_CHAT_LUONG"],PDO::PARAM_INT);
    $stmt->bindParam(':P_THAM_DINH_KHOI_LUONG',$arr_params["P_THAM_DINH_KHOI_LUONG"],PDO::PARAM_INT);
    $stmt->bindParam(':P_NGUOI_THAM_DINH',$arr_params["P_NGUOI_THAM_DINH"],PDO::PARAM_INT);
    $stmt->bindParam(':result',$result);
    $stmt->execute();
    return $result;
    }
}
