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
                    P_ID_LICH_CT VARCHAR2(1000);
                BEGIN
                :RESULT_CV := THEM_CAPNHAT_LICH_CT(:P_ID_LICH_CT, :P_TEN_LICH_CT, :P_NOI_DUNG_LICH_CT, :P_TIME_START, :P_DATE_START, :P_TIME_END, :P_DATE_END, :P_NHAN_VIEN_CT, :P_ACTION);
                END;
        "
    }
}
