<?php

namespace App\model;

use Illuminate\Database\Eloquent\Model;
use PDO;
use DB;
class CongViecModel extends Model
{
    public function GUI_THAM_DINH($arr_params)
    {
        $sql = "DECLARE
                    P_ARRAY_ID_CV_DA VARCHAR2(1000);
                    P_ACTION_TD NUMBER;
                BEGIN
                    :RESULT_CV := GUI_THAM_DINH(:P_ARRAY_ID_CV_DA);
                END;
        ";
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ARRAY_ID_CV_DA',$arr_params["P_ARRAY_ID_CV_DA"]);
        $stmt->bindParam(':RESULT_CV',$RESULT_CV, PDO::PARAM_INT);
        $stmt->execute();
        return $RESULT_CV;
    }
}
