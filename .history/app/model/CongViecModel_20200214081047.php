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
                BEGIN
                    :RESULT_CV := THEM_CAPNHAT_LICH_CT(:P_ARRAY_ID_CV_DA);
                END;
        ";
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
    }
}
