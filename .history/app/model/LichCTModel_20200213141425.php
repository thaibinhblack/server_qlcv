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
        $P_TEN_LICH_CT = $arr_params["P_TEN_LICH_CT "];
        $P_NOI_DUNG_LICH_CT = $arr_params["P_NOI_DUNG_LICH_CT"];
        $P_TIME_START = $arr_params["P_TIME_START"];
        $P_DATE_START = $arr_params["P_DATE_START"];
        $P_TIME_END = $arr_params["P_TIME_END"];
        $P_DATE_END = $arr_params["P_DATE_END"];
        $P_NHAN_VIEN_CT = $arr_params["P_NHAN_VIEN_CT"];
        $P_ACTION = $arr_params["P_ACTION"];

        $pdo = DB::getPdo();
        $stmt = $pdo->prepare("SELECT THEM_CAPNHAT_LICH_CT($P_ID_LICH_CT, '$P_TEN_LICH_CT', '$P_NOI_DUNG_LICH_CT',
         '$P_TIME_START', '$P_DATE_START', '$P_TIME_END', '$P_DATE_END', '$P_NHAN_VIEN_CT', '$P_ACTION') FROM dual");
        $result = $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    }
}
