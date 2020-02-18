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
        P_VALUE_CD_DA VARCHAR2(5000);
    BEGIN
        :result :=SETTING_THUOC_TIH_DA(:P_ID_DU_AN, :P_VALUE_CD_DA);
    END;";
   
    $pdo = DB::getPdo();
    $stmt = $pdo->prepare($sql);
    $stmt->bindParam(':P_ID_DU_AN',$P_ID_DU_AN,PDO::PARAM_INT);
    $stmt->bindParam(':P_VALUE_CD_DA',$P_VALUE_CD_DA);
    $stmt->bindParam(':result',$result);
    $stmt->execute();
    return $result;
    }
}
