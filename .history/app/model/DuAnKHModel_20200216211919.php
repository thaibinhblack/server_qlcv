<?php

namespace App\model;

use Illuminate\Database\Eloquent\Model;

class DuAnKHModel extends Model
{
    public function SELECT_DU_AN_KH($arr_params)
    {
        $pdo = DB::getPdo();
        $P_ID_DU_AN = $arr_params["P_ID_DU_AN"];
        $stmt = $pdo->prepare("SELECT SELECT_DU_AN_KH('$arr') FROM dual");
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    }
}
