<?php

namespace App\model;

use Illuminate\Database\Eloquent\Model;

class DuAnKHModel extends Model
{
    public function SELECT_DU_AN_KH($arr_params)
    {
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare("SELECT SELECT_INFO_USER('$api_token') FROM dual");
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    }
}
