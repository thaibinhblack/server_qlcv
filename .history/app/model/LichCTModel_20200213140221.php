<?php

namespace App\model;

use Illuminate\Database\Eloquent\Model;
use DB;
use PDO;
class LichCTModel extends Model
{
    public function THEM_CAPNHAT_LICH_CT($arr_params)
    {
        $sql = "DECLARE
            P_ID_LICH_CT NUMBER;
            P_TEN_LICH_CT VARCHAR2(255);
            P_NOI_DUNG_LICH_CT VARCHAR2(4000);
            
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
