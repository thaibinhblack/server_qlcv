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
        $stmt = $pdo->prepare("SELECT SELECT_INFO_USER('$api_token') FROM dual");
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    }
}
