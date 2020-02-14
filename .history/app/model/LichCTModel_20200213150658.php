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
        $P_TEN_LICH_CT = $arr_params["P_TEN_LICH_CT"];
        $P_NOI_DUNG_LICH_CT = $arr_params["P_NOI_DUNG_LICH_CT"];
        $P_TIME_START = $arr_params["P_TIME_START"];
        $P_DATE_START = $arr_params["P_DATE_START"];
        $P_TIME_END = $arr_params["P_TIME_END"];
        $P_DATE_END = $arr_params["P_DATE_END"];
        $P_NHAN_VIEN_CT = $arr_params["P_NHAN_VIEN_CT"];
        $P_ACTION = $arr_params["P_ACTION"];
        $sql = "DECLARE
                P_ID_LICH_CT NUMBER;
                P_TEN_LICH_CT VARCHAR2(255);
                P_NOI_DUNG_LICH_CT VARCHAR2(4000);
                P_TIME_START VARCHAR2(100);
                P_DATE_START DATE;
                P_TIME_END VARCHAR2(100);
                P_DATE_END DATE;
                P_NHAN_VIEN_CT VARCHAR2(4000);
                P_ACTION NUMBER;

            BEGIN
                :RESULT_CV := THEM_CAPNHAT_LICH_CT(:P_ID_LICH_CT, :P_TEN_LICH_CT, :P_NOI_DUNG_LICH_CT, :P_TIME_START, :P_DATE_START, :P_TIME_END, :P_DATE_END, :P_NHAN_VIEN_CT, :P_ACTION);
        END;"; 
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_LICH_CT',$P_ID_SETTING, PDO::PARAM_INT);
        $stmt->bindParam(':P_TEN_LICH_CT',$P_TEN_LICH_CT);
        $stmt->bindParam(':P_NOI_DUNG_LICH_CT',$P_NOI_DUNG_LICH_CT);
        $stmt->bindParam(':P_TIME_START',$P_TIME_START);
        $stmt->bindParam(':P_DATE_START',$P_DATE_START);
        $stmt->bindParam(':P_TIME_END',$P_TIME_END);
        $stmt->bindParam(':P_DATE_END',$P_DATE_END);
        $stmt->bindParam(':P_NHAN_VIEN_CT',$P_NHAN_VIEN_CT);
        $stmt->bindParam(':P_ACTION',$P_ACTION, PDO::PARAM_INT);
        $stmt->bindParam(':RESULT_CV',$RESULT_CV, PDO::PARAM_INT);
        $stmt->execute();
        return $RESULT_CV;
    }
}
