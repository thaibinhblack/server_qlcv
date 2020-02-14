<?php

namespace App\model;

use Illuminate\Database\Eloquent\Model;
use DB;
use PDO;
class LichCTModel extends Model
{
    public function THEM_CAPNHAT_LICH_CT($arr_params)
    {
        $P_ID_LICH_CT = $arr_params["P_ID_LICH_CT"];

        $pdo = DB::getPdo();
        $stmt = $pdo->prepare("SELECT THEM_CAPNHAT_LICH_CT($P_ID_LICH_CT, '$P_TIME_END', $P_ID_ND, $P_ID_DA, $P_ID_DU_AN_KH, $P_ID_LOAI_CV) FROM dual");
        $result = $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    }
}
