<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ThongKeController extends Controller
{
    public function so_luong_lcv_12_thang()
    {
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare("SELECT SELECT_SETTING($id_setting) FROM dual");
        $result = $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    }
}
