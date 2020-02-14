<?php

namespace App\model;

use Illuminate\Database\Eloquent\Model;
use DB;
use PDO;
class UserModel extends Model
{
    public function SELECT_INFO_USER($api_token)
    {
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare("SELECT THEM_CAPNHAT_LICH_CT($P_ID_LICH_CT, '$P_TEN_LICH_CT', '$P_NOI_DUNG_LICH_CT',
         '$P_TIME_START', '$P_DATE_START', '$P_TIME_END', '$P_DATE_END', '$P_NHAN_VIEN_CT', '$P_ACTION') FROM dual");
        $result = $stmt->execute();
        return $result;
    }
}
