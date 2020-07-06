<?php

namespace App\model;

use Illuminate\Database\Eloquent\Model;
use PDO;
use DB;
class ThongKeModel extends Model
{
    public function THONGKE_DU_AN_KH()
    {
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare("SELECT THONGKE_DU_AN_KH() FROM dual");
        $result = $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    }
}
